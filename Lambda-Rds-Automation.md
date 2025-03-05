**Creating an AWS Lambda Function to Automate RDS Database and Table Creation**

### Introduction

AWS Lambda is a powerful, serverless computing service that allows you to execute code without provisioning or managing servers. In this document, we will outline the steps required to create an AWS Lambda function that automates the creation of an RDS database and a table within it.

### Prerequisites

Before setting up the Lambda function, ensure you have:

- An AWS account with necessary IAM permissions for Lambda and RDS.
- An RDS instance (MySQL) set up.
- AWS Lambda configured with an appropriate execution role that includes access to RDS.
- The `pymysql` library included in the Lambda function deployment package.

### Lambda Function Code

Below is the Python code used in the AWS Lambda function to create an RDS database and a table within it:

```python
import os
import pymysql

# Database settings from environment variables
db_host = os.environ['DB_HOST']
db_user = os.environ['DB_USER']
db_pass = os.environ['DB_PASS']
new_db_name = "test"  # Change as needed
table_name = "mytable"  # Change as needed

# Establish a database connection
def connect_to_rds():
    connection = pymysql.connect(
        host=db_host,
        user=db_user,
        password=db_pass,
        cursorclass=pymysql.cursors.DictCursor
    )
    return connection

# Lambda function handler
def lambda_handler(event, context):
    try:
        connection = connect_to_rds()
        with connection.cursor() as cursor:
            # Create a new database
            create_db_sql = f"CREATE DATABASE IF NOT EXISTS {new_db_name};"
            cursor.execute(create_db_sql)

            # Select the new database
            cursor.execute(f"USE {new_db_name};")

            # Create a new table
            create_table_sql = f"""
            CREATE TABLE IF NOT EXISTS {table_name} (
                id INT AUTO_INCREMENT PRIMARY KEY,
                name VARCHAR(255) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
            """
            cursor.execute(create_table_sql)

            print(f"Database '{new_db_name}' and table '{table_name}' created successfully.")
            return {
                'statusCode': 200,
                'body': f"Database '{new_db_name}' and table '{table_name}' created successfully."
            }
    except Exception as e:
        print("Error:", str(e))
        return {
            'statusCode': 500,
            'body': str(e)
        }
    finally:
        connection.close()
```

### Steps to Deploy the Lambda Function

1. **Create an IAM Role for Lambda:**

   - Attach the necessary policies to allow Lambda to access RDS.
   - Example: `AmazonRDSFullAccess`.

2. **Prepare the Deployment Package:**

   - Since `pymysql` is not a built-in library in AWS Lambda, create a zip package including `pymysql`.
   - Install `pymysql` using:
     ```
     pip install pymysql -t .
     zip -r lambda_function.zip .
     ```

3. **Create a Lambda Function:**

   - Go to AWS Lambda console and create a new function.
   - Choose "Author from scratch" and use Python as the runtime.
   - Upload the `lambda_function.zip` package.
   - Set environment variables:
     - `DB_HOST`: Your RDS endpoint.
     - `DB_USER`: Database username.
     - `DB_PASS`: Database password.

4. **Configure Execution Role:**

   - Assign the IAM role created earlier to the Lambda function.

5. **Test the Function:**

   - Use AWS Lambda test events to trigger the function and verify that the database and table are created successfully.

### Conclusion

By following these steps, you have successfully automated the creation of an RDS database and a table using AWS Lambda. This setup eliminates the need for manual database creation, making your cloud infrastructure more efficient and manageable.

-![image](https://github.com/user-attachments/assets/5090d29b-2f49-4497-8536-6dbabf80227c)

-![image](https://github.com/user-attachments/assets/57ff1e04-090e-45c0-92c3-922f4161c4ca)

-![image](https://github.com/user-attachments/assets/51591db4-c8c1-4ffc-810a-d004a6f4682d)
