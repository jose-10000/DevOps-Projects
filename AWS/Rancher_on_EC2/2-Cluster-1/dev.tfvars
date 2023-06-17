configuration = [
  {
    "application_name" : "Rancher-SVR-dev",
    "ami" : "ami-0c90138cdc75f84d2",  // Rancher-Ubuntu-22.04-LTS // eu-west-1
    "no_of_instances" : "1",
    "instance_type" : "t3.xlarge", # t3.xlarge (4 vCPU, 16 GB RAM). Next best is t3.2xlarge (4 vCPU, 32 GB RAM)
    "subnet_id" : "subnet-0f4f294d8404946eb",  subnet_id              = aws_subnet.subnet_public.id
    "vpc_security_group_ids" : ["sg-0d15a4cac0567478c","sg-0d8749c35f7439f3e"]
  },
  {
    "application_name" : "Rancher-Cluster-1-dev",
    "ami" : "ami-01dd271720c1ba44f" # Ubuntu 22.04 LTS // eu-west-1    
    "instance_type" : "t3.xlarge", # t3.xlarge (4 vCPU, 16 GB RAM). Next best is t3.2xlarge (4 vCPU, 32 GB RAM)
    "no_of_instances" : "1"
    "subnet_id" : "subnet-0f4f294d8404946eb"
    "vpc_security_group_ids" : ["sg-0d15a4cac0567478c"]
  },
  {
    "application_name" : "Rancher-Cluster-2-dev",
    "ami" : "ami-01dd271720c1ba44f" # Ubuntu 22.04 LTS // eu-west-1    
    "instance_type" : "t3.medium", # t3.medium (2 vCPU, 4 GB RAM)
    "no_of_instances" : "1"
    "subnet_id" : "subnet-0f4f294d8404946eb"
    "vpc_security_group_ids" : ["sg-0d15a4cac0567478c"]
  }
  
]