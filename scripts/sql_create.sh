#!/bin/bash

# Generate a time stamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Set up database connection parameters
DB_HOST="webserver-mysqlserver.mariadb.database.azure.com"
DB_USER="mariaadmin@webserver-mysqlserver"
DB_PASS="Admin123!"
DB_NAME="webserver_mysqldb"

# SQL query to create the table
CREATE_TABLE_SQL="CREATE TABLE gym_members (
id INT(11) NOT NULL AUTO_INCREMENT,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(50) NOT NULL,
start_date DATE NOT NULL,
duration VARCHAR(20) NOT NULL,
payment_type VARCHAR(20) NOT NULL,
medical_notes TEXT,
PRIMARY KEY (id)
);"

# Echo the time stamp
echo "Script started at $TIMESTAMP"
# Execute the SQL query to create the table
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "$CREATE_TABLE_SQL"