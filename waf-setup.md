# Step-by-Step Guide: AWS Web Application Firewall (WAF) Setup

-![Screenshot 2025-03-11 202031](https://github.com/user-attachments/assets/907fde6d-a489-41f9-b1fd-accf37810030)


## Introduction

This guide provides a step-by-step approach to setting up AWS WAF (Web Application Firewall) to protect web applications. It covers infrastructure setup, configuring EC2 instances, implementing a load balancer, and creating Web ACLs with rules to allow or block HTTP requests.

---

## Prerequisites

- An AWS account
- Basic knowledge of AWS services such as EC2, VPC, and Load Balancers
- IAM permissions to create and configure networking and security services

---

## Step 1: Set Up the VPC

1. Navigate to **AWS Management Console** → **VPC**.
2. Click **Create VPC**.
3. Provide a name and **CIDR block** (e.g., `10.0.0.0/16`).
4. Click **Create VPC**.

---

## Step 2: Set Up Internet Gateway

1. In the **VPC dashboard**, select **Internet Gateways**.
2. Click **Create Internet Gateway** and name it.
3. Attach it to the VPC created earlier.

---

## Step 3: Create Subnets

1. In **VPC dashboard**, go to **Subnets**.
2. Click **Create Subnet**.
3. Choose the VPC created earlier.
4. Create **two public subnets** in different availability zones.
5. Assign appropriate **CIDR ranges** (e.g., `10.0.1.0/24`, `10.0.2.0/24`).
6. Click **Create Subnet**.

---

## Step 4: Configure Route Table

1. In **VPC dashboard**, select **Route Tables**.
2. Click **Create Route Table** and associate it with the VPC.
3. Edit routes:
   - Add a route to `0.0.0.0/0` and select the **Internet Gateway**.
4. Associate this Route Table with the public subnets.

---

## Step 5: Launch an EC2 Instance

1. Navigate to **EC2 dashboard** → **Instances**.
2. Click **Launch Instance**.
3. Choose an **Amazon Linux/Ubuntu** AMI.
4. Select **t2.micro** instance type.
5. Configure the instance to be in one of the **public subnets**.
6. Enable **Auto-assign Public IP**.
7. Configure **Security Group** to allow HTTP, HTTPS, and SSH traffic.
8. Click **Launch**.

---

## Step 6: Create an Application Load Balancer (ALB)

1. Navigate to **EC2 dashboard** → **Load Balancers**.
2. Click **Create Load Balancer** → **Application Load Balancer**.
3. Configure:
   - Name the load balancer.
   - Select **Internet-facing**.
   - Choose **public subnets**.
   - Create a **new Security Group** to allow HTTP and ssh
4. Configure a **Target Group**:
   - Register the EC2 instance as a target.
5. Click **Create Load Balancer**.

---

## Step 7: Create AWS WAF Web ACL

1. Navigate to **AWS WAF & Shield** → **Web ACLs**.
2. Click **Create Web ACL**.
3. Choose the appropriate **Region**.
4. Select **Resource Type** (Application Load Balancer).
5. Attach the previously created **Load Balancer**.
6. Click **Next**.

-![Screenshot 2025-03-11 210405](https://github.com/user-attachments/assets/009285b6-6fe1-46cd-a68a-8617ee0786c6)
-![Screenshot 2025-03-11 210459](https://github.com/user-attachments/assets/bd54adea-4211-4914-b439-e233d2c4aa53)
-![Screenshot 2025-03-11 210537](https://github.com/user-attachments/assets/c57391c2-23f4-4bca-92af-f2cabe1caeb7)
-![Screenshot 2025-03-11 210637](https://github.com/user-attachments/assets/895ef511-afad-4fff-91ca-730b7aaf70dd)
-
---

## Step 8: Add Rules to Web ACL

### Block Specific IPs

1. Click **Add Rule** → **IP Set**.
2. Define IPs to block (e.g., `192.168.1.0/24`).
3. Set Action to **Block**.
4. Click **Save Rule**.

### Allow or CAPTCHA Requests

1. Create another rule to allow traffic.
2. Click **Add Rule** → **Custom Rule**.
3. Define a condition (e.g., allow requests from a specific country or based on rate limiting).
4. Set Action to **Allow** or **Captcha**.
5. Click **Save Rule**.

---

## Step 9: Test the Setup

1. Copy the **Load Balancer DNS Name** from AWS.
2. Open a browser and access the **Load Balancer DNS**.
3. If rules are set to block, the request should be blocked.
4. Modify rules to **Allow** and test again.
5. Experiment with other WAF rules like CAPTCHA, Rate Limiting, etc.

---

## Conclusion

You have successfully configured AWS WAF to protect your web application by filtering HTTP requests. You can further explore additional WAF rules and fine-tune security policies to enhance your setup.

