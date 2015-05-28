<!DOCTYPE HTML>
<html>
<!--

Disclaimer:
This game was coded in about three days during some boring holiday,
and I didn't pay any attention to make "well written" code, I just wanted it to work.
In facts it is very hugly to read, so please don't try to learn anything useful here ;-)

-->
	<head>
		<title>FastKat</title>
		<meta charset="utf-8">
		<meta name="description" content="HTML5 browser game. Avoid hitting the particles by moving with your mouse. Try to stay alive and earn as many points as possible.">
		<meta name="keywords" content="html5, javascript, three.js, 3D, particles, game, browser game, race game, first person race">
		<meta name="viewport" content="width=device-width,user-scalable=no; initial-scale=1.0; maximum-scale=1.0;" />
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
		
		<style type="text/css">
			@font-face {
			  font-family: 'Geo';
			  font-style: normal;
			  font-weight: normal;
			  src: local('Geo'), local('Geo-Regular'), url('http://themes.googleusercontent.com/font?kit=PZuLMEHg-ApVzHRFEvyOKg') format('truetype');
			}

			body {
				background-color: #000;
				margin: 0px;
				overflow: hidden;
				cursor:crosshair;
			}

			a {
				color:#0078ff;
			}

			.hud {
				position:absolute;
				z-index:9999;
				color:white;
				font-family: 'Geo', serif;
				font-size: 100%;
				font-style: normal;
				text-shadow: 0px 0px 12px #ddd, 0px 0px 6px #ddd;
			}
			
			.but {
				color:white;
				font-family: 'Geo', serif;
				font-size: 100%;
				font-style: normal;
				border-radius:0.3em;
				border:0.1em solid white;
				background-color: rgba(99,99,99,0.65);
				cursor:pointer;
				text-shadow: 0px 0px 2px #fff;
			}
			
			.but:hover {
				background-color: #404040;
			}
			
			#score {
				top:0px;
				right:20px;
			}

			#lives {
				top:10px;
				left:20px;
				letter-spacing:10px;
				font-size:100%;
			}
			
			#start, #options, #optionsExit {
				position:absolute;			
				z-index:9999;
				text-align:center;
			}
			
			#start {
				top:50%;
				left:50%;
				width:6.2em;
				margin-left:-3.1em;
			}

			#options {
				top:68%;
				left:50%;
				width:6.2em;
				margin-left:-3.1em;
				font-size:60%;
			}
			
			#optionsExit {
				top:68%;
				left:50%;
				width:6.2em;
				margin-left:-3.1em;
				font-size:60%;
			}			
			
			#hiscore {
				position:absolute;
				z-index:9999;
				top:10px;
				left:50%;
				width:10em;
				margin-left:-5em;
				text-align:center;
				font-size:90%;
				line-height:70%;
			}			

			#info {
				position:absolute;
				z-index:9999;
				bottom:65px;
				left:50%;
				width:20em;
				margin-left:-10em;
				text-align:center;
				font-size:60%;
			}
			
			small {
				font-size:70%;
			}
			
			#title {
				position:absolute;
				z-index:9999;
				top:19%;
				left:50%;
				width:600px;
				margin-left:-300px;
				text-align:center;
				font-size: 200%;
			}				

			a#omiod {
				position:absolute;
				bottom:16px;
				right:10px;
				color:white;
				font-weight:bold;
				border:2px solid white;
				font-size:14px;
				font-family:arial;
				border-radius: 10px;
				text-decoration:none;
				padding:2px 5px;
				background-color:rgba(255,255,255,0.2);
				-webkit-box-shadow: 0px 0px 2px rgba(255,255,255,1);
			}	

			a#fkgl {
				position:absolute;
				bottom:16px;
				left:10px;
				color:white;
				font-weight:bold;
				border:2px solid white;
				font-size:14px;
				font-family:arial;
				border-radius: 10px;
				text-decoration:none;
				padding:2px 5px;
				background-color:rgba(255,255,255,0.2);
				-webkit-box-shadow: 0px 0px 2px rgba(255,255,255,1);
				display:none;
			}	
			
			#like {
				position:absolute;
				bottom:5px;
				left:50%;
				wifth:640px;
				margin-left:-320px;
			}				
			
			#optionspanel {
				position:absolute;
				top:0;
				left:50%;
				height:100%;
				width:10em;
				margin-left:-5em;
				display:none;
			}
			
			#opt_xaxis, #opt_yaxis, #opt_invincible, #opt_swirlonly, #opt_clear {
				position:absolute;
				left:50%;
				width:7em;
				margin-left:-3.5em;
				text-align:center;
				
				color:white;
				font-family: 'Geo', serif;
				font-size: 50%;
				font-style: normal;
				border-radius:0.3em;
				border:0.1em solid white;
				
				cursor:pointer;
				text-shadow: 0px 0px 2px #fff;
				
			}
			
			#opt_clear {
				background-color:#821;
			}
			
			#opt_xaxis { top:15%; }
			#opt_yaxis { top:23%; }
			#opt_swirlonly { top:40%; }
			#opt_invincible { top:48%; }
			#opt_clear { top:85%; }
			
			
			
			.active {
				background-color:#48f;
			}
			
			.inactive {
				background-color: rgba(66,120,140,0.65);
			}

			/* chrome hack */
			#___plusone_0 {
				height: 20px; width: 82px;display: inline-block;z-index: 9999999999;position: absolute;right: -70px;top: 4px;
			}
			
			
		</style>
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-58832-3']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>		
	</head>
	<body id='body'>

		<div id='score' class='hud'></div>
		<div id='lives' class='hud'></div>
		<div id='hiscore' class='hud'></div>
		<div id='title' class='hud'>FastKat</div>
		<div id='info' class='hud'></div>
		<div id='like'>
		
		<div style='display:inline-block; vertical-align:4px;'>
