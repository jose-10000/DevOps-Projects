############################ Variables############################

# Region
variable "aws-region" {
  default = "eu-west-1"
}

##################################################

# Profile, used to authenticate to AWS.
# This is the profile name in ~/.aws/credentials
variable "aws-profile" {
  default = "terraform-course"
}

##################################################

# S3 Bucket name
variable "s3_tfstate" {
  type = object({
    bucket = string
  })
  default = {
    bucket = "ansible-state-2023"
  }
}

##################################################

# DynamoDB table name
variable "dynamodb-lock" {
  type = object({
    table = string
  })
  default = {
    table = "ansible-state-locking"
  }
}
