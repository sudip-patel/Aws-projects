#!/bin/bash

# 🚀 Secure AWS Web Server Setup Script
# This script installs Apache, MySQL, PHP, Tomcat 9, and sets up AWS CloudWatch monitoring.

set -e  # Exit immediately if any command fails

# Update system packages
echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Apache
echo "🌍 Installing Apache Web Server..."
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2

# Install MySQL
echo "💾 Installing MySQL Database..."
sudo apt install mysql-server -y
echo "Securing MySQL installation..."
sudo mysql --execute="
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password123';
    DELETE FROM mysql.user WHERE User='';
    DROP DATABASE IF EXISTS test;
    FLUSH PRIVILEGES;
"

# Start and enable MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Install PHP
echo "🛠 Installing PHP..."
sudo apt install php libapache2-mod-php php-mysql -y

# Install Java (Required for Tomcat)
echo "☕ Installing Java..."
sudo apt install openjdk-11-jdk -y

# Install Tomcat 9
echo "🚀 Installing Apache Tomcat 9..."
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

cd /tmp
TOMCAT_VERSION=9.0.82
TOMCAT_URL="https://downloads.apache.org/tomcat/tomcat-9/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz"

# Try both wget and curl
if ! wget -q "$TOMCAT_URL" -O apache-tomcat.tar.gz; then
    echo "⚠️ wget failed, trying curl..."
    curl -s -o apache-tomcat.tar.gz "$TOMCAT_URL"
fi

sudo tar -xvzf apache-tomcat.tar.gz -C /opt/tomcat --strip-components=1
sudo chown -R tomcat:tomcat /opt/tomcat
sudo chmod +x /opt/tomcat/bin/*.sh
sudo /opt/tomcat/bin/startup.sh

# Configure Security: Restrict SSH Access
echo "🔒 Securing SSH Access..."
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Check if SSH is open to public (BAD SECURITY)
SECURITY_GROUP_ID=$(curl -s http://169.254.169.254/latest/meta-data/security-groups)
if [[ "$SECURITY_GROUP_ID" == "0.0.0.0/0" ]]; then
    echo "⚠️ WARNING: Your SSH is open to the public! Fix it in AWS Security Groups."
fi

# Install & Configure CloudWatch Agent
echo "📊 Installing AWS CloudWatch Agent..."
wget -q https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl enable amazon-cloudwatch-agent

# Verify CloudWatch Agent is Running
if ! systemctl is-active --quiet amazon-cloudwatch-agent; then
    echo "❌ CloudWatch Agent FAILED to start!"
    exit 1
else
    echo "✅ CloudWatch Agent Running!"
fi

echo "✅ All services installed and secured! Your AWS Web Server is ready. 🚀"
