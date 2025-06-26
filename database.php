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

$host = 'your-db-name.region.psdb.io';  // host ya PlanetScale (uzabone muri credentials)
$db = 'electricity_system';              // izina rya database
$user = 'claudejesus';                 // username yo kuri PlanetScale
$pass = 'claudesegatware@23';                 // password
$port = 3306;                           // port isanzwe ya MySQL

$conn = new mysqli($host, $user, $pass, $db, $port);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
