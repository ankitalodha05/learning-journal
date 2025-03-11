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
-![Screenshot 2025-03-11 210725](https://github.com/user-attachments/assets/8c7865ed-f256-47ed-9bcf-3b5772ad971a)
-![Screenshot 2025-03-11 211101](https://github.com/user-attachments/assets/d359ea64-3d78-40b2-8af8-5bf296f9a644)
-![Screenshot 2025-03-11 211145](https://github.com/user-attachments/assets/de9872cd-e653-41aa-b9b1-707b4fc8455e)
-![Screenshot 2025-03-11 211423](https://github.com/user-attachments/assets/77058fdd-3610-43b0-9b9b-8cbd93b8bc1b)
-
---

## Step 8: Add Rules to Web ACL

now go back to our web application firewall , where we are trying to add rules
--![Screenshot 2025-03-11 211736](https://github.com/user-attachments/assets/380eb636-fb1f-4fb7-bd7b-439fc5b71ae0)
### Block Specific IPs

1. Click **Add Rule** → **IP Set**.
2. Define IPs to block (e.g., `192.168.1.0/24`).
3. Set Action to **Block**.
4. Click **Save Rule**.


-![Screenshot 2025-03-11 211932](https://github.com/user-attachments/assets/4bd6fed8-f5ae-42e2-93ba-f56736a83c09)
-![Screenshot 2025-03-11 212227](https://github.com/user-attachments/assets/b98baeb3-51af-406b-9f04-2ceed619b7d9)
-![Screenshot 2025-03-11 212710](https://github.com/user-attachments/assets/1634f785-d4ae-475f-b09d-94a5a2ddc2d5)
-![Screenshot 2025-03-11 212816](https://github.com/user-attachments/assets/6694c96d-97e9-4f0b-b908-4afc7ffdb28f)
-![Screenshot 2025-03-11 212920](https://github.com/user-attachments/assets/d50d8558-24bb-48fb-8c85-4a58826ff276)
-![Screenshot 2025-03-11 213312](https://github.com/user-attachments/assets/3a76b2f6-693c-4b52-bd0c-d81caa7e1ff8)
-![Screenshot 2025-03-11 213410](https://github.com/user-attachments/assets/8e4f0cfc-0455-4293-a12b-6f62a92349d9)

keep this default--
-![Screenshot 2025-03-11 213459](https://github.com/user-attachments/assets/19400edf-4d9b-4a4c-8ed3-840601981bcc)
-![Screenshot 2025-03-11 213602](https://github.com/user-attachments/assets/f3852063-3dfc-465d-85c1-95a2b1aa97de)

created
-![Screenshot 2025-03-11 213707](https://github.com/user-attachments/assets/eccdfccd-2a9c-438d-9ab9-75f451184ec1)

check for resources-
-![Screenshot 2025-03-11 213818](https://github.com/user-attachments/assets/4e32b168-a23f-49d2-874b-1071e6b778fc)

check for rules-
-![Screenshot 2025-03-11 214016](https://github.com/user-attachments/assets/afd53700-8a6b-465d-ad92-29d30162a44c)
-![Screenshot 2025-03-11 214107](https://github.com/user-attachments/assets/a05d7be6-2296-4dfe-8aa9-9d94b0ccfd3c)

check loadbalancer dns into browser-
-![Screenshot 2025-03-11 215144](https://github.com/user-attachments/assets/a0d484fc-7341-497c-a975-7f506d6cc806)

We are successfully able to block this user.
---------

Now lets change the rules – to allow – go to rule and edit the rule- 
-![Screenshot 2025-03-11 215338](https://github.com/user-attachments/assets/a81a8e71-762b-4b63-ba9a-1f87b944c258)
-![Screenshot 2025-03-11 215559](https://github.com/user-attachments/assets/83fc011a-aafd-4666-b264-ad569266424d)
-![Screenshot 2025-03-11 215628](https://github.com/user-attachments/assets/3a031220-653c-4445-9273-cee52afde583)


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

