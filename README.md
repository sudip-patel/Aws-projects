# 🔥 Secure Linux Web Server on AWS (Apache, Tomcat, MySQL, CloudWatch)

## 🚀 Project Overview  
This project demonstrates **real-world best practices** for deploying a **secure, monitored, and optimized** web server on AWS. It follows **DevOps methodologies** and **security hardening techniques** to ensure reliability, scalability, and protection against threats.

## 💡 Technologies Used  
- **AWS EC2** – Virtual server hosting for the application
- **Amazon CloudWatch** – Monitoring (CPU, Memory, Disk Usage)
- **Apache Web Server** – Serves static web content
- **Tomcat** – Runs Java-based applications
- **MySQL** – Database management system
- **Shell Scripting** – Automates server setup & configurations
- **IAM Roles & Security Groups** – Secure access management
- **Firewall Hardening** – SSH restrictions, custom firewall rules

---

## ⚙️ Setup Instructions  

### **1️⃣ Clone the Repository**  
```bash
git clone https://github.com/yourusername/aws-secure-web-server.git
cd aws-secure-web-server
```

### **2️⃣ Configure AWS EC2 Key Pair**  
Ensure your private key is properly secured to establish an SSH connection:
```bash
chmod 400 your-aws-key.pem
```

### **3️⃣ Run the Setup Script**  
The `setup.sh` script will:
- Install & configure **Apache, Tomcat, MySQL**
- Set up **AWS CloudWatch Agent** for monitoring
- Apply **Firewall rules & SSH security hardening**
- Enable **automated security updates**

Run the script:
```bash
bash setup.sh
```

### **4️⃣ Configure AWS CloudWatch Agent**  
Edit the CloudWatch agent configuration file:
```bash
sudo nano /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

#### **Example CloudWatch Config:**
```json
{
  "metrics": {
    "append_dimensions": { "InstanceId": "${!aws:InstanceId}" },
    "metrics_collected": {
      "cpu": { "measurement": ["cpu_usage_idle"], "metrics_collection_interval": 60 },
      "disk": { "measurement": ["disk_used_percent"], "metrics_collection_interval": 60 }
    }
  }
}
```

Save and restart the agent:
```bash
sudo systemctl restart amazon-cloudwatch-agent
```

---

## 📂 Project Folder Structure  
```bash
aws-secure-web-server/
│── config/               # Configuration files
│── logs/                 # Log files (sanitized, no confidential data)
│── screenshots/          # Documentation images
│── scripts/              # Automation & setup scripts
│── .gitignore            # Prevents sensitive data from being committed
│── LICENSE               # License file
│── README.md             # Project documentation
└── setup.sh              # Main installation script
```

---

## 🔒 Security Hardening Implemented  
- **Firewall Rules**: Only allows SSH (22), HTTP (80), and HTTPS (443)
- **IAM Role for EC2**: Grants minimal required permissions for security
- **CloudWatch Monitoring**: Tracks CPU, memory, and disk usage in real time
- **SSH Hardening**: Disables root login & restricts SSH access to specific IPs
- **Automated Security Updates**: Ensures all packages are kept up to date

---

## 🎨 Why This Project Matters?  
This setup is **more than just a simple web server**—it's built with **scalability, automation, and security** in mind. Whether you're deploying for **production**, **testing**, or **learning DevOps**, this project equips you with **real-world best practices**.

🔗 **Contributions & Feedback**  
Feel free to **fork**, **improve**, and **contribute**! Feedback is welcome—let’s build secure and scalable solutions together.

🛠 **Maintainer**: Sudip Patel
📄 **License**: MIT License  

