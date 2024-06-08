<?php
$username="root";//change username 
$password=""; //change password
$host="localhost";
$db_name="trailrun"; //change databasename

$connect=mysqli_connect($host,$username,$password,$db_name);

if(!$connect)
{
	echo json_encode("Connection Failed");
}

$username = mysqli_real_escape_string($connect, $_POST['username']);
$password = mysqli_real_escape_string($connect, $_POST['password']);
$phno = mysqli_real_escape_string($connect, $_POST['phno']);


$query = "INSERT INTO logindata (username,password,phno)
                VALUES('$username','$password','$phno') ";
$results = mysqli_query($connect, $query);

if($results>0){
    $sql = " CREATE TABLE $username (id INT AUTO_INCREMENT PRIMARY KEY, ofname varchar(20) unique) ";
    $sql1 = " ALTER TABLE $username AUTO_INCREMENT=1 ";
    $result = mysqli_query($connect,$sql);
    $result1 = mysqli_query($connect,$sql1);
    echo "user added successfully";
}
else{
    echo "invalied";
}
    



?>