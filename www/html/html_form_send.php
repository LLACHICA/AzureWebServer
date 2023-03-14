<?php
// Database credentials
$host = "mysql";
$username = "myuser";
$password = "password";
$database = "mydb";

// Connect to database
$conn = mysqli_connect($host, $username, $password, $database);
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
echo "Connected successfully";

// Check if the form was submitted
if (isset($_POST['Submit'])) {
    // Sanitize and validate form data
    $first_name = mysqli_real_escape_string($conn, $_POST['first_name']);
    $last_name = mysqli_real_escape_string($conn, $_POST['last_name']);
    $email = mysqli_real_escape_string($conn, $_POST['customer_mail']);
    $start_date = mysqli_real_escape_string($conn, $_POST['date']);
    $duration = mysqli_real_escape_string($conn, $_POST['period']);
    $payment_type = mysqli_real_escape_string($conn, $_POST['payment']);
    $medical_notes = mysqli_real_escape_string($conn, $_POST['detail']);

    // Insert data into database
    $sql = "INSERT INTO gym_members (first_name, last_name, email, start_date, duration, payment_type, medical_notes) 
            VALUES ('$first_name', '$last_name', '$email', '$start_date', '$duration', '$payment_type', '$medical_notes')";
    if (mysqli_query($conn, $sql)) {
        echo "Data inserted successfully";
    } else {
        echo "Error inserting data: " . mysqli_error($conn);
    }
}

// Close database connection
mysqli_close($conn);
?>