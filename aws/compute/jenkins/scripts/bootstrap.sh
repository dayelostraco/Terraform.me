#!/bin/bash
set -e

echo "Updating yum..."
yum update -y

echo "Installing Development Tools"
yum -y groupinstall "Development Tools"

echo "Installing git..."
yum install -y git

echo "Updating Pip..."
pip install --upgrade pip

echo "Installing S3cmd..."
pip install s3cmd
