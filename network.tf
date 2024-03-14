resource "aws_db_subnet_group" "subnet-totem-postgres" {
  name       = "subnet-totem-postgres-${var.projectName}"
  subnet_ids = ["${var.subnet01}", "${var.subnet02}", "${var.subnet03}"]
}