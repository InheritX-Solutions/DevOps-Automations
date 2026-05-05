# Shell Scripting Showcase

This directory contains robust Bash scripts that automate common system administration and deployment tasks. These scripts are designed with best practices in mind, including error handling, logging, and configurability.

## Available Scripts

### 1. `system_health_check.sh`
A comprehensive system monitoring script. It checks CPU utilization, memory usage, disk space, and the status of critical services.
- **Usage:** `./system_health_check.sh`
- **Highlights:** Demonstrates using `awk`, `sed`, and conditional logic to parse system metrics and alert on thresholds.

### 2. `backup_rotation.sh`
An automated backup utility that compresses a target directory and enforces a retention policy (e.g., keeps only the last 7 backups).
- **Usage:** `./backup_rotation.sh /path/to/source /path/to/destination`
- **Highlights:** Demonstrates cron-ready execution, tar archiving, and dynamic file manipulation to clean up old backups.

### 3. `automated_deployment.sh`
A simulated CI/CD deployment script. It mocks the process of pulling code from a repository, running tests, and deploying a service.
- **Usage:** `./automated_deployment.sh staging`
- **Highlights:** Demonstrates environment variables, function-based structure, and simulated deployment steps with proper exit codes.

### 4. `setup_node_ubuntu.sh`
A utility script to set up a Node.js development environment on Ubuntu using NVM (Node Version Manager).
- **Usage:** `./setup_node_ubuntu.sh 20` (Installs Node v20)
- **Highlights:** Demonstrates OS checking, package management (`apt-get`), external script execution, and user environment configuration.

## Prerequisites

Ensure the scripts are executable before running them:

```bash
chmod +x *.sh
```
