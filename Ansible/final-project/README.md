Absolutely. Copy-paste this **entire block** into `README.md` in Vim.

````markdown
# Ansible AWS Web Server Automation

## Overview

This project demonstrates how Ansible can be used to automatically discover AWS EC2 instances and configure them as web servers.

The project combines:

- Ansible Roles
- AWS Dynamic Inventory
- AWS EC2 Tags
- ansible.cfg
- Jinja2 Templates
- Handlers
- Idempotency
- Ansible Vault
- Vault Password File
- Ansible Galaxy & Collections
- amazon.aws Collection
- ec2_instance_info

---

## Architecture

```text
Windows Laptop
      |
      v
WSL Ubuntu
Ansible Control Node
      |
      | SSH
      v
AWS EC2
      |
      | Tags
      | Environment=Dev
      | Role=Web
      |
      v
AWS Dynamic Inventory
amazon.aws.aws_ec2
      |
      v
role_Web
      |
      v
site.yml
      |
      v
webserver Role
      |
      +---- Install Nginx
      |
      +---- Configure Nginx
      |          |
      |          v
      |     Jinja2 Template
      |
      +---- Handler
                 |
                 v
            Restart Nginx
````

---

# Project Structure

```text
final-project/
│
├── ansible.cfg
├── aws_ec2.yml
├── requirements.yml
├── site.yml
├── secrets.yml
├── .gitignore
├── README.md
│
└── webserver/
    ├── defaults/
    │   └── main.yml
    ├── tasks/
    │   └── main.yml
    ├── handlers/
    │   └── main.yml
    └── templates/
        └── devops.conf.j2
```

---

# 1. Ansible Role

The `webserver` directory is a reusable Ansible Role.

The role is responsible for installing and configuring Nginx.

Important role directories:

```text
defaults/     → Default variables
tasks/        → Main automation tasks
handlers/     → Handlers triggered by changed tasks
templates/    → Jinja2 templates
```

Role name:

```text
webserver
```

The role name is not a reserved Ansible keyword. It is the name we selected for this project.

---

# 2. Variables

File:

```text
webserver/defaults/main.yml
```

Example:

```yaml
package_name: nginx
```

The task uses:

```yaml
name: "{{ package_name }}"
```

Using a variable makes the role more reusable because the package name can be changed without modifying the task itself.

---

# 3. AWS Dynamic Inventory

File:

```text
aws_ec2.yml
```

The project uses the AWS EC2 inventory plugin:

```yaml
plugin: amazon.aws.aws_ec2
```

Instead of manually maintaining EC2 IP addresses, Ansible queries AWS and discovers running EC2 instances dynamically.

This is useful because an EC2 public IP can change after a stop/start when an Elastic IP is not being used.

Flow:

```text
AWS EC2
   |
   v
amazon.aws.aws_ec2
   |
   v
Ansible Dynamic Inventory
```

---

# 4. AWS Tag-Based Groups

The EC2 instance uses these tags:

```text
Environment = Dev
Role        = Web
```

The Dynamic Inventory converts the tags into Ansible groups.

Example:

```text
Environment=Dev
       |
       v
environment_Dev

Role=Web
       |
       v
role_Web
```

The main playbook uses:

```yaml
hosts: role_Web
```

Therefore, the playbook does not depend on a hardcoded EC2 IP address.

---

# 5. ansible.cfg

File:

```text
ansible.cfg
```

The project-level configuration contains common Ansible settings such as:

* Dynamic inventory
* Remote user
* SSH private key
* Host key checking
* Vault password file

This allows us to avoid repeatedly specifying these options on the command line.

Example:

```ini
[defaults]
inventory = aws_ec2.yml
remote_user = ubuntu
private_key_file = ~/.ssh/test1234.pem
host_key_checking = False
vault_password_file = ../vault-pass.txt
```

---

# 6. Nginx

Nginx is used in this project as a web server.

The Ansible role:

1. Installs Nginx.
2. Configures Nginx.
3. Restarts Nginx when the configuration changes.

The configuration is managed by Ansible rather than manually editing the EC2 server.

---

# 7. Jinja2 Template

File:

```text
webserver/templates/devops.conf.j2
```

The template is deployed to:

```text
/etc/nginx/conf.d/devops.conf
```

The configuration contains:

```nginx
location / {
    return 200 "Managed by Ansible\n";
}
```

Jinja2 allows Ansible to generate configuration files dynamically using variables and facts.

---

# 8. Handlers

File:

```text
webserver/handlers/main.yml
```

The Nginx configuration task uses:

```yaml
notify:
  - Restart Nginx