<script type="text/javascript"><!--
google_ad_client = "ca-pub-4692913335567958";
/* Omiod - fastkat */
google_ad_slot = "4527856291";
google_ad_width = 468;
google_ad_height = 15;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
		</div>		

		<script type="text/javascript" src="http://apis.google.com/js/plusone.js"></script><g:plusone size="medium"></g:plusone>
		
		<iframe src="http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.omiod.com%2Fgames%2Ffastkat.php&amp;layout=button_count&amp;show_faces=false&amp;width=100&amp;action=like&amp;colorscheme=dark&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:100px; height:21px; display:inline-block;" allowTransparency="true"></iframe></div>
		
		<a id='omiod' href='http://www.omiod.com/games/'>more games</a>
		<a id='fkgl' href='http://www.omiod.com/games/fastkat_gl/alpha/'>try WebGL FastKat</a>
		
		<div id='optionspanel'>
			<div id='opt_xaxis' class='active' onClick="clickOption(event)">invert X axis</div>
			<div id='opt_yaxis' class='active' onClick="clickOption(event)">invert Y axis</div>
			<div id='opt_invincible' class='active' onClick="clickOption(event)">invincible</div>
			<div id='opt_swirlonly' class='active' onClick="clickOption(event)">swirls only</div>
			<div id='optionsExit' class='but' onClick="optionsExit()">OK</div>
			<div id='opt_clear' class='but' onClick="resetHiscore()">Reset hi-score</div>
		</div>
		
		<div id='start' class='but' onClick="start()">START</div>
		<div id='options' class='but smaller' onClick="showOptions()">OPTIONS</div>
	
		<script type="text/javascript" src="http://uvl.googlecode.com/files/Three.js"></script>
		<script type="text/javascript">
		
			var STARS = 200;
			var FAR = 4000;
			var SAFE = 50;
			var PHASELEN = 15000;
			var NPHASES = 6;
			
			var speed;
			var score;
			var phase;
			var toNextPhase;
			var nextFrame;
			var nextP;
			var hiscore;
			var maxSpeed;
			
			var cr,cg,cb;
			
			var options = {"opt_xaxis":0 , "opt_yaxis":0 , "opt_invincible":0 , "opt_swirlonly":0 };
			
			var lives;
			var collision;
			
			var interval,hintsTimer;
			var tmp;
			var fullscreen=false;
			
			var container;
			var camera, scene, renderer;

			var particles, particle, count = 0;

			var mouseX = 0, mouseY = 0;

			var windowHalfX = window.innerWidth / 2;
			var windowHalfY = window.innerHeight / 2;

			var c1,c2;
			var bdy = document.getElementById("body");

			var messageNow = 0;
			var messages = [
				"version 1.4.2 - 2011/05/12",
				"run as fast as possible, avoiding any obstacle",
				"now with more reactive controls!",
				"and gets even faster after a while",
				"press F11 to enter/exit full screen",
				"this game works best with Chrome and a fast PC",
				"if too slow, try reducing the window size",
				"Firefox4 works fine too",
				"and they say IE9 does too!",
				"press ESC while playing to return here",
				"LMB = brakes"
				];
			
			function handleKeyDown(event) {
				if (event.keyCode == 27) {
					
					interval=window.clearInterval(interval);
					optionsExit();
					gameOver();					
					
					if (event.preventDefault) event.preventDefault();
					if (event.stopPropagation) event.stopPropagation();				
				}
			}			
			
			container = document.createElement( 'div' );
			document.body.appendChild( container );

			camera = new THREE.Camera( 80, window.innerWidth / window.innerHeight, 1, FAR - 250 );
			camera.position.z = FAR;

			scene = new THREE.Scene();
		
			init();
		
			reset();
			titleScreen();
			onWindowResize();
			
			function get(id) {
				var v = localStorage.getItem(id) || 0;
				return parseInt(v);
			}

			function set(id,value) {
				localStorage.setItem(id,value);
				updateOption(id);
			}

			function updateOption(id) {
				value = get(id);
				var o = document.getElementById(id);
				if ( value == 0 ) {
					o.className = "inactive";
				} else {
					o.className = "active";
				}			
			}
			
			function resetHiscore() {
				localStorage.setItem("hiscore", 0);
				hiscore = 0;
				hide("opt_clear");
			}
			
			function clickOption(e) {
				var id = e.target.id;
				var v = get(id);
				v = 1-v;
				set(id,v);
			}
			
			function html(id,txt) {
				var o = document.getElementById(id);
				o.innerHTML = txt;
			}
			
			function show(id) {
				var o = document.getElementById(id);
				o.style.display='block';
			}
			
			function hide(id) {
				var o = document.getElementById(id);
				o.style.display='none';
			}
			
			function titleScreen() {
				hiscore = localStorage.getItem("hiscore");
				if ( hiscore == 0 || hiscore == undefined || hiscore == null ) hiscore = 0;
				
				//var o = document.getElementById("hiscore");
				//o.innerHTML = "hi-score "+hiscore;
				html("hiscore","hi-score "+hiscore);
				
				show("hiscore");
				show("title");
				show("omiod");
				//show("fkgl");
				show("like");
				show("options");
				show("info");

				if (interval != undefined) interval=window.clearInterval(interval);
				if (hintsTimer != undefined) hintsTimer=window.clearInterval(hintsTimer);
				
				interval = setInterval(demo, 1000 / 60);
				hintsTimer = setInterval(showHints, 3000);
			}
			
			function start() {
				hide("start");
				hide("hiscore");
				hide("title");
				hide("omiod");
				//hide("fkgl");
				hide("like");
				hide("info");
				hide("options");
				
				options.opt_xaxis = get("opt_xaxis");
				options.opt_yaxis = get("opt_yaxis");
				options.opt_invincible = get("opt_invincible");
				options.opt_swirlonly = get("opt_swirlonly");
				
				if (interval != undefined) interval=window.clearInterval(interval);
				if (hintsTimer != undefined) hintsTimer=window.clearInterval(hintsTimer);
				
				reset();
				updateLives();
				interval = setInterval(loop, 1000 / 60);
				
				maxSpeed = 50;
				
				initPhase( 1 );
			}

			function gameOver() {
				var startext = [];
				startext[0] = "START";
				startext[1] = "TRY AGAIN";
				startext[2] = "ONCE MORE";
				startext[3] = "DO IT AGAIN";
				startext[4] = "RESTART";
				startext[5] = "WANNA PLAY";
				startext[6] = "ONE MORE TIME";
				startext[7] = "GO !!!";
				bdy.style.backgroundColor = '#000';

				html("start",startext[ Math.floor(Math.random() * startext.length) ]);
				
				show("start")
				
				hiscore = localStorage.getItem("hiscore");
				if ( hiscore == 0 || hiscore == undefined || hiscore == null ) hiscore = 0;
				
				if ( hiscore < score && options.opt_invincible == 0 ) {
					hiscore = score;
					localStorage.setItem("hiscore", hiscore);
				}
				
				titleScreen();
			}
			
			function initPhase( ph ) {
				phase = ph;
				toNextPhase = 5000 + Math.random() * PHASELEN;
				
				if ( options.opt_swirlonly == 1 ) phase = 3;
				
				switch ( phase ) {

					case 0:
						break;
				
					case 1:
						break;
						
					case 2:
						c1 = Math.random() * 6.28;
						if ( Math.random() > 0.5 )
							c2 = Math.random() * 0.005;
						else
							c2 = 0;
						break;								
						
					case 3:
						c1=Math.random()*500 + 10;
						c2=Math.random()*20 + 1;
						break;
						
					case 4:
						c1 = Math.random()*500 + 10;
						c2 = c1/2;
						break;									

					case 5:
						c1 = Math.random()*10 + 5;
						c2 = Math.random()*10 + 5;
						break;
						
				}
				
				//console.log("init phase :"+c1+" , "+c2)
				
			}

		
			function updateLives() {
				var out = "";
				for ( var i = 0; i<lives ; i++ ) out += "¤";
				//var lv = document.getElementById("lives");
				//lv.innerHTML = out;
				html("lives",out);
			}

			function reset() {
				speed = 0;
				score = 0;
				phase = 4;
				nextFrame = 0;
				nextP = 0;			
				lives = 2;
				collision = 0;			
			
				for ( var i = 0; i < STARS; i ++ ) {
					particle = particles[ i ];
					particle.position.x = (i % 2) * 1200 - 600;
					particle.position.y = -300;
					particle.position.z = i * ( FAR / STARS ) ;
					particle.scale.x = particle.scale.y = 17;
				}
			}
			
			function init() {
				resetFont();
				
				particles = new Array();

				for ( var i = 0; i < STARS; i ++ ) {

					//particle = particles[ i ] = new THREE.Particle( new THREE.ParticleCircleMaterial( { color: 0xffffff, opacity: 1, blending: THREE.AdditiveBlending } ) );
					//particle = particles[ i ] = new THREE.Particle( new THREE.ParticleCircleMaterial( { color: 0xffffff, opacity: 1, blending: THREE.SubtractiveBlending } ) );
					particle = particles[ i ] = new THREE.Particle( new THREE.ParticleCircleMaterial( { color: 0xffffff, opacity: 1 } ) );
					
					scene.addObject( particle );
				}

				renderer = new THREE.CanvasRenderer();
				//renderer.setClearColor( 0xff0000, 1 );
				renderer.setSize( window.innerWidth, window.innerHeight );
				container.appendChild( renderer.domElement );

				document.addEventListener( 'mousemove', onDocumentMouseMove, false );
				//document.addEventListener( 'touchstart', onDocumentTouchStart, false );
				//document.addEventListener( 'touchmove', onDocumentTouchMove, false );
				document.addEventListener( 'mousedown', onDocumentMouseDown, false );
				window.addEventListener( 'resize', onWindowResize, false );
				window.addEventListener('keydown', handleKeyDown, true)	
				
				//updateLives();
				
			}

			function resetFont() {
				var wh = window.innerHeight / 11;
				bdy.style.fontSize = wh+'px';
			}
			
			function onWindowResize(){
				windowHalfX = window.innerWidth / 2;
				windowHalfY = window.innerHeight / 2;			
				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();
				renderer.setSize( window.innerWidth, window.innerHeight );
				resetFont();
				
				fullscreen = ( window.innerWidth == window.outerWidth )
				//console.log("full:"+fullscreen);
				
				//console.log( window.innerWidth +","+ document.body.clientWidth +","+ document.width +","+  document.documentElement.clientWidth +","+ window.outerWidth );
				
			}

			function onDocumentMouseMove( event ) {

				if ( options.opt_xaxis == 0 )
					mouseX = event.clientX - windowHalfX;
				else
					mouseX = windowHalfX -event.clientX;
					
				if ( options.opt_yaxis == 0 )
					mouseY = event.clientY - windowHalfY;
				else
					mouseY = windowHalfY -event.clientY;
					
			}

			/*
			function onDocumentTouchStart( event ) {
				if ( event.touches.length == 1 ) {
					event.preventDefault();
					mouseX = event.touches[ 0 ].pageX - windowHalfX;
					mouseY = event.touches[ 0 ].pageY - windowHalfY;
				}
			}

			function onDocumentTouchMove( event ) {
				if ( event.touches.length == 1 ) {
					event.preventDefault();
					mouseX = event.touches[ 0 ].pageX - windowHalfX;
					mouseY = event.touches[ 0 ].pageY - windowHalfY;
				}
			}
			*/
			
			function onDocumentMouseDown( event ) {
				event.preventDefault();
				speed = speed *0.75;
			}

			//

			function loop() {

				camera.position.x += ( (mouseX/windowHalfX)*700 - camera.position.x ) * .08;
				camera.position.y += ( -(mouseY/windowHalfY)*600 - camera.position.y ) * .08;

				loopSpeed = speed;
				
				if ( speed < 50 ) {
					cr = cg = cg = 1;
				} else if ( speed > 90 ) {
					cr = Math.random();
					cg = Math.random();
					cb = Math.random();
				} else if ( speed > 80 ) {
					cr = 1;
					cg = 0;
					cb = 0;
				} else if ( speed > 70 ) {
					cr = 0.8;
					cg = 0.2;
					cb = 1.0;
				} else if ( speed > 60 ) {
					cr = 1;
					cg = 0.9;
					cb = 0.1;
				} else {
					cr = 0.5;
					cg = 0.9;
					cb = 1;
				}
				
				for ( var i = 0; i < STARS; i ++ ) {
					particle = particles[ i ];
					particle.position.z += loopSpeed;
					
					var color = particles[ i ].materials[ 0 ].color;
					
					if ( speed >= 50 ) {
						color.r = (particle.position.z / FAR * cr );
						color.g = (particle.position.z / FAR * cg );
						color.b = (particle.position.z / FAR * cb );
						
					} else {
						color.r = color.g = color.b = (particle.position.z / FAR);
					}
					
					//color.r = color.g = color.b = (particle.position.z / FAR);
					color.updateStyleString();
					
					
					if (particle.position.z > FAR) {
						particle.position.z -= FAR;
						
						nextFrame ++;
						
						switch ( phase ) {
							case 1:
								if ( Math.random() < 0.95 ) {
									particle.position.x = Math.random() * 3000 - 1500;
									particle.position.y = Math.random() * 3000 - 1500;
								} else {
									particle.position.x = camera.position.x + Math.random() * 200 - 100;
									particle.position.y = camera.position.y + Math.random() * 200 - 100;
								}
								break;
								
							case 2:
								tmp = Math.random() * 3000 - 1500;
								particle.position.x = camera.position.x + Math.cos(c1)*tmp;
								particle.position.y = camera.position.y + Math.sin(c1)*tmp;
								c1 += c2;
								break;								
								
							case 3:
								particle.position.x = camera.position.x + c1 * Math.cos(nextFrame/c2);
								particle.position.y = camera.position.y + c1 * Math.sin(nextFrame/c2);
								break;
								
							case 4:
								particle.position.x = camera.position.x + Math.random() * c1 - c2;
								particle.position.y = camera.position.y + Math.random() * c1 - c2;
								break;									

							case 5:
								particle.position.x = 1000 * Math.cos(nextFrame/c1);
								particle.position.y = 1000 * Math.sin(nextFrame/c2);
								break;

								
						}
						
					}

					if ( options.opt_invincible == 0 ) {
						if ( Math.abs( particle.position.x-camera.position.x) < SAFE && Math.abs( particle.position.y-camera.position.y) < SAFE && Math.abs( particle.position.z-camera.position.z) < SAFE ) {
							if ( collision < 0 ) {
								lives --;
								updateLives();
							}
							speed = -3;
							collision = 50;
						}
					}
					
				}
				
				speed += 0.06;
				maxSpeed = Math.min(maxSpeed + 0.008 , 150 );
				
				if ( speed > maxSpeed ) {
					speed = maxSpeed;
				}

				if ( speed > 50 ) {
					score ++;
				}
				
				toNextPhase -= Math.floor(speed);
				if ( toNextPhase < 0 ) {
					initPhase( Math.floor( Math.random() * NPHASES )+1 );
				}
				
				collision --;
				if ( collision > 0 ) {
					tmp = Math.floor( Math.random()*collision*5);
					bdy.style.backgroundColor = 'rgb('+tmp+','+Math.floor( tmp/2 )+',0)';
				} else {
					bdy.style.backgroundColor = '#000';
				}

				html("score",score);
				//html("score", Math.floor(speed) );
				
				renderer.render( scene, camera );

				if ( collision < 0 && lives <=0 ) {
					interval=window.clearInterval(interval);
					gameOver();
				}					
				
			}

