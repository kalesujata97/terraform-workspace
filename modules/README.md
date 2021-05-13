## This terraform template provisions ElasticSearch on AWS.

### Usage
1. Terraform Init : Initializes a working directory containing Terraform configuration files.
	`terraform init`
	
2. Terraform Plan : Creates an execution plan.
	`terraform plan -var-file="dev.tfvars" -out="dev.tfstate"`
	 Select variable and state file as per environment. If this matches your expectation, you can confirm resource creation using apply.
	
3. Terraform Apply : Executes the actions proposed in a Terraform plan.
    `terraform apply -var-file="dev.tfvar" -state-out="dev.tfstate"`
	
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.7 |

### Providers

| Name | Version |
|------|---------|
| aws | >= 3.35.0 |

### Modules

| Sr. No. | Module Name             |
|---------|-------------------------|            
| 1       | ElasticSearch                |

## Resources

| Name | Type |
|------|------|
| [aws_elasticsearch_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |

# Inputs & Outputs

### Inputs for main module

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| account_id | AWS account ID | `string` | `null` | Yes |
| region | This is the AWS region | `string` | `us-east-1` | No |
| profile | Environment profile | `string` | `dev` | No |

## Module 1. Amazon S3 Bucket

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| domain_name | Name of the domain | `string` | `null` | Yes |
| es_version |  | `string` | `null` | Yes |
| instance_type |  | `string` | `null` | Yes |
| instance_count |  | `string` | `null` | Yes |
| dedicated_master_enabled |  | `bool` | `false` | No |
| ebs_enabled | Whether EBS volumes are attached to data nodes in the domain | `bool` | `true` | No |
| ebs_volume_size | Size of EBS volumes attached to data nodes (in GiB) | `string` | `50` | No |
| ebs_volume_type | Type of EBS volumes attached to data nodes | `string` | `gp2` | No |
| advanced_security_options_enabled |  Whether advanced security is enabled.  | `bool` | `false` | No |
| advanced_security_options_internal_user_database_enabled | Whether the internal user database is enabled | `string` | `false` | No |
| advanced_security_options_master_user_arn | ARN for the main user | `string` | `null` | No |
| advanced_security_options_master_user_name | Main user's username, which is stored in the Amazon Elasticsearch Service domain's internal database | `string` | `null` | Yes |
| advanced_security_options_master_user_password | Main user's password, which is stored in the Amazon Elasticsearch Service domain's internal database | `string` | `null` | Yes |

