# Terraform Workspaces – Environment-Based Infrastructure

## 📌 Project Overview

This project demonstrates how Terraform Workspaces can be used to manage multiple environments using a **single Terraform configuration** while maintaining a **separate state for each environment**.

The practical uses three environments:

- Development
- Staging
- Production

Each environment uses the same Terraform configuration but maintains its own Terraform state and infrastructure.

The practical follows the Terraform Workspaces concepts demonstrated in the Terraform Zero to Hero series.

---

## 🎯 Objectives

This project demonstrates:

- Why a single Terraform state cannot safely manage separate environments using only different `.tfvars` files
- What Terraform Workspaces are
- Creating Terraform Workspaces
- Switching between Workspaces
- Workspace-specific Terraform state
- Using `terraform.workspace`
- Using `lookup()` with a Terraform map
- Creating separate infrastructure for Dev, Stage, and Prod
- Destroying infrastructure independently per workspace
- Understanding workspace-related operational risks

---

# 🏗️ Architecture

```text
                       One Terraform Project
                               │
                               ▼
                     Terraform Workspaces
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ▼                 ▼                 ▼
            dev              stage              prod
             │                 │                 │
             ▼                 ▼                 ▼
        State A            State B            State C
             │                 │                 │
             ▼                 ▼                 ▼
          EC2 A              EC2 B              EC2 C
        t3.micro            t3.small            t3.small

Each workspace has an independent Terraform state.

📁 Project Structure
01-Environment-Workspaces/
├── .gitignore
├── README.md
├── main.tf
├── variables.tf
├── terraform.tfvars
└── terraform.tfstate.d/
    ├── dev/
    │   └── terraform.tfstate
    ├── stage/
    │   ├── terraform.tfstate
    │   └── terraform.tfstate.backup
    └── prod/
        ├── terraform.tfstate
        └── terraform.tfstate.backup

The terraform.tfstate.d/ directory and Terraform state files are created locally during the practical but are excluded from Git using .gitignore.

1. The Environment Problem

Suppose an organization has three environments:

Dev
Stage
Prod

The infrastructure requirements are similar, but each environment needs its own infrastructure.

For example:

Dev   → EC2
Stage → EC2
Prod  → EC2

A simple approach might be to create different .tfvars files:

terraform.tfvars
stage.tfvars
prod.tfvars

However, if all configurations use the same Terraform state, Terraform can interpret the Stage configuration as a change to the infrastructure already tracked for Dev.

For example:

Dev state
    ↓
EC2 t3.micro

Stage configuration
    ↓
EC2 t3.small

Terraform compares them
    ↓
Existing EC2 may be modified

This does not provide independent infrastructure for each environment.

2. Terraform Workspace Solution

Terraform Workspaces provide separate state for different environments while allowing the same Terraform configuration to be reused.

Terraform Project
│
├── dev
│   └── terraform.tfstate
│
├── stage
│   └── terraform.tfstate
│
└── prod
    └── terraform.tfstate

The configuration remains the same:

main.tf
variables.tf
terraform.tfvars

but Terraform maintains separate state for each workspace.

3. Terraform Configuration
main.tf
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
  # AWS region used for this practical
  region = "eu-north-1"
}

# Create an EC2 instance for the active Terraform workspace
resource "aws_instance" "workspace_demo" {
  # Ubuntu AMI used for all environments
  ami = var.ami

  # Select the instance type based on the active workspace
  # Example:
  # dev   = t3.micro
  # stage = t3.small
  # prod  = t3.small
  instance_type = lookup(
    var.instance_types,
    terraform.workspace,
    "t3.micro"
  )

  # Use the existing subnet from the AWS lab environment
  subnet_id = var.subnet_id

  # Use the existing AWS key pair
  key_name = var.key_name

  # Add tags that identify the Terraform workspace
  tags = {
    Name        = "terraform-workspace-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
4. Variables
variables.tf
# AMI used for the EC2 instance
variable "ami" {
  description = "Ubuntu AMI used for the EC2 instance"
  type        = string
}

# Subnet where the EC2 instance will be created
variable "subnet_id" {
  description = "AWS subnet ID for the EC2 instance"
  type        = string
}

# Existing AWS key pair used for the EC2 instance
variable "key_name" {
  description = "AWS key pair name"
  type        = string
}

# EC2 instance types mapped to Terraform workspaces
variable "instance_types" {
  description = "EC2 instance type for each Terraform workspace"
  type        = map(string)

  # Define the instance type for each environment
  default = {
    # Development environment
    dev = "t3.micro"

    # Staging environment
    stage = "t3.small"

    # Production environment
    prod = "t3.small"
  }
}
5. Terraform Variables File
terraform.tfvars
# Ubuntu AMI used for this practical
ami = "ami-035c8a091035e710a"

# Existing subnet in eu-north-1
subnet_id = "subnet-06fd8657f4a7f6722"

# Existing AWS key pair
key_name = "test1234"
6. Initialize Terraform
# Initialize Terraform and download the required AWS provider
terraform init
7. Format Configuration
# Format Terraform configuration files
terraform fmt
8. Validate Configuration
# Validate the Terraform configuration
terraform validate

Expected:

Success! The configuration is valid.
9. Check the Default Workspace
# Display the currently selected Terraform workspace
terraform workspace show

Initially:

default

List all workspaces:

# Display all Terraform workspaces
terraform workspace list
10. Create Workspaces

Create the three environment workspaces:

# Create the Development workspace
terraform workspace new dev

# Create the Stage workspace
terraform workspace new stage

# Create the Production workspace
terraform workspace new prod

List them:

# Display all Terraform workspaces
terraform workspace list

Example:

  default
  dev
  stage
* prod

The * identifies the currently selected workspace.

11. Switch Between Workspaces

Switch to Development:

# Switch to the Development workspace
terraform workspace select dev

Switch to Stage:

# Switch to the Stage workspace
terraform workspace select stage

Switch to Production:

# Switch to the Production workspace
terraform workspace select prod

Check the active workspace:

# Display the currently selected workspace
terraform workspace show
12. Workspace-Specific State

Terraform creates separate state for each workspace.

The local state structure becomes:

terraform.tfstate.d/
├── dev/
│   └── terraform.tfstate
├── stage/
│   └── terraform.tfstate
└── prod/
    └── terraform.tfstate

Therefore:

dev workspace
     ↓
dev state
     ↓
Dev infrastructure

and:

stage workspace
     ↓
stage state
     ↓
Stage infrastructure

and:

prod workspace
     ↓
prod state
     ↓
Production infrastructure
13. Workspace-Specific Instance Types

The project uses a Terraform map:

default = {
  dev   = "t3.micro"
  stage = "t3.small"
  prod  = "t3.small"
}

The active workspace is obtained using:

terraform.workspace

The lookup() function selects the corresponding instance type:

lookup(
  var.instance_types,
  terraform.workspace,
  "t3.micro"
)

The flow is:

terraform.workspace
        │
        ▼
 ┌──────┼─────────┐
 │      │         │
dev   stage      prod
 │      │         │
 ▼      ▼         ▼
t3.micro t3.small t3.small
14. Create Development Infrastructure

Switch to Dev:

# Switch to the Development workspace
terraform workspace select dev

# Confirm the active workspace
terraform workspace show

Create a plan:

# Create the Development execution plan
terraform plan

Apply:

# Create the Development EC2 infrastructure
terraform apply

Verify:

# List resources tracked by the Development workspace
terraform state list

Expected:

aws_instance.workspace_demo
15. Create Stage Infrastructure

Switch to Stage:

# Switch to the Stage workspace
terraform workspace select stage

Check the plan:

# Create the Stage execution plan
terraform plan

Apply:

# Create the Stage EC2 infrastructure
terraform apply

The Stage workspace uses its own state and therefore creates a separate EC2 instead of modifying the Dev EC2.

16. Create Production Infrastructure

Switch to Production:

# Switch to the Production workspace
terraform workspace select prod

Create the plan:

# Create the Production execution plan
terraform plan

Apply:

# Create the Production EC2 infrastructure
terraform apply

Production also has an independent state.

17. Verify Workspace Isolation
Development
# Switch to the Development workspace
terraform workspace select dev

# Confirm the active workspace
terraform workspace show

# Show resources tracked in the Dev state
terraform state list

# Display the Dev infrastructure state
terraform state show aws_instance.workspace_demo

Expected instance type:

t3.micro
Stage
# Switch to the Stage workspace
terraform workspace select stage

# Confirm the active workspace
terraform workspace show

# Show resources tracked in the Stage state
terraform state list

# Display the Stage infrastructure state
terraform state show aws_instance.workspace_demo

Expected instance type:

t3.small
Production
# Switch to the Production workspace
terraform workspace select prod

# Confirm the active workspace
terraform workspace show

# Show resources tracked in the Production state
terraform state list

# Display the Production infrastructure state
terraform state show aws_instance.workspace_demo

Expected instance type:

t3.small
18. Final Workspace State Structure

After creating all three environments:

terraform.tfstate.d/
├── dev/
│   └── terraform.tfstate
├── stage/
│   ├── terraform.tfstate
│   └── terraform.tfstate.backup
└── prod/
    └── terraform.tfstate

Each workspace has an independent state.

19. Terraform Plan Verification

Each workspace can be checked independently.

Development:

# Switch to Dev
terraform workspace select dev

# Verify that Dev matches its state and configuration
terraform plan

Stage:

# Switch to Stage
terraform workspace select stage

# Verify that Stage matches its state and configuration
terraform plan

Production:

# Switch to Prod
terraform workspace select prod

# Verify that Production matches its state and configuration
terraform plan

Expected:

No changes. Your infrastructure matches the configuration.
20. Destroy Infrastructure Per Workspace

Terraform operates on the currently selected workspace.

Production
# Select the Production workspace
terraform workspace select prod

# Destroy only Production infrastructure
terraform destroy
Stage
# Select the Stage workspace
terraform workspace select stage

# Destroy only Stage infrastructure
terraform destroy
Development
# Select the Development workspace
terraform workspace select dev

# Destroy only Development infrastructure
terraform destroy

After destruction, the workspace states remain but no resources are tracked.

21. Important Operational Warning

Always verify the active workspace before running destructive commands.

For example:

# Display the currently selected workspace
terraform workspace show

Before:

# Destroy infrastructure in the selected workspace
terraform destroy

The same Terraform command can affect completely different infrastructure depending on the selected workspace.

terraform destroy
      │
      ▼
Current Workspace
      │
 ┌────┼────┐
 ▼    ▼    ▼
dev stage prod

Therefore, workspace selection must be treated carefully, especially for production environments.

22. Important Commands
Command	Purpose
terraform workspace list	List all workspaces
terraform workspace show	Show the current workspace
terraform workspace new <name>	Create a workspace
terraform workspace select <name>	Switch workspace
terraform workspace delete <name>	Delete a workspace
terraform plan	Preview changes in the current workspace
terraform apply	Apply changes to the current workspace
terraform destroy	Destroy infrastructure in the current workspace
terraform state list	List resources in the current workspace state
terraform state show <address>	Inspect a resource in the current workspace state
23. Key Concepts
One Configuration

The same Terraform configuration can be reused:

main.tf
variables.tf
terraform.tfvars
Multiple Workspaces
dev
stage
prod
Separate State
dev   → State A
stage → State B
prod  → State C
Workspace Selection
terraform workspace select dev

changes which environment Terraform operates on.

terraform.workspace

Terraform exposes the active workspace through:

terraform.workspace

This can be used to select environment-specific configuration.

lookup()

The lookup() function can select a value from a map based on the active workspace.

24. Practical Troubleshooting

During this practical, Stage initially used:

t3.medium

AWS rejected the request because the instance type was not eligible for the account's available Free Tier options.

The available eligible types were checked using:

# List EC2 instance types reported as Free Tier eligible
aws ec2 describe-instance-types \
  --filters "Name=free-tier-eligible,Values=true" \
  --query "InstanceTypes[].InstanceType" \
  --output table \
  --region eu-north-1

The workspace configuration was then adjusted to use:

dev   → t3.micro
stage → t3.small
prod  → t3.small

This demonstrated that the Terraform workspace configuration was working correctly and the original failure was an AWS instance-type eligibility issue.

25. Git Safety

Terraform state files should not be committed to GitHub.

The project .gitignore contains:

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

Therefore these files remain local:

terraform.tfstate
terraform.tfstate.backup
terraform.tfvars
.terraform/

Only Terraform configuration and documentation should be committed.

26. Final Learning Flow
Terraform Configuration
        │
        ▼
Create Workspaces
        │
        ├── dev
        ├── stage
        └── prod
        │
        ▼
Separate State
        │
        ├── Dev State
        ├── Stage State
        └── Prod State
        │
        ▼
Workspace-Specific Configuration
        │
        ▼
Separate Infrastructure
        │
        ▼
Verify Independently
        │
        ▼
Destroy Independently
27. Final Outcome

This practical demonstrated how Terraform Workspaces allow a single Terraform project to manage multiple environments while maintaining separate state for each workspace.

Final concept:

One Terraform Project
        │
        ▼
Multiple Workspaces
        │
        ├── Dev   → Separate State → Separate Infrastructure
        ├── Stage → Separate State → Separate Infrastructure
        └── Prod  → Separate State → Separate Infrastructure

The most important operational rule is:

Always verify the active workspace before running terraform apply or terraform destroy.