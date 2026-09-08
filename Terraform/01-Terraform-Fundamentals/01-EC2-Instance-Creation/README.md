
# Terraform EC2 Instance Creation

## Overview

This practical covers the fundamentals of Terraform and Infrastructure as Code (IaC) by creating an AWS EC2 instance using Terraform.

The practical follows the Terraform lifecycle:

```text
Terraform Configuration
        ↓
terraform init
        ↓
terraform validate
        ↓
terraform plan
        ↓
terraform apply
        ↓
AWS EC2 Instance
        ↓
terraform show / terraform state
        ↓
terraform destroy
````

---

## Objectives

* Understand Infrastructure as Code (IaC)
* Understand why Terraform is used
* Install and verify Terraform
* Configure Terraform for AWS
* Understand Terraform providers and resources
* Discover required AWS resource information
* Create an EC2 instance using Terraform
* Understand the Terraform lifecycle
* Understand Terraform state
* Troubleshoot common Terraform/AWS issues
* Destroy Terraform-managed infrastructure

---

## Environment

| Component        | Details              |
| ---------------- | -------------------- |
| Operating System | Windows + WSL Ubuntu |
| Terraform        | 1.16.1               |
| Cloud Provider   | AWS                  |
| AWS Region       | `eu-north-1`         |
| Editor           | Visual Studio Code   |
| Terminal         | Ubuntu WSL           |
| Resource         | AWS EC2              |
| Instance Type    | `t3.micro`           |

Terraform was executed from WSL and communicated with AWS through AWS APIs.

---

## Terraform Configuration

The Terraform configuration was created in:

```text
01-Terraform-Fundamentals/
└── 01-EC2-Instance-Creation/
    └── main.tf
```

### `main.tf`

```hcl
# Configure AWS as the cloud provider
provider "aws" {
  # AWS region where resources will be created
  region = "eu-north-1"
}

# Create an EC2 instance
resource "aws_instance" "terraform_ec2" {

  # Ubuntu AMI to use for the instance
  ami = "ami-035c8a091035e710a"

  # EC2 instance size
  instance_type = "t3.micro"

  # Subnet where the instance will be created
  subnet_id = "subnet-06fd8657f4a7f6722"

  # AWS key pair used for SSH access
  # This is the key-pair name, not the .pem file path
  key_name = "test1234"

  # Name tag for the EC2 instance
  tags = {
    Name = "terraform-ec2-instance-creation"
  }
}
```

---

## AWS Resource Discovery

Before creating the EC2 instance, the required AWS information was verified using AWS CLI.

### Verify AWS authentication

```bash
aws sts get-caller-identity
```

This confirmed that the AWS CLI was correctly authenticated.

### Check configured AWS region

```bash
aws configure get region
```

### Find the subnet

```bash
aws ec2 describe-subnets \
  --query 'Subnets[*].[SubnetId,AvailabilityZone,VpcId]' \
  --output table
```

### Check available key pairs

```bash
aws ec2 describe-key-pairs \
  --query 'KeyPairs[*].KeyName' \
  --output table
