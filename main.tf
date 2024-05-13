terraform {
  backend "s3" {
    bucket = "techchallengegrupo60"
    key    = "postgres/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
  }
  required_version = ">= 0.13"
}
provider "aws" {
  profile = "default"
  region = var.region

  default_tags {
    tags = var.tags
  }
}

provider "mongodbatlas" {
  public_key  = var.mongodb_atlas_api_pub_key
  private_key = var.mongodb_atlas_api_pri_key
}

resource "aws_secretsmanager_secret" "db" {
  name        = "prod/totem/Postgresql"
  description = "Armazena as credenciais do banco de dados PostgreSQL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "totem-db-secrets" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username             = base64encode("${var.rdsUser}")
    password             = base64encode("${var.rdsPass}")
    host                 = base64encode("${var.rdsUser}")
    dbInstanceIdentifier = base64encode("${var.rdsUser}")
    port                 = base64encode("${aws_db_instance.database.address}")
    path                 = base64encode(
      "${var.dbEngine}://${var.rdsUser}:${var.rdsPass}@${aws_db_instance.database.address}:${var.rdsPort}/${var.rdsUser}"
    )
  })
}

resource "aws_iam_policy" "policy_secret_db" {
  name        = "policy-secret-db"
  description = "Permite acesso somente leitura ao Secret ${aws_secretsmanager_secret.db.name} no AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.db.arn
      },
    ]
  })
}
