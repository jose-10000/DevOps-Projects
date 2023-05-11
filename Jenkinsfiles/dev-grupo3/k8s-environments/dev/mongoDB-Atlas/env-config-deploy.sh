#!/bin/bash

# This script is used to set the environment variables for the deployment
# It is called by the deploy.sh script
# Insert your mongoDB Atlas Org ID and API Key below
# You can find your Org ID and API Key in the MongoDB Atlas UI
# https://docs.atlas.mongodb.com/configure-api-access/

# Install jq
echo "Installing jq"
sudo apt-get install jq

# Insert your mongoDB Atlas Org ID below
read -p  "Insert your mongoDB Atlas Org ID: " ORG_ID
export ORG_ID=$ORG_ID

# Insert your mongoDB Atlas API Public Key below
read -p  "Insert your mongoDB Atlas Org ID and API Public Key: " ATLAS_PUBLIC_KEY
export ATLAS_PUBLIC_KEY=$ATLAS_PUBLIC_KEY

# Insert your mongoDB Atlas API Private Key below
read -p  "Insert your mongoDB Atlas Private Key: " ATLAS_PRIVATE_KEY
export ATLAS_PRIVATE_KEY=$ATLAS_PRIVATE_KEY

# Insert your mongoDB Atlas DB Password below
read -p  "Insert your mongoDB Atlas Password: " ATLAS_DB_PASSWORD
export ATLAS_DB_PASSWORD=$ATLAS_DB_PASSWORD

# Insert your mongoDB Atlas DB User below
read -p  "Insert your mongoDB Atlas User: " ATLAS_DB_USER
export ATLAS_DB_PASSWORD=$ATLAS_DB_USER


# Create the MongoDB Atlas Operator
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-atlas-kubernetes/main/deploy/all-in-one.yaml

# Create the MongoDB Atlas Operator API Key Secret
	kubectl create secret generic mongodb-atlas-operator-api-key \
        --from-literal="orgId=$ORG_ID" \
        --from-literal="publicApiKey=$ATLAS_PUBLIC_KEY" \
        --from-literal="privateApiKey=$ATLAS_PRIVATE_KEY" \
        -n mongodb-atlas-system

# Label the MongoDB Atlas Operator API Key Secret
kubectl label secret mongodb-atlas-operator-api-key atlas.mongodb.com/type=credentials -n mongodb-atlas-system

# Create the MongoDB Atlas DB Password Secret
kubectl create secret generic atlaspassword --from-literal="password=$ATLAS_DB_PASSWORD"

# Label the MongoDB Atlas Operator Project Secret
kubectl label secret atlaspassword atlas.mongodb.com/type=credentials


# Deploy the MongoDB Atlas Operator Project
kubectl apply -f .


# Wait for the MongoDB Atlas Operator to create the MongoDB Atlas Project
echo "Waiting for MongoDB Atlas Operator to create the MongoDB Atlas Project"
sleep 60

# Deploy application
echo "Deploying application"
kubectl apply -f k8s/

# Wait for the deployment to be ready
echo "Waiting for the deployment to be ready"
sleep 20

# Wait for the MongoDB Atlas Operator to create the MongoDB Atlas Project
echo "Waiting for the rest of MongoDB Atlas Project deployment"
sleep 40

# Get the MongoDB Atlas Operator Project Secret
kubectl get secret atlaspassword -o json | jq -r '.data | with_entries(.value |= @base64d)'

# Clean up Variables
unset ORG_ID
unset ATLAS_PUBLIC_KEY
unset ATLAS_PRIVATE_KEY
unset ATLAS_DB_PASSWORD
unset ATLAS_DB_USER

# At the end execute the following command to get conect to the application
echo "Leave the terminal open "
minikube tunnel
