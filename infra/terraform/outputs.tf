output "cluster_endpoint" {
  value = aws_eks_cluster.kubeflare_cluster.endpoint
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}
