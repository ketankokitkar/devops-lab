# Ansible

A practical Ansible learning and automation repository covering configuration management, infrastructure automation, AWS integration, dynamic inventory, Ansible Vault, roles, and a complete Nginx deployment project.

This repository documents hands-on work performed while learning Ansible and building automation against AWS EC2 infrastructure.

---

## Overview

Ansible is an agentless automation and configuration management platform used to automate repetitive infrastructure and application-management tasks.

This repository focuses on practical implementation rather than only theoretical concepts.

The work progresses from individual Ansible features to a complete project that combines:

* Ansible Playbooks
* Modules
* Variables
* Facts
* Conditionals
* Loops
* Registered variables
* Jinja2 Templates
* Handlers
* Error Handling
* Tags
* Ansible Vault
* Roles
* Ansible Galaxy and Collections
* AWS integration
* Dynamic Inventory
* EC2 automation
* Nginx configuration

---

## Repository Structure

```text
Ansible/
│
├── README.md
│
├── basics/
│   ├── README.md
│   ├── install-nginx.yml
│   ├── nginx-service.yml
│   ├── index.html
│   ├── variables.yml
│   ├── handlers.yml
│   ├── facts.yml
│   ├── when.yml
│   ├── loop.yml
│   ├── register.yml
│   ├── server-info.j2
│   ├── template.yml
│   ├── error-handling.yml
│   └── tags.yml
│
├── vault/
│   ├── README.md
│   └── vault-test.yml
│
├── dynamic-inventory/
│   ├── README.md
│   └── aws_ec2.yml
│
├── aws/
│   ├── README.md
│   └── aws-web.yml
│
└── final-project/
    ├── README.md
    ├── .gitignore
    ├── ansible.cfg
    ├── aws_ec2.yml
    ├── requirements.yml
    ├── secrets.yml
    ├── site.yml
    │
    └── webserver/
        ├── README.md
        ├── defaults/
        │   └── main.yml
        ├── handlers/
        │   └── main.yml
        ├── meta/
        │   └── main.yml
        ├── tasks/
        │   └── main.yml
        ├── templates/
        │   └── devops.conf.j2
        ├── tests/
        │   ├── inventory
        │   └── test.yml
        └── vars/
            └── main.yml
```

---

## Learning Areas

### Ansible Basics

The [`basics/`](./basics/) directory contains hands-on examples covering the fundamental building blocks of Ansible automation.

Topics include:

* Ad-hoc commands
* Playbooks
* Modules
* Package management
* Service management
* File operations
* Variables
* Facts
* Conditionals
* Loops
* Registered variables
* Templates
* Handlers
* Error handling
* Tags
* Idempotency
* Privilege escalation

These examples provide the foundation used in the final project.

---

### Ansible Vault

The [`vault/`](./vault/) directory contains practical work with Ansible Vault for protecting sensitive configuration data.

Vault can be used to protect information such as:

* Database credentials
* Passwords
* API keys
* Other sensitive variables

Sensitive values are stored in an encrypted YAML file rather than in plaintext.

The repository intentionally does not contain the Vault password file.

---

### AWS Integration

The [`aws/`](./aws/) directory contains examples of using Ansible with AWS infrastructure.

The project uses the `amazon.aws` Ansible collection for AWS-related functionality.

This provides experience with managing and querying cloud infrastructure through Ansible rather than treating Ansible and AWS as completely separate tools.

---

### Dynamic Inventory

The [`dynamic-inventory/`](./dynamic-inventory/) directory demonstrates AWS EC2 Dynamic Inventory.

Instead of maintaining a static list of servers, Ansible discovers running EC2 instances directly from AWS.

EC2 tags are used to organize discovered hosts into Ansible groups.

For example:

```text
Environment=Dev
Role=Web
```

These tags can result in groups such as:

```text
environment_Dev
role_Web
```

This allows playbooks to target infrastructure based on its AWS metadata.

---

## Final Project

The [`final-project/`](./final-project/) directory combines the major concepts learned throughout the repository into a practical automation project.

The project configures an AWS EC2 instance as an Nginx web server using:

* AWS Dynamic Inventory
* Ansible configuration
* Ansible Vault
* Ansible Roles
* Variables
* Jinja2 Templates
* Handlers
* Privilege escalation
* Idempotent configuration
* Ansible Galaxy collection dependencies

