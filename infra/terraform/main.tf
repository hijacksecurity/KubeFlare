terraform {
  required_version = "~> 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
}

provider "aws" {
  region = var.aws_region
}

# EKS Cluster
resource "aws_eks_cluster" "kubeflare_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
  }
}

# IAM Role for EKS
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

# Node group for worker nodes (Fargate or EC2)
resource "aws_eks_fargate_profile" "kubeflare_fargate" {
  cluster_name           = aws_eks_cluster.kubeflare_cluster.name
  fargate_profile_name   = "kubeflare-fargate-profile"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution.arn

  subnet_ids = var.subnet_ids

  selector {
    namespace = "default"
  }
}

# IAM role for EKS
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_policy" {
  role       = aws_iam_role.cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

