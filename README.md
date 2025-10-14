# Todo App Infrastructure - AWS EKS with Terraform

A production-ready AWS infrastructure built from scratch for deploying a containerized todo application on EKS. This project demonstrates real-world DevOps practices, security hardening, and infrastructure as code principles.

## 🎯 Project Overview

This isn't just another copied infrastructure project. Every line of code here was written with intention, reviewed, debugged, and improved through multiple iterations. The infrastructure evolved from basic requirements to a secure, scalable, production-ready setup.

## 🏗️ Architecture

This project includes two complete environments: **Development** and **Production**.

### Development Environment (~$180/month)
**Optimized for learning and cost:**
- **VPC:** 2 Availability Zones with 8 subnets (2 public, 6 private)
- **Compute:** 2 Jenkins EC2 instances (t2.medium) for CI/CD
- **Database:** RDS MySQL 8.0 (single-AZ, 20GB, encrypted)
- **Kubernetes:** EKS 1.34 cluster with 2 t3.small worker nodes (20GB disk)
- **Networking:** 1 NAT Gateway (cost-optimized)
- **Container Registry:** ECR for Docker images
- **Secrets:** AWS Secrets Manager for RDS credentials

### Production Environment (~$340/month)
**Optimized for high availability and performance:**
- **VPC:** Same architecture (2 AZs, 8 subnets) for consistency
- **Compute:** 2 Jenkins EC2 instances (t3.medium) - more powerful
- **Database:** RDS MySQL 8.0 (Multi-AZ, 50GB, 7-day backups, encrypted)
- **Kubernetes:** EKS 1.34 cluster with 3 t3.medium worker nodes (30GB disk)
- **Networking:** 2 NAT Gateways (one per AZ for high availability)
- **Container Registry:** Shared ECR (same images, different tags)
- **Secrets:** Separate Secrets Manager secrets per environment

## 🛠️ What Makes This Project Different

<details>
<summary><b>Real Problem-Solving Journey (Click to expand)</b></summary>

This project went through actual code reviews and iterative improvements. Here's what we tackled:

#### Security Hardening
1. **EBS Encryption** - Added encryption for all EC2 volumes (initially missing)
2. **RDS Encryption** - Ensured database encryption at rest
3. **EKS Secrets Encryption** - Implemented KMS encryption for Kubernetes secrets
4. **Public Endpoint Security** - Disabled EKS public endpoint, using SSM for secure access
5. **EKS Audit Logging** - Enabled control plane logging for security monitoring
6. **Jenkins IAM Least Privilege** - Restricted Jenkins EKS access to specific cluster ARNs instead of wildcard

#### Code Quality Improvements
1. **Descriptive Naming** - Replaced numeric subnet keys ("1", "2", "3") with meaningful names ("jenkins-2a", "eks-2a", "rds-2a")
2. **Variable Documentation** - Added descriptions to all module variables for better maintainability
3. **Dynamic Configuration** - Removed hardcoded availability zones from NAT gateway setup
4. **Modular Design** - Created reusable modules for network, EC2, RDS, IAM roles, and EKS

#### Design Decisions (With Reasoning)

**Why we kept certain "issues":**
- **Hardcoded AMI ID:** Intentional for stability - using "latest" AMI causes unpredictable changes
- **Jenkins Admin Policy:** Required for our pipeline that manages cluster infrastructure (namespaces, metrics-server, Prometheus)
- **Unrestricted Egress:** Standard practice for both environments; restricting requires expensive VPC endpoints ($50-100/month)
- **S3 Native Locking:** Using modern S3 native state locking (2024 feature) instead of DynamoDB

#### Modern AWS Practices & Advanced Features

This project uses several modern AWS features and best practices that differentiate it from typical tutorial projects:

1. **S3 Native State Locking (2024)** - Using `use_lockfile = true` instead of DynamoDB (most projects still use the old method)
2. **EKS Access Entry API (2023)** - Modern `authentication_mode = "API"` instead of legacy aws-auth ConfigMap
3. **ECR with IAM Authentication** - No Docker Hub credentials needed, fully integrated with AWS IAM
4. **Secrets Manager Integration Pattern** - Terraform reads secrets AND updates them with connection details (bidirectional)
5. **Flexible IAM Role Module** - Single module supports multiple AWS services via `service` variable (DRY principle)

