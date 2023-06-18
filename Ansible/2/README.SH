#!/bin/bash


# The following variables are used to generate the README.md file.
# They are not intended to be modified by the user.
# In order to easylly set de environment variables, you can use the following command:


# Requeriments

    Azure cli
    Terraform
    Ansible

# 1. Login to Azure
    az login

# 3 Create a Service Principal for Terraform
    
    az ad sp create-for-rbac --name <service_principal_name> --role Contributor --scopes /subscriptions/<subscription_id>

    

# 4. Then, set the following environment variables:
    
    bash azure-profile.sh
    source credentials.sh

# 5. Terraform
    # Remember, the next commands must be executed in the same terminal session where you set the environment variables.
    
    terraform init
    terraform plan
    terraform apply

# 6. Ansible
    
    ansible-playbook -i inventory/hosts playbook.yml



# To use SSH to connect to the virtual machine, do the following steps:

    #1. Run terraform output to get the SSH private key and save it to a file.
        terraform output -raw tls_private_key > ~/.ssh/id_rsaazure

    #2. Run chmod 600 id_rsa to set the permissions of the SSH private key file.
        chmod 600 ~/.ssh/id_rsaazure

    #3. Run terraform output to get the virtual machine public IP address.
        terraform output public_ip_address

    #4. Connect to the virtual machine using the SSH private key and the virtual machine public IP address.
        ssh -i ~/.ssh/id_rsaazure azureuser@<public_ip_address>


# Verify the sql resource

        terraform output -raw admin_password
        terraform output -raw admin_login

        az mysql flexible-server db show \
            --resource-group <resource_group_name> \
            --server-name <azurerm_mysql_flexible_server> \
            --database-name <mysql_flexible_server_database_name>

# 7. Destroy
    
    terraform destroy
