# AWS Services Overview

## General AWS Topics
- Cloud Introduction AWS
- Software Development Life Cycle (SDLC)

## EC2 (Elastic Compute Cloud)
- EC2 on default network
- Custom Network
- VPC, Subnets, Route Tables (RT), NAT, Internet Gateway (IG)
- CIDR (Classless Inter-Domain Routing)
- Bastion Host
- Load Balancer (Network and Application)
- Auto Scaling
- EBS (Elastic Block Store) Volumes
- AMI (Amazon Machine Image), Security Groups (SG)

## S3 (Simple Storage Service)
- S3 Introduction
- Bucket Overview
- Storage Classes
- S3 Access: Public and Private
- S3 Versioning
- Replication Rules
- Lifecycle Manager Rules
- Inventory Configuration
- Static Website Hosting
- S3 Cross-Region Replication
- Storage Options

## Route 53 (DNS Service)
- Public Hosted Zone
- Name Servers, Records Replacement
- Record Creation (A Type, CNAME, Alias, etc.)
- Routing Policies (Simple, Failover, Geo-location, Latency)
- Health Checks

## IAM (Identity and Access Management)
- IAM User Concept
- Permissions
- Different Policies: Inline, Custom, Default
- User Login Methods
- CLI Approach with Root and User
- IAM Groups
- IAM Roles
- Access from Local and EC2
- AWS CLI Interaction with Cloud

## RDS (Relational Database Service)
- On-Prem vs. EC2 vs. RDS
- Creating RDS Master DB
- External Access
- Read Replica Concepts
- Promoting Read Replica to Master
- Deleting Master Instance
- Snapshots, Copy, Migration
- Monitoring Data Creation, Updates, Modifications
- Subnet Groups (Public & Private)
- Internal & External Access

## AWS Lambda (Serverless Compute)
- AWS Lambda Overview
- Creating Lambda Functions
- Triggers & Destinations
- Event-Based Concepts
- Scheduled Tasks
- Function URLs
- Connecting Lambda with RDS & EC2
- Internal & Public Access to RDS from Lambda
- RDS Connection Process from Lambda
- Lambda Layers

## AWS Certificate Manager
- Certificate Issues
- Route 53 Validation
- Load Balancer (HTTPS Configuration)

## CloudWatch (Monitoring & Logging)
- Configure CloudWatch for EC2
- Log Groups
- Push Logs to S3 (Manually & via Lambda)
- CloudWatch Alerts (CPU-based)

## AWS EventBridge
- Configuring Rules for Source & Target
- Event-Based Architecture

## Python Boto3 (AWS SDK for Python)
- AWS Cloud Interaction using Python
- Automations

## Linux Basics
- Commands
- User Management
- Permissions
