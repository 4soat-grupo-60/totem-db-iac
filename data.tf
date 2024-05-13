data "aws_vpc" "default" {
  default = true
}

data "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project_ip_access_list.ip.project_id
  cidr_block = mongodbatlas_project_ip_access_list.ip.cidr_block
}