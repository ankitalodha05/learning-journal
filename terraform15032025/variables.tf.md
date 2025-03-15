**Terraform Variables (`variables.tf`)**

## **Introduction**
`variables.tf` is a Terraform configuration file used to define input variables, allowing users to provide dynamic values instead of hardcoding them in configuration files. This improves reusability, flexibility, and scalability in infrastructure management.

## **Why Use `variables.tf`?**
1. **Parameterization** - Avoids hardcoding values in `main.tf`.
2. **Reusability** - Makes the configuration reusable for different environments.
3. **Consistency** - Allows defining values in one place and using them across multiple resources.
4. **Ease of Change** - Updating a single variable value can modify multiple resources.

## **Defining Variables in `variables.tf`**
Variables in Terraform are defined using the `variable` block.

### **Example: Defining Variables**
```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

## **Using Variables in `main.tf`**
Once defined, variables can be referenced using `var.<variable_name>` syntax.

### **Example: Using Variables in `main.tf`**
```hcl
provider "aws" {
  region = var.region
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = var.instance_type
}
```

## **Passing Values to Variables**
There are multiple ways to pass values to variables in Terraform.

### **1. Default Values (Defined in `variables.tf`)**
If a variable has a `default` value, it will be used automatically unless overridden.

### **2. Using a `terraform.tfvars` File**
You can define variables in a `terraform.tfvars` file:
```hcl
region = "us-west-2"
instance_type = "t3.medium"
```
Apply Terraform using:
```bash
terraform apply -var-file="terraform.tfvars"
```

### **3. Passing via Command Line**
You can override variables by passing them as command-line arguments:
```bash
terraform apply -var="region=us-west-2" -var="instance_type=t3.medium"
```

### **4. Using Environment Variables**
Set Terraform variables using environment variables:
```bash
export TF_VAR_region="us-west-2"
export TF_VAR_instance_type="t3.medium"
terraform apply
```

## **Best Practices for Using Variables**
- **Use descriptive names** for variables to improve readability.
- **Group related variables** in separate files (e.g., `variables.tf` for declarations, `terraform.tfvars` for values).
- **Avoid hardcoding sensitive information**; use environment variables or secrets management tools.
- **Use `terraform.tfvars` for default variable values** when running in different environments.

## **Conclusion**
The `variables.tf` file makes Terraform configurations modular, flexible, and environment-independent. It is a best practice to use variables for values that might change between deployments.

By leveraging variables, you can efficiently manage Terraform configurations for different cloud providers and infrastructure components.