### Architecture

```text
                    AWS
                     │
                     ▼
              EC2 Web Server
                     │
              AWS Tags
        ┌────────────┴────────────┐
        │                         │
 Environment=Dev             Role=Web
        │                         │
        └────────────┬────────────┘
                     ▼
            Dynamic Inventory
                     │
                     ▼
            Ansible Control Node
                 (WSL/Ubuntu)
                     │
                     ▼
                  site.yml
                     │
                     ▼
              webserver Role
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       Tasks      Template    Handler
          │          │          │
          └──────────┼──────────┘
                     ▼
                   Nginx
                     │
                     ▼
             Managed by Ansible
```

---

## Final Project Workflow

The automation follows this general flow:

```text
1. Ansible loads project configuration
              ↓
2. Dynamic Inventory queries AWS
              ↓
3. Running EC2 instances are discovered
              ↓
4. AWS tags determine Ansible groups
              ↓
5. site.yml targets the required group
              ↓
6. Encrypted variables are loaded from Vault
              ↓
7. webserver role is executed
              ↓
8. Nginx is installed
              ↓
9. Existing known lab configuration is cleaned up
              ↓
10. Nginx configuration is generated using Jinja2
              ↓
11. Handler restarts Nginx when configuration changes
              ↓
12. Nginx serves the expected response
```

---

## Role-Based Automation

The final project uses an Ansible Role to separate automation into logical components.

```text
webserver/
├── defaults/
├── handlers/
├── meta/
├── tasks/
├── templates/
├── tests/
└── vars/
```

### Tasks

`tasks/main.yml` contains the main configuration workflow.

It handles:

* Package installation
* Existing configuration cleanup
* Nginx configuration deployment

### Templates

`templates/devops.conf.j2` contains the Nginx configuration template.

The template is deployed to:

```text
/etc/nginx/conf.d/devops.conf
```

### Handlers

`handlers/main.yml` contains the Nginx restart handler.

The handler is triggered only when a configuration task reports a change.

This prevents unnecessary service restarts.

### Defaults

`defaults/main.yml` defines default role variables such as the package to install.

Example:

```yaml
package_name: nginx
```

---

## Idempotency

A key principle demonstrated throughout the project is **idempotency**.

The desired state is declared rather than writing a sequence of commands that blindly modify the system.

For example:

```yaml
apt:
  name: nginx
  state: present
```

If Nginx is already installed, Ansible does not reinstall it unnecessarily.

Similarly, configuration changes trigger the handler only when the configuration task actually changes.

This makes the automation safe to run repeatedly.

---

## AWS Dynamic Inventory

The final project uses the `amazon.aws.aws_ec2` inventory plugin.

Example configuration:

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

The inventory discovers running EC2 instances and creates groups based on AWS tags.

This removes the need to manually maintain changing EC2 IP addresses in a static inventory.

---

## Ansible Vault

The final project includes an encrypted:

```text
secrets.yml
```

The playbook loads the encrypted variables using:

```yaml
vars_files:
  - secrets.yml
```

The project configuration references the Vault password file outside the repository:

```ini
vault_password_file = ../vault-pass.txt
```

The Vault password itself is **not committed to GitHub**.

---

## AWS and Ansible Components

This repository demonstrates two different ways Ansible interacts with AWS.

### Dynamic Inventory

```text
amazon.aws.aws_ec2
```

Used to discover EC2 hosts dynamically.

### EC2 Information Module

```text
amazon.aws.ec2_instance_info
```

Used to retrieve information about EC2 instances.

For example:

```bash
ansible localhost -c local \
  -m amazon.aws.ec2_instance_info \
  -a "region=eu-north-1"
```

The important distinction is:

```text
aws_ec2
    → Inventory Plugin
    → Discovers hosts

ec2_instance_info
    → Ansible Module
    → Retrieves EC2 information
```

---

## Nginx Configuration

The final project configures Nginx as a web server.

The managed configuration is generated from:

```text
webserver/templates/devops.conf.j2
```

The resulting server responds with:

```text
Managed by Ansible
```

Verification:

```bash
curl -s http://localhost
```

Expected response:

```text
Managed by Ansible
```

---

## Configuration Management Approach

The repository demonstrates a transition from manually executing server commands toward declarative automation.