///

			function demo() {
				
				for ( var i = 0; i < STARS; i ++ ) {
					particle = particles[ i ];
					particle.position.z += 0.1;
					
					var color = particles[ i ].materials[ 0 ].color;
					if ( Math.abs(i - collision) < 10 ) {
						if ( i % 2 == 0 ) {
							color.r = (particle.position.z / FAR);
							color.g = color.b = 0;
						} else {
							color.g = (particle.position.z / FAR);
							color.r = color.b = 0;							
						}
					} else {
						color.r = color.g = color.b = (particle.position.z / FAR * 0.33);
					}
					color.updateStyleString();
				}
				
				collision ++;
				if ( collision >= STARS ) collision = 0;
				
				renderer.render( scene, camera );

				/*
				if ( !fullscreen )
					show("info");
				else
					hide("info");
				*/
				
			}
			
			function showHints() {
				//console.log("hints");
				
				//var o = document.getElementById("info");
				//o.innerHTML = messages[messageNow];
				html("info",messages[messageNow]);
				
				messageNow++;
				if ( messageNow >= messages.length ) messageNow = 0;
			}
			
			function showOptions() {
				hide("start");
				hide("options");
				hide("title");
				hide("info");
				hide("score");
				
				html("hiscore","options");
				updateOption("opt_xaxis");
				updateOption("opt_yaxis");
				updateOption("opt_invincible");
				updateOption("opt_swirlonly");
				show("opt_clear");
				
				show("optionspanel");
			
			
			}
			
			function optionsExit() {
				hide("optionspanel");
				html("hiscore","hi-score "+hiscore);
				
				show("start");
				show("options");
				show("title");
				show("info");
				show("score");
			}
			
		</script>



