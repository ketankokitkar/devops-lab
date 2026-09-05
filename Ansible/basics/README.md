# Ansible Basics

This directory contains hands-on Ansible examples covering the core concepts used to build and manage automated infrastructure.

The examples are intentionally separated into small, focused playbooks so each Ansible feature can be understood and tested independently before being used in the final project.

---

## What This Section Covers

The examples in this directory cover:

| Topic                     | Example              |
| ------------------------- | -------------------- |
| Package Management        | `install-nginx.yml`  |
| Service Management        | `nginx-service.yml`  |
| File & Content Management | `index.html`         |
| Variables                 | `variables.yml`      |
| Handlers                  | `handlers.yml`       |
| Facts                     | `facts.yml`          |
| Conditionals              | `when.yml`           |
| Loops                     | `loop.yml`           |
| Registered Variables      | `register.yml`       |
| Jinja2 Templates          | `server-info.j2`     |
| Template Module           | `template.yml`       |
| Error Handling            | `error-handling.yml` |
| Tags                      | `tags.yml`           |

---

## 1. Package Management

### `install-nginx.yml`

Demonstrates how Ansible can install and manage system packages.

Example:

```yaml
- name: Install Nginx
  apt:
    name: nginx
    state: present
    update_cache: yes
```

Key concept:

```text
Desired State → Nginx should be installed
```

Ansible checks the current state and makes changes only when required.

This also demonstrates **idempotency**.

---

## 2. Service Management

### `nginx-service.yml`

Demonstrates managing Linux services using Ansible.

Typical operations include:

```text
start
stop
restart
enable
disable
```

Example:

```yaml
- name: Start Nginx
  service:
    name: nginx
    state: started
```

This approach allows service state to be managed declaratively instead of relying on manually executed system commands.

---

## 3. Files and Content

### `index.html`

A simple HTML file used for practicing file/content deployment.

Ansible can manage files using modules such as:

```text
file
copy
template
```

For example, the `copy` module can transfer a local file to a managed server.

---

## 4. Variables

### `variables.yml`

Demonstrates the use of variables in Ansible.

Variables allow values to be defined once and reused throughout automation.

Example:

```yaml
vars:
  package_name: nginx
```

The variable can then be referenced using Jinja2 syntax:

```yaml
name: "{{ package_name }}"
```

Variables make playbooks easier to reuse and maintain.

---

## 5. Handlers

### `handlers.yml`

Demonstrates Ansible handlers.

Handlers are tasks that execute when another task explicitly notifies them.

Example:

```yaml
notify:
  - Restart Nginx
```

A handler can then perform:

```yaml
- name: Restart Nginx
  service:
    name: nginx
    state: restarted
```

Handlers are particularly useful for configuration changes where a service should be restarted or reloaded only when its configuration changes.

---

## 6. Facts

### `facts.yml`

Demonstrates Ansible Facts.

Facts provide information collected from managed hosts, such as:

* Hostname
* Operating system
* IP addresses
* CPU information
* Memory
* Network information

Facts are available through:

```text
ansible_facts
```

Example:

```yaml
{{ ansible_facts['hostname'] }}
```

Facts are collected during playbook execution and can be used to make automation dynamic.

---

## 7. Conditionals

### `when.yml`

Demonstrates conditional task execution.

The `when` keyword allows a task to execute only when a specified condition is true.

Example:

```yaml
when: ansible_facts['distribution'] == "Ubuntu"
```

This is useful when automation needs to behave differently depending on:

* Operating system
* Environment
* Variables
* Host characteristics
* Previous task results

---

## 8. Loops

### `loop.yml`

Demonstrates how a single Ansible task can operate on multiple values.

Example:

```yaml
loop:
  - nginx
  - curl
  - git
```

Instead of creating separate tasks for each item, the same task can process the complete list.

Loops are useful for:

* Installing multiple packages
* Creating multiple files
* Managing users
* Processing configuration items

---

## 9. Registered Variables

### `register.yml`

Demonstrates how the output of an Ansible task can be stored in a variable.

Example:

```yaml
- name: Check uptime
  command: uptime
  register: uptime_result
```

The result can then be referenced by another task.

For example:

```yaml
- name: Display uptime
  debug:
    var: uptime_result.stdout
```

Registered results commonly contain information such as:

```text
stdout
stderr
rc
changed
failed
```

Registered variables are useful when the result of one task needs to influence later tasks.

---

## 10. Jinja2 Templates

### `server-info.j2`

This file demonstrates an Ansible Jinja2 template.

Templates allow configuration or content to be generated dynamically using variables and facts.

Example:

```jinja2
Hostname: {{ ansible_facts['hostname'] }}
OS: {{ ansible_facts['distribution'] }}
IP: {{ ansible_facts['default_ipv4']['address'] }}
```

The same template can generate different output depending on the managed host.

---

## 11. Template Module

### `template.yml`

Demonstrates how the Ansible `template` module deploys a Jinja2 template to a managed host.

Example:

```yaml
- name: Generate server information
  template:
    src: server-info.j2
    dest: /tmp/server-info
```

The important distinction is:

```text
copy
  → Copies static content

template
  → Renders Jinja2 and generates dynamic content
```

---

## 12. Error Handling

### `error-handling.yml`

Demonstrates mechanisms for controlling task failure and execution behavior.

Important Ansible features include:

```text
failed_when
changed_when
ignore_errors
block
rescue
always
```

These features allow playbooks to handle expected conditions while still exposing genuine failures.

Error handling should be used carefully so that automation does not silently hide real infrastructure problems.

---

## 13. Tags

### `tags.yml`

Demonstrates the use of Ansible tags.

Tags allow specific parts of a playbook to be selected during execution.