</details>

## 📁 Project Structure

```
terraform/
├── dev/
│   ├── main.tf           # Main configuration with all module calls
│   ├── variables.tf      # Environment-specific variables
│   ├── outputs.tf        # Infrastructure outputs
│   ├── provider.tf       # AWS provider with default tags
│   └── backend.tf        # S3 backend with native locking
├── modules/
│   ├── network/          # VPC, subnets, NAT, security groups
│   ├── ec2/              # EC2 instances with encrypted EBS
│   ├── rds/              # RDS with Secrets Manager integration
│   ├── role/             # Flexible IAM role module
│   └── eks/              # Complete EKS setup (cluster, nodes, OIDC, access)
└── prod/                 # Production environment (complete)
```

## 🔐 Security Features

- ✅ All data encrypted at rest (EBS, RDS, EKS secrets, S3)
- ✅ IAM roles with least privilege (no hardcoded credentials)
- ✅ Private subnets for all workloads
- ✅ Security groups with specific rules (no 0.0.0.0/0 ingress)
- ✅ EKS control plane logging to CloudWatch
- ✅ SSM Session Manager for secure access (no bastion host or SSH keys)
- ✅ Secrets Manager for database credentials
- ✅ KMS key rotation enabled

<details>
<summary><b>🔒 Security & Secrets Management - Zero Secret Exposure (Click to expand)</b></summary>

This project follows strict security practices to ensure **no secrets are ever exposed**:

### Secrets Manager Integration
**How Secrets Are Handled:**
- ✅ RDS credentials stored in AWS Secrets Manager (encrypted at rest with KMS)
- ✅ Secrets created **manually outside Terraform** (never in code or Git)
- ✅ Terraform reads secrets via `data` source (no plaintext exposure)
- ✅ Passwords **never appear** in:
  - Git repository
  - Terraform code
  - Terraform state files (state is encrypted in S3)
  - CI/CD logs
  - Container images
- ✅ Secrets Manager automatically updates with RDS endpoint after creation
- ✅ Future: External Secrets Operator will sync to Kubernetes (encrypted with KMS)

### Encryption at Every Layer
**Data at Rest:**
- ✅ **RDS:** Database encrypted with AWS-managed keys
- ✅ **EBS:** All EC2 volumes encrypted by default
- ✅ **EKS:** Kubernetes secrets encrypted with KMS key (created by Terraform)
- ✅ **S3:** Terraform state encrypted in S3 bucket
- ✅ **Secrets Manager:** All secrets encrypted with KMS

**Data in Transit:**
- ✅ All AWS API calls use TLS 1.2+
- ✅ RDS connections encrypted
- ✅ EKS API endpoint uses TLS

### IAM Security (No Hardcoded Credentials)
- ✅ EC2 instances use IAM roles (not access keys)
- ✅ Jenkins accesses AWS services via instance profile
- ✅ Least privilege policies (Jenkins can only access its own cluster)
- ✅ No AWS credentials in code, environment variables, or config files
- ✅ No root account usage

### Network Security
- ✅ All workloads in private subnets (no direct internet access)
- ✅ RDS not publicly accessible
- ✅ EKS API endpoint private-only (no public access)
- ✅ Security groups with specific rules (no 0.0.0.0/0 ingress)
- ✅ NAT Gateway for controlled outbound access

### Audit & Monitoring
- ✅ EKS control plane logging to CloudWatch
- ✅ SSM session logging to CloudWatch
- ✅ All IAM actions logged via CloudTrail (AWS default)
- ✅ Secrets Manager access logged

**Result:** Zero secrets in code, zero secrets in Git, zero secrets exposed. All sensitive data encrypted and access-controlled.

</details>

## 💡 Key Technical Decisions

### 1. NAT Gateway Strategy
**Dev:** 1 NAT Gateway in us-east-2a (shared across both AZs)
- Cost: ~$35/month
- Acceptable risk: If NAT fails, dev environment is down (not critical)
- Cross-AZ traffic cost: ~$0.01/GB (minimal for dev workloads)

