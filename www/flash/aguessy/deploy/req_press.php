<?php
include ('connect.php');
$pass = $_POST['password'];
// $uri   = rtrim(dirname($_SERVER['HTTP_REFERER']), '/\\');

// $req = mysql_query("SELECT * FROM press_user WHERE pass='$pass'");
// $tab = mysql_num_rows($req);

if($pass == "kossigan"){
	setcookie("pressAccess", "1", time()+3600*24*365, "/");
	echo 'true';
}
else {
	echo 'false';
}
?>