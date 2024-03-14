output "totem-db-name" {
  value = "rds-${var.projectName}"
}

output "totem-db-host" {
  value = aws_db_instance.database.address
}

