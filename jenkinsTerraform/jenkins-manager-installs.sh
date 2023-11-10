#!/bin/bash

#################### Install Java ####################
sudo apt-get update -y

#################### Install Jenkins ####################
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list
sudo apt-get update -y

#################### Install and start Jenkins ####################
sudo apt-get install -y fontconfig openjdk-17-jre jenkins
sudo systemctl start jenkins

#################### Print initial admin password ####################
echo "Jenkins initial admin password: " 
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

#################### Done! ####################
echo "Jenkins successfully insalled!"
echo "########################################"
echo "Install the Docker pipeline plugin using the web interface"

exit 0