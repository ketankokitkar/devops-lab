# Ansible Dynamic Inventory with AWS EC2

This directory demonstrates how Ansible can dynamically discover and organize AWS EC2 instances without maintaining a static inventory file.

The implementation uses the `amazon.aws.aws_ec2` inventory plugin to query AWS and build the Ansible inventory from running EC2 instances.

---

## Overview

In a traditional static inventory, server addresses are manually maintained.

Example:

```text
[webservers]
172.31.43.128
```

This approach becomes difficult to maintain when infrastructure changes frequently.

With Dynamic Inventory:

```text
AWS EC2
   ↓
amazon.aws.aws_ec2
   ↓
Dynamic Ansible Inventory
   ↓
Groups based on EC2 metadata
   ↓
Playbooks
```

Ansible can therefore discover the current infrastructure directly from AWS.

---

## File

```text
dynamic-inventory/
├── README.md
└── aws_ec2.yml
```

### `aws_ec2.yml`

Contains the configuration for the AWS EC2 Dynamic Inventory plugin.

---

## Architecture

```text
                 AWS Account
                     │
                     ▼
               EC2 Instances
                     │
               AWS Metadata
                     │
              ┌──────┴──────┐
              │             │
          Instance       EC2 Tags
          State             │
              │             │
              └──────┬──────┘
                     ▼
          amazon.aws.aws_ec2
                     │
                     ▼
           Ansible Inventory
                     │
             ┌───────┴───────┐
             │               │
       environment_Dev     role_Web
             │               │
             └───────┬───────┘
                     ▼
                Playbooks
```

---

## Why Dynamic Inventory?

Dynamic Inventory is useful when infrastructure is created, destroyed, or changed frequently.

Instead of updating IP addresses manually, Ansible queries the cloud provider and discovers the current hosts.

### Static Inventory

```text
Inventory file
     ↓
Manually maintained hosts
     ↓
Playbook
```

### Dynamic Inventory

```text
AWS
 ↓
EC2 instances
 ↓
Dynamic Inventory Plugin
 ↓
Automatically generated inventory
 ↓
Playbook
```

This is particularly useful in cloud and dynamically scaled environments.

---

## AWS EC2 Inventory Plugin

The project uses:

```text
amazon.aws.aws_ec2
```

This is an **Ansible Inventory Plugin**, not an Ansible module.

Its responsibility is to discover EC2 instances and expose them to Ansible as inventory hosts.

---

## Configuration

The inventory configuration is stored in:

```text
aws_ec2.yml
```

Current configuration:

```yaml
plugin: amazon.aws.aws_ec2

regions:
  - eu-north-1

filters:
  instance-state-name: running

keyed_groups:
  - key: tags.Environment
    prefix: environment

  - key: tags.Role
    prefix: role
```

---

## Region

The inventory queries:

```text
eu-north-1
```

This is the AWS region where the lab EC2 instance is running.

---

## Instance State Filter

The configuration contains:

```yaml
filters:
  instance-state-name: running
```

This means only EC2 instances currently in the **running** state are discovered.

Stopped instances are therefore excluded from the generated inventory.

---

## AWS Tags and Groups

The inventory uses EC2 tags to organize discovered hosts.

Example EC2 tags:

```text
Environment=Dev
Role=Web
```

The `keyed_groups` configuration converts these tags into Ansible groups.

```yaml
keyed_groups:
  - key: tags.Environment
    prefix: environment

  - key: tags.Role
    prefix: role
```

This produces groups such as:

```text
environment_Dev
role_Web
```

A playbook can then target:

```yaml
hosts: role_Web
```

without knowing the EC2 instance's current IP address.

---

## Inventory Discovery

Ansible can display the dynamically generated inventory using:

```bash
ansible-inventory --graph
```

Example structure:

```text
@all:
  |--@environment_Dev:
  |  |--<EC2 host>
  |
  |--@role_Web:
     |--<EC2 host>
```

This confirms that Ansible successfully discovered the EC2 instance and placed it into the expected groups.

---

## Testing Connectivity

Once the inventory has discovered the host, Ansible can communicate with the group directly.

Example:

```bash
ansible role_Web -m ping
```

Expected result:

