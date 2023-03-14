<?php

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve form data
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $start_date = $_POST['start_date'];
    $duration = $_POST['duration'];
    $payment_type = $_POST['payment_type'];
    $medical_notes = $_POST['medical_notes'];

    // Database credentials
    $host = 'mysql';
    $database = 'mydb';
    $user = 'myuser';
    $password = 'password';

    // Connect to database
    $pdo = new PDO("mysql:host=$host;dbname=$database;charset=utf8", $user, $password);

    // Prepare SQL statement
    $stmt = $pdo->prepare("INSERT INTO gym_members (first_name, last_name, email, start_date, duration, payment_type, medical_notes) VALUES (?, ?, ?, ?, ?, ?, ?)");

    // Execute SQL statement with form data
    $stmt->execute([$first_name, $last_name, $email, $start_date, $duration, $payment_type, $medical_notes]);

    // Display success message
    echo "Data successfully inserted!";
}
?>