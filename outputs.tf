output "prefect_worker_service_id" {
  description = "ID of the AWS ECS service that runs the Prefect worker tasks."
  value = aws_ecs_service.prefect_worker_service.id
}

output "prefect_worker_execution_role_arn" {
  description = "ARN of the IAM execution role used by the Prefect worker task definition (pull images, write logs)."
  value = aws_iam_role.prefect_worker_execution_role.arn
}

output "prefect_worker_task_role_arn" {
  description = "ARN of the IAM task role assumed by Prefect worker tasks (may be provided via var.worker_task_role_arn or created by this module)."
  value = var.worker_task_role_arn == null ? aws_iam_role.prefect_worker_task_role[0].arn : var.worker_task_role_arn
}

output "prefect_worker_security_group" {
  description = "ID of the security group attached to the Prefect worker service ENIs."
  value = aws_security_group.prefect_worker.id
}

output "prefect_worker_cluster_name" {
  description = "Name of the ECS cluster hosting the Prefect worker service."
  value = aws_ecs_cluster.prefect_worker_cluster.name
}

output "ecs_cluster" {
  description = "Full aws_ecs_cluster object for the Prefect worker cluster (all attributes as exposed by the resource)."
  value = aws_ecs_cluster.prefect_worker_cluster
}

output "ecs_service" {
  description = "Full aws_ecs_service object for the Prefect worker service (all attributes as exposed by the resource)."
  value = aws_ecs_service.prefect_worker_service
}

output "ecs_task_definition" {
  description = "Full aws_ecs_task_definition object for the Prefect worker (all attributes as exposed by the resource)."
  value = aws_ecs_task_definition.prefect_worker_task_definition
}