```text
SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

This verifies both:

* Dynamic inventory discovery
* SSH connectivity to the managed host

---

## Dynamic Inventory vs Static Inventory

| Static Inventory                  | Dynamic Inventory                     |
| --------------------------------- | ------------------------------------- |
| Hosts manually defined            | Hosts discovered automatically        |
| IP addresses maintained manually  | AWS provides current host information |
| Changes require inventory updates | Inventory reflects infrastructure     |
| Simple environments               | Well suited to cloud environments     |
| Example: `inventory` file         | Example: `aws_ec2.yml`                |

---

## Tags as Infrastructure Metadata

AWS tags provide useful metadata about infrastructure.

For example:

```text
Environment=Dev
Role=Web
```

Tags can represent:

* Environment
* Application
* Role
* Team
* Project
* Ownership

Dynamic Inventory can use this metadata to create meaningful Ansible groups.

This allows automation to target infrastructure based on **what a server represents**, rather than its IP address.

---

## Example Targeting

Instead of:

```yaml
hosts: 172.31.43.128
```

the playbook can use:

```yaml
hosts: role_Web
```

This is more suitable for dynamic cloud environments because the IP address can change while the EC2 instance's role remains the same.

---

## Relationship with the Final Project

The Dynamic Inventory configuration is used again in the final project.

```text
dynamic-inventory/aws_ec2.yml
```

provides the foundation for:

```text
final-project/aws_ec2.yml
```

The final project uses:

```yaml
hosts: role_Web
```

in `site.yml`.

The complete flow is:

```text
AWS EC2
   ↓
EC2 Tags
   ↓
Dynamic Inventory
   ↓
role_Web group
   ↓
site.yml
   ↓
webserver role
   ↓
Nginx configuration
```

---

## AWS Credentials

The Dynamic Inventory plugin needs permission to query AWS.

The AWS CLI credentials used for the lab are maintained outside the Git repository.

Credentials should never be hardcoded into:

```text
aws_ec2.yml
```

or committed to GitHub.

The AWS identity used for the lab has permissions required to read EC2 information.

---

## Required Collection

The Dynamic Inventory implementation uses the:

```text
amazon.aws
```

collection.

The collection can be checked with:

```bash
ansible-galaxy collection list
```

Project dependencies are documented in:

```text
../final-project/requirements.yml
```

---

## Important Distinction: Plugin vs Module

One of the important concepts demonstrated here is the difference between an Inventory Plugin and an Ansible Module.

### Inventory Plugin

```text
amazon.aws.aws_ec2
```

Purpose:

```text
Discover EC2 hosts
```

It participates in inventory generation.

### Module

```text
amazon.aws.ec2_instance_info
```

Purpose:

```text
Retrieve information about EC2 instances
```

It is executed as an Ansible task or ad-hoc command.

Conceptually:

```text
amazon.aws.aws_ec2
        ↓
Inventory Plugin
        ↓
Discovers hosts
```

versus:

```text
amazon.aws.ec2_instance_info
        ↓
Ansible Module
        ↓
Queries EC2 information
```

---

## Useful Commands

### Display inventory graph

```bash
ansible-inventory --graph
```

### Display complete inventory

```bash
ansible-inventory --list
```

### Test discovered hosts

```bash
ansible role_Web -m ping
```

### Check host information

```bash
ansible role_Web -m setup
```

### Query EC2 information

```bash
ansible localhost -c local \
  -m amazon.aws.ec2_instance_info \
  -a "region=eu-north-1"
```

---

## Troubleshooting

If the expected EC2 instance does not appear in the inventory, check:

### 1. EC2 State

The configuration only includes:

```text
running
```

A stopped instance will not be discovered.

### 2. AWS Region

Confirm that the instance is running in:

```text
eu-north-1
```

### 3. AWS Credentials

Verify that the AWS CLI can authenticate:

```bash
aws sts get-caller-identity
```

### 4. Collection Installation

Check:

```bash
ansible-galaxy collection list
```

Confirm that:

```text
amazon.aws
```

is installed.

### 5. Inventory Output

Run:

```bash
ansible-inventory --graph
```

This is usually the first command to use when troubleshooting Dynamic Inventory.

---

## Practical Workflow

The workflow used in this lab is:

```text
Create EC2 Instance
        ↓
Apply AWS Tags
        ↓
Configure Dynamic Inventory
        ↓
Query AWS
        ↓
Discover Running Instances
        ↓
Create Ansible Groups
        ↓
Test Connectivity
        ↓
Target Group in Playbook
```

---

## Key Benefits

Dynamic Inventory provides:

* Automatic host discovery
* Reduced manual inventory maintenance
* Integration with cloud infrastructure
* Tag-based host grouping
* Better support for changing infrastructure
* Easier targeting of environments and server roles

---

## Key Takeaway

Dynamic Inventory allows Ansible to treat cloud infrastructure as a dynamic source of inventory information.

Instead of maintaining:

```text
Server IP → manually maintained inventory
```

the automation can use:

```text
AWS Metadata + Tags
        ↓
Dynamic Inventory
        ↓
Ansible Groups
        ↓
Automation
```

This approach becomes especially valuable as infrastructure grows and server addresses change frequently.

