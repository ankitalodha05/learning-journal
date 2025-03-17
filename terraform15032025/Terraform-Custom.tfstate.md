# Using Custom `.tfstate` File in Terraform

## **1. Can You Rename `.tfstate` (e.g., `dev.tfstate`)?**
Yes, you **can** give a custom name to the Terraform state file (e.g., `dev.tfstate`), but Terraform **does not automatically recognize it** unless explicitly specified using the `-state` flag.

---

## **2. How Terraform Works with Custom State File Names**
By default, Terraform looks for `terraform.tfstate`. If you rename it (e.g., `dev.tfstate`), Terraform will not use it unless explicitly told to do so.

### **Using a Custom State File (`dev.tfstate`)**
To use `dev.tfstate` instead of `terraform.tfstate`, specify it in commands:

#### **1. Running `terraform plan` with a Custom State File**
```sh
terraform plan -state=dev.tfstate
terraform apply -state=dev.tfstate
```

#### **2. Storing Custom State File Remotely**
For remote state storage (e.g., AWS S3), define the custom file name in the `backend` block:

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "dev/dev.tfstate"  # Custom state file name
    region = "us-east-1"
  }
}
```
Terraform will then automatically use `dev.tfstate` without requiring the `-state` flag.

---

## **3. Will `terraform plan` Work Without `-state`?**
❌ **No**, if you simply run:
```sh
terraform plan
```
Terraform will look for `terraform.tfstate` and ignore `dev.tfstate`.

✅ **Yes**, if you specify the custom state file:
```sh
terraform plan -state=dev.tfstate
```

✅ **Yes**, if configured in the `backend` block (for remote storage). No need to pass `-state` manually.

---

## **4. Best Practices for Custom State Files**
1. **Use Different State Files for Different Environments**  
   - Example:
     - `dev.tfstate` → Development
     - `staging.tfstate` → Staging
     - `prod.tfstate` → Production

2. **Use Remote State Storage**  
   - If multiple team members are working on the same infrastructure, store state remotely (e.g., AWS S3, Terraform Cloud).

3. **Use `-state` Flag for Local Custom State Files**  
   - Always specify `-state=<filename>` when running Terraform commands with a custom local state file.

---

## **5. Summary Table**
| Custom State File | Works Automatically? | Requires `-state` Flag? |
|------------------|-------------------|-------------------|
| `terraform.tfstate` | ✅ Yes | ❌ No |
| `dev.tfstate` | ❌ No | ✅ Yes (`-state=dev.tfstate`) |
| Remote state (`backend "s3"` with `key = "dev/dev.tfstate"`) | ✅ Yes | ❌ No |

By understanding how Terraform handles state files, you can **efficiently manage multiple environments** and **avoid accidental overwrites**. 🚀

