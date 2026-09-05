# AWS + Ansible

This directory contains practical work demonstrating how Ansible can interact with AWS infrastructure.

The examples focus on using Ansible with the AWS ecosystem, particularly Amazon EC2, through the `amazon.aws` Ansible collection.

---

## Overview

Ansible can be used not only to configure operating systems and applications, but also to interact with cloud infrastructure.

In this lab, AWS provides the infrastructure layer while Ansible provides the automation and configuration layer.

```text
AWS
 │
 └── EC2
      │
      ▼
 Ansible + amazon.aws
      │
      ├── Discover infrastructure
      ├── Retrieve EC2 information
      └── Configure managed hosts
```

This directory focuses specifically on the **AWS integration layer**. Dynamic Inventory is documented separately under [`dynamic-inventory/`](../dynamic-inventory/).

---

## Files

```text
aws/
├── README.md
└── aws-web.yml
```

### `aws-web.yml`

Contains the practical AWS + Ansible automation example used during the lab.

---

## AWS and Ansible

There are two different responsibilities in the lab:

### AWS

AWS provides the infrastructure:

* EC2 instances
* Networking
* Security groups
* Instance metadata
* Tags
* Compute resources

### Ansible

Ansible provides automation:

* Connect to servers
* Configure operating systems
* Install packages
* Manage services
* Deploy configuration
* Query infrastructure information
* Automate repeatable operations

The combination can be represented as:

```text
AWS Infrastructure
       ↓
      EC2
       ↓
Ansible
       ↓
Configuration & Automation
```

---

## Ansible AWS Collection

AWS functionality is provided through the:

```text
amazon.aws
```

Ansible collection.

Collections package Ansible content such as:

* Modules
* Plugins
* Roles
* Other automation components

Check installed collections:

```bash
ansible-galaxy collection list
```

The `amazon.aws` collection should be available before using AWS-specific modules and plugins.

---

## AWS Authentication

Ansible needs AWS credentials when it communicates with AWS APIs.

The lab uses AWS CLI credentials configured outside the Git repository.

Verify the AWS identity:

```bash
aws sts get-caller-identity
```

This confirms that the AWS CLI can authenticate and identifies the AWS account/user being used.

AWS credentials should **never** be hardcoded into playbooks or committed to GitHub.

---

## EC2 Instance Information

One of the AWS modules practiced in this lab is:

```text
amazon.aws.ec2_instance_info
```

Its purpose is to retrieve information about EC2 instances.

Example:

```bash
ansible localhost -c local \
  -m amazon.aws.ec2_instance_info \
  -a "region=eu-north-1"
```

This can return information such as:

* Instance ID
* Instance type
* Private IP
* Public IP
* Instance state
* Availability zone
* Tags
* Network information

---

## Module vs Inventory Plugin

It is important to distinguish between AWS modules and the Dynamic Inventory plugin.

### EC2 Information Module

```text
amazon.aws.ec2_instance_info
```

This is an **Ansible module**.

It is used to query EC2 information during Ansible execution.

```text
Ansible
   ↓
ec2_instance_info
   ↓
AWS API
   ↓
EC2 information
```

### EC2 Dynamic Inventory

```text
amazon.aws.aws_ec2
```

This is an **Inventory Plugin**.

It discovers EC2 instances and creates the Ansible inventory.

```text
AWS
 ↓
EC2 instances
 ↓
aws_ec2 inventory plugin
 ↓
Ansible inventory
```

These two components solve different problems.

---

## EC2 Information vs Dynamic Inventory

| Component                      | Type             | Purpose                  |
| ------------------------------ | ---------------- | ------------------------ |
| `amazon.aws.ec2_instance_info` | Module           | Retrieve EC2 information |
| `amazon.aws.aws_ec2`           | Inventory Plugin | Discover EC2 hosts       |

The Dynamic Inventory implementation is documented separately in:

```text
../dynamic-inventory/
```

---

## AWS Tags

EC2 tags provide metadata that can describe the purpose or environment of an instance.

Example:

```text
Name=test
Environment=Dev
Role=Web
```

Tags are useful for:

* Identifying resources
* Grouping infrastructure
* Environment classification
* Application identification
* Automation targeting

Dynamic Inventory can consume these tags and create Ansible groups.

For example:

```text
Environment=Dev
Role=Web
```

can result in:

```text
environment_Dev
role_Web
```

This allows automation to target infrastructure logically rather than relying on manually maintained IP addresses.

---

## Region

The AWS lab infrastructure is deployed in:

```text
eu-north-1
```

AWS resources are region-specific, so AWS modules and inventory configurations need to query the correct region.

Example:

```yaml
region: eu-north-1
```

or:

```bash
-a "region=eu-north-1"
```

---

## Localhost Execution

Some AWS modules interact with the AWS API rather than the managed EC2 server itself.

For these operations, Ansible can execute the module locally:

```bash
ansible localhost -c local ...
```

