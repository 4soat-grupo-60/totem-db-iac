terraform {
  backend "s3" {
    bucket = "techchallengegrupo60"
    key    = "postgres/terraform.tfstate"
    region = "us-east-1"
  }
}
provider "aws" {
  profile = "default"
  region = var.region

  default_tags {
    tags = var.tags
  }
}
resource "aws_secretsmanager_secret" "totem_database_host" {
  name = "totem_database_host"
}

resource "aws_secretsmanager_secret_version" "totem_database_host" {
  secret_id = aws_secretsmanager_secret.totem_database_host.id
  secret_string =  aws_db_instance.database.address
}

