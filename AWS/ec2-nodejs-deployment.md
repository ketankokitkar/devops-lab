````markdown
# Node.js Application Deployment on AWS EC2

## Project Overview

Deployed a Node.js application on an AWS EC2 Ubuntu instance and made it accessible over the internet using the EC2 public IP and a custom application port.

## Architecture

User Browser  
↓  
AWS EC2  
↓  
Ubuntu Linux  
↓  
Node.js Application  
↓  
Port 3000

## Environment

* Cloud: AWS
* Service: EC2
* OS: Ubuntu
* Instance Type: t3.micro
* Region: eu-north-1 (Stockholm)
* Node.js: v22.22.0
* npm: 9.2.0
* Git: 2.53.0
* Application Port: 3000

## Deployment Steps

### 1. Create EC2 Instance

* Created an Ubuntu EC2 instance.
* Created/downloaded an SSH key pair.
* Connected to the instance using MobaXterm.

### 2. Configure Ubuntu

```bash
sudo apt update
```

Installed and verified:

```bash
git --version
node --version
npm --version
```

### 3. Clone the Application

```bash
git clone https://github.com/verma-kunal/AWS-Session.git
cd AWS-Session
```

### 4. Configure Environment Variables

Created the `.env` file:

```bash
touch .env
```

Configuration:

```env
DOMAIN=""
PORT=3000
STATIC_DIR="./client"

PUBLISHABLE_KEY=""
SECRET_KEY=""
```

> Stripe keys were kept empty during the initial deployment. They can be configured later when Stripe functionality is required.

### 5. Install Dependencies

```bash
npm install
```

### 6. Start the Application

```bash
npm run start
```

Application started successfully:

```text
Server listening on port: 3000
```

## AWS Security Group

Added an inbound rule to allow application traffic:

```text
Type: Custom TCP
Port: 3000
Source: My IP
```

The application was then accessed using:

```text
http://<EC2-PUBLIC-IP>:3000
```

## Stop and Start

### Stop Node.js application

Press:

```text
Ctrl + C
```

Start again:

```bash
npm run start
```

### Stop EC2

When finished with the practice session:

```text
AWS Console
→ EC2
→ Instances
→ Select Instance
→ Instance state
→ Stop instance
```

Start it again when required.

## Important Notes

* `.env` must not be committed to Git.
* `.env` is included in `.gitignore`.
* Never commit AWS credentials, SSH private keys, or API/secret keys.
* EC2 public IPv4 can change after stopping and starting the instance.
* An Elastic IP can be used when a persistent public IP is required.
* Stopping EC2 stops compute usage, but associated resources such as EBS storage and public IPv4 may still incur charges.

## What I Learned

* Creating and managing an AWS EC2 instance
* Connecting to Ubuntu using SSH/MobaXterm
* Installing and configuring Node.js
* Using Git on a remote Linux server
* Deploying a Node.js application
* Configuring environment variables
* Understanding AWS Security Groups
* Exposing an application through a custom port
* Accessing an application using an EC2 public IP
* Understanding the difference between stopping an application and stopping an EC2 instance

```

This is better suited to your **`devops-lab` portfolio** because it documents what you actually did rather than just copying the tutorial README.
```
