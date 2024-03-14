data "aws_secretsmanager_secret_version" "database" {
  secret_id = "totem-postgres-secrets"
}