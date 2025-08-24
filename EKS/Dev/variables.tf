variable "kubernetes_version" {
  default     = "1.33"
  description = "Kubernetes version (latest stable minor version as of Aug 2025)"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}

variable "aws_region" {
  default     = "ca-central-1"
  description = "AWS region"
}

variable "cluster_name" {
  default = "first-cluster"
  description = "Name of the cluster"
}

variable "cluster_vpc_name" {
  default = "first-cluster-vpc"
  description = "Name of cluster VPC"
}
