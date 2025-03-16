variable "aws_region" {
  default = "us-east-1"
}

variable "cluster_name" {
  default = "kubeflare-cluster"
}

variable "subnet_ids" {
  type = list(string)
}
