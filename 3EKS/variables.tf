# environments/dev/variables.tf
variable "region" {
  description = "region i use my aws in"
  type = string
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "stamp" {
  description = "name to use in every resource"
  type = string 
}

variable "ec2_type" {
  type        = string
  description = "EC2 instance types"
}

variable "domain" {
  type = string
  description = "bokertovmatoki.online"
}

variable "db_engine" {
  type = string
  description = "mysql for RDS"
}

variable "db_type" {
  type = string
  description = "RDS Instance"
  
}

variable "db_name" {
  type = string
  description = "Database name"

}
variable "min_size" {
  type = number
  description = "EKS managed node group"
}

variable "max_size" {
  type = number
  description = "EKS managed node group"
}

variable "desired_size" {
  type = number
  description = "EKS managed node group"
}

variable "db_engine_version" {
  description = "the db version"
  type = string
}

variable "_LocalAdmin" {
  description = "Admin role to allow other admins to join the work"
  type = string
}