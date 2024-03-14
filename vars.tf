variable "projectName" {
  default = "totempostgres"
}

variable "region" {
  default = "us-east-1"
}

variable "dbType" {
  default = "postgres"
}

variable "dbTypeVersion" {
  default = "16.1"
}
variable "instance" {
  default = "db.t3.micro"
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

variable "AWSAccount" {
  default = ""
}

variable "vpcId" {
  default = ""
}

variable "vpcCIDR" {
  default = ""
}

variable "subnet01" {
  default = ""
}

variable "subnet02" {
  default = ""
}

variable "subnet03" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {
    App      = "totem",
    Env = "Develop"
  }
}