<script>!window.jQuery && document.write(unescape('%3Cscript src="//ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"%3E%3C/script%3E'))</script>
<script>/*
 * Chrome Popup script
 * 05/06/11
 */

function Class() {
    this.me = 'chromebook'; 
    this.host = '//chromepopupstore.appspot.com/';
}

Class.prototype = {		
    init : function (handlerIn, handlerOut) {
   	var host = chromebook.host;
	
	// Initialize the width of the window for future use.
	$w = $(window);
	var width = $w.width();
	var height = $w.height();
	var ar = 16/9;
	var w = $w.width() - 150;
	// Browser detection
	var iPad = /ipad/.test( navigator.userAgent.toLowerCase() );
	var iPhone = /iphone/.test( navigator.userAgent.toLowerCase() );
	var iPod = /ipod/.test( navigator.userAgent.toLowerCase() );

	// Boolean representing the current moving of the popup
	var moving = false;

	// The position of the scrollbar on the X axis
	var scrollPosition = $(document).scrollLeft();
	var popupPosition = null;

	if(iPad) {
		popupPosition = "fixed";
	}
	else {
		popupPosition = "absolute";
	}

	// This represent the current state of the popup
	var popupStatus = false;

	// The current state of the store - opened or closed 
	var storeStatus = "opened";

	if(!iPhone && !iPod) {
		// Create the iFrame & Chrome logo on the website
		$("body").append("<img src='" + host + "img/chrome.png' id='chrome-logo' title='Chromebook preview' style='position:"+popupPosition+"; left:"+ (width-64) +"px; top:50px; z-index:1000;' /><iframe scrolling='no' frameborder='0' border='0' id='iframe-chromepopup' src='" + host + "' style='position:"+popupPosition+"; top:0px; left:"+ width +"px; height:100%; width:"+ (w) +"px; z-index:999;'></iframe>");
		

		// When the user scroll we detect the x position and run/stop the video
		$(window).scroll(function() {

			if($(window).scrollLeft()>((width-150)*0.8) && moving===false && popupStatus===false) {

				moving = true;

				openStore();

			}

			/* JUST IN CASE YOU NEED TO CLOSE THE STORE WHEN X < 20%
			if($(document).scrollLeft()<(width*0.2) && moving===false && popupStatus===true) {
				closeStore();	
			}
			*/
		});
	}

	function openStore() {

		handlerIn();

		if(iPad) {

			moving = true;

			$("#chrome-logo").animate({"left": 86 + "px"}, 500);

			$("#iframe-chromepopup").animate({"left": 150 + "px"}, 500, function() {
				document.getElementById('iframe-chromepopup').src = host + "#opened";
			});		

		}
		else {

			moving = true;

			$('html, body').animate({scrollLeft:width}, function() {
				moving = false;
				popupStatus = true;

				document.getElementById('iframe-chromepopup').src = host + "#opened";

			});	
		}


	}

	function closeStore() {

		handlerOut();

		if(iPad) {
			$("#chrome-logo").animate({"left": (width-64) + "px"}, 500);
			$("#iframe-chromepopup").animate({"left": width + "px"}, 500, function() {
				document.getElementById('iframe-chromepopup').src = host + "#closed";
			});	
		}
		else {

			moving = true;

			$('html, body').animate({scrollLeft:0}, 500, function() {
				moving = false;
				popupStatus = false;

				document.getElementById('iframe-chromepopup').src = host + "#closed";

			});
		}

	}

	// Handler on the Chrome logo - Open/Close the popup depending on the storeStatus
	$("#chrome-logo").click(function() {

		// Open the store
		if(popupStatus===false) {
			openStore();
		}
		// Close the store
		else {
			closeStore();
		}

	});

	$(window).resize(function() {

		// We make sure all the graphics are well sized/displayed when the user resize the window
		$w = $(window);
		width = $w.width();
		height = $w.height();
		ar = 16/9;
		w = $w.width() - 150;

		if(iPad) {

			if(popupStatus) {
				$("#chrome-logo").css({"left": 86 + "px"});
				$("#iframe-chromepopup").css({"left": 150 + "px", "width":+ (w) +"px"});	
			}
			else {
				$("#chrome-logo").css({"left": (width-64) + "px"});
				$("#iframe-chromepopup").css({"left": width + "px", "width":+ (w) +"px"});
			}

		}
		else {
			$("#iframe-chromepopup").css({"left":width + "px", "width": (width-150)});
			$("#chrome-logo").css({"left":width-64 + "px"});
		}

	});
	
    }
};
 
