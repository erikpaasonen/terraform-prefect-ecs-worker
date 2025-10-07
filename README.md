# Terraform Prefect ECS Module

This module deploys a Prefect worker onto ECS Fargate using
[Terraform](https://www.terraform.io/).

![image](https://github.com/PrefectHQ/prefect-recipes/assets/68969861/d148af90-58dd-4ce2-a160-e23fada6c895)

## Requirements

You will need an AWS user with the following permissions. This will allow
Terraform to create and manage the resources required to create the Prefect
worker in ECS. Some example policies that provide these permissions are
mentioned as a starting point, but we recommend providing more restricted
access.

- `ec2:CreateVpc` (provided by `AmazonVPCFullACcess` policy)
- `ecs:CreateCluster` (provided by `AmazonECS_FullAccess` policy)
- `secretsmanager:CreateSecret` (provided by `SecretsManagerReadWrite` policy)
- `iam:CreateRole` (provided by `IAMFullAcess`)
- `logs:createLogGroup` (provided by `CloudWatchLogsFullAccess` policy)
- `ecr:CreateRepository` (provided by `AmazonEC2ContainerRegistryFullAccess` policy)

Next, you will need:

- The [Terraform CLI](https://developer.hashicorp.com/terraform/cli)
- The [Prefect CLI](https://docs.prefect.io/v3/get-started/install)
- Your Prefect account ID
- Your Prefect workspace ID
- Your Prefect API key

## Usage

### Configure Terraform

The following is an example directory structure to use this module:

```
.
├── main.tf
├── terraform.tfvars
└── variables.tf
```

```hcl
// variables.tf
variable prefect_api_key {}
```

```hcl
// terraform.tfvars
prefect_api_key = "pnu_xxxxx"
```

```hcl
// main.tf

provider "aws" {
  region = "us-east-1"
}

module "prefect_ecs_worker" {
  source = "prefecthq/ecs-worker/prefect"

  name                  = "dev"

  vpc_id                = "vpc-acfc2092275244ca8"
  worker_subnets        = [
    "subnet-014aa5f348034e45b",
    "subnet-df23ae9eab1f49af9"
  ]

  prefect_api_key       = var.prefect_api_key
  prefect_account_id    = "6e02a1db-07de-4760-a15d-60d8fe0b04e1"
  prefect_workspace_id  = "54cdfc71-9f13-41ba-9492-e1cf24eed185"

  worker_work_pool_name = "my-ecs-pool"
}
```

See the [Inputs](#inputs) section below for more options.

See the [full example](./examples/ecs-worker/), which makes use of an AWS-provided
module to create most of the AWS resources automatically.

You can run `terraform init` followed by `terraform apply` to create the
resources.

### Configure the Prefect work pool

Once `terraform apply` has completed successfully, within a few minutes you should
see a new ECS work pool in the UI.

Click the three dots to open the context menu, and select `Edit`.

Provide the following values for the work pool:

| Field | Required | Notes | Example |
|-------|----------|-------|---------|
| Execution role ARN | Yes | This is specified in the task definition resource, but is still needed in the work pool settings. | `arn:aws:iam::123456789:role/prefect-worker-execution-role-<name>` |
| VPC ID | Yes | Required when using the `awsvpc` network mode. | `vpc-123abc456def` |
| Cluster | No | If not set, uses the default cluster. | `arn:aws:ecs:us-east-1:123456789:cluster/prefect-worker-<name>` |
| Image | No | Image setting is retrieved from the deployment configuration, but a default can be provided here. | `123456.dkr.ecr.us-east-1.amazonaws.com/<image_name>:latest` |
| Task role ARN | No | Defaults to the task role on the service, but can be overridden here. | `arn:aws:iam::123456789:role/prefect-worker-task-role-<name>` |

More details on these settings are available on the `Edit` page of the work pool.

This configuration can also be provided in the base job template. For more information, see
[work pools](https://docs.prefect.io/v3/deploy/infrastructure-concepts/work-pools).

Additionally, work pools and the associated base job templates can be managed
with the Prefect Terraform provider. See the
[`work_pool`](https://registry.terraform.io/providers/PrefectHQ/prefect/latest/docs/resources/work_pool)
resource documentation for more information.

Once complete, you will see a new work pool available in Prefect.
You can then use this work pool for your deployments. See the [deployments
documentation](https://docs.prefect.io/v3/deploy/index) for more information.

## Reference

The [Terraform docs](https://github.com/hashicorp/terraform-plugin-docs) below can be generated with the following command:

```sh
make docs
```

## Further reading

- [Prefect ECS guide](https://docs.prefect.io/integrations/prefect-aws/ecs_guide)
- [Amazon ECS networking best practices](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/networking-best-practices.html)
- [Troubleshoot ECS pulling secrets](https://repost.aws/knowledge-center/ecs-unable-to-pull-secrets)

## Contributing

Contributions are always welcome. To get started, run:

```shell
# Install pre-commit hooks
pre-commit install

# Install dependencies
mise install
```

This uses [`mise`](https://mise.jdx.dev) as a user-friendly alternative to
Make. You can run `mise tasks ls` to see available tasks and `mise run` to run
a specific task. Additionally, `pre-commit` will make sure tasks like the
generation of the documentation happens when committing changes.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.prefect_worker_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.prefect_worker_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.prefect_worker_cluster_capacity_providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.prefect_worker_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.prefect_worker_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.prefect_worker_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.prefect_worker_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.allow_create_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.prefect_worker_allow_ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.ssm_allow_read_prefect_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.prefect_worker_ecs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.prefect_api_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.prefect_api_key_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.prefect_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.network_outbound](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Unique name for this worker deployment | `string` | n/a | yes |
| <a name="input_prefect_account_id"></a> [prefect\_account\_id](#input\_prefect\_account\_id) | Prefect Cloud account ID | `string` | n/a | yes |
| <a name="input_prefect_api_key"></a> [prefect\_api\_key](#input\_prefect\_api\_key) | Prefect Cloud API key | `string` | n/a | yes |
| <a name="input_prefect_workspace_id"></a> [prefect\_workspace\_id](#input\_prefect\_workspace\_id) | Prefect Cloud workspace ID | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID in which to create all resources | `string` | n/a | yes |
| <a name="input_worker_subnets"></a> [worker\_subnets](#input\_worker\_subnets) | Subnet(s) to use for the worker | `list(string)` | n/a | yes |
| <a name="input_worker_work_pool_name"></a> [worker\_work\_pool\_name](#input\_worker\_work\_pool\_name) | Work pool that the worker should poll | `string` | n/a | yes |
| <a name="input_secrets_manager_recovery_in_days"></a> [secrets\_manager\_recovery\_in\_days](#input\_secrets\_manager\_recovery\_in\_days) | Deletion delay for AWS Secrets Manager upon resource destruction | `number` | `30` | no |
| <a name="input_worker_cpu"></a> [worker\_cpu](#input\_worker\_cpu) | CPU units to allocate to the worker | `number` | `1024` | no |
| <a name="input_worker_desired_count"></a> [worker\_desired\_count](#input\_worker\_desired\_count) | Number of workers to run | `number` | `1` | no |
| <a name="input_worker_extra_pip_packages"></a> [worker\_extra\_pip\_packages](#input\_worker\_extra\_pip\_packages) | Packages to install on the worker assuming image is based on prefecthq/prefect | `string` | `"prefect-aws s3fs"` | no |
| <a name="input_worker_image"></a> [worker\_image](#input\_worker\_image) | Container image for the worker. This could be the name of an image in a public repo or an ECR ARN | `string` | `"prefecthq/prefect:3-python3.11"` | no |
| <a name="input_worker_log_retention_in_days"></a> [worker\_log\_retention\_in\_days](#input\_worker\_log\_retention\_in\_days) | Number of days to retain worker logs | `number` | `30` | no |
| <a name="input_worker_memory"></a> [worker\_memory](#input\_worker\_memory) | Memory units to allocate to the worker | `number` | `2048` | no |
| <a name="input_worker_task_role_arn"></a> [worker\_task\_role\_arn](#input\_worker\_task\_role\_arn) | Optional task role ARN to pass to the worker. If not defined, a task role will be created | `string` | `null` | no |
| <a name="input_worker_type"></a> [worker\_type](#input\_worker\_type) | Prefect worker type that gets passed into the Prefect worker start command | `string` | `"ecs"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster"></a> [ecs\_cluster](#output\_ecs\_cluster) | Full aws\_ecs\_cluster object for the Prefect worker cluster (all attributes as exposed by the resource). |
| <a name="output_ecs_service"></a> [ecs\_service](#output\_ecs\_service) | Full aws\_ecs\_service object for the Prefect worker service (all attributes as exposed by the resource). |
| <a name="output_ecs_task_definition"></a> [ecs\_task\_definition](#output\_ecs\_task\_definition) | Full aws\_ecs\_task\_definition object for the Prefect worker (all attributes as exposed by the resource). |
| <a name="output_prefect_worker_cluster_name"></a> [prefect\_worker\_cluster\_name](#output\_prefect\_worker\_cluster\_name) | Name of the ECS cluster hosting the Prefect worker service. |
| <a name="output_prefect_worker_execution_role_arn"></a> [prefect\_worker\_execution\_role\_arn](#output\_prefect\_worker\_execution\_role\_arn) | ARN of the IAM execution role used by the Prefect worker task definition (pull images, write logs). |
| <a name="output_prefect_worker_security_group"></a> [prefect\_worker\_security\_group](#output\_prefect\_worker\_security\_group) | ID of the security group attached to the Prefect worker service ENIs. |
| <a name="output_prefect_worker_service_id"></a> [prefect\_worker\_service\_id](#output\_prefect\_worker\_service\_id) | ID of the AWS ECS service that runs the Prefect worker tasks. |
| <a name="output_prefect_worker_task_role_arn"></a> [prefect\_worker\_task\_role\_arn](#output\_prefect\_worker\_task\_role\_arn) | ARN of the IAM task role assumed by Prefect worker tasks (may be provided via var.worker\_task\_role\_arn or created by this module). |
<!-- END_TF_DOCS -->
