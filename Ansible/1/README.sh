# A simple web project to install nginx on n servers

Suppose we have 100 servers and we need to install Nginx on all those servers at the same time. So how would we accomplish this task? Well, with Ansible we can do it in one step.

- This guide is made for running Ansible in a local machine, but it can be run in a remote machine too.
- In fact, it is recommended to run Ansible in a remote machine, the terraform code create a remote machine and install Ansible in it. Go to the folder AWS_instance/1-EC2_Instance and follow the instructions in the README.sh file.

- Requeriments

- Ansible
- SSH key
- SSH access to the servers

- Create a SSH key

- ssh-keygen -t rsa -b 4096 -C "ansible" -f ~/.ssh/ansible

- If doesn't exist, create a inventory file
    mkdir -p /etc/ansible
    touch /etc/ansible/hosts

- Add the servers to the inventory file, for example:

#### [servers]
#### 
#### server1 ansible_host=3.250.154.208
#### server2 ansible_host=34.254.178.173
#### 
#### [servers:vars]
#### ansible_user=admin
#### ansible_ssh_private_key_file=/home/runner/.ssh/ansible
#### ansible_python_interpreter=/usr/bin/python3 

- Now we can run the playbook

- ansible-playbook condition_install.yaml
- ansible-playbook date.yaml
- ansible-playbook nginx_install.yaml




