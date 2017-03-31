# Terraformit Microservice Modules #

This project is meant to be a helpful baseline Terraform module that can be used for deploying microservices with common PaaS features.  For full Terraform documentation see [HERE](https://www.terraform.io/docs/index.html).

## Abstract

Terraformit is designed to help engineers develop and deploy their microservices, regardless of their application platform decisions in a simplified, portable, secure (i.e. no checked in credentials) and automated way. 
Since Terraform.io has created a nearly unified scripting language for deploying applications to major Cloud providers, we took a stab at creating some common Terraform scripts for frequently used PaaS features.

### Terraformit Feature Goals ###

* Postgres Instance Creation via RDS
* MariaDB Instance Creation via RDS
* CloudFront Distribution Creation
* Cassandra n-cluster Creation
* MongoDB n-Cluster Creation (with Arbiter Node)

### Currently implemented Providers ###

* AWS

#### Currently implemented Services ####

* IAM User Creation
* VPC Creation
* NAT Creation
* Public Subnet Creation
* Private Subnet Creation
* Security Group Creation (ELB, WEB, WEB-ELB, WEB HTTPS)
* EC2 Instance Creation
* S3 Bucket Creation
* Auto-scaling Groups
* Launch Configurations
* Load Balancer Creation
* Jenkins CI&amp;D
* Git Integration

### Before you begin ###

* Verify you have an IAM user Access Key and Secret Key with full AWS API permissions (or appropriate subset).  It is normally easier to create a <account>-devops IAM user in the appropriate AWS account
* Configure your local AWS credentials for either your AWS user or the <account>-devops IAM user.
```
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: ENTER
```
* Create SSH keys for terraform-automation.  **Note**: the public key will need to be added to terraform-automation user within bitbucket.org before it can be used.
```
$ ssh-keygen -f ~/.ssh/terraform-automation -C "terraform-automation" 
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:

$ ssh-add ~/.ssh/terraform-automation

# Email output to dayel.ostraco@gmail.com
$ cat ~/.ssh/terraform-automation.pub
```
* Create SSH alias for terraform-automation and bitbucket
```
$ printf "Host terraform-automation\n HostName bitbucket.org\n IdentityFile ~/.ssh/terraform-automation" >> ~/.ssh/config
```

### Resources created in example ###

* SSH public and private keys
* AWS Key Pair
* AWS VPC with public and private subnets across multiple availability zones
* AWS Security Group with basic Web inbound/outbound rules
* AWS Launch Configuration for example web app.
* AWS AutoScaling group.
* AWS ELB

### Project Structure ###

```
.
├── providers  
│   └── aws  
│       └── <region>  
│           └── <environment>  
│               ├── main.tf
│               ├── network.tf  
│               ├── security.tf  
│               ├── datastore.tf    
│               ├── compute.tf  
│               ├── terraform.tfvars  
│               └── variables.tf  
└── setup  
    └── ssh_key_gen.sh  
```

### Setup ###

Before you begin, SSH keys must be generated.  Run the following command replacing the two args with the appropriate values.

```
$ sh ./setup/ssh_key_gen.sh <PROJECT> <ENVIRONMENT>
```

<PROJECT> and <ENVIRONMENT> should match the values supplied in ./providers/aws/<region>/<environment>/terraform.tfvars