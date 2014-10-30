<?php

/*
PHP test file WeGotNext
Nick Zayatz
10/30/14
*/

$host = "localhost"; //database host server
$database = "WeGotNext_db"; //name of the database
$user = "nzayatzweb"; //the user of the database
$password = ")%$#^@*"; //the password for the user stated

$connection = mysql_connect($host, $user, $password);

//check to make sure the connection to the database works
if(!$connection){
        die("Connection to host failed.");
}else{
        $dbConnect = mysql_select_db($database, $connection);

        if(!$dbConnect){
                die("Unable to be connected to the specific database.");
        }else{
                //set the query and get the results
                $data = $_POST['json'];
                $query = json_decode($data)->{'query'};

                $result = mysql_query($query, $connection);

                if(!$result){
                        die("Error getting results");
                }
        }
}

mysql_close($connection);

?>
