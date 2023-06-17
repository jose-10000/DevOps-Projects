terraform {
  backend "s3" {
    bucket         = "terraform-state-2023-21-05" # REEMPLAZAR CON EL NOMBRE DEL BUCKET NECESARIO
    key            = "terraform-state-2023-21-05/import-bootstrap/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }



}