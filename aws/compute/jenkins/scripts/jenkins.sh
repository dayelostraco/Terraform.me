#!/bin/bash -xe

# Install Jenkins
sudo curl -o /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins

service jenkins start
chkconfig jenkins on

# Update the AWS CLI to the latest version
yum update -y aws-cli

# Wait 30 seconds to allow Jenkins to startup
echo "Waiting 30 seconds for Jenkins to start....."
sleep 30

# Install the required plugins
cd /var/lib/jenkins/plugins

installPlugin() {
  if [ -f ./${1}.hpi -o -f ./${1}.jpi ]; then
    if [ "$2" == "1" ]; then
      return 1
    fi
    echo "Skipped: $1 (already installed)"
    return 0
  else
    echo "Installing: $1"
    curl -L --silent -O https://updates.jenkins-ci.org/latest/${1}.hpi
    return 0
  fi
}

installPlugin multiple-scms
installPlugin github-api
installPlugin scm-api
installPlugin git-client
installPlugin github
installPlugin git
installPlugin codedeploy
installPlugin bitbucket
installPlugin bitbucket-oauth
installPlugin nodejs
installPlugin cloudbees-folder
installPlugin slack
installPlugin exclusive-execution
installPlugin ws-cleanup

# Get all plugin dependencies
changed=1
maxloops=100

while [ "$changed"  == "1" ]; do
  echo "Check for missing dependecies ..."
  if  [ $maxloops -lt 1 ] ; then
    echo "Max loop count reached - probably a bug in this script: $0"
    exit 1
  fi
  ((maxloops--))
  changed=0
  for f in *.hpi ; do
    # without optionals
    #deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | grep -v "resolution:=optional" | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    # with optionals
    deps=$( unzip -p ${f} META-INF/MANIFEST.MF | tr -d '\r' | sed -e ':a;N;$!ba;s/\n //g' | grep -e "^Plugin-Dependencies: " | awk '{ print $2 }' | tr ',' '\n' | awk -F ':' '{ print $1 }' | tr '\n' ' ' )
    for plugin in $deps; do
      installPlugin "$plugin" 1 && changed=1
    done
  done
done

chown jenkins:jenkins *.hpi

# Restarting Jenkins
service jenkins restart

# Configure SSH, AWS CLI and GIT for jenkins user
su - jenkins --shell /bin/bash -c "ssh-keygen -t rsa -q -f '/var/lib/jenkins/.ssh/id_rsa' -N ''"
su - jenkins --shell /bin/bash -c "ssh-keyscan -t rsa github.com >> /var/lib/jenkins/.ssh/known_hosts"
su - jenkins --shell /bin/bash -c "ssh-keyscan -t rsa bitbucket.org >> /var/lib/jenkins/.ssh/known_hosts"
su - jenkins --shell /bin/bash -c "aws configure set region us-east-1"
su - jenkins --shell /bin/bash -c "aws configure set output json"
su - jenkins --shell /bin/bash -c "git config --global credential.helper '!aws codecommit credential-helper $@'"
su - jenkins --shell /bin/bash -c "git config --global credential.useHttpPath true"
su - jenkins --shell /bin/bash -c "git config --global user.email 'q-automation@qonceptual.com'"
su - jenkins --shell /bin/bash -c "git config --global user.name 'q-automation'"

