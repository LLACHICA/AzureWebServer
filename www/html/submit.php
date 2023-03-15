<?php

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve form data
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['customer_mail'];
    $start_date = $_POST['date'];
    $duration = $_POST['period'];
    $payment_type = $_POST['payment'];
    $medical_notes = $_POST['detail'];

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
    $result = $stmt->execute([$first_name, $last_name, $email, $start_date, $duration, $payment_type, $medical_notes]);

    // Check if data is inserted successfully
    if ($result && $stmt->rowCount() > 0) {
        // Display success message
        echo "Data successfully inserted!";
    } else {
        // Display error message
        echo "Failed to insert data: " . $stmt->errorInfo()[2];
    }
}

// Retrieve data from database
$query = "SELECT * FROM gym_members";
$result = $pdo->query($query);
if ($result) {
    while ($row = $result->fetch()) {
        echo "ID: " . $row['id'] . "<br>";
        echo "First Name: " . $row['first_name'] . "<br>";
        echo "Last Name: " . $row['last_name'] . "<br>";
        echo "Email: " . $row['email'] . "<br>";
        echo "Start Date: " . $row['start_date'] . "<br>";
        echo "Duration: " . $row['duration'] . "<br>";
        echo "Payment Type: " . $row['payment_type'] . "<br>";
        echo "Medical Notes: " . $row['medical_notes'] . "<br>";
        echo "<br>";
    }
} else {
    echo "No data found.";
}

//<button onclick="window.location.href='index.php'">Back to Main Page</button>

?>