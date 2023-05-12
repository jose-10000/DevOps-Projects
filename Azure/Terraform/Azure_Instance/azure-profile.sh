#! /bin/bash
# Description: Input Azure Environment Variables

# Run this script with the command "source ./azure-profile.sh" 
# to set the environment variables for Terraform and Ansible.

# Do it before running Terraform or Ansible, then in the same terminal session, you can run Terraform or Ansible.

# Create a Service Principal for Terraform
az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>


export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"


# For Terraform
export TF_VAR_SUBSCRIPTION_ID="<azure_subscription_id>"
export TF_VAR_TENANT_ID="<azure_subscription_tenant_id>"
export TF_VAR_CLIENT_ID="<service_principal_appid>"
export TF_VAR_CLIENT_SECRET="<service_principal_password>"

# For GitHUB
export MSYS_NO_PATHCONV=1  

echo "Azure Environment Variables set."
echo "Now you can run Terraform or Ansible in this terminal session."