**Prod:** 2 NAT Gateways (one per AZ)
- Cost: ~$70/month
- High availability: If one AZ fails, other AZ continues working
- No cross-AZ traffic for NAT (each AZ uses its own NAT)

### 2. RDS Configuration
**Dev:** 
- Single-AZ (us-east-2a only)
- 20GB storage
- 1-day backup retention
- skip_final_snapshot = true (faster teardown)
- Instance: db.t3.micro

**Prod:**
- Multi-AZ (automatic failover to standby in us-east-2b)
- 50GB storage (room for growth)
- 7-day backup retention (compliance/recovery)
- skip_final_snapshot = false (safety)
- Instance: db.t3.small (better performance)

### 3. EKS Configuration
**Dev:**
- 2 worker nodes (t3.small)
- Desired: 2, Min: 1, Max: 3
- 20GB disk per node
- Acceptable for development workloads

**Prod:**
- 3 worker nodes (t3.medium)
- Desired: 3, Min: 2, Max: 5
- 30GB disk per node
- Better performance and more headroom for scaling

### 4. SSM Session Manager (No Bastion Host)
Using AWS Systems Manager Session Manager instead of traditional bastion hosts or jump servers:

**Why SSM over Bastion:**
- ✅ No SSH keys to manage or rotate
- ✅ No bastion host to maintain and patch
- ✅ All sessions logged to CloudWatch
- ✅ IAM-based access control
- ✅ No inbound security group rules needed
- ✅ Cost savings (~$15/month for bastion host)

**Access Jenkins:**
```bash
aws ssm start-session --target <jenkins-instance-id>
```

**Access EKS via Jenkins EC2:**
```bash
# Connect to Jenkins via SSM
aws ssm start-session --target <jenkins-instance-id>

# Run kubectl from Jenkins instance
kubectl get nodes
kubectl get pods -A
```

**Port Forwarding (SSM Tunneling):**
```bash
# Access Jenkins UI locally
aws ssm start-session --target <jenkins-instance-id> \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["8080"],"localPortNumber":["8080"]}'

# Then access: http://localhost:8080
```

### 5. Secrets Management
Manual secret creation (outside Terraform) ensures:
- Secrets persist across `terraform destroy`
- Passwords never appear in code or Git
- Terraform reads and updates with connection details

### 6. Jenkins Per-Environment Strategy
**Why Jenkins in Both Dev and Prod:**

This project deploys Jenkins instances in both dev and prod environments for complete isolation:

**Dev Environment:**
- 2x t2.medium Jenkins instances
- Used for development, testing, and experimentation
- Can be destroyed/recreated without affecting production
- Lower cost, acceptable downtime

**Prod Environment:**
- 2x t3.medium Jenkins instances (more powerful)
- Dedicated CI/CD for production deployments
- Complete isolation from dev environment
- No cross-environment dependencies

**Why This Approach:**
- ✅ **Complete Isolation:** Dev Jenkins failures don't affect prod deployments
- ✅ **Security:** Prod credentials never touch dev environment
- ✅ **Compliance:** Some regulations require separate tooling per environment
- ✅ **Team Autonomy:** Different teams can manage different environments
- ✅ **Learning Value:** Demonstrates how to scale infrastructure across environments

**Alternative Approach:**
In many organizations, a single Jenkins in a "tools" account deploys to all environments. Both approaches are valid - this project chose per-environment isolation for learning and security demonstration.

### 7. Environment-Specific Variables Strategy
**Why Hardcoded Defaults Instead of .tfvars:**

This project intentionally uses hardcoded default values in `variables.tf` for each environment rather than `.tfvars` files:

**Dev Environment (terraform/dev/variables.tf):**
```hcl
ec2_config = {
  instance_type = "t2.medium"  # Visible in code
}
```

**Prod Environment (terraform/prod/variables.tf):**
```hcl
ec2_config = {
  instance_type = "t3.medium"  # Visible in code
}
```

