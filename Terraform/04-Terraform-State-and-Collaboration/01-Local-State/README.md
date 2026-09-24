# Terraform State and Collaboration – Local State & Remote S3 Backend

## 📌 Project Overview

This project demonstrates how **Terraform state** works and why remote state is important when working with Terraform in a team.

The practical covers:

- Terraform local state
- How Terraform tracks AWS resources using state
- State loss and resource tracking
- Terraform state commands
- Creating an S3 bucket for remote state
- Migrating local state to S3
- S3 state versioning
- S3-native state locking
- Team collaboration using shared remote state
- Terraform plan/apply/destroy with remote state
- State behavior after infrastructure destruction and recreation

The project uses an **AWS EC2 instance** as the infrastructure resource.

---

## 🏗️ Architecture

### Local State

```text
main.tf
   │
   ▼
Terraform
   │
   ├── terraform.tfstate
   │
   ▼
AWS EC2 Instance
````

Terraform uses `terraform.tfstate` to keep track of the AWS resource it manages.

---

### Remote State

```text
                    GitHub
                      │
                      │ Git
                      ▼
              Terraform Configuration
              ├── main.tf
              └── backend.tf
                      │
                      ▼
                 Terraform
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
     S3 State                 AWS APIs
          │                       │
          ▼                       ▼
 terraform.tfstate           EC2 Instance
          │
          ▼
    State Lock File
```

---

## 📁 Project Structure

```text
04-Terraform-State-and-Collaboration/
└── 01-Local-State/
    ├── .terraform/
    ├── .terraform.lock.hcl
    ├── main.tf
    ├── backend.tf
    └── README.md