```

The handler runs only when the task that notified it reports a change.

Flow:

```text
Nginx configuration changes
          |
          v
        notify
          |
          v
    Restart Nginx handler
```

If the configuration has not changed, the handler does not run.

This avoids unnecessary service restarts.

---

# 9. Idempotency

Ansible is designed to be idempotent.

Idempotency means that repeatedly running the same automation should not continuously make unnecessary changes.

Example:

```text
First run
changed = 2

Second run
changed = 0
```

This makes automation safer and repeatable.

---

# 10. Ansible Vault

File:

```text
secrets.yml
```

The file contains encrypted variables.

Example variables used during Vault practice:

```text
db_username
db_password
api_key
```

The file starts with:

```text
$ANSIBLE_VAULT;1.1;AES256
```

This confirms that the file is encrypted using Ansible Vault.

Vault is used to protect sensitive information instead of storing passwords or API keys as plain text.

---

# 11. Vault Password File

The Vault password is stored locally outside the project:

```text
../vault-pass.txt
```

The project `ansible.cfg` references this file:

```ini
vault_password_file = ../vault-pass.txt
```

The password file has restricted permissions:

```text
-rw-------
```

The Vault password file must never be committed to GitHub.

---

# 12. Galaxy and Collections

Ansible Galaxy is a repository for sharing and installing Ansible content.

Ansible Collections package reusable Ansible content such as:

* Modules
* Plugins
* Roles

This project uses the:

```text
amazon.aws
```

collection.

The dependency is documented in:

```text
requirements.yml
```

Example:

```yaml
---
collections:
  - name: amazon.aws
```

Install project dependencies with:

```bash
ansible-galaxy collection install -r requirements.yml
```

---

# 13. amazon.aws Collection

The project uses the `amazon.aws` collection for AWS integration.

Important components practiced:

```text
amazon.aws.aws_ec2
amazon.aws.ec2_instance_info
```

## aws_ec2

Used as an AWS EC2 Dynamic Inventory plugin.

Purpose:

```text
Discover EC2 instances
       |
       v
Create Ansible inventory
```

## ec2_instance_info

Used to retrieve information about EC2 instances through the AWS API.

Important difference:

```text
amazon.aws.aws_ec2
        |
        → Discovers EC2 hosts for inventory


amazon.aws.ec2_instance_info
        |
        → Retrieves EC2 instance information
```

---

# 14. ec2_instance_info

Example command:

```bash
ansible localhost -c local -m amazon.aws.ec2_instance_info \
  -a "region=eu-north-1"
```

This module queries AWS and returns information about EC2 instances.

Examples of information available include:

* Instance ID
* Instance type
* Private IP
* Public IP
* Instance state
* Tags

This module is different from the Dynamic Inventory plugin because it retrieves EC2 information rather than building the Ansible inventory.

---

# 15. Important Ansible Commands

## Check Dynamic Inventory

```bash
ansible-inventory --graph
```

## Test connectivity

```bash
ansible role_Web -m ping
```

## Check playbook syntax

```bash
ansible-playbook site.yml --syntax-check
```

## Run in check mode

```bash
ansible-playbook site.yml --check
```

Check mode simulates changes without applying them.

## Run the playbook

```bash
ansible-playbook site.yml
```

## View encrypted Vault file

```bash
ansible-vault view secrets.yml --vault-password-file ../vault-pass.txt
```

## Install collection dependencies

```bash
ansible-galaxy collection install -r requirements.yml
```

---

# 16. Nginx Verification

After deployment, Nginx can be tested directly on the EC2 instance:

```bash
ansible role_Web -m command -a "curl -s http://localhost"
```

The expected response is:

```text
Managed by Ansible
```

Meaning:

```text
Ansible
   |
   v
