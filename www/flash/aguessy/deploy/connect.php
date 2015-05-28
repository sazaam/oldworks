<?php
session_start();
$serveur     = "";
$utilisateur = "root";
$motDePasse  = "Zoo3rues";
$base        = "1KSABLE";
$svconnex = mysql_connect($serveur, $utilisateur, $motDePasse);
$dbconnex = mysql_select_db($base);
?>