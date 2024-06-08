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

    $tablename1 = mysqli_real_escape_string($connect, $_POST['tablename1']);
    $tablename2 = mysqli_real_escape_string($connect, $_POST['tablename2']);
    $owner = mysqli_real_escape_string($connect, $_POST['cname1']);
    $cfname = mysqli_real_escape_string($connect, $_POST['cname2']);

    //$sql4 = " CREATE TABLE $cfname (id INT AUTO_INCREMENT PRIMARY KEY, ofname varchar(100)  ) ";
    $sql5 = " ALTER TABLE $cfname AUTO_INCREMENT=1 ";
    //$result4 = mysqli_query($connect,$sql4);
    $result5 = mysqli_query($connect,$sql5);

    $sql6 = " INSERT INTO $cfname (ofname) VALUE ('$owner') ";
    $sql7 = " INSERT INTO $owner (ofname) VALUE ('$cfname') ";
    $results6 = mysqli_query($connect,$sql6);
    $results7 = mysqli_query($connect,$sql7);

    $sql = " CREATE TABLE $tablename1 (id INT AUTO_INCREMENT PRIMARY KEY, msgs varchar(100),statues INT ) ";
    $sql1 = " ALTER TABLE $tablename1 AUTO_INCREMENT=1 ";
    $result = mysqli_query($connect,$sql);
    $result1 = mysqli_query($connect,$sql1);

    $sql2 = " CREATE TABLE $tablename2 (id INT AUTO_INCREMENT PRIMARY KEY, msgs varchar(100),statues INT  ) ";
    $sql3 = " ALTER TABLE $tablename2 AUTO_INCREMENT=1 ";
    $result2 = mysqli_query($connect,$sql2);
    $result3 = mysqli_query($connect,$sql3);
if($result>0){

    echo "user added successfully";
}
else{
    echo "invalied";
}
    



?>