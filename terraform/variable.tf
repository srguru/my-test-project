# variables.tf
variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  default     = "sample-cluster"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}