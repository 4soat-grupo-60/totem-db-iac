resource "aws_default_subnet" "default_az1" {
  availability_zone = var.availabilityZone
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = var.availabilityZone2
}

resource "aws_db_subnet_group" "subnet-totem-postgres" {
  name       = "subnet-rds-${var.projectName}"
  subnet_ids = ["${aws_default_subnet.default_az1.id}", "${aws_default_subnet.default_az2.id}"]
}