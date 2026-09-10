# Terraform EC2 Module

A reusable Terraform module for provisioning an AWS EC2 instance.

This project demonstrates how to separate reusable infrastructure logic into a child module while keeping environment-specific configuration in the root module.

---

## Project Overview

The project creates an AWS EC2 instance using a reusable Terraform module.

The root module provides the configuration values, passes them to the EC2 module, and receives the EC2 instance ID and public IP as outputs.

### Architecture

```text
                         ROOT MODULE
                    ┌─────────────────────┐
                    │                     │
                    │ terraform.tfvars    │
                    │        │            │
                    │        ▼            │
                    │ variables.tf        │
                    │        │            │
                    │        ▼            │
                    │     main.tf         │
                    │        │            │
                    └────────┼────────────┘
                             │
                             │ Module Inputs
                             ▼
                  ┌──────────────────────────┐
                  │     EC2 CHILD MODULE     │
                  │                          │
                  │      variables.tf       │
                  │            │             │
                  │            ▼             │
                  │         main.tf          │
                  │            │             │
                  │            ▼             │
                  │    aws_instance.this     │
                  │            │             │
                  │            ▼             │
                  │        outputs.tf        │
                  └────────────┼─────────────┘
                               │
                               │ Module Outputs
                               ▼
                         ROOT MODULE
                  ┌─────────────────────┐
                  │                     │
                  │     outputs.tf      │
                  │          │          │
                  │          ▼          │
                  │   Final Terraform   │
                  │      Outputs        │
                  │                     │
                  └─────────────────────┘
````

---

## Project Structure

```text
01-EC2-Module/
│
├── main.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── README.md
│
└── modules/
    └── ec2-instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## How the Project Works

The project has two Terraform layers:

### Root Module

The root module is responsible for:

* AWS provider configuration
* Defining input variables
* Providing variable values
* Calling the child module
* Consuming module outputs

### Child Module

The child module is responsible for:

* Defining module inputs
* Creating the EC2 instance
* Defining module outputs

This separation makes the EC2 configuration reusable.

---

# Configuration Flow

## 1. `terraform.tfvars`

The project-specific values are defined in `terraform.tfvars`.

```hcl
ami           = "ami-035c8a091035e710a"
instance_type = "t3.micro"
subnet_id     = "subnet-06fd8657f4a7f6722"
key_name      = "test1234"
environment   = "dev"
name          = "terraform-module-ec2"
```

These values are assigned to the variables defined in the root `variables.tf`.

```text
terraform.tfvars
       │
       ▼
root variables.tf
```

---

## 2. Root `variables.tf`

The root module defines the variables required by the project.

```text
variable "ami"
variable "instance_type"
variable "subnet_id"
variable "key_name"
variable "environment"
variable "name"
```

Terraform makes the values available through:

```text
var.ami
var.instance_type
var.subnet_id
var.key_name
var.environment
var.name
```

Flow:

```text
terraform.tfvars
       │
       ▼
root variables.tf
       │
       ▼
root var.*
```

---

## 3. Root `main.tf`

The root module calls the reusable EC2 module.

```hcl
module "ec2_instance" {
  source = "./modules/ec2-instance"

  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  name          = var.name
  environment   = var.environment
}
```

The root variables are passed to the child module one-to-one.

```text
Root Module                         Child Module

var.ami              ───────────►  var.ami
var.instance_type    ───────────►  var.instance_type
var.subnet_id        ───────────►  var.subnet_id
var.key_name         ───────────►  var.key_name
var.name             ───────────►  var.name
var.environment      ───────────►  var.environment
```

---

# EC2 Module

The reusable module is located at:

```text
modules/ec2-instance/
```

## 4. Module `variables.tf`

The child module defines the inputs it expects from the root module.

```text
Root main.tf
     │
     │ module arguments
     ▼
modules/ec2-instance/variables.tf
```

The module can then access the values using:

```text
var.ami
var.instance_type
var.subnet_id
var.key_name
var.name
var.environment
```

---

## 5. Module `main.tf`

The child module uses the input variables to create the EC2 instance.

```hcl
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name        = var.name
    Environment = var.environment
  }
}
```

The mapping is:

```text
Module Variable                    EC2 Resource

var.ami              ───────────►  aws_instance.this.ami

var.instance_type    ───────────►  aws_instance.this.instance_type

var.subnet_id        ───────────►  aws_instance.this.subnet_id

var.key_name         ───────────►  aws_instance.this.key_name

var.name             ───────────►  aws_instance.this.tags.Name

var.environment      ───────────►  aws_instance.this.tags.Environment
```

The result is an AWS EC2 instance.

```text
modules/ec2-instance/main.tf
             │
             ▼
     aws_instance.this
             │
             ▼
          AWS EC2
```

---

# Output Flow

## 6. Module `outputs.tf`

The child module exposes selected attributes from the EC2 resource.

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}
```

The resource attributes are passed to the module outputs.

```text
aws_instance.this.id
        │
        ▼
module output: instance_id


aws_instance.this.public_ip
        │
        ▼
