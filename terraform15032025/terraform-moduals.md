# 📘 Terraform Modules – Learning Document

---

## ✅ What is a Terraform Module?

> A **Terraform module** is a collection of standard Terraform configuration files in a folder. It allows you to organize your infrastructure code, make it reusable, and manage it in a scalable way.

You can think of a module like a **function in programming** – it can take **input variables**, perform actions, and return **output values**. Modules help break down complex infrastructure into smaller, manageable parts.

---

### 📌 Why Use Terraform Modules?

- ♻️ **Reusability** – Write once, reuse in multiple environments.
- 🧩 **Modularity** – Break down infrastructure into logical components.
- 🤝 **Team Collaboration** – Different teams can work on different modules.
- 📦 **Cleaner Code** – Better organization of infrastructure codebase.
- ⚙️ **Ease of Maintenance** – Update logic in one place, and apply everywhere.

---

## ✅ Types of Terraform Modules

Terraform has two primary types of modules:

---

### 1. **Root Module**

> The root module is the directory where you run Terraform commands like `terraform init`, `plan`, and `apply`.

It usually contains:
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `terraform.tfvars`

#### 🔹 Example:
```bash
$ tree
.
︻— main.tf
︻— variables.tf
︻— outputs.tf
︻— terraform.tfvars
```

This is your **root module**, and it's the starting point for your infrastructure deployment.

---

### 2. **Child Module**

> A child module is a reusable module that is **called from the root module** (or another module) using the `module` block.

Child modules are defined in separate directories and contain their own `main.tf`, `variables.tf`, and `outputs.tf`.

#### 🔹 Example:
```hcl
module "networking" {
  source       = "./modules/vpc"
  vpc_name     = "dev-vpc"
  cidr_block   = "10.0.0.0/16"
}
```

Here, the folder `./modules/vpc` is a **child module**, and it's being called by the **root module**.

---

## ✅ Module Folder Structure (Best Practice)

```
project/
│
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

- The root module (project/) is calling child modules (`vpc/`, `ec2/`)
- All input variables for child modules are passed from the root

---

## ✅ How to Use a Module

```hcl
module "ec2_instance" {
  source         = "./modules/ec2"
  instance_type  = "t2.micro"
  ami_id         = "ami-123456"
  subnet_id      = "subnet-abc"
}
```

- `source` – Path to the module (local folder, Git URL, or Terraform Registry)
- `instance_type`, `ami_id`, etc. – Inputs required by the module

---

## ✅ ⚠️ Important Note About `source` and Module Design

> When using Terraform modules, the directory defined in the `source` attribute (i.e., the **module folder**) should act as a **template**, not a standalone executable configuration.

### 🔹 What Does This Mean?

- The `source` directory (child module) **should not hardcode any values** or directly create resources with fixed values.
- The **root module**, where you call the module, is responsible for supplying the required input values.
- This ensures the module is **reusable** and does not behave unexpectedly when called from multiple places.

---

### ❗ Why Should the `source` Be a Template?

> If the `source` folder has hardcoded values and creates resources directly, then:
- It will create resources **when you run Terraform from the module directory**.
- It will also create resources **again when you call it as a module from another directory (root module)**.

🚨 This results in **duplicate resources** or **conflicts**, which is a big problem.

---

### ✅ Correct Practice

- **DO NOT** define values directly in the module's `main.tf` (like hardcoded AMI IDs, region, instance type, etc.).
- **DO define** variables in `variables.tf` and use them in `main.tf`.

```hcl
# inside module (source dir)
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
}
```

- **Then pass values from the root module**:

```hcl
# root module
module "my_instance" {
  source         = "./modules/ec2"
  ami_id         = "ami-123456"
  instance_type  = "t2.micro"
}
```

This way:
- The module acts as a **template** (no resources will be created if run directly).
- The **root module controls the behavior** by injecting values.
- Resource creation happens only once — from the root module.

---

### 🧠 Key Concept

> Think of the `source` module as a **reusable blueprint**. It should wait for input and do nothing on its own. All values should be **passed from the root module**.

---

## ✅ Summary

| Module Type  | Description                                                  |
|--------------|--------------------------------------------------------------|
| **Root**     | Main entry point where you run Terraform CLI commands        |
| **Child**    | Reusable module called from root or another module           |

---

## ✅ Additional Tips

- You can use modules from the **Terraform Registry**:  
  ```hcl
  module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "5.0.0"
    ...
  }
  ```

- If using `.tfvars` files to provide input values, they must be in the **same directory** where you run Terraform.  
  If the file is in another directory, you must specify the path:
  ```bash
  terraform apply -var-file="../config/dev.tfvars"
  ```

---

This document gives you a solid understanding of how to work with Terraform modules the right way. Let me know if you'd like this exported as a PDF or want a version tailored to AWS, Azure, or GCP.

