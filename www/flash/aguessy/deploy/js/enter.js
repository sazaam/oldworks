function popItup(url, popname) {
	var w = 950 ;
	var h = 650 ;
	var l =(screen.width-w)/2;
	var t =(screen.height-h)/2;
	document.location.href = url ;
	//window.open(url || "static-popup.html",popname || "_blank","top="+t+",left="+l+",width="+w+",height="+h+",toolbar=no,menubar=no,scrollbars=no,resizable=no,directories=no,status=no");
}