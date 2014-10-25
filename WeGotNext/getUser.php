<?php

/*
PHP test file WeGotNext
Nick Zayatz
10/21/14
*/

$host = “hostname”; //database host server
$database = “databaseName”; //name of the database
$user = “yourUserName”; //the user of the database
$password = “yourPassword”; //the password for the user stated

$connection = mysql_connect($host, $user, $password);

//check to make sure the connection to the database works
if(!$connection){
	die(“Connection to host failed.”);
}else{
	$dbConnect = mysql_select_db($database, $connection);

	if(!$dbconnect){
		die(“Unable to be connected to the specific database.”);
	}else{
		//set the query and get the results
		$data = $_POST[‘json’];
		$query = json_decode($data)->{‘query’};

		$result = mysql_query($query, $connection);

		$person;

		while($r = mysql_fetch_row($result)){
			$person = $r;
		}

		echo json_encode($person);

		mysql_close($result);
	}
}

mysql_close($connection);

?>