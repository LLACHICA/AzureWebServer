<?php
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname="gym";

    $conn = new mysqli($servername, $username, $password,$dbname);
    if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
    } 
    $fname=$_POST['first_name'];
    print_r($_POST['first_name']);
    $sql=$conn->prepare("INSERT INTO gym_data (First Name,Last Name,Email Address,Telephone Number,Comments)VALUES(?,?,?,?,?)");
    $sql->bind_param('sssds',$_POST['first_name'],$_POST['last_name'],$_POST['email'],$_POST['telephone'],$_POST['comments']);

    if($sql->execute()){

    echo "New records created successfully";
    }
    else{
    echo 'Error'.$conn->error;


    }

$sql->close();
$conn->close();
?>

</body>
</html>