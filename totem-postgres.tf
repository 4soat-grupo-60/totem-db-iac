locals {
  totem_db = jsondecode(
    data.aws_secretsmanager_secret_version.database.secret_string
  )
}

resource "aws_db_instance" "database" {
  db_name                      = var.projectName
  engine                       = var.dbType
  engine_version               = var.dbTypeVersion
  identifier                   = "rds-${var.projectName}"
  username                     = local.totem_db.db_user
  password                     = local.totem_db.db_pass
  instance_class               = var.instance
  storage_type                 = var.storage
  allocated_storage            = var.minStorage
  max_allocated_storage        = var.maxStorage
  multi_az                     = false
  vpc_security_group_ids       = ["${aws_security_group.sg-postgres.id}"]
  db_subnet_group_name         = aws_db_subnet_group.subnet-totem-postgres.id
  apply_immediately            = true
  skip_final_snapshot          = true
  publicly_accessible          = true
  deletion_protection          = false
  performance_insights_enabled = true
  backup_retention_period      = 1
  backup_window                = "00:00-00:30"
  copy_tags_to_snapshot        = true
  delete_automated_backups     = true
}