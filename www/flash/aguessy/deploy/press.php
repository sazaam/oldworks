<?php 
	session_start();
	if($_COOKIE['pressAccess'] != "1"){
		header("Location: ./");
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Kossi Aguessy - Designer</title>
		<meta http-equiv="Content-Type" Content="text/html; charset=UTF-8" /> 
		<script type="text/javascript" src="../js/mootools.js"></script>
		<script type="text/javascript" src="../js/default_press.js"></script>
		<link href="../css/default_press.css" rel="stylesheet" type="text/css" media="screen" />
		<link rel="stylesheet" type="text/css" media="screen" href="../css/default.css" />
		<link rel="shortcut icon" href="../favicon.ico">
		<link rel="icon" type="image/png" href="../favicon.png" />
	</head>
	<body style="background:#121212;background-image:none">
		<div id="page">
			<?php
			include('inc/head.php');
			?>
			<div class="all">
				<div class="main">
					<h4 class="f6 ">
						<strong class="context">Aguessy Medias</strong>
						<span>.</span>
						<?php echo nl2br($txt['dl_folio']); ?>
					</h4>
					<div class="article ">
						<?php 
						include("../php/pressFolio.php");
						?>
					</div>
				</div>
			</div>
		</div>
	</body>
	</html>