Here:

```text
localhost
    ↓
Ansible Control Node
    ↓
AWS API
    ↓
AWS Infrastructure
```

This is different from configuration tasks that connect to an EC2 instance over SSH.

---

## AWS API vs SSH

The lab demonstrates two different communication paths.

### AWS API Operations

Used for querying or managing AWS infrastructure:

```text
Ansible Control Node
        ↓
     AWS API
        ↓
       AWS
```

Example:

```text
amazon.aws.ec2_instance_info
```

### Server Configuration

Used to configure the operating system on an EC2 instance:

```text
Ansible Control Node
        ↓
        SSH
        ↓
    EC2 Instance
```

Example:

```text
apt
service
file
template
```

This distinction is important when designing cloud automation.

---

## Practical Workflow

The AWS + Ansible workflow used in this lab can be summarized as:

```text
AWS Account
    ↓
EC2 Infrastructure
    ↓
AWS Authentication
    ↓
amazon.aws Collection
    ↓
Query / Discover EC2
    ↓
Ansible Inventory
    ↓
SSH to Managed Node
    ↓
Configuration Automation
```

---

## Example: Query EC2

A basic EC2 information query:

```bash
ansible localhost -c local \
  -m amazon.aws.ec2_instance_info \
  -a "region=eu-north-1"
```

The returned information can be used to understand the current AWS infrastructure.

For example:

```text
Instance ID
Instance Type
Private IP
Public IP
State
Tags
```

---

## Example: Use EC2 Information in Automation

AWS information can be queried independently:

```text
ec2_instance_info
```

while server configuration can be performed separately:

```text
apt
service
template
file
```

This allows infrastructure discovery and server configuration to be treated as separate automation concerns.

---

## AWS Credentials and Security

AWS credentials are sensitive.

Do not store credentials directly in:

```text
aws-web.yml
aws_ec2.yml
README.md
```

Do not commit:

```text
AWS Access Keys
AWS Secret Keys
Private SSH Keys
Vault Passwords
```

to GitHub.

The lab keeps AWS CLI credentials outside the repository.

---

## Relationship to Dynamic Inventory

AWS integration and Dynamic Inventory are related but should not be confused.

```text
AWS Integration
       │
       ├── AWS Modules
       │      └── Query/manage AWS resources
       │
       └── Dynamic Inventory
              └── Discover hosts
```

The Dynamic Inventory implementation is maintained separately in:

```text
../dynamic-inventory/
```

---

## Relationship to the Final Project

The AWS integration concepts are used in the final project.

The final project combines:

```text
AWS
 ↓
EC2
 ↓
Dynamic Inventory
 ↓
Ansible
 ↓
Role
 ↓
Nginx
```

The final project is documented separately in:

```text
../final-project/
```

---

## Useful Commands

### Verify AWS authentication

```bash
aws sts get-caller-identity
```

### Check AWS CLI version

```bash
aws --version
```

### Check Ansible version

```bash
ansible --version
```

### List installed Ansible collections

```bash
ansible-galaxy collection list
```

### Query EC2 information

```bash
ansible localhost -c local \
  -m amazon.aws.ec2_instance_info \
  -a "region=eu-north-1"
```

### View Dynamic Inventory

```bash
ansible-inventory --graph
```

### Test discovered EC2 hosts

```bash
ansible role_Web -m ping
```

---

## Troubleshooting

### AWS Authentication

If an AWS module fails, first verify:

```bash
aws sts get-caller-identity
```

If this fails, the issue is related to AWS authentication or credentials rather than the Ansible playbook itself.

### Incorrect Region

Confirm that the AWS resource exists in the configured region:

```text
eu-north-1
```

### Missing Collection

Check:

```bash
ansible-galaxy collection list
```

Confirm:

```text
amazon.aws
```

is installed.

### EC2 Not Appearing in Inventory

Check:

```bash
ansible-inventory --graph
```

Then verify:

* EC2 instance state
* AWS region
* AWS credentials
* EC2 tags
* Dynamic Inventory configuration

---

## Key Concepts Demonstrated

This directory provides practical experience with:

* AWS and Ansible integration
* Amazon EC2
* `amazon.aws` collection
* AWS authentication
* EC2 information retrieval
* AWS regions
* EC2 tags
* AWS API communication
* Local Ansible execution
* Difference between AWS modules and inventory plugins
* Relationship between AWS infrastructure and Ansible configuration management

---

## Summary

AWS provides the infrastructure, while Ansible provides the automation layer.

The practical model demonstrated in this repository is:

```text
                AWS
                 │
                 ▼
              EC2
                 │
       ┌─────────┴─────────┐
       │                   │
   AWS API              SSH
       │                   │
       ▼                   ▼
AWS Modules         Configuration
       │             Management
       │                   │
       └─────────┬─────────┘
                 ▼
              Ansible
```

This foundation is extended further through **Dynamic Inventory** and the **role-based final project**.

