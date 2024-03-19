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

resource "aws_secretsmanager_secret" "db" {
  name        = "totem-db-secrets"
  description = "Armazena as credenciais do banco de dados PostgreSQL"
  recovery_window_in_days = 0
}

locals {
  initial = {
    # Inicializa as Keys com valores default
    username             = "totem"
    password             = "totempostgres"
    engine               = "postgres"
    port                 = "5432"
    dbInstanceIdentifier = "totem"
  }
}

resource "aws_secretsmanager_secret_version" "version1" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode(local.initial)
}

resource "aws_secretsmanager_secret_version" "totem_database_host" {
  secret_id = aws_secretsmanager_secret.totem_database_host.id
  secret_string =  aws_db_instance.database.address
}

resource "aws_iam_policy" "policy_secret_db" {
  name        = "policy-secret-db"
  description = "Permite acesso somente leitura ao Secret ${aws_secretsmanager_secret.db.name} no AWS Secrets Manager"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

