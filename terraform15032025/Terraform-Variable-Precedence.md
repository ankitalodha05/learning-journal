# Understanding Variable Precedence in Terraform

## **Scenario 1: Understanding Value Priority in Terraform**

### **Implication:**
When defining values in multiple places within a Terraform configuration, it's important to understand which value takes precedence. The order of precedence is as follows:

1. **Explicitly hardcoded values inside `main.tf`** (Highest priority)
2. **Values defined in `terraform.tfvars`**
3. **Environment variables (`TF_VAR_` prefixed variables)**
4. **Default values defined in `variables.tf`** (Lowest priority)

### **Case 1: Values Defined in Multiple Places**
**Question:** If I hardcode values inside `main.tf`, define them as variables in `variables.tf`, and also provide values inside `terraform.tfvars`, which value will Terraform prioritize?

✅ **Answer:**
Terraform will always prioritize the **hardcoded value inside `main.tf`** over any other source.

### **Case 2: No Hardcoded Values in `main.tf`**
**Question:** If I don’t hardcode the value inside `main.tf`, but define it inside `variables.tf` and also provide values inside `terraform.tfvars`, which value will Terraform use?

✅ **Answer:**
Terraform will take the value from **`terraform.tfvars`** because it has a higher precedence than `variables.tf`.

### **Case 3: Environment Variables vs. `terraform.tfvars`**
**Question:** If I define a value using an **environment variable (`TF_VAR_<variable_name>`)** and also define the same value inside `terraform.tfvars`, which one will Terraform use?

✅ **Answer:**
Terraform will prioritize the **environment variable** (`TF_VAR_`) over `terraform.tfvars`.

---

## **Terraform Variable Precedence Order (Highest to Lowest Priority)**
Terraform follows this strict order when resolving variable values:

1. **Hardcoded values inside `main.tf`**  
   _Example:_
   ```hcl
   resource "aws_instance" "example" {
     instance_type = "t2.micro"  # This is hardcoded and takes highest priority
   }
   ```

2. **Values from `terraform.tfvars`**  
   _Example `terraform.tfvars`:_
   ```hcl
   instance_type = "t3.medium"
   ```

3. **Environment Variables (`TF_VAR_<variable_name>`)**  
   _Example:_
   ```sh
   export TF_VAR_instance_type="t3.large"
   ```

4. **Default Values in `variables.tf`** (Lowest priority)  
   _Example `variables.tf`:_
   ```hcl
   variable "instance_type" {
     description = "Type of AWS instance"
     type        = string
     default     = "t2.small"  # Lowest priority
   }
   ```

---

## **Key Takeaways**
- **Hardcoded values in `main.tf` always win** over any other definition.
- **Values in `terraform.tfvars` override values in `variables.tf`.**
- **Environment variables (`TF_VAR_`) take precedence over `terraform.tfvars`.**
- **Default values in `variables.tf` are only used if no other values are provided.**

---

By understanding these precedence rules, you can write more predictable and modular Terraform configurations, ensuring that your infrastructure is managed effectively and consistently. 🚀

