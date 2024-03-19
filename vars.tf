variable "projectName" {
  default = "totempostgres"
}

variable "region" {
  default = "us-east-1"
}

variable "availabilityZone" {
  default = "us-east-1a"
}

variable "availabilityZone2" {
  default = "us-east-1b"
}

variable "dbTypeVersion" {
  default = "16.1"
}

variable "instance" {
  default = "db.t3.micro"
}

variable "dbEngine" {
  default = "postgresql"
}

variable "dbType" {
  default = "postgres"
}

variable "rdsUser" {
  default = "totem"
}

variable "rdsPass" {
  default = "totempostgres"
}

variable "rdsPort" {
  default = "5432"
}

variable "storage" {
  default = "gp3"
}

variable "minStorage" {
  default = "20"
}

variable "maxStorage" {
  default = "20"
}

variable "tags" {
  type    = map(string)
  default = {
    App      = "totem",
    Env = "Develop"
  }
}
