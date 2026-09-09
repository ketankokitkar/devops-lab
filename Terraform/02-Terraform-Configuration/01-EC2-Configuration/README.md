# Terraform Configuration

## Overview

This project covers the Terraform configuration concepts from Day 2 of the Terraform Zero to Hero learning path.

The practical builds and manages an AWS EC2 instance using input variables, TFVars, conditional expressions, built-in functions, provider configuration, and outputs.

## Objectives

- Understand Terraform providers
- Understand required providers
- Configure AWS providers
- Understand multiple providers
- Understand multiple AWS regions
- Use provider aliases
- Use input variables
- Use `terraform.tfvars`
- Use output variables
- Use conditional expressions
- Use built-in Terraform functions
- Practice Terraform formatting and validation
- Deploy and destroy infrastructure using Terraform

## Project Structure

```text
01-EC2-Configuration/
├── main.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── .gitignore
└── README.md
````

## Terraform Configuration Flow

```text
terraform.tfvars
       ↓
variables.tf
       ↓
main.tf
       ↓
AWS Provider
       ↓
EC2 Instance
       ↓
outputs.tf
```

## Providers

Terraform providers are plugins that allow Terraform to communicate with external platforms and APIs.

This project uses the HashiCorp AWS provider.

The `required_providers` block defines the provider dependency:

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}
```

The `provider` block configures the AWS provider:

```hcl
provider "aws" {
  region = "eu-north-1"
}
```

## Required Providers

The `required_providers` block tells Terraform which provider is required by the configuration.

The provider source used in this project is:

```text
hashicorp/aws
```

Terraform downloads the provider during:

```bash
terraform init
```

## Multiple Providers

Terraform can use multiple providers in a single project.

For example, a Terraform project can work with AWS and Azure:

```text
Terraform
├── AWS Provider
└── Azure Provider
```

This allows resources from different cloud platforms to be managed using Terraform.

The AWS + Azure configuration was covered as a concept in this lab. Azure infrastructure was not deployed.

## Multiple AWS Regions

Terraform can configure multiple instances of the same provider using aliases.

Example:

```hcl
provider "aws" {
  region = "eu-north-1"
}

provider "aws" {
  alias  = "secondary"
  region = "us-east-1"
}
```

The secondary provider can be selected by a resource using:

```hcl
provider = aws.secondary
```

This allows different resources in the same Terraform project to use different AWS regions.

In this practical, the EC2 instance was deployed only in `eu-north-1`.

## Input Variables

Input variables make Terraform configurations reusable and reduce hard-coded values.

Example:

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

The resource can reference the variable:

```hcl
instance_type = var.instance_type
```

The variables used in this project include:

* `ami`
* `instance_type`
* `subnet_id`
* `key_name`
* `environment`

## Terraform TFVars

The `terraform.tfvars` file provides values for the input variables.

Example:

```hcl
ami           = "..."
instance_type = "t3.micro"
subnet_id     = "..."
key_name      = "test1234"
environment   = "dev"
```

Terraform automatically loads `terraform.tfvars`.

The file is excluded from Git using `.gitignore` because it contains environment-specific configuration values.

## Conditional Expressions

Terraform supports conditional expressions using:

```text
condition ? true_value : false_value
```

This project uses the environment to determine the EC2 instance type:

```hcl
instance_type = var.environment == "prod" ? "t3.small" : var.instance_type
```

The logic is:

```text
environment = prod
      ↓
   t3.small

environment != prod
      ↓
var.instance_type
```

This demonstrates how Terraform configuration can change based on environment-specific values.

## Built-in Functions

Terraform provides built-in functions for working with values.

Functions practiced in this project include:

### `lower()`

Converts a string to lowercase.

```hcl
lower(var.environment)
```

### `length()`

Returns the number of characters in a string.

```hcl
length(var.environment)
```

These functions were used to demonstrate how Terraform expressions can transform and evaluate values.

## Outputs

Outputs expose useful information after Terraform creates infrastructure.

This project defines outputs for:

* EC2 instance ID
* EC2 public IP
* Environment name length

Example:

```hcl
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.terraform_ec2.public_ip
}
```

Outputs can be displayed using:

```bash
terraform output
```

## Terraform Workflow

The following Terraform workflow was practiced:

```text
terraform fmt
      ↓
terraform validate
      ↓
terraform init
      ↓
terraform plan
      ↓
terraform apply
      ↓
Verify AWS resource
      ↓
terraform output
      ↓
terraform destroy
```

### `terraform fmt`

Formats Terraform configuration files using Terraform's standard formatting.

### `terraform validate`

Checks whether the Terraform configuration is syntactically and structurally valid.

### `terraform init`

Initializes the Terraform working directory and downloads required providers.

### `terraform plan`

Shows the infrastructure changes Terraform intends to make without applying them.

### `terraform apply`

Creates or modifies infrastructure according to the Terraform configuration.

### `terraform destroy`

Removes infrastructure managed by the Terraform configuration.

## Terraform Plan

`terraform plan` provides a preview of the changes Terraform intends to make.

Example:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

A normal `terraform plan` does not save the plan to a file.

Terraform also supports saving a plan:

```bash
terraform plan -out=tfplan
```

The saved plan can then be applied with:

```bash
terraform apply tfplan
```

## Troubleshooting

### Duplicate Variable Declaration

During implementation, duplicate variable declarations were encountered.

Example:

```text
Error: Duplicate variable declaration
```

Terraform requires variable names to be unique within a module.

The issue was resolved by removing the duplicate variable blocks.

### Missing Required Provider

`terraform validate` was initially run before the AWS provider was initialized.

Terraform reported:

```text
Error: Missing required provider
```

The issue was resolved by running:

```bash
terraform init
```

After initialization, the configuration was successfully validated.

## Terraform State

Terraform creates state files to track the infrastructure it manages.

Files such as:

```text
terraform.tfstate
terraform.tfstate.backup
```

were generated during the practical.

These files are excluded from Git using `.gitignore`.

State management will be covered in greater detail in the later Terraform State and Collaboration topic.

## Security and Git

The following files and directories are excluded from Git:

```text
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
```

The `.terraform.lock.hcl` file is retained because it records the provider dependency selections used by the project.

Sensitive credentials and AWS access keys are not stored in the Terraform project.

## Commands Practiced

```bash
terraform --version
aws --version
aws sts get-caller-identity

terraform fmt
terraform validate
terraform init
terraform plan
terraform apply
terraform output
terraform destroy
```

## Key Learnings

* Providers allow Terraform to interact with external platforms.
* `required_providers` defines provider dependencies.
* Provider configuration determines where Terraform operates.
* Multiple provider configurations can be used in one project.
* Provider aliases allow different AWS regions to be used.
* Terraform can work with multiple cloud platforms.
* Variables remove hard-coded configuration values.
* `terraform.tfvars` provides values for input variables.
* Conditional expressions allow environment-specific configuration.
* Built-in functions can transform and evaluate Terraform values.
* Outputs expose useful infrastructure information.
* `terraform plan` previews infrastructure changes.
* `terraform apply` creates infrastructure.
* `terraform destroy` removes managed infrastructure.
* Terraform state tracks managed infrastructure.
* `.gitignore` prevents Terraform state, working directories, and variable files from being committed.


```
```

