<?php
include ('../php/connect.php');
//sleep(2);
// recuperer l'ensemble des medias et construire une suite de lien
$uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
preg_match('/\/[a-z][a-z]\/*/',$uri, $tab);
if(isset($_COOKIE['lng'])){
	$lng = $_COOKIE['lng'];
}
else {
	$lang = $tab[0];
	$lng = substr($lang,1,2);
}

$cat = "all";
$default_language = "en";
$tab;
$req;
$num = 1;
$req0 = mysql_query("SELECT DISTINCT cat FROM kossi_folio WHERE lng='en' ");
while ($tab0 = mysql_fetch_array($req0)){
		$cat = $tab0['cat'];
		echo "<h4>".strtoupper($tab0['cat'])."</h4>";
		$req = mysql_query("SELECT * FROM kossi_folio WHERE lng='en' AND cat='$cat'");
		while ($tab = mysql_fetch_array($req)){
			$nom = utf8_encode($tab["nom"]);
			if($tab['desc_full'] != "" ) {
				echo "<div class='intro mea'>";
				echo "<img src='../img/portfolio/".utf8_encode($tab['url'])."' style='width:20%;' class='media' alt='".$tab['desc_courte']."'/>"; 
				echo "<div class='text'>";
				echo "<h1>".$nom."</h1>";
				echo "<p>".utf8_encode($tab['desc_full'])."</p>";
				$url = $tab['url'];
				echo "<a  href='../php/download.php?p=1&q=HD&n=$url'>Télécharger au format HD</a>";
				echo "<br />";
				echo "<a  href='../php/download.php?p=1&q=LD&n=$url'>Télécharger au format web</a>";
				echo "<br />";
				echo "<a  href='../php/download.php?p=3&n=$nom'>Télécharger le descriptif</a>";
				echo "</div></div>";
		}
	}
}
?>