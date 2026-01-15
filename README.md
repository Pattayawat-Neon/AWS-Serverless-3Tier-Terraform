# AWS Serverless Daily Finance App

A cloud-native web application for tracking daily finances, built with a serverless architecture on AWS. This project demonstrates a 3-tier architecture (Frontend, Backend, Database) fully provisioned using **Terraform**.

## ☁️ Cloud Architecture & Tech Stack

This project leverages AWS Serverless services to ensure scalability, low cost, and minimal operational overhead.

![AWS Serverless Architecture](assets/AWS%20Serverless.jpg)

### Infrastructure as Code (IaC)
- **Terraform**: Manages the entire lifecycle of AWS resources (S3, Lambda, API Gateway, DynamoDB, IAM Roles).
- **State Management**: Remote state stored in S3 (`daily-finance-tfstate-dev`) with DynamoDB locking (implied).

### Components
| Component | Technology | Description |
|-----------|------------|-------------|
| **Frontend** | HTML5, CSS3, JavaScript | Static website hosted on **S3** with public read access. |
| **API** | Amazon API Gateway | REST API acting as the entry point for the backend. |
| **Backend** | AWS Lambda (Python 3.9+) | Serverless functions executing business logic (`Boto3`). |
| **Database** | Amazon DynamoDB | NoSQL key-value store for fast transaction lookups. |

---

⚠️ Note on Environment & Constraints This project was developed and tested within the AWS Learner Lab environment. Due to the platform's specific restrictions, certain architectural decisions were made:

Service Availability: Limited to a subset of AWS services (e.g., CloudFront and Route 53 were not used due to lab permissions).

IAM Restrictions: IAM roles and policies were configured within the scope of the LabRole provided by the environment.

Session Management: Infrastructure was designed to be easily reproducible via Terraform to accommodate the 4-hour lab session limit.

## 📂 Project Structure

```bash
AWS-Serverless-Project/
├── backend/                # Python code for Lambda functions
│   ├── createTransaction.py
│   ├── deleteTransaction.py
│   └── listTransactions.py
├── frontend/               # Static website files
│   ├── index.html
│   ├── css/
│   └── javascript/
├── terraform/              # Infrastructure definitions
│   ├── main.tf             # Provider & Backend config
│   ├── lambda.tf           # Lambda resource definitions
│   ├── apigateway.tf       # (Implied) API Gateway config
│   ├── dynamodb.tf         # DynamoDB table definition
│   ├── s3.tf               # S3 bucket for frontend & state
│   └── ...
└── README.md
```

---

## 🚀 Deployment Guide

### Prerequisites
- **AWS CLI** configured with appropriate credentials.
- **Terraform** (v1.5.0+) installed.
- **Python 3.9+** (for preparing Lambda zips).

### 1. Initialize Infrastructure
Navigate to the terraform directory:
```bash
cd terraform
terraform init
```

### 2. Deploy Resources
Review and apply the plan. This will create all AWS resources and output the API Endpoint.
```bash
terraform plan
terraform apply --auto-approve
```

### 3. Update Frontend Configuration
After deployment, Terraform typically outputs the **API Gateway Endpoint**. Update your frontend JavaScript configuration to point to this new URL.

### 4. Upload Frontend to S3
Upload your static files to the created S3 bucket:
```bash
aws s3 sync ../frontend s3://<YOUR_BUCKET_NAME>
```

---

## 🛡️ Security & Scalability features
- **IAM Roles**: Least privilege policies attached to Lambda functions (managed in `lambda.tf`).
- **CORS**: Configured in API Gateway and Lambda to allow cross-origin requests from the S3 website.
- **Auto-scaling**: AWS Lambda and DynamoDB (On-Demand mode) scale automatically with traffic.

## 📝 License
This project is open source.
