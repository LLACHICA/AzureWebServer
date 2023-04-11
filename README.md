# Infrastructure as Code with Terraform, Nginx, PHP, and MySQL
 
 Infrastructure as Code with Terraform, Nginx, PHP, and MySQL
This repository contains code for automating the deployment and management of an infrastructure stack using Terraform, Nginx, PHP, and MySQL. The project uses Bash scripts, Docker containers, and PHP scripts to automate the setup of the staging environment, the installation of dependencies, and the configuration of webserver and database environments.

## Getting Started
To use this project, you will need to have Terraform,Visual studio code,Azure CLI installed on your machine.

Clone this repository to your local machine using Git or download the ZIP file and extract it.
Navigate to the project directory and run terraform init to initialize the Terraform configuration.
Run terraform apply to deploy the infrastructure stack.
Once the infrastructure is deployed, run docker-compose up to start the Docker containers.
You should now be able to access the web server by opening a web browser and navigating to http://<publicIP> or the DNS label on the Terrafom code. 
  
##Deploying to Azure
To deploy this infrastructure stack to Azure, you will need to have an Azure account and the Azure CLI installed on your machine.

Run terraform init to initialize the Terraform configuration.
Run terraform apply to deploy the infrastructure stack to Azure.
Once the infrastructure is deployed, bash script will run setup the staging everonment and execute docker-compose up to start the Docker containers.
You should now be able to access the web server by opening a web browser and navigating to the public IP address of your Azure virtual machine.


https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-terraform
