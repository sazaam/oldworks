//swfobject.embedSWF("test_filterTween.swf", "flashInside", "100%", "100%", "9.0.45", "expressInstall.swf");

function cl(msg)
{
	if(window.console && window.console.firebug) console.info(msg)
	else alert(msg)
}

function resizeDivStage()
{
var win = window ;
var diff = 0 ;
var h = win.innerHeight-diff ;
var w = win.innerWidth ;
var flInside = document.body ;
//if(h > 600){
	flInside.style.height = h + "px" ;
//}
//if(w > 1000){
	flInside.style.width = win.innerWidth + "px" ;
//}
}

window.onload = function()
{
	initialize() ;	
}

function initialize()
{
	resizeDivStage() ;
		window.onresize = function(e){
		resizeDivStage() ;
	} ;
	testMouseRightClick() ;
}


function testMouseRightClick()
{
	//alert(document.documentElement)
	//document.body.onclick = function(){
		//alert("YO")
		//}
}