**Why This Approach:**
- ✅ **Transparency:** Differences between environments are explicit and visible in Git
- ✅ **Code Review:** Changes to environment config go through PR review
- ✅ **Documentation:** The code itself documents what's different between dev/prod
- ✅ **No Hidden Config:** Everything is in version control, nothing hidden in .tfvars
- ✅ **Learning Value:** Makes it clear what changes between environments

**When to Use .tfvars:**
- Secrets or sensitive values (but we use Secrets Manager instead)
- Frequently changing values (not applicable here)
- Same codebase deployed to many environments (we have 2 well-defined environments)

For this project, explicit defaults in `variables.tf` provide better transparency and learning value than `.tfvars` files.

### 8. Jenkins IAM Permissions (Least Privilege)
**Scoped EKS Access:**

Jenkins IAM policy is restricted to only the specific EKS cluster in its environment:

**Dev Jenkins:**
```hcl
Resource = module.eks.cluster_arn  # Only todo-app-dev
```

**Prod Jenkins:**
```hcl
Resource = module.eks.cluster_arn  # Only todo-app-prod
```

**Why not use wildcard (*):**
- ✅ **Least Privilege:** Jenkins can only access its own cluster
- ✅ **Security:** Prevents accidental access to other EKS clusters
- ✅ **Compliance:** Follows AWS IAM best practices
- ✅ **Blast Radius:** Limits impact if Jenkins credentials are compromised

**Alternative (Not Used):**
Using `Resource = "*"` would allow Jenkins to describe all EKS clusters in the account, which violates the principle of least privilege.

### 9. IAM Role Module Flexibility
Supports multiple AWS services via `service` variable:
```hcl
service = "ec2.amazonaws.com"      # For EC2 instances
service = "eks.amazonaws.com"      # For EKS cluster
```

## 🚀 Deployment

<details>
<summary><b>Deployment Steps (Click to expand)</b></summary>

### Prerequisites
- AWS CLI configured
- Terraform >= 1.0
- S3 bucket for state (with encryption enabled)
- Secrets Manager secret for RDS credentials

### Steps

1. **Create RDS Secrets (one-time per environment):**

**For Dev:**
```bash
aws secretsmanager create-secret \
  --name todo-db-dev-credentials \
  --secret-string '{"username":"admin","password":"YourDevPassword","dbname":"tododb"}' \
  --region us-east-2
```

**For Prod:**
```bash
aws secretsmanager create-secret \
  --name todo-db-prod-credentials \
  --secret-string '{"username":"admin","password":"YourStrongProdPassword","dbname":"tododb"}' \
  --region us-east-2
```

2. **Initialize Terraform:**
```bash
cd terraform/dev
terraform init
```

3. **Review Plan:**
```bash
terraform plan
```

4. **Deploy:**
```bash
terraform apply
```

5. **Configure kubectl:**
```bash
# Connect to Jenkins via SSM
aws ssm start-session --target <jenkins-instance-id>

# Update kubeconfig
aws eks update-kubeconfig --name todo-app-dev --region us-east-2
```

</details>

## 📊 Cost Breakdown

<details>
<summary><b>Development Environment (~$180/month)</b></summary>

| Service | Configuration | Monthly Cost |
|---------|--------------|--------------|
| NAT Gateway | 1x NAT | ~$35 |
| EC2 (Jenkins) | 2x t2.medium | ~$30 |
| RDS MySQL | db.t3.micro, single-AZ, 20GB | ~$15 |
| EKS Control Plane | 1 cluster | $73 |
| EKS Worker Nodes | 2x t3.small | ~$30 |
| **Total** | | **~$180/month** |

</details>

<details>
<summary><b>Production Environment (~$340/month)</b></summary>

| Service | Configuration | Monthly Cost |
|---------|--------------|--------------|
| NAT Gateway | 2x NAT (HA) | ~$70 |
| EC2 (Jenkins) | 2x t3.medium | ~$60 |
| RDS MySQL | db.t3.small, Multi-AZ, 50GB | ~$50 |
| EKS Control Plane | 1 cluster | $73 |
| EKS Worker Nodes | 3x t3.medium | ~$90 |
| **Total** | | **~$340/month** |

