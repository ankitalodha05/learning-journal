# Terraform Modules, Variable Precedence, and Template Resources

## 🔧 1. Using Module Blocks Instead of Resource Blocks

Instead of writing the full `resource` block every time, it's best practice to create a **module** that contains the resource logic. You can then **call that module** using a `module` block and pass the required values as inputs.

### ✅ Why Use Modules?
- Reuse infrastructure code
- Keep configurations clean and organized
- Easier to maintain and scale

---

## ⚠️ 2. Important Note: No Hardcoded Values Inside Module Resources

When calling a resource through a module, ensure that the **resource inside the module is not hardcoded**. It should act as a **template**.

### ❌ Example of Hardcoded Resource
```hcl
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}
```

### ✅ Example of Template Resource Using Variables
```hcl
resource "aws_instance" "example" {
  ami           = var.ami
  instance_type = var.instance_type
}
```

This makes the module reusable. You can now pass different values from outside using the module block.

```hcl
module "ec2" {
  source         = "./modules/ec2"
  ami            = "ami-987654"
  instance_type  = "t3.small"
}
```

---

## 🧙‍♂️ 3. What Does “Resource Should Be Template” Mean?

It means the resource should be written in a **generic and reusable way**, using input **variables** instead of fixed values. This allows you to:
- Reuse the same module in different environments
- Avoid duplication
- Configure resources dynamically

---

## 🤺 4. What Happens If You Define a Variable in Both `variables.tf` and Module Block?

### Example:

#### In `modules/ec2/variables.tf`:
```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

#### In `main.tf` (Calling the Module):
```hcl
module "ec2" {
  source         = "./modules/ec2"
  instance_type  = "t3.small"
}
```

### ✅ Which Value Will Be Used?
**Terraform will use the value provided in the module block.**

> **Rule:** Value provided in the module block **overrides** the default value in `variables.tf`.

---

## 📌 Final Summary

| Feature                        | Description |
|-------------------------------|-------------|
| `terraform.tfvars`            | Provides values to root-level variables |
| `module` block                | Calls reusable modules and passes inputs |
| Template resource             | Resource using variables, not hardcoded values |
| Variable value precedence     | Module block input > `variables.tf` default |

---

## ✅ Best Practices

- Always write resources inside modules using variables — never hardcode values.
- Use `terraform.tfvars` for environment-specific configurations.
- Use module blocks to keep your root project clean and maintainable.
- Lock module versions when using public modules from the Terraform Registry.

---

## 📚 References

- [Terraform Modules Documentation](https://developer.hashicorp.com/terraform/language/modules)
- [Terraform Registry](https://registry.terraform.io/)

