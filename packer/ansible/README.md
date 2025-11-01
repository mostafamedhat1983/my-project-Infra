# Ansible - Jenkins AMI Provisioning

Configures Jenkins master AMI with required tools and security hardening.

## Installed Software
- **Docker** - Container runtime
- **Java 21 Corretto** - Jenkins requirement
- **Git** - Version control
- **Jenkins** - CI/CD server (latest stable)
- **kubectl v1.34** - Kubernetes CLI (matches EKS version)
- **Helm** - Kubernetes package manager
- **AWS CLI** - Pre-installed on Amazon Linux 2023

## What It Does
1. **System Update** - Full dnf update
2. **Package Installation** - All tools with GPG verification
3. **Service Configuration** - Docker and Jenkins started and enabled
4. **Security Hardening** - SSH password auth disabled
5. **Verification** - All tools tested (fails if missing)
6. **Cleanup** - Remove unused packages and cache

## Security Features
- GPG key verification for Jenkins, Kubernetes, and Helm repos
- SSH password authentication disabled (defense-in-depth)
- Installation verification with failure detection
- Services started during build (validates configuration)

## Usage
Called automatically by Packer - not run manually.

## Notes
- Uses native Ansible modules (dnf, systemd, yum_repository)
- `state: present` for packages (after full system update)
- Services enabled for auto-start on EC2 boot
- Ansible-lint compliant with documented exceptions