**Key Differences:**
- Prod uses 2 NAT Gateways for high availability (+$35/month)
- Prod uses larger instance types for better performance (+$60/month)
- Prod uses Multi-AZ RDS with more storage and longer backups (+$35/month)
- Prod uses 3 larger EKS nodes instead of 2 smaller ones (+$60/month)

</details>

## 🤖 AI-Assisted Development

This project was built with the assistance of **Amazon Q** and **Gemini Code Assist** - not to generate the entire codebase, but as productivity tools to accelerate development and learning.

**How AI was used:**
- **Code Review:** Identified security issues, best practices violations, and improvement opportunities
- **Documentation:** Helped write clear variable descriptions and module documentation
- **Debugging:** Assisted in troubleshooting Terraform syntax and AWS service configurations
- **Learning:** Explained AWS concepts, Terraform patterns, and architectural decisions

**What AI didn't do:**
- Design the architecture (I made all architectural decisions)
- Write modules from scratch (I built each module iteratively)
- Make tradeoff decisions (I evaluated cost vs security vs complexity)
- Understand project context (I provided requirements and constraints)

**The Result:**
Using AI tools saved hours of documentation writing and syntax debugging, allowing me to focus on understanding AWS services, making design decisions, and solving real infrastructure problems. Every line of code was reviewed, understood, and intentionally committed.

**Production Environment Creation:**
Amazon Q replicated the dev environment to production by adjusting only variable values (NAT gateways, RDS configuration, instance sizes) - demonstrating how modular design enables rapid environment scaling. This saved hours of manual file creation and reduced human error.

**Think of it like:** Using Stack Overflow or AWS documentation, but interactive and context-aware. The learning and problem-solving were still mine.

## 🎓 What I Learned

1. **Infrastructure as Code:** Building modular, reusable Terraform modules
2. **Security Best Practices:** Encryption, IAM roles, network isolation
3. **Cost Optimization:** Strategic decisions for dev vs prod environments
4. **AWS Services:** Deep dive into VPC, EKS, RDS, Secrets Manager, SSM
5. **Code Review Process:** Iterative improvements based on feedback
6. **Design Tradeoffs:** When to optimize for cost vs security vs simplicity

## 🔄 Evolution of This Project

<details>
<summary><b>Project Journey: From Basic to Production-Ready (Click to expand)</b></summary>

**Initial Version:**
- Basic VPC and EC2 setup
- Hardcoded values everywhere
- Missing encryption
- Public EKS endpoint
- Numeric subnet keys

**After Multiple Iterations:**
- Modular, reusable code
- Full encryption at rest
- Secure access patterns
- Descriptive naming
- Comprehensive documentation
- Production-ready security

</details>

## 📝 Lessons Learned

1. **Hardcoded AMI is OK:** Stability > always-latest for production
2. **Cost vs Security:** Dev environments can make reasonable tradeoffs
3. **Documentation Matters:** Future-you will thank present-you
4. **Modular Design:** Reusable modules save time and reduce errors
5. **Security Layers:** Defense in depth (encryption + IAM + network + logging)

## 🔮 Future Enhancements

**Infrastructure (Already Implemented):**
- ✅ Production environment with Multi-AZ RDS
- ✅ 2 NAT Gateways for high availability
- ✅ Separate dev and prod environments
- ✅ EKS 1.34 with proper node sizing

**Potential Additions (Optional):**
- [ ] RDS read replicas for prod (if read-heavy workload)
- [ ] GuardDuty for threat detection (account-level, manual setup recommended)
- [ ] AWS Config for compliance monitoring
- [ ] Enable Secrets Manager automatic rotation for RDS
- [ ] Prometheus & Grafana for EKS cluster monitoring
- [ ] CloudWatch alarms for RDS and EC2 critical metrics
- [ ] AWS Backup for automated backup management
- [ ] WAF for application-level protection

## 🤝 Contributing

This is a personal learning project, but feedback and suggestions are welcome! Feel free to open issues or reach out.

## 📄 License

This project is open source and available under the MIT License.

---

**Built with:** Terraform, AWS, and lots of iteration 🚀

**Note:** This infrastructure was built from the ground up, not copied from templates. Every decision was made consciously, every issue was debugged, and every improvement was earned through the learning process.