module output: public_ip
```

---

## 7. Root `outputs.tf`

The root module consumes the outputs returned by the child module.

```hcl
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = module.ec2_instance.public_ip
}
```

The output flow is:

```text
AWS EC2
   │
   ├── instance ID
   │       │
   │       ▼
   │   Module outputs.tf
   │       │
   │       ▼
   │   module.ec2_instance.instance_id
   │       │
   │       ▼
   │   Root outputs.tf
   │
   └── public IP
           │
           ▼
       Module outputs.tf
           │
           ▼
       module.ec2_instance.public_ip
           │
           ▼
       Root outputs.tf
```

---

# Complete End-to-End Flow

```text
terraform.tfvars
       │
       │ Input Values
       ▼
Root variables.tf
       │
       │ var.*
       ▼
Root main.tf
       │
       │ Module Arguments
       ▼
Child Module variables.tf
       │
       │ var.*
       ▼
Child Module main.tf
       │
       ▼
aws_instance.this
       │
       │ Resource Attributes
       ▼
Child Module outputs.tf
       │
       │ Module Outputs
       ▼
Root outputs.tf
       │
       ▼
terraform output
```

---

# Module Inputs

| Variable        | Type     | Description                          |
| --------------- | -------- | ------------------------------------ |
| `ami`           | `string` | AMI ID used for the EC2 instance     |
| `instance_type` | `string` | EC2 instance type                    |
| `subnet_id`     | `string` | Subnet where the instance is created |
| `key_name`      | `string` | AWS key pair name                    |
| `name`          | `string` | EC2 instance name                    |
| `environment`   | `string` | Deployment environment               |

---

# Module Outputs

| Output        | Source                        | Description                   |
| ------------- | ----------------------------- | ----------------------------- |
| `instance_id` | `aws_instance.this.id`        | ID of the EC2 instance        |
| `public_ip`   | `aws_instance.this.public_ip` | Public IP of the EC2 instance |

---

# Why This Module Is Reusable

The EC2 resource configuration is maintained only once inside:

```text
modules/ec2-instance/
```

Different root configurations can reuse the same module by passing different values.

For example:

```hcl
module "web_server" {
  source = "./modules/ec2-instance"

  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  name          = "web-server"
  environment   = "dev"
}
```

The module implementation remains unchanged while the inputs can vary.

---

# Module Source

This project uses a local module:

```hcl
source = "./modules/ec2-instance"
```

Terraform loads the module from the local project directory.

Terraform modules can also be sourced from:

* GitHub repositories
* Git repositories
* Terraform Registry
* Other supported remote sources

When using external modules, consider:

* Source trustworthiness
* Maintenance
* Versioning
* Security
* Compatibility
* Documentation

---

# Terraform Workflow

```text
terraform fmt
      │
      ▼
terraform init
      │
      ▼
terraform validate
      │
      ▼
terraform plan
      │
      ▼
terraform apply
      │
      ▼
terraform output
      │
      ▼
terraform destroy
```

### Format

```bash
terraform fmt
```

Formats the Terraform configuration.

### Initialize

```bash
terraform init
```

Initializes Terraform and downloads the required provider.

It also initializes the local module.

### Validate

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically and structurally valid.

### Plan

```bash
terraform plan
```

Shows the infrastructure changes Terraform intends to make.

### Apply

```bash
terraform apply
```

Creates the EC2 instance.

### Output

```bash
terraform output
```

Displays the outputs returned by the root module.

### Destroy

```bash
terraform destroy
```

Removes the infrastructure managed by this project.

---

# Expected Result

After applying the configuration, Terraform creates:

```text
AWS EC2 Instance
```

The root module exposes:

```text
instance_id
public_ip
```

Example:

```text
instance_id = "i-xxxxxxxxxxxxxxxxx"
public_ip   = "x.x.x.x"
```

---

# Key Concepts Demonstrated

* Terraform root modules
* Terraform child modules
* Module inputs
* Module outputs
* Variable passing
* Resource-to-output mapping
* Local module sources
* Module reusability
* Terraform module architecture
* Separation of infrastructure logic and configuration

---

# Final Architecture

```text
                    ┌─────────────────┐
                    │ terraform.tfvars│
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Root variables  │
                    │    .tf          │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Root main.tf  │
                    │                 │
                    │ module call     │
                    └────────┬────────┘
                             │
                     INPUTS  │
                             ▼
             ┌────────────────────────────┐
             │      EC2 Child Module      │
             │                            │
             │      variables.tf          │
             │           │                │
             │           ▼                │
             │        main.tf             │
             │           │                │
             │           ▼                │
             │    aws_instance.this       │
             │           │                │
             │           ▼                │
             │       outputs.tf           │
             └────────────┬───────────────┘
                          │
                    OUTPUTS│
                          ▼
                 ┌─────────────────┐
                 │ Root outputs.tf │
                 └────────┬────────┘
                          │
                          ▼
                 ┌─────────────────┐
                 │ Final Terraform │
                 │     Output      │
                 │                 │
                 │ instance_id     │
                 │ public_ip       │
                 └─────────────────┘
```
