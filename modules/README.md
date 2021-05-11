# This terraform template provisions Amazon Elastic Beanstalk, Amazon Certificate Manager and Amazon CloudFront web Distribution.

##Usage
1. Terraform Plan
	terraform plan -var-file="dev.tfvars" -out="dev.tfstate"
	Select variable and state file as per environment. If everything looks fine you can confirm resource creation uging apply.
	
2. Terraform Apply
    terraform apply -var-file="dev.tfvar" -state-out="dev.tfstate"
	
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.7 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.35.0 |

## Modules

| Sr. No. | Module Name             |
|---------|-------------------------|            
| 1       | ElasticBeanstalk        |
| 2       | ACM                     |
| 3       | CloudFront Distribution |

## Resources

| Name | Type |
|------|------|
| [aws_elastic_beanstalk_application](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application) | resource |
| [aws_elastic_beanstalk_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment) | resource |
| [aws_acm_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_acm_certificate_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |

# Inputs & Outputs

## Module 1. Elastic Beanstalk

### Inputs 
| Name | Description | Type | Default | Required |
| beanstalk_application_name | The name of the beanstalk application, must be unique within your account | `string` | `null` | Yes |
| beanstalk_environment | A unique name for this Beanstalk Environment | `string` | `null` | Yes |
| instance_type | Instance Type for the the EC2 instances managed by Beanstalk | `string` | `null` | Yes |
| vpc_id | VPC ID for the Beanstalk | `string` | `null` | Yes |
| ec2_subnet_id | | `list(string)` | `null` | Yes |
| elb_subnet_id | | `list(string)` | `null` | Yes |
| ec2_root_volume_type | | `string` | `gp2` | No |
| ec2_root_volume_size | | `string` | `null` | Yes |
| keypair | | `string` | `null` | Yes |
| environment_type | | `string` | `null` | Yes |
| service_role | | `string` | `null` | Yes |
| measurename | | `string` | `null` | Yes |
| statistic | | `string` | `null` | Yes |
| unit | | `string` | `null` | Yes |
| upperthreshold | | `string` | `null` | Yes |
| lowerthreshold | | `string` | `null` | Yes |

### Outputs
| Name | Description | Type |
| beanstalk_endpoint_url | Beanstalk endpoint url to be used in Cloudfront Distribution | `String` |

## Module 2. Amazon Certificate Manager (ACM)

### Inputs
| Name | Description | Type | Default | Required |
| domain_name | A domain name for which the certificate should be issued | `string` | `null` | Yes |
| profile | Adds a profile tag for certificate | `string` | `dev` | No |

### Outputs
| Name | Description | Type |
| acm_certificate_arn | To reference in CloudFront Distribution | `string` |

## Module 3. CloudFront Distribution

### Inputs
| Name | Description | Type | Default | Required |
| beanstalk_endpoint_url | No need to pass from variable file. It will be referenced from output of Beanstalk module | `string` | `module.ElasticBeanstalk.beanstalk_endpoint_url` | No |
| acm_certificate_arn |  No need to pass from variable file. It will be referenced from output of ACM module | `string` | `module.ACM.acm_certificate_arn` | No |
| minimum_protocol_version | The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections | `string` | `null` | Yes |


