terraform {
  backend "s3" {
    bucket         = "ansible-state-2023" # REEMPLAZAR CON EL NOMBRE DEL BUCKET NECESARIO
    key            = "ansible-state-2023-06/import-bootstrap/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "ansible-state-locking"
    encrypt        = true
  }



}