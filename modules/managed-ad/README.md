# Managed AD

Terraform module which creates a Managed AD service on AWS.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_directory_service_directory.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_edition"></a> [edition](#input\_edition) | Edition of Managed AD service | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | FQDN of Managed AD domain | `string` | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for Managed AD domain | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for Managed AD service | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for Managed AD service | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The directory identifier |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
