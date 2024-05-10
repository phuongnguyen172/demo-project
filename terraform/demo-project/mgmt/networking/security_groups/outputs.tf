output "SG_Jenkins_id" {
  value       = aws_security_group.SG_Jenkins.id
  description = "ID of SG_Jenkins"
}

output "SG_LB_Kubernetes_id" {
  value       = aws_security_group.SG_LB_Kubernetes.id
  description = "ID of SG_LB_Kubernetes"
}

output "SG_Kubernetes_Master_id" {
  value = aws_security_group.SG_Kubernetes_Master.id
  description = "ID of SG_KubernetesMaster"
}

output "SG_Kubernetes_Worker_id" {
  value = aws_security_group.SG_Kubernetes_Worker.id
  description = "ID of SG_KubernetesWorker"
}