Instead of manually performing:

```text
Install package
Create configuration
Restart service
Verify service
```

Ansible defines the desired state and determines what actions are required to reach it.

This makes the process:

* Repeatable
* Consistent
* Auditable
* Easier to maintain
* Easier to reproduce

---

## Salt to Ansible Mapping

My existing experience with Salt provides a useful comparison when understanding Ansible.

| Salt             | Ansible           |
| ---------------- | ----------------- |
| Salt Master      | Control Node      |
| Salt Minion      | Managed Node      |
| Salt State       | Playbook          |
| State File       | Playbook / Role   |
| Pillar           | Variables / Vault |
| Grains           | Facts             |
| Salt Module      | Ansible Module    |
| Execution Module | Ad-hoc Command    |
| Jinja            | Jinja2 Templates  |

The major architectural difference is that Ansible is generally **agentless**, using SSH for Linux/Unix managed nodes.

---

## Important Commands

### Verify Ansible installation

```bash
ansible --version
```

### View inventory

```bash
ansible-inventory --graph
```

### Test connectivity

```bash
ansible role_Web -m ping
```

### Run a playbook

```bash
ansible-playbook site.yml
```

### Validate syntax

```bash
ansible-playbook site.yml --syntax-check
```

### Perform a dry run

```bash
ansible-playbook site.yml --check
```

### View available tasks

```bash
ansible-playbook site.yml --list-tasks
```

### Run with verbose output

```bash
ansible-playbook site.yml -v
```

---

## Security Practices

The repository follows basic practices for preventing accidental credential exposure.

Files such as the following are excluded using `.gitignore`:

```text
*.pem
*.key
vault-pass.txt
.env
*.vault_pass
```

The repository contains the encrypted Vault file but not the plaintext Vault password.

AWS CLI credentials are maintained outside the repository through the normal AWS credential configuration.

No private SSH keys or plaintext cloud credentials should be committed to this repository.

---

## What This Repository Demonstrates

This repository demonstrates practical understanding of:

```text
                 Ansible
                    │
       ┌────────────┼────────────┐
       │            │            │
   Automation    Config       Orchestration
       │        Management        │
       │            │            │
       └────────────┼────────────┘
                    │
             Cloud Integration
                    │
                   AWS
                    │
             EC2 + Dynamic
               Inventory
                    │
                 Nginx
```

The progression from individual examples to the final project demonstrates how Ansible concepts can be combined to build a maintainable automation workflow.

---

## Repository Purpose

This repository serves two purposes:

### 1. Practical Portfolio

Demonstrates hands-on experience with Ansible automation, AWS integration, configuration management, and infrastructure tooling.

### 2. Technical Reference

Provides working examples that can be revisited when reviewing Ansible concepts or implementing similar automation in future projects.

Detailed interview preparation and question-and-answer material will be maintained separately.

---

## Current Coverage

The current Ansible implementation covers:

* [x] Ansible fundamentals
* [x] Ad-hoc commands
* [x] Playbooks
* [x] Modules
* [x] Variables
* [x] Facts
* [x] Conditionals
* [x] Loops
* [x] Registered variables
* [x] Jinja2 templates
* [x] Handlers
* [x] Error handling
* [x] Tags
* [x] Idempotency
* [x] Privilege escalation
* [x] Ansible Vault
* [x] Roles
* [x] Ansible Galaxy
* [x] Ansible Collections
* [x] AWS integration
* [x] EC2 information
* [x] Dynamic Inventory
* [x] Nginx automation
* [x] Complete role-based project

---

## Learning Progression

```text
Ansible Fundamentals
        ↓
Ad-Hoc Commands
        ↓
Playbooks & Modules
        ↓
Variables & Facts
        ↓
Conditionals & Loops
        ↓
Register & Debugging
        ↓
Templates & Jinja2
        ↓
Handlers & Idempotency
        ↓
Error Handling & Tags
        ↓
Ansible Vault
        ↓
Roles
        ↓
Galaxy & Collections
        ↓
AWS Integration
        ↓
Dynamic Inventory
        ↓
Role-Based Final Project
```

---

## Related Projects

The parent repository contains additional DevOps learning areas:

* [AWS](../AWS/)
* [Ansible](./)

More DevOps technologies will be added as the learning path progresses.