```

### Find the Ubuntu AMI

```bash
aws ec2 describe-images ...
```

The required values were then used in `main.tf`.

---

## Terraform Lifecycle

### 1. Format the configuration

```bash
terraform fmt
```

Formats Terraform configuration files according to Terraform's standard formatting.

### 2. Validate the configuration

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid and internally consistent.

### 3. Initialize Terraform

```bash
terraform init
```

Initializes the Terraform working directory and downloads the required provider plugins.

The AWS provider was installed during initialization.

### 4. Create an execution plan

```bash
terraform plan
```

Shows what Terraform intends to create, modify, or destroy without actually changing the infrastructure.

Expected result:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

### 5. Apply the configuration

```bash
terraform apply
```

Creates the infrastructure described in the Terraform configuration.

Terraform displayed a confirmation prompt before creating the EC2 instance.

### 6. Inspect Terraform state

```bash
terraform show
```

Displays the resources and attributes currently recorded in Terraform state.

### 7. List managed resources

```bash
terraform state list
```

Displays the resources currently managed by Terraform.

### 8. Destroy the infrastructure

```bash
terraform destroy
```

Removes the infrastructure managed by Terraform.

The EC2 instance created during the practical was successfully destroyed after verification.

---

## Troubleshooting

### Issue 1: Terraform provider was not initialized

Terraform requires the AWS provider before it can create AWS resources.

**Solution:**

```bash
terraform init
```

---

### Issue 2: IAM permission denied

During the first `terraform apply`, Terraform failed with:

```text
UnauthorizedOperation:
You are not authorized to perform: ec2:RunInstances
```

The IAM identity being used by Terraform did not have sufficient permission to launch an EC2 instance.

For this lab, the required EC2 permissions were added to the existing IAM group.

After updating the permissions, `terraform apply` was executed again successfully.

**Learning:**

Terraform itself does not bypass AWS permissions.

Terraform uses the AWS identity configured in the environment, and AWS IAM determines what Terraform is allowed to do.

---

### Issue 3: `t2.micro` was not eligible

The tutorial used:

```hcl
instance_type = "t2.micro"
```

However, the AWS account/region being used for this lab did not show `t2.micro` as an eligible instance type.

The available eligible instance types were checked using AWS CLI.

The configuration was changed to:

```hcl
instance_type = "t3.micro"
```

The Terraform plan and apply then completed successfully.

**Learning:**

Tutorial values are not always directly reusable because AWS availability, pricing, Free Tier eligibility, AMIs, and resource IDs can vary by account and region.

---

## Terraform State

Terraform maintains a state file to keep track of infrastructure it manages.

After running Terraform, the working directory contained files such as:

```text
.terraform/
.terraform.lock.hcl
main.tf
terraform.tfstate
terraform.tfstate.backup
```

### Important files

**`main.tf`**

Defines the desired infrastructure.

**`terraform.tfstate`**

Stores Terraform's record of the infrastructure it manages.

**`.terraform/`**

Contains Terraform's local working data and provider information.

**`.terraform.lock.hcl`**

Locks provider versions and should normally be committed to Git.

**`terraform.tfstate.backup`**

Backup of the previous Terraform state.

Terraform state files should not be committed to a public Git repository because they can contain sensitive infrastructure information.

---

## EC2 Verification

The created EC2 instance was verified using AWS CLI:

```bash
aws ec2 describe-instances ...
```

The verification confirmed that Terraform successfully created the EC2 instance.

After the practical was completed, `terraform destroy` was executed and the EC2 instance was removed.

---

## Important Learnings

### Terraform and AWS

Terraform communicates with AWS through the AWS provider and AWS APIs.

```text
WSL
 │
 ├── Terraform
 ├── AWS CLI
 └── Git
       │
       ▼
   AWS APIs
       │
       ▼
   AWS Infrastructure
```

### Terraform vs AWS Console

Instead of manually creating infrastructure through the AWS Console, Terraform allows infrastructure to be defined as code.

```text
Manual approach:
AWS Console → Create resources manually

Terraform:
main.tf → Terraform → AWS API → Resources
```

### Desired State vs Actual Infrastructure

Terraform configuration represents the desired state.

AWS contains the actual infrastructure.

Terraform state keeps track of the resources Terraform manages.

```text
main.tf
Desired State
     │
     ▼
 Terraform
     │
     ├──────────────► AWS Infrastructure
     │
     └──────────────► terraform.tfstate
```

### Key Pair vs PEM File

The Terraform configuration uses the AWS key pair name:

```hcl
key_name = "test1234"
```

The `.pem` file is the local private key used later when connecting to the EC2 instance through SSH.

The `.pem` file path should **not** be specified in `key_name`.

---

## Commands Practiced

```bash
terraform --version

aws --version

aws sts get-caller-identity

aws configure get region

aws ec2 describe-subnets ...

aws ec2 describe-key-pairs ...

aws ec2 describe-images ...

terraform fmt

terraform validate

terraform init

terraform plan

terraform apply

terraform show

terraform state list

terraform destroy
```

---

## Covered Area

* [x] Understand Infrastructure as Code
* [x] Understand Terraform fundamentals
* [x] Install Terraform
* [x] Configure AWS access
* [x] Configure AWS provider
* [x] Discover AWS resources
* [x] Create Terraform configuration
* [x] Run `terraform init`
* [x] Run `terraform validate`
* [x] Run `terraform plan`
* [x] Create EC2 using `terraform apply`
* [x] Verify EC2 creation
* [x] Inspect Terraform state
* [x] Troubleshoot IAM permission issue
* [x] Troubleshoot instance-type eligibility
* [x] Run `terraform destroy`
* [x] Confirm infrastructure cleanup


```
```

