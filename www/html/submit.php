
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
        echo "<br>Data successfully inserted!";
    } else {
        // Display error message
        echo "Failed to insert data: " . $stmt->errorInfo()[2];
    }
}

// Retrieve data from database
$query = "SELECT * FROM gym_members";
$result = $pdo->query($query);
if ($result) {
    echo "<table>";
    echo "<tr><th>ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Start Date</th><th>Duration</th><th>Payment Type</th><th>Medical Notes</th></tr>";
    while ($row = $result->fetch()) {
        echo "<tr>";
        echo "<td>" . $row['id'] . "</td>";
        echo "<td>" . $row['first_name'] . "</td>";
        echo "<td>" . $row['last_name'] . "</td>";
        echo "<td>" . $row['email'] . "</td>";
        echo "<td>" . $row['start_date'] . "</td>";
        echo "<td>" . $row['duration'] . "</td>";
        echo "<td>" . $row['payment_type'] . "</td>";
        echo "<td>" . $row['medical_notes'] . "</td>";
        echo "</tr>";
    }
    echo "</table>";
} else {
    echo "No data found.";
}
?>

<html>
<head>
<meta charset="utf-8"/>
<title>Hamza Gym</title>
<meta name="viewport" content="width=device-width, intial-scale=1.0"/>
<link rel="stylesheet" type="text/css" href="index.css"/>
</head>
<body>
<br><br>
<button onclick="window.location.href='contactjs.html'">Back to Registration </button>
</body>
</html>