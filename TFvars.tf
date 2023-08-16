variable "project_name" {
  description = "Project"
  default     = "DemoA"
}
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-west-1a" ,"eu-west-1b"]
}

variable "domain_prefix" {
  description = "The cognito client domain"
  default     = "my-iitc-app"
}