```

> Terraform state files and variable files are excluded from Git using `.gitignore`.

---

# 1. Terraform Configuration

## `main.tf`

```hcl
# Declare the Terraform providers required by this project
terraform {
  required_providers {
    # AWS provider used to create and manage AWS resources
    aws = {
      # Download the AWS provider from HashiCorp
      source = "hashicorp/aws"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  # AWS region where the EC2 instance will be created
  region = "eu-north-1"
}

# Create an EC2 instance for the Terraform State practical
resource "aws_instance" "state_demo" {
  # Ubuntu AMI used for this lab
  ami = "ami-035c8a091035e710a"

  # EC2 instance type used for the lab
  instance_type = "t3.micro"

  # Subnet where the EC2 instance will be created
  subnet_id = "subnet-06fd8657f4a7f6722"

  # Existing AWS key pair used for SSH access
  key_name = "test1234"

  # Add a meaningful name tag to identify the instance
  tags = {
    Name = "terraform-state-demo"
  }
}
```

---

# 2. Verify AWS Configuration

Before running Terraform, verify that the configured subnet exists.

```bash
# Verify that the configured subnet exists in the selected AWS region
aws ec2 describe-subnets \
  --subnet-ids subnet-06fd8657f4a7f6722 \
  --region eu-north-1
```

Verify that the configured AMI exists.

```bash
# Verify that the configured AMI exists in the selected AWS region
aws ec2 describe-images \
  --image-ids ami-035c8a091035e710a \
  --region eu-north-1
```

---

# 3. Initialize Terraform

```bash
# Initialize Terraform and download the required AWS provider
terraform init
```

---

# 4. Format Terraform Configuration

```bash
# Format Terraform configuration files using the standard Terraform format
terraform fmt
```

---

# 5. Validate Configuration

```bash
# Validate the Terraform configuration and provider configuration
terraform validate
```

Expected result:

```text
Success! The configuration is valid.
```

---

# 6. Create Terraform Plan

```bash
# Show the infrastructure changes Terraform plans to make
terraform plan
```

Initially, Terraform plans to create the EC2 instance:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

---

# 7. Create EC2 Using Terraform

```bash
# Apply the Terraform configuration and create the EC2 instance
terraform apply
```

Terraform creates the EC2 instance and stores information about the resource in the state.

---

# 8. Terraform State

Terraform state is the record Terraform uses to track infrastructure that it manages.

For example:

```text
AWS EC2
   │
   ▼
Instance ID
Public IP
AMI
Instance Type
Subnet
Tags
   │
   ▼
Terraform State
```

Terraform uses the state when comparing:

```text
Desired Configuration
        +
Current State
        ↓
Terraform Plan
        ↓
Required Changes
```

---

# 9. Check Terraform State

List resources currently tracked by Terraform.

```bash
# Display all resources currently tracked in Terraform state
terraform state list
```

Expected:

```text
aws_instance.state_demo
```

---

## Inspect a Specific Resource

```bash
# Display detailed state information for the EC2 resource
terraform state show aws_instance.state_demo
```

This displays information such as:

* Instance ID
* AMI
* Instance type
* Subnet
* Availability Zone
* Private IP
* Public IP
* Tags
* Other resource attributes

---

# 10. Run Terraform Apply Again

After the infrastructure already exists:

```bash
# Check whether Terraform needs to make any infrastructure changes
terraform apply
```

Expected:

```text
No changes. Your infrastructure matches the configuration.
```

This demonstrates that Terraform uses state to understand that the EC2 already exists and is managed.

---

# 11. Demonstrate State Loss

Terraform depends on its state to track resources.

Remove the local state file:

```bash
# Remove the local Terraform state file for the state-loss demonstration
rm terraform.tfstate
```

Now run:

```bash
# Check what Terraform plans when the state no longer tracks the EC2
terraform plan
```

Terraform can propose:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

The EC2 still exists in AWS, but Terraform no longer has the local state record connecting the resource to:

```text
aws_instance.state_demo
```

### Important Concept

Deleting state **does not automatically delete the AWS resource**.

It removes Terraform's knowledge of the resource from that state.

---

# 12. Restore Resource Tracking

The existing EC2 can be imported back into Terraform state using:

```bash
# Import an existing AWS EC2 instance into Terraform state
terraform import aws_instance.state_demo <INSTANCE_ID>
```

After importing:

```bash
# Verify that Terraform is tracking the EC2 instance again
terraform state list
```

Expected:

```text
aws_instance.state_demo
```

---

# 13. Create S3 Bucket for Remote State

Terraform state should not be stored in GitHub.

Create an S3 bucket for remote Terraform state.

```bash
# Generate a globally unique S3 bucket name
BUCKET_NAME="ketan-terraform-state-$(date +%s)"

# Create the S3 bucket in the eu-north-1 region
aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region eu-north-1 \
  --create-bucket-configuration LocationConstraint=eu-north-1

# Display the bucket name so it can be used in backend configuration
echo "$BUCKET_NAME"
```

Example bucket:

```text
ketan-terraform-state-1790140692
```

---

# 14. Verify S3 Bucket

```bash
# Verify that the S3 bucket exists and is accessible
aws s3api head-bucket \
  --bucket "ketan-terraform-state-1790140692"
```

---

# 15. Enable S3 Versioning

Enable versioning so previous versions of the Terraform state object can be retained.

```bash
# Enable versioning on the Terraform state bucket
aws s3api put-bucket-versioning \
  --bucket "ketan-terraform-state-1790140692" \
  --versioning-configuration Status=Enabled
```

Verify:

```bash
# Check whether S3 bucket versioning is enabled
aws s3api get-bucket-versioning \
  --bucket "ketan-terraform-state-1790140692"
```

Expected:

```text
Status: Enabled
```

---

# 16. Configure S3 Backend

Create `backend.tf`.

## `backend.tf`

```hcl
# Configure Amazon S3 as the remote Terraform state backend
terraform {
  backend "s3" {
    # S3 bucket where Terraform will store the state
    bucket = "ketan-terraform-state-1790140692"

    # Path of the Terraform state file inside the S3 bucket
    key = "01-local-state/terraform.tfstate"

    # AWS region where the S3 bucket exists
    region = "eu-north-1"

    # Enable S3-native state locking
    use_lockfile = true
  }
}
```

---

# 17. Migrate Local State to S3

After creating `backend.tf`, run:

```bash
# Reinitialize Terraform and configure the S3 remote backend
terraform init
```

Terraform detects that the backend has changed and asks whether the existing local state should be migrated.

Select:

```text
yes
```

Terraform then moves the active state to:

```text
S3 Bucket
└── 01-local-state/
    └── terraform.tfstate
```

---

# 18. Verify State in S3

```bash
# List the Terraform state file stored in the S3 bucket
aws s3 ls s3://ketan-terraform-state-1790140692/01-local-state/
```

The state object should be visible.

---

# 19. Verify Terraform State After Migration

```bash
# Display resources tracked in the remote Terraform state
terraform state list
```

Expected:

```text
aws_instance.state_demo
```

Inspect the resource:

```bash
# Display detailed information about the EC2 resource from Terraform state
terraform state show aws_instance.state_demo
```

Terraform continues to work normally because it is now reading the state from the S3 backend.

---

# 20. Verify Remote Backend

Run:

```bash
# Check whether the infrastructure matches the remote Terraform state
terraform plan
```

Expected:

```text
No changes. Your infrastructure matches the configuration.
```

Apply again:

```bash
# Apply the configuration using the remote S3 state
terraform apply
```

Expected:

```text
No changes. Your infrastructure matches the configuration.
```

---

# 21. Terraform State Locking

The backend configuration contains:

```hcl
# Enable S3-native state locking
use_lockfile = true
```

This prevents multiple Terraform operations from modifying the same state simultaneously.

### Example

```text
User A
   │
   │ terraform apply
   ▼
S3 State
   │
   ▼
🔒 Lock acquired
   │
   ▼
AWS changes
   │
   ▼
State updated
   │
   ▼
🔓 Lock released
```

At the same time:

```text
User B
   │
   │ terraform apply
   ▼
S3 State
   │
   ▼
🔒 Already locked
   │
   ▼
Waits / cannot modify state
```

Terraform normally manages lock acquisition and release automatically.

---

# 22. Team Collaboration

Remote state allows multiple engineers to work with the same Terraform-managed infrastructure.

```text
                    GitHub
                       │
                       │
              Terraform Configuration
                       │
          ┌────────────┴────────────┐
          │                         │
       User A                    User B
          │                         │
          └────────────┬────────────┘
                       │
                       ▼
                 Terraform
                       │
                       ▼
                 S3 Remote State
                       │
                       ▼
                  AWS Resources
```

### GitHub

Stores:

```text
main.tf
backend.tf
variables.tf
modules/
README.md
```

### S3

Stores:

```text
terraform.tfstate
```

The state file should **not** be committed to GitHub.

---

# 23. Important Team Workflow

Suppose User A changes Terraform configuration.

```text
User A
  ↓
Modify main.tf
  ↓
git push
  ↓
GitHub
```

User B pulls the change:

```bash
# Pull the latest Terraform configuration from GitHub
git pull
```

Then:

```bash
# Check the difference between the configuration and current infrastructure
terraform plan
```

If the plan is approved:

```bash
# Apply the planned infrastructure changes
terraform apply
```

Terraform then:

```text
Configuration
      +
S3 State
      ↓
Terraform
      ↓
AWS Infrastructure
      ↓
Updated S3 State
```

### Important

`git pull` **does not pull the Terraform state**.

The state is obtained from the configured S3 backend when Terraform runs.

---

# 24. Destroy Infrastructure

To remove the EC2:

```bash
# Destroy infrastructure managed by this Terraform configuration
terraform destroy
```

Expected:

```text
Destroy complete! Resources: 1 destroyed.
```

After destruction:

```bash
# List resources currently tracked by Terraform
terraform state list
```

No resources should be listed.

Trying:

```bash
# Attempt to inspect the destroyed resource
terraform state show aws_instance.state_demo
```

will return:

```text
Error: No instance found for the given address!
```

This is expected because the resource has been removed from Terraform state.

---

# 25. Recreate the EC2

The S3 backend remains available even after destroying the EC2.

Simply run:

```bash
# Recreate the EC2 defined in main.tf
terraform apply
```

Terraform sees:

```text
main.tf
   ↓
aws_instance.state_demo exists in configuration

S3 State
   ↓
EC2 does not currently exist
```

Therefore Terraform plans:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

After creation, the new EC2 details are written to the S3 state.

The state represents the **current infrastructure**, not an append-only history.

---

# 26. State Update Concept

Terraform state should be understood as the **current record of managed infrastructure**.

Example:

```text
Before destroy:

S3 State
└── aws_instance.state_demo
    └── instance_id = i-OLD
```

After:

```bash
terraform destroy
```

```text
S3 State
└── No aws_instance.state_demo
```

After:

```bash
terraform apply
```

```text
S3 State
└── aws_instance.state_demo
    └── instance_id = i-NEW
```

Because S3 versioning is enabled, older S3 object versions may still exist, but Terraform's active state represents the current infrastructure.

---

# 27. Complete Terraform Workflow

```text
                  Terraform Configuration
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
                    AWS Infrastructure
                           │
                           ▼
                     S3 Remote State
                           │
                           ▼
                    State Locking
                           │
                           ▼
                   Team Collaboration
```

---

# 28. Important Commands

| Command                | Purpose                                        |
| ---------------------- | ---------------------------------------------- |
| `terraform init`       | Initialize Terraform and configure the backend |
| `terraform fmt`        | Format Terraform files                         |
| `terraform validate`   | Validate configuration                         |
| `terraform plan`       | Preview infrastructure changes                 |
| `terraform apply`      | Apply infrastructure changes                   |
| `terraform destroy`    | Destroy managed infrastructure                 |
| `terraform state list` | List resources tracked in state                |
| `terraform state show` | Display detailed state for a resource          |
| `terraform import`     | Import an existing resource into state         |

---

# 29. Key Concepts Learned

### Terraform State

Terraform state keeps track of the infrastructure Terraform manages.

### Local State

```text
Terraform
    ↓
terraform.tfstate
    ↓
AWS Resources
```

Useful for individual/local work but not ideal for team collaboration.

### Remote State

```text
Terraform
    ↓
S3
    ↓
terraform.tfstate
```

Allows multiple engineers to work with a shared state.

### State Locking

```text
User A → 🔒 State → Apply → 🔓
User B → ⏳ Wait
```

Prevents concurrent Terraform operations from modifying the same state simultaneously.

### Git vs Terraform State

```text
GitHub
  ↓
Desired Configuration

S3
  ↓
Current Terraform State
```

They have different responsibilities.

### Terraform Apply

```text
terraform apply
      ↓
Changes AWS infrastructure
      ↓
Updates Terraform state
```

---

# 30. Security and Best Practices

* **Do not commit `terraform.tfstate` to GitHub.**
* **Do not commit AWS credentials.**
* Use a remote backend for team environments.
* Enable S3 versioning for state recovery.
* Use state locking for team collaboration.
* Use least-privilege IAM permissions in real environments.
* Do not use AWS root credentials for Terraform.
* Review `terraform plan` before applying changes.
* Treat Terraform state as sensitive because it can contain infrastructure details and potentially sensitive values.

---

# 31. `.gitignore`

```gitignore
# Terraform working directory
.terraform/

# Terraform state files
*.tfstate
*.tfstate.*

# Terraform variable files
*.tfvars
*.tfvars.json

# Terraform crash logs
crash.log
crash.*.log
```

---

# 32. Final Project Outcome

This practical demonstrated the complete Terraform state lifecycle:

```text
Local State
    ↓
Create EC2
    ↓
Track Resource in State
    ↓
Demonstrate State Loss
    ↓
Restore Resource Tracking
    ↓
Create S3 Backend
    ↓
Enable Versioning
    ↓
Migrate State to S3
    ↓
Enable State Locking
    ↓
Verify Remote State
    ↓
Team Collaboration Model
    ↓
Destroy EC2
    ↓
Recreate EC2
    ↓
Update Remote State
```

The key takeaway is:

> **Terraform configuration defines what infrastructure should exist, Terraform state records what Terraform currently manages, and `terraform apply` reconciles the two while updating the remote state.**

```

