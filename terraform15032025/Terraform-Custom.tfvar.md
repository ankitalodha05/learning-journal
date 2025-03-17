# Using Custom `.tfvars` Files in Terraform

## **1. Can You Rename `terraform.tfvars` to Another Name Like `dev.tfvars`?**
Yes, **you can name the `.tfvars` file anything you want**, such as `dev.tfvars`, `staging.tfvars`, or `prod.tfvars`. However, **Terraform does not automatically load files that are not named `terraform.tfvars`**. You need to **explicitly specify the file** when running Terraform commands.

---

## **2. How to Use a Custom `.tfvars` File?**
If your file is named something other than `terraform.tfvars`, you must use the `-var-file` flag.

### **Example Usage**
```sh
terraform plan -var-file="dev.tfvars"
```
or
```sh
terraform apply -var-file="dev.tfvars"
```
This tells Terraform to load the variable values from `dev.tfvars` instead of the default `terraform.tfvars`.

---

## **3. What Happens If You Just Run `terraform plan` Without Specifying a `.tfvars` File?**
If you run:
```sh
terraform plan
```
Terraform will automatically:
1. **Look for a file named `terraform.tfvars`** in the working directory and use it if found.
2. **Ignore any other `.tfvars` files** (like `dev.tfvars`), unless explicitly specified.
3. **Use default values** from `variables.tf` if no `.tfvars` file is provided.

---

## **4. Best Practice for Managing Multiple Environments**
If you're working with **multiple environments**, it's a good practice to maintain separate `.tfvars` files for each:

```
project/
│── main.tf
│── variables.tf
│── terraform.tfvars  (default)
│── dev.tfvars
│── staging.tfvars
│── prod.tfvars
```

To apply configurations for a specific environment, use:
```sh
terraform apply -var-file="staging.tfvars"
```

---

## **5. Summary**
| Scenario | Works? | Notes |
|-----------|------|------------------------|
| `terraform.tfvars` | ✅ Yes | Auto-loaded by default. |
| `dev.tfvars`, `staging.tfvars` | ❌ No (unless specified) | Must use `-var-file` flag. |
| `terraform plan` | ✅ Yes | Uses `terraform.tfvars` if present, otherwise defaults from `variables.tf`. |
| `terraform plan -var-file="dev.tfvars"` | ✅ Yes | Loads variables from `dev.tfvars`. |

---

## **6. Final Takeaway**
- **Yes, you can use any `.tfvars` file name like `dev.tfvars`**, but you **must specify it using `-var-file`** when running Terraform commands.
- **If you just run `terraform plan`**, it will only use `terraform.tfvars` if it exists; otherwise, it will fall back to default values in `variables.tf`.

By following these best practices, you can efficiently manage multiple environments in Terraform and maintain a modular infrastructure setup! 🚀

