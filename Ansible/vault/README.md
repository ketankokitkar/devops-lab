# Ansible Vault

This directory contains practical work with **Ansible Vault** for securely managing sensitive data used by Ansible automation.

Ansible Vault provides encryption for sensitive variables and files so that credentials and other secrets do not need to be stored in plaintext.

---

## Purpose

In infrastructure automation, playbooks and configuration files are often stored in source control. Sensitive information such as passwords and API keys should not be exposed in plaintext.

Ansible Vault addresses this by encrypting sensitive data while still allowing Ansible to use it during playbook execution.

This section demonstrates:

* Creating encrypted Vault files
* Viewing encrypted data
* Editing encrypted data
* Using Vault variables in Ansible
* Supplying the Vault password securely
* Integrating Vault with a playbook
* Keeping the Vault password outside the Git repository

---

## Files in This Directory

```text
vault/
├── README.md
└── vault-test.yml
```

### `vault-test.yml`

A practical example used to work with variables stored in an Ansible Vault file.

The actual encrypted `secrets.yml` used by the final project is maintained under:

```text
../final-project/secrets.yml
```

---

## What Ansible Vault Protects

Typical sensitive information includes:

```text
Database usernames
Database passwords
API keys
Service credentials
Application secrets
```

Example plaintext variables might look like:

```yaml
db_username: admin
db_password: mypassword
api_key: example-key
```

Storing such values directly in Git would expose the credentials.

With Ansible Vault, the file is encrypted.

An encrypted Vault file starts with:

```text
$ANSIBLE_VAULT;1.1;AES256
```

The contents are no longer readable as normal YAML without the Vault password.

---

## Creating a Vault File

A new encrypted file can be created with:

```bash
ansible-vault create secrets.yml
```

Ansible opens the file in an editor and encrypts the contents when it is saved.

---

## Editing a Vault File

To modify an existing encrypted file:

```bash
ansible-vault edit secrets.yml
```

Ansible decrypts the file temporarily for editing and encrypts it again after saving.

The encrypted file remains encrypted on disk.

---

## Viewing a Vault File

To inspect the decrypted contents without permanently decrypting the file:

```bash
ansible-vault view secrets.yml
```

This is useful for verifying the variables stored inside the Vault.

---

## Encrypting an Existing File

An existing plaintext file can be encrypted using:

```bash
ansible-vault encrypt secrets.yml
```

After encryption, the file is stored in encrypted form.

---

## Decrypting a Vault File

A Vault file can be permanently decrypted with:

```bash
ansible-vault decrypt secrets.yml
```

This should be used carefully because the resulting file becomes plaintext.

For normal usage, `view` or `edit` is generally preferable when the file needs to remain encrypted.

---

## Vault Password

Ansible needs the Vault password to decrypt encrypted data during execution.

The password can be supplied interactively:

```bash
ansible-playbook site.yml --ask-vault-pass
```

Alternatively, Ansible can use a password file.

The final project uses:

```ini
vault_password_file = ../vault-pass.txt
```

The password file is intentionally stored **outside the GitHub repository**.

---

## Vault Integration

The final project loads the encrypted variables using:

```yaml
vars_files:
  - secrets.yml
```

The overall flow is:

```text
Encrypted secrets.yml
        ↓
   Vault password
        ↓
   Ansible decrypts
        ↓
 Variables become available
        ↓
     Playbook
        ↓
    Role / Tasks
```

The encrypted file can therefore be committed to the repository without exposing its plaintext values, provided the Vault password is kept separate and secure.

---

## Final Project Vault Configuration

The final project contains:

```text
final-project/
├── secrets.yml
├── ansible.cfg
└── site.yml
```

`site.yml` references the encrypted file:

```yaml
vars_files:
  - secrets.yml
```

`ansible.cfg` specifies the password file:

```ini
vault_password_file = ../vault-pass.txt
```

The password file is not part of the repository.

---

## Security Practices

Sensitive information should never be committed to GitHub in plaintext.

The repository excludes files such as:

```text
vault-pass.txt
*.pem
*.key
.env
*.vault_pass
```

The encrypted Vault file can be stored in Git, while the password required to decrypt it remains outside the repository.

### Important

An encrypted Vault file is only as secure as the protection of its Vault password.

The password should therefore be:

* Kept private
* Not committed to source control
* Not included in documentation
* Not hardcoded into playbooks
* Protected with appropriate filesystem permissions

---

## Vault and Git

A typical secure repository structure is:

```text
GitHub Repository
│
├── secrets.yml          ← Encrypted
├── site.yml
├── ansible.cfg
└── .gitignore
       
Outside Repository
│
└── vault-pass.txt       ← Password
```

This separation prevents the Vault password from being stored alongside the encrypted secrets.

---

## Verification

The final project was validated using Ansible syntax checking:

```bash
ansible-playbook site.yml --syntax-check
```

The playbook successfully loaded the encrypted variables without requiring the Vault password to be entered interactively because the project configuration references the external password file.

The final project was subsequently executed successfully against the AWS EC2 managed node.

---

## Vault vs Plaintext Variables

| Plaintext Variables             | Ansible Vault                           |
| ------------------------------- | --------------------------------------- |
| Values are readable             | Values are encrypted                    |
| Unsafe to commit when sensitive | Encrypted file can be committed         |
| Credentials easily exposed      | Credentials protected by Vault password |
| No encryption at rest           | Encryption at rest                      |

---

## Practical Workflow

A typical workflow for managing secrets is:

```text
Create / prepare sensitive variables
             ↓
       Encrypt with Vault
             ↓
     Store encrypted file
             ↓
       Commit to Git
             ↓
 Ansible receives Vault password
             ↓
    Ansible decrypts at runtime
             ↓
     Playbook uses variables
```

---

## Key Takeaway

Ansible Vault allows sensitive configuration data to be incorporated into infrastructure automation without storing the actual secret values in plaintext.

The important security model demonstrated in this project is:

```text
Encrypted Secrets
       +
Protected Vault Password
       ↓
Secure Ansible Automation
```

Vault is integrated into the final project alongside **roles, dynamic inventory, AWS EC2, Jinja2 templates, handlers, and Nginx automation**.

