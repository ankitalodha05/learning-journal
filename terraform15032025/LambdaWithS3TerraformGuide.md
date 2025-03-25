## 📘 Complete Step-by-Step Guide: Deploying AWS Lambda with S3 and Terraform

### 🧠 Why Not Keep Lambda Code on Local Machine?
Keeping your Lambda code only on your laptop is **not a good practice** because:
- ❌ It’s not version-controlled or easily shareable
- ❌ Not reproducible for other team members or environments
- ❌ Breaks CI/CD workflows

✅ Instead, you should:
1. **Upload the code to an S3 bucket**
2. **Reference that bucket in Terraform**
3. **Deploy the Lambda function by pulling code from S3**

---

## 🔁 High-Level Workflow

1. ✅ Terraform creates an S3 bucket
2. ✅ Lambda code (ZIP file) is uploaded to S3
3. ✅ Terraform deploys a Lambda function using the S3 bucket and key
4. ✅ `etag` is used to detect if the ZIP file has changed (auto re-upload)

---

## 📁 Folder Structure Example

```bash
lambda-terraform/
├── lambda_code/
│   └── lambda_function.py
├── my_lambda.zip
├── main.tf
├── iam.tf
├── lambda.tf
├── s3.tf
├── provider.tf
├── variables.tf
```

---

## 🧱 Step-by-Step Terraform Configuration

### 1. ✅ `variables.tf` – Define Variables
```hcl
variable "bucket_name" {
  description = "S3 bucket name for Lambda code"
  type        = string
}
```

### 2. ✅ `provider.tf` – Configure AWS Provider
```hcl
provider "aws" {
  region = "us-east-1"  # or your desired region
}
```

### 3. ✅ `s3.tf` – Create S3 Bucket and Upload Code
```hcl
resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name = "LambdaCodeBucket"
  }
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda/my_lambda.zip"
  source = "my_lambda.zip"
  etag   = filemd5("my_lambda.zip")
}
```

### 4. ✅ `iam.tf` – Create IAM Role for Lambda
```hcl
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
```

### 5. ✅ `lambda.tf` – Create Lambda Function
```hcl
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_zip.key

  memory_size = 128
  timeout     = 10
}
```

### 6. ✅ `main.tf` – Can Be Left Empty or Used for Future Resources
```hcl
# This file can remain empty for now
```

---

## 📝 Lambda Code Example (lambda_code/lambda_function.py)
```python
def lambda_handler(event, context):
    print("Hello from Lambda!")
    return {
        'statusCode': 200,
        'body': 'Lambda executed successfully!'
    }
```

---

## 🧰 Build & Deploy Instructions

### ✅ Step 1: Create the ZIP File in PowerShell (Windows)
From inside the `lambda_code` directory, run:
```powershell
Compress-Archive -Path .\lambda_function.py -DestinationPath ..\my_lambda.zip -Force
```

### ✅ Step 2: Initialize Terraform
```powershell
cd ..
terraform init
```

### ✅ Step 3: Plan the Deployment
```powershell
terraform plan -var="bucket_name=my-unique-lambda-bucket25032025"
```

### ✅ Step 4: Apply the Deployment
```powershell
terraform apply -var="bucket_name=my-unique-lambda-bucket25032025" -auto-approve
```

---

## ✅ Summary Table
| Component       | Purpose                               |
| --------------- | ------------------------------------- |
| S3 Bucket       | Stores the Lambda ZIP file            |
| S3 Object       | Uploads the actual code to the bucket |
| `etag`          | Detects changes in the ZIP file       |
| Lambda Function | Executes the code uploaded via S3     |
| IAM Role        | Gives Lambda permission to run        |
| Provider Block  | Specifies AWS provider configuration  |

---

🎉 Your Lambda function is now successfully deployed using S3 and Terraform!
