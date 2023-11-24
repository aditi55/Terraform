# Terraform

Modularized approach using Terraform to deploy an EC2 instance with IAM role, security group, an encrypted EBS volume, and metadata stored securely in an S3 bucket with state locking (using DynamoDB)


This Terraform project sets up a basic AWS infrastructure, including EC2 instances, VPC, subnets, IAM roles, and security groups.

## Prerequisites

Before you begin, ensure you have the following installed:

- Terraform 
- AWS CLI configured with necessary access credentials

## Configuration

Clone the repository:

   ```bash
   git clone https://github.com/aditi55/Terraform.git
```

## Usage

### Initialize the Terraform configuration:

```bash
terraform init

terraform validate
```

![Screenshot 2023-11-24 134925](https://github.com/aditi55/Terraform/assets/67974030/e7a7633d-91a3-4e20-b383-e3397946e52f)

### Review the plan to ensure everything looks correct:
```
terraform plan
```

### Apply the Terraform configuration:

```
terraform apply
```
Enter yes when prompted.

  
### Clean Up
To destroy the infrastructure and release AWS resources:

```
terraform destroy
```
Enter yes when prompted.

## Secure State file storage

main.tf
```
resource "aws_s3_bucket" "terraform_state" {
  bucket = "your-unique-s3-bucket-name"
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform_lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "terraform.tfstate"
    encrypt        = true
    dynamodb_table = aws_dynamodb_table.terraform_lock.name
  }
}
```
