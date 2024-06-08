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

$table = mysqli_real_escape_string($connect, $_POST['tablename1']);
$ftable = mysqli_real_escape_string($connect, $_POST['tablename2']);
$msgs = mysqli_real_escape_string($connect, $_POST['msgs']);



$query = "INSERT INTO $table (msgs,statues)
                VALUES('$msgs','0') ";
$results = mysqli_query($connect, $query);

$query1 = "INSERT INTO $ftable (msgs,statues)
                VALUES('$msgs','1') ";
$results1 = mysqli_query($connect, $query1);

if($results>0){
    echo "user added successfully";
}
else{
    echo "invalied";
}
    



?>