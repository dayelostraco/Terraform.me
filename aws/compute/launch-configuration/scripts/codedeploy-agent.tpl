#!/bin/bash -ex
yum update -y
yum update -y aws-cfn-bootstrap 
yum install -y aws-cli

# Install the AWS CodeDeploy Agent.
cd /home/ec2-user/ 
aws s3 cp 's3://aws-codedeploy-${region}/latest/codedeploy-agent.noarch.rpm' . --region ${region} 
yum -y install codedeploy-agent.noarch.rpm 

service codedeploy-agent start
chkconfig codedeploy-agent on

# Create user meant strictly for running the deployed application
useradd -s /sbin/nologin codedeploy
