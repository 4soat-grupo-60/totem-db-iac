resource "aws_security_group" "sg-postgres" {
  name        = "SG-${var.projectName}-rds"
  description = var.projectName
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}