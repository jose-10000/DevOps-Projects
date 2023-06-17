# Deploy EC2 instances with terraform

1.  Requeriments
    -   Terraform
    -   AWS account
    -   AWS CLI
    -   AWS credentials
    -   SSH key
2.  Create a SSH key
    -   ssh-keygen -t rsa -b 4096 -C "ansible" -f ~/.ssh/ansible

3.  Create a AWS credentials

    -   aws configure --profile ansible

4.  Create a s3 bucket to store terraform state

    cd 0-s3_bucket
    terraform init
    terraform plan
    terraform apply
    

5.  Create a AWS EC2 instance with terraform
    
        -   terraform init
        -   terraform plan
        -   terraform apply
