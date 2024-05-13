resource "aws_secretsmanager_secret" "mongo_db" {
  name        = "prod/totem/MongoDB"
  description = "Armazena as credenciais do banco de dados MongoDB"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "totem-mongo-db-secrets" {
  secret_id     = aws_secretsmanager_secret.mongo_db.id
  secret_string = jsonencode({
    username             = base64encode("${var.rdsUser}")
    password             = base64encode("${var.rdsPass}")
    host                 = base64encode("${var.rdsUser}")
    dbInstanceIdentifier = base64encode("${var.rdsUser}")
    port                 = base64encode("27017")
    path                 = base64encode(
      "${mongodbatlas_cluster.atlas-cluster.connection_strings[0].standard}"
    )
  })
}
resource "aws_iam_policy" "policy_secret_db_mongo" {
  name        = "policy-secret-db-mongo"
  description = "Permite acesso somente leitura ao Secret ${aws_secretsmanager_secret.mongo_db.name} no AWS Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.mongo_db.arn
      },
    ]
  })
}

resource "mongodbatlas_project" "atlas-project" {
  org_id = var.atlas_org_id
  name = var.atlas_project_name
}

resource "mongodbatlas_database_user" "db-user" {
  username = var.rdsUser
  password = var.rdsPass
  project_id = mongodbatlas_project.atlas-project.id
  auth_database_name = "admin"
  roles {
    role_name     = "readWrite"
    database_name = "${var.atlas_project_name}-db"
  }
}

resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project.atlas-project.id
  cidr_block = var.ip_address
}

resource "mongodbatlas_cluster" "atlas-cluster" {
  project_id = mongodbatlas_project.atlas-project.id
  name = "${var.atlas_project_name}-${var.environment}-cluster"
  provider_name = var.mongo_provider_name
  backing_provider_name = var.backing_provider_name
  provider_region_name = var.atlas_region
  provider_instance_size_name = var.cluster_instance_size_name
}