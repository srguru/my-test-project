# main.tf
provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block             = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone      = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public-${count.index + 1}"
  }
}

# Create EKS cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  
  vpc_id          = aws_vpc.main.id
  subnet_ids      = aws_subnet.public[*].id

  eks_managed_node_groups = {
    main = {
      min_size     = 2
      max_size     = 3
      desired_size = 2

      instance_types = ["t3.medium"]
    }
  }
}

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

# outputs.tf
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.eks.cluster_security_group_id
}