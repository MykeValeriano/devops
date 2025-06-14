# Terraform EC2 Project

This project contains Terraform scripts to provision an EC2 instance on AWS. It is structured to use a modular approach, allowing for easy management and reuse of the EC2 instance configuration.

## Project Structure

```
terraform-ec2-project
├── main.tf                # Main Terraform configuration file
├── modules
│   └── ec2
│       ├── main.tf        # EC2 module configuration
│       ├── variables.tf   # Input variables for the EC2 module
│       └── outputs.tf     # Outputs for the EC2 module
├── variables.tf           # Input variables for the main configuration
├── outputs.tf             # Outputs for the main configuration
└── README.md              # Project documentation
```

## Getting Started

### Prerequisites

- Terraform installed on your machine.
- An AWS account with appropriate permissions to create EC2 instances.

### Setup

1. Clone the repository:

   ```
   git clone <repository-url>
   cd terraform-ec2-project
   ```

2. Configure your AWS credentials. You can do this by setting environment variables or using the AWS CLI.

3. Modify the `variables.tf` files in both the root and the `modules/ec2` directory to set your desired configurations, such as region, instance type, AMI ID, and key name.

### Applying the Configuration

To apply the Terraform configuration, run the following commands:

1. Initialize the Terraform working directory:

   ```
   terraform init
   ```

2. Review the execution plan:

   ```
   terraform plan
   ```

3. Apply the configuration:

   ```
   terraform apply
   ```

### Outputs

After applying the configuration, you will receive outputs such as the EC2 instance ID and public IP address. These will be displayed in the terminal and can also be found in the `outputs.tf` files.

### Cleanup

To remove the resources created by Terraform, run:

```
terraform destroy
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.