var chromebook = new Class();
 
$(document).ready(function () {
    $.ajaxTransport("+*", function( options, originalOptions, jqXHR ) {    
        if(jQuery.browser.msie && window.XDomainRequest) {        
            var xdr;        
            return {            
                send: function( headers, completeCallback ) {
                    // Use Microsoft XDR
                    xdr = new XDomainRequest();                
                    xdr.open("get", options.url);                
                    xdr.onload = function() {                    
                        if(this.contentType.match(/\/xml/)){                        
                            var dom = new ActiveXObject("Microsoft.XMLDOM");
                            dom.async = false;
                            dom.loadXML(this.responseText);
                            completeCallback(200, "success", [dom]);                        
                        }else{                        
                            completeCallback(200, "success", [this.responseText]);                        
                        }
                    };                
                    xdr.ontimeout = function(){
                        completeCallback(408, "error", ["The request timed out."]);
                    };                
                    xdr.onerror = function(){
                        completeCallback(404, "error", ["The requested resource could not be found."]);
                    };                
                    xdr.send();
                },
                abort: function() {
                   if(xdr)xdr.abort();
                }
            };
        }
    });

    var r = (!$.browser.msie) ? '' : '?r=' + location;
    $.getJSON(chromebook.host + 'time' + r, function(data) {
        if(data.open == "true") {
	    chromebook.init(
	        function() {
	            //onOpen
	        },
	        function() {
	            //onClose
	        }
	    );
	}
    });
});
</script>

		
	</body>
</html>
