## 🌍 Complete Learning Guide: Using Multiple `.tfvars` Files in Terraform

Managing multiple `.tfvars` files in Terraform is a common practice for handling different **environments** (e.g., `dev`, `test`, `prod`) or **modular configurations**. Here's everything you need to know.

---

## 📘 What is a `.tfvars` File?
A `.tfvars` file is used to assign **values to variables** defined in your `variables.tf` file.

```hcl
# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

```hcl
# dev.tfvars
instance_type = "t2.micro"
```

You can pass this file during execution:
```bash
terraform plan -var-file="dev.tfvars"
```

---

## ✅ Why Use Multiple `.tfvars` Files?
- Separate configurations for **dev**, **test**, and **prod** environments
- Better **modularity and reuse**
- Easier **collaboration** and **automation**

---

## 📁 Recommended Directory Structure
```bash
project/
├── main.tf
├── variables.tf
├── dev.tfvars
├── test.tfvars
├── prod.tfvars
```

---

## 🚀 How to Use Multiple `.tfvars` Files Together
Terraform allows you to pass multiple `.tfvars` files:

```bash
terraform apply -var-file="dev.tfvars" -var-file="override.tfvars"
```

### 🔁 Merge Behavior:
- **All files are used**
- If the **same variable** is defined in multiple files, the **last one takes precedence**

#### Example:
```hcl
# dev.tfvars
instance_type = "t2.micro"

# override.tfvars
instance_type = "t2.nano"
```

✅ Terraform will use `t2.nano`

---

## 🧠 Best Practices

### 1. ✅ Use `.tfvars` Naming Convention
- `dev.tfvars`
- `test.tfvars`
- `prod.tfvars`
- `override.tfvars`

### 2. ✅ Never Hardcode Secrets
Use `terraform.tfvars` for default values, but keep sensitive data in encrypted state or via Terraform Cloud/Backend.

### 3. ✅ Keep Environment Logic Separate
Use separate workspaces or folders if configs vary widely.

---

## 🔄 Alternate: Use `terraform.tfvars` Automatically
Terraform will automatically use `terraform.tfvars` or `*.auto.tfvars` without explicitly passing them:
```bash
terraform plan    # Automatically picks terraform.tfvars if present
```

---

## ✅ Example Workflow
```bash
# For development
terraform plan -var-file="dev.tfvars"

# For testing
terraform plan -var-file="test.tfvars"

# For production with overrides
terraform plan -var-file="prod.tfvars" -var-file="secrets.tfvars"
```

---

## 🛠 Tips for Real Projects
- Use a **CI/CD pipeline** to auto-select `.tfvars` files per environment
- Keep a `README.md` explaining each `.tfvars` purpose
- Use a `.gitignore` to exclude `*.tfvars` containing secrets

---

## 📌 Summary Table
| Feature                         | Explanation |
|---------------------------------|-------------|
| `.tfvars` file purpose           | Assign values to variables |
| Multiple file support           | Yes, passed with multiple `-var-file` flags |
| Conflict handling               | Last file overrides previous ones |
| Auto-loaded files               | `terraform.tfvars` or `*.auto.tfvars` |
| Common use case                 | Managing environments (dev, test, prod) |

---

Let me know if you want me to generate a sample project or templates for `.tfvars` environments!

