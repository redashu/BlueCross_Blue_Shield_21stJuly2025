# Terraform CLI Tips & Security Best Practices

## 1. Essential Terraform CLI Tips

### a. Workflow Optimization

| Command                       | Purpose                      | Example                        |
|-------------------------------|------------------------------|-------------------------------|
| `terraform validate`          | Checks syntax errors         | `terraform validate`          |
| `terraform fmt`               | Auto-formats code            | `terraform fmt -recursive`    |
| `terraform plan -out=tfplan`  | Saves plan for review        | `terraform apply tfplan`      |
| `terraform refresh`           | Sync state with real infra   | `terraform refresh`           |
| `terraform state list`        | Lists managed resources      | `terraform state list`        |

**Pro Tip:**

```bash
# Plan & auto-approve if no changes
terraform plan -detailed-exitcode && echo "No changes" || terraform apply -auto-approve
```

### b. Debugging & Logging

```bash
# Enable verbose logging
export TF_LOG=DEBUG  # Levels: TRACE, DEBUG, INFO, WARN, ERROR

# Log to a file
export TF_LOG_PATH=terraform.log
```

### c. Workspace Management

```bash
# List workspaces
terraform workspace list

# Create/switch workspaces
terraform workspace new dev
terraform workspace select prod
```

### d. Targeting Specific Resources

```bash
# Plan/apply only for a specific resource
terraform plan -target=aws_instance.web
terraform apply -target=module.vpc
```

---

## 2. Terraform Security Best Practices

### a. Secrets Management

| Method              | Implementation            | Example                                         |
|---------------------|--------------------------|-------------------------------------------------|
| Environment Vars    | `TF_VAR_` prefix         | `export TF_VAR_db_password="..."`               |
| Encrypted Backends  | Use AWS/Azure Key Vault  | `terraform { backend "s3" { ... } }`            |
| Terraform Cloud     | Mark vars as sensitive   | `variable "api_key" { sensitive = true }`       |

**Never Do This:**

```hcl
# ❌ Hardcoded secret
variable "password" {
    default = "Password123!"  # Exposed in state file
}
```

### b. Secure State Files

**Remote Backends:**

```hcl
terraform {
    backend "s3" {
        bucket = "my-tf-state"
        key    = "prod/terraform.tfstate"
        region = "us-east-1"
        encrypt = true  # SSE encryption
    }
}
```

**State Locking:**  
Enabled by default in S3/Azure Blob backends.  
Prevents concurrent edits.

**Audit State:**

```bash
terraform state show aws_instance.web  # Inspect resources
```

### c. Least Privilege IAM

**Terraform Execution Role:**

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["ec2:Describe*", "s3:ListBucket"],
            "Resource": "*"
        }
    ]
}
```

Use AWS IAM Roles instead of access keys.

### d. Policy Enforcement

**Sentinel (Terraform Enterprise/Cloud):**

```python
# Enforce tagging policy
main = rule {
    all tfplan.resources as _, resources {
        resources.change.after.tags contains "Environment"
    }
}
```

**OPA (Open Policy Agent):**

```rego
# Rego policy to restrict instance types
deny[msg] {
    instance := input.resource_changes[_]
    instance.type == "aws_instance"
    not instance.change.after.instance_type in ["t2.micro", "t3.small"]
    msg := "Instance type not allowed"
}
```

### e. Secure CI/CD Pipelines

**Temporary Credentials (GitHub Actions Example):**

```yaml
- name: Assume AWS Role
    uses: aws-actions/configure-aws-credentials@v1
    with:
        role-to-assume: arn:aws:iam::123456789012:role/TerraformDeployRole
```

**Mask Secrets:**

```yaml
env:
    TF_VAR_db_password: ${{ secrets.DB_PASSWORD }}
```

---

## 3. Key Security Risks & Mitigations

| Risk                | Mitigation                                   |
|---------------------|----------------------------------------------|
| State File Exposure | Encrypt backend, restrict access             |
| Secret Leakage      | Use Vault/Secrets Manager, never commit .tfvars |
| Drift Attacks       | Enable drift detection in Terraform Cloud    |
| Malicious Modules   | Pin versions, audit third-party modules      |

---

## 4. Pro Tips for Secure Workflows

**Use `-lock=false` Sparingly:**

```bash
terraform apply -lock=false  # Only for emergency fixes
```

**Automate Scans:**

```bash
# Check for secrets in code
git secrets --scan
```

**Private Module Registry:**  
Host internal modules to avoid public dependencies.