<?php
// database.php
// $host = 'localhost';
// $db = 'electricity_system';
// $user = 'root';
// $pass = ''; // your DB password, if any

// $conn = new mysqli($host, $user, $pass, $db);

// if ($conn->connect_error) {
//     die("Connection failed: " . $conn->connect_error);
// }
?>
<?php
// database.php

$host = 'electricity-system.us-east.psdb.io';  // shyiramo hostname nyayo ubonye
$db = 'electricity_system';                     // izina rya database
$user = 'claudejesus';                          // username
$pass = 'claudesegatware@23';                   // password
$port = 3306;

$conn = new mysqli($host, $user, $pass, $db, $port);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "Connection successful!";
?>
