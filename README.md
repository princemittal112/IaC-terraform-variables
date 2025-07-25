# 🚀 Terraform AWS Infrastructure Project

This project creates a **scalable AWS infrastructure** using Terraform and variables. It’s designed for anyone learning Infrastructure as Code (IaC), and demonstrates how to dynamically provision:

- ✅ A custom VPC
- ✅ 10 Public + 10 Private Subnets
- ✅ Internet Gateway (IGW)
- ✅ NAT Gateway with Elastic IP
- ✅ Route Tables for public and private traffic
- ✅ Security Group (for SSH access)
- ✅ 100 EC2 Instances — launched using loops and variables

---

## 📁 Project Structure

<img width="549" alt="Screenshot 2025-07-05 at 2 08 20 PM" src="https://github.com/user-attachments/assets/cfa05a4e-2975-40b0-ad69-c0a378c42990" />

---

## ⚙️ Technologies Used

- **Terraform** v1.x
- **AWS Provider**
- EC2, VPC, Subnets, NAT/IGW, Route Tables, Elastic IP

---

## 🚦 How to Use

### 🔁 Prerequisites
- AWS account and IAM user with EC2/VPC permissions
- Terraform installed

### ⏳ Steps

#### 1. Initialize Terraform
terraform init

#### 2. Review the execution plan
terraform plan

#### 3. Apply infrastructure (creates 100 EC2s, 20 subnets, etc.)
terraform apply

## 📤 Outputs
After terraform apply, you'll see:
- List of all EC2 instance names
- VPC ID
- Subnet IDs
- NAT Gateway IP

## 🧠 Concepts Practiced
- count and for_each
- locals with cidrsubnet() for dynamic CIDRs
- values() to loop over map outputs
- Infrastructure modularity using variables
- Clean output management with terraform output



## Final Output

<img width="545" alt="Screenshot 2025-07-05 at 2 11 39 PM" src="https://github.com/user-attachments/assets/52aec0a1-d2d2-48a2-98aa-f28aba51c616" />

<img width="1440" height="900" alt="terraform variable vpc diagram" src="https://github.com/user-attachments/assets/39740976-cbcd-429a-8f0c-fb88f3c41c88" />

