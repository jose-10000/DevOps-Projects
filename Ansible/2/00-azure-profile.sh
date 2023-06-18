#! /bin/bash
# This script is used to set the environment variables used by the Terraform and Ansible scripts.




# Requirements:
# 1. Install Azure CLI and login
#   1.1 az login
#   1.2 az account list --query "[?isDefault].id" -o tsv # get the subscription id
# 2. Install Terraform
# 3. Install Ansible

BD=credentials.sh

if ! [ -f "$BD" ]; then #BD does not exist
    touch credentials.sh

fi 


# Run this script with the command "source azure-profile.sh" 
# to set the environment variables for Terraform and Ansible.

# Do it before running Terraform or Ansible, then in the same terminal session, you can run Terraform or Ansible.

# Create a Service Principal for Terraform, change the name of the service principal

# az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>
# 


# Show Subscriptions and Tenants IDs
read -p "Enter your Service Principal Name: " service_principal_name
echo "Here is your Subscriptions ID: "
az account list --query "[?isDefault].id" -o tsv 
echo "Here is your Tenants ID: "
az account list --query "[?isDefault].tenantId" -o tsv
echo "Here is your Service Principal App ID: "
az ad sp list --display-name ${service_principal_name} --query "[].appId" -o tsv


# Input Azure Environment Variables
echo "#! /bin/bash" > credentials.sh
read -p "Enter the Azure Subscription ID: " azure_subscription_id
read -p "Enter the Azure Subscription Tenant ID: " azure_subscription_tenant_id
read -p "Enter the Service Principal App ID: " service_principal_appid
read -p "Enter the Service Principal Password: " service_principal_password

# Print the variables to the file credentials.sh
echo " # Pricipal" >> credentials.sh
echo "export ARM_SUBSCRIPTION_ID=$azure_subscription_id" >> credentials.sh
echo "export ARM_TENANT_ID=$azure_subscription_tenant_id" >> credentials.sh
echo "export ARM_CLIENT_ID=$service_principal_appid" >> credentials.sh
echo "export ARM_CLIENT_SECRET=$service_principal_password" >> credentials.sh
echo " # Terraform" >> credentials.sh
echo "export TF_VAR_SUBSCRIPTION_ID=$azure_subscription_id" >> credentials.sh
echo "export TF_VAR_TENANT_ID=$azure_subscription_tenant_id" >> credentials.sh
echo "export TF_VAR_CLIENT_ID=$service_principal_appid" >> credentials.sh
echo "export TF_VAR_CLIENT_SECRET=$service_principal_password" >> credentials.sh
echo " # Ansible" >> credentials.sh
echo "export AZURE_SUBSCRIPTION_ID=$azure_subscription_id" >> credentials.sh
echo "export AZURE_TENANT_ID=$azure_subscription_tenant_id" >> credentials.sh
echo "export AZURE_CLIENT_ID=$service_principal_appid" >> credentials.sh
echo "AZURE_CLIENT_SECRET=$service_principal_password" >> credentials.sh
echo " # GitHUB" >> credentials.sh
echo "export MSYS_NO_PATHCONV=1" >> credentials.sh

# Clear the file credentials.sh when the command "source credentials.sh" is executed and finished
echo "echo " " > credentials.sh" >> credentials.sh


chmod +x credentials.sh




echo "Azure Environment Variables set."
echo "Now you can run Terraform or Ansible in this terminal session."
echo "Run the command 'source credentials.sh' to set the environment variables for Terraform and Ansible."




