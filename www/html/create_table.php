<?php

$database = "mydb";
$user = "myuser";
$password = "password";
$host = "mysql";

try {
    $connection = new PDO("mysql:host={$host};dbname={$database};charset=utf8", $user, $password);
    $connection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $createTableSQL = "CREATE TABLE gym_members (
        id INT(11) NOT NULL AUTO_INCREMENT,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email VARCHAR(50) NOT NULL,
        start_date DATE NOT NULL,
        duration VARCHAR(20) NOT NULL,
        payment_type VARCHAR(20) NOT NULL,
        medical_notes TEXT,
        PRIMARY KEY (id)
    )";

    $connection->exec($createTableSQL);

    echo "Table created successfully.";

} catch(PDOException $e) {
    echo "Error creating table: " . $e->getMessage();
}

$connection = null;
?>