Example:

```yaml
tags:
  - install
```

Run only selected tasks:

```bash
ansible-playbook tags.yml --tags install
```

Skip selected tasks:

```bash
ansible-playbook tags.yml --skip-tags install
```

Tags become especially useful as playbooks become larger and contain multiple independent operations.

---

# Core Ansible Modules Practiced

The examples in this directory provide hands-on experience with commonly used modules:

| Module     | Purpose                            |
| ---------- | ---------------------------------- |
| `apt`      | Package management                 |
| `service`  | Service management                 |
| `file`     | File/directory management          |
| `copy`     | Copy static files                  |
| `template` | Deploy Jinja2 templates            |
| `command`  | Execute commands                   |
| `shell`    | Execute commands through a shell   |
| `debug`    | Display variables and task results |

---

# Important Concepts Demonstrated

## Declarative Automation

Ansible playbooks describe the **desired state** rather than simply providing a sequence of shell commands.

For example:

```yaml
state: present
```

means the package should be installed.

Ansible determines whether a change is necessary.

---

## Idempotency

The same playbook can be executed repeatedly without continuously making unnecessary changes.

Example:

```text
First execution  → changed
Second execution → ok
```

This is one of the important characteristics of Ansible automation.

---

## Privilege Escalation

Some system-level operations require elevated privileges.

Ansible uses:

```yaml
become: yes
```

to perform privilege escalation, commonly through `sudo`.

Example:

```yaml
- name: Install Nginx
  apt:
    name: nginx
    state: present
  become: yes
```

---

## Ad-Hoc Commands

Before building playbooks, Ansible can be used for quick operational tasks.

Example:

```bash
ansible webservers -m ping
```

Command execution:

```bash
ansible webservers -m command -a "uptime"
```

Disk usage:

```bash
ansible webservers -m command -a "df -h"
```

Ad-hoc commands are useful for:

* Connectivity testing
* Troubleshooting
* Quick checks
* One-time operations

For repeatable automation, playbooks are preferred.

---

# Practical Learning Flow

The examples were developed progressively:

```text
Package Management
        ↓
Service Management
        ↓
Files & Copy
        ↓
Variables
        ↓
Handlers
        ↓
Facts
        ↓
Conditionals
        ↓
Loops
        ↓
Register
        ↓
Templates / Jinja2
        ↓
Error Handling
        ↓
Tags
        ↓
Roles
        ↓
Vault
        ↓
AWS / Dynamic Inventory
        ↓
Final Project
```

This progression builds the individual Ansible building blocks before combining them into a larger automation project.

---

# Practical Relationship Between the Examples

The examples are intentionally small, but the concepts are used together in real automation.

A typical configuration workflow can look like:

```text
Variables
    ↓
Facts
    ↓
Conditionals
    ↓
Tasks
    ↓
Template
    ↓
Configuration Change
    ↓
Handler
    ↓
Service Restart
```

For example, an Nginx automation workflow may:

1. Install Nginx
2. Configure Nginx
3. Use variables for reusable values
4. Generate configuration using Jinja2
5. Notify a handler when configuration changes
6. Restart Nginx only when required
7. Verify the resulting service state

These concepts are combined in the [`final-project/`](../final-project/) implementation.

---

# Validation and Troubleshooting

Common commands used while working with these examples:

### Check Ansible version

```bash
ansible --version
```

### Test connectivity

```bash
ansible webservers -m ping
```

### Check playbook syntax

```bash
ansible-playbook <playbook>.yml --syntax-check
```

### Perform a dry run

```bash
ansible-playbook <playbook>.yml --check
```

### Run a playbook

```bash
ansible-playbook <playbook>.yml
```

### Run with verbose output

```bash
ansible-playbook <playbook>.yml -v
```

For deeper troubleshooting:

```bash
ansible-playbook <playbook>.yml -vvv
```

---

# Example Execution Pattern

A typical workflow when developing an Ansible playbook:

```text
Write / modify playbook
        ↓
Syntax check
        ↓
Dry run
        ↓
Execute
        ↓
Verify result
        ↓
Run again
        ↓
Confirm idempotency
```

Useful commands:

```bash
ansible-playbook playbook.yml --syntax-check
ansible-playbook playbook.yml --check
ansible-playbook playbook.yml
ansible-playbook playbook.yml
```

The second execution should normally report fewer or no changes when the desired state has already been achieved.

---

# Relationship to the Final Project

The individual examples in this directory are building blocks for the larger project.

| Basic Concept        | Used In Final Project    |
| -------------------- | ------------------------ |
| Package management   | Nginx installation       |
| Variables            | Role defaults            |
| Facts                | Host/runtime information |
| Templates            | Nginx configuration      |
| Handlers             | Nginx restart            |
| Idempotency          | Repeatable configuration |
| Privilege escalation | System configuration     |
| Dynamic inventory    | AWS EC2 discovery        |
| Vault                | Encrypted variables      |
| Roles                | Web server automation    |

The [`final-project/`](../final-project/) directory combines these concepts into a structured, role-based Ansible implementation.

---

# Key Takeaways

The practical exercises in this directory establish the core Ansible workflow:

```text
Inventory
   ↓
Playbook
   ↓
Play
   ↓
Tasks
   ↓
Modules
   ↓
Desired State
   ↓
Managed Infrastructure
```

The most important concepts demonstrated here are:

* Agentless automation
* Declarative configuration
* Idempotency
* Modules
* Variables
* Facts
* Templates
* Handlers
* Conditional execution
* Loops
* Registered results
* Error handling
* Tags
* Privilege escalation

These fundamentals provide the foundation for the more advanced Ansible work documented in the other directories of this repository.

