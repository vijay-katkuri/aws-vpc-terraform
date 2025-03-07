# Terraform AWS VPC Module

This repository contains a Terraform module for creating a fully functional **AWS Virtual Private Cloud (VPC)** with customizable subnets, routing, NAT Gateway, and Internet Gateway.

---

## 🚀 Project Overview

This Terraform configuration allows you to create:

- **A VPC** with a custom CIDR block.
- **Public and Private Subnets** based on your preferences.
- **NAT Gateway** (optional) for internet access from private subnets.
- **Internet Gateway** for internet access from public subnets.
- **Route Tables** for both public and private subnets.

---

## 🛠 Requirements

Before running the Terraform code, ensure you have the following:

- **Terraform**: v0.12 or later.
- **AWS CLI**: Configured with appropriate AWS credentials.
- **AWS Account**: With permissions to create VPCs, subnets, NAT Gateway, and Route Tables.

---

## 🔧 Variables

You can customize the infrastructure by modifying the variables in the `variables.tf` file.

| **Variable Name**          | **Description**                                      | **Default Value**         |
|----------------------------|------------------------------------------------------|---------------------------|
| `aws_region`               | The AWS region to create the resources               | `"eu-south-1"`            |
| `vpc_name`                 | The name of the VPC                                  | `"vkatkuri-lab"`          |
| `vpc_cidr`                 | The CIDR block for the VPC                           | `"10.0.1.0/24"`           |
| `number_of_subnets`        | The number of subnets to create                      | `6`                       |
| `create_private_subnets`   | Whether to create private subnets                    | `true`                    |
| `create_public_subnets`    | Whether to create public subnets                     | `true`                    |
| `create_nat_gateway`       | Whether to create a NAT Gateway                      | `true`                    |

---

## 🏷 Tags

By default, the following tags are applied to all resources:

```hcl
default_tags = {
  Environment   = "PROD"
  Owner         = "vkatkuri"
  "Expiry Days" = "365"
}
```
---
## 📜 How to Use

Follow these steps to use this Terraform module to create a VPC with public and private subnets:

### 1. **Clone this repository**

First, clone the repository to your local machine.

```bash
git clone https://github.com/your-username/terraform-aws-vpc.git
cd terraform-aws-vpc
```
### 2. **Initialize the Terraform Project**

Before you can apply the configuration, initialize the Terraform project. This will download the necessary providers and set up the working environment.
```bash
terraform init
```
### 3. **Edit the terraform.tfvars file**

Edit terraform.tfvars file to with appropriate variable values.
```hcl
aws_region = "eu-south-1"
vpc_name   = "vkatkuri-lab"
vpc_cidr   = "10.0.1.0/24"
number_of_subnets = 6
create_private_subnets = true
create_public_subnets = true
create_nat_gateway = true
```
### 4. **Plan the Deployment**
Preview the infrastructure changes with the terraform plan command.

```bash
terraform plan
```
### 5. **Apply the Deployment**
Apply the Terraform configuration to create the resources in AWS.

```bash
terraform apply
```
---
## 🔄 **Outputs**

Terraform outputs help you track the created resources.

Here are the key outputs:

- **`vpc_id`**: The ID of the created VPC.
- **`public_subnet_ids`**: The IDs of the public subnets.
- **`private_subnet_ids`**: The IDs of the private subnets.
- **`vpc_summary`**: A summary of the created VPC and its resources.

Example `vpc_summary` output:

```bash
vpc_summary = <<EOT
    VPC "vkatkuri-lab" created with associated CIDR block "10.0.1.0/24":
      - Contains 6 subnets,
        in which 3 are public and 3 are private.
      - Public Subnets:
            - subnet-08hc9p3ry89497tcz ---- 10.0.1.0/27 (eu-south-1a)
            - subnet-0lkneru9o9ingm9zh ---- 10.0.1.32/27 (eu-south-1b)
            - subnet-0whfrb23mvl7knrmd ---- 10.0.1.64/27 (eu-south-1c)
      - Private Subnets:
            - subnet-0sushn9l78xl29ijx ---- 10.0.1.96/27 (eu-south-1a)
            - subnet-0n1zey7iywj7mqjaw ---- 10.0.1.128/27 (eu-south-1b)
            - subnet-0je8rwt9v8bmnglm1 ---- 10.0.1.160/27 (eu-south-1c)
      - Internet Gateway: igw-0nc39n6yi27qyg2pt
      - NAT Gateway: nat-0xy3z5xokhyoxxfzk
      - Private Route Table: rtb-0swenjn0f5kcuztwu
      - Public Route Table: rtb-0lyl39xvo30kj3ndl

EOT
```
---
## 🌐 **Conclusion**
This Terraform module simplifies the process of creating a VPC with configurable subnets, routing, and optional NAT Gateway. You can easily extend this module to include more AWS services such as EC2, RDS, etc., or modify it based on your specific requirements.

For more information on Terraform, visit the [Terraform Documentation](https://www.terraform.io/docs).
