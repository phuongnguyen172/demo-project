output "JenkinsRole_instance_profile" {
  value       = module.iam_role_JenkinsRole.instance_profile_name
  description = "IAM instance profile of JenkinsRole"
}

output "DockerRole_instance_profile" {
  value       = module.iam_role_DockerRole.instance_profile_name
  description = "IAM instance profile of DockerRole"
}

output "KubernetesMasterRole_instance_profile" {
  value       = module.iam_role_KubernetesMasterRole.instance_profile_name
  description = "IAM instance profile of KubernetesMasterRole"
}

output "KubernetesWorkerRole_instance_profile" {
  value       = module.iam_role_KubernetesWorkerRole.instance_profile_name
  description = "IAM instance profile of KubernetesWorkerRole"
}
