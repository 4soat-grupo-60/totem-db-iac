provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

resource "aws_secretsmanager_secret" "totem_db" {
  name        = "prod/totem/Postgresql"
  description = "Armazena as credenciais do banco de dados PostgreSQL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "totem_database_secrets" {
  secret_id     = aws_secretsmanager_secret.totem_db.id
  secret_string = jsonencode({
    username             = base64encode("${var.rdsUser}")
    password             = base64encode("${var.rdsPass}")
    host                 = base64encode("${aws_db_instance.database.address}")
    dbInstanceIdentifier = base64encode("${var.rdsUser}")
    port                 = base64encode("${var.rdsPort}")
    path                 = base64encode(
      "${var.dbEngine}://${var.rdsUser}:${var.rdsPass}@${aws_db_instance.database.address}:${var.rdsPort}/${var.projectName}"
    )
  })
}

resource "aws_iam_policy" "policy_secret_totem_database" {
  name        = "policy-secret-totem-database"
  description = "Permite acesso somente leitura ao Secret ${aws_secretsmanager_secret.totem_db.name} no AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.totem_db.arn
      },
    ]
  })
}

terraform {
  cloud {
    organization = "4SOAT-G60"

    workspaces {
      name = "totem-db-iac"
    }
  }
}