Nginx configuration
   |
   v
Nginx
   |
   v
HTTP response
   |
   v
Managed by Ansible
```

---

# 17. Troubleshooting During the Project

## Nginx Welcome Page

Initially, the default Nginx welcome page was displayed even though Ansible had successfully deployed our configuration.

We checked the complete active Nginx configuration using:

```bash
sudo nginx -T
```

We found multiple server configurations listening on port 80, including:

```text
/etc/nginx/sites-enabled/default
/etc/nginx/conf.d/ansible-demo.conf
/etc/nginx/conf.d/demo.conf
/etc/nginx/conf.d/devops.conf
```

The default site was disabled through Ansible.

Only the old demo configurations created during our earlier lab practice were removed.

We avoided blindly deleting all Nginx configuration files.

This was an important troubleshooting and configuration-management lesson.

---

# 18. Security Practices

The following must never be committed to GitHub:

```text
*.pem
vault-pass.txt
AWS access keys
AWS secret keys
.env
real passwords
private keys
```

AWS CLI credentials are stored separately in the AWS CLI configuration and are not stored inside this project.

The Vault password file is also kept outside the project directory.

The `secrets.yml` file in this project is encrypted using Ansible Vault.

---

# 19. Key Concepts for Revision

## What is Ansible?

Ansible is an automation and configuration-management tool.

## Is Ansible agentless?

Yes.

Linux managed nodes normally use SSH and do not require an Ansible agent.

## What is Dynamic Inventory?

Dynamic Inventory automatically discovers infrastructure from an external source such as AWS EC2.

## What is a Role?

A Role is a reusable structure for organizing Ansible automation.

## What is a Handler?

A Handler is a task that runs when notified by another task that changed something.

## What is Idempotency?

Idempotency means repeatedly running automation should result in the desired state without unnecessary changes.

## What is Ansible Vault?

Ansible Vault encrypts sensitive information such as passwords and API keys.

## What is a Collection?

A Collection is a package containing Ansible content such as modules, plugins and roles.

## What is amazon.aws.aws_ec2?

It is an AWS EC2 Dynamic Inventory plugin used to discover EC2 instances.

## What is ec2_instance_info?

It is an Ansible module used to retrieve information about EC2 instances.

---

# 20. Final Project Flow

```text
AWS EC2
   |
   | Tags
   | Environment=Dev
   | Role=Web
   |
   v
AWS Dynamic Inventory
   |
   | amazon.aws.aws_ec2
   v
role_Web
   |
   v
site.yml
   |
   v
webserver Role
   |
   +---- Variables
   |
   +---- Install Nginx
   |
   +---- Jinja2 Template
   |
   +---- Handler
   |
   +---- Idempotency
   |
   v
Configured Nginx
```

Security flow:

```text
Ansible Vault
      |
      v
Encrypted secrets.yml
      |
      v
Vault Password File
      |
      v
Secure secret handling
```

---

# Project Status

```text
Ansible AWS Web Server Automation

Role                         ✅
Variables                    ✅
Dynamic Inventory            ✅
AWS EC2 Tags                 ✅
Tag-Based Groups             ✅
ansible.cfg                  ✅
Nginx                        ✅
Jinja2 Template              ✅
Handlers                     ✅
Idempotency                  ✅
Ansible Vault                ✅
Vault Password File          ✅
Galaxy                       ✅
Collections                  ✅
amazon.aws                   ✅
ec2_instance_info            ✅
Nginx Verification           ✅
Troubleshooting              ✅
```

---

