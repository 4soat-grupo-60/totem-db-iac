variable "atlas_org_id" {
  type        = string
  default = "663d544185ea9446747dce85"
}

variable "atlas_project_name" {
  type        = string
  default = "totem"
}

variable "environment" {
  type        = string
  default = "dev"
}

variable "cluster_instance_size_name" {
  type        = string
  default = "M0"
}

variable "mongo_provider_name" {
  type        = string
  default = "TENANT"
}

variable "backing_provider_name" {
  type        = string
  default = "AWS"
}

variable "atlas_region" {
  type        = string
  default = "US_EAST_1"
}

variable "mongodb_version" {
  type        = string
  default = "7.0"
}

variable "ip_address" {
  type = string
  default = "0.0.0.0/0"
}

variable "mongodb_atlas_api_pub_key" {
  type = string
  default = "hkghisky"
}

variable "mongodb_atlas_api_pri_key" {
  type = string
  default = "85bf69e4-7ecd-4436-b771-e74a6364ab10"
}