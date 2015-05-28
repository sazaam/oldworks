// class hasJS
document.documentElement.className+=" hasJS"; 
// shortcut console
log = function (txt) {
	//if(window.console && window.console.firebug) console.log(txt);
	//else {alert(txt)}
}

var manager, layer, loaderFX, news;

/********************************************************************
***														                      	   ***
	3.2.1 GO !				 
***																	         ***	
********************************************************************/
window.addEvent('domready',function(){
	loaderFX = new Fx.Style($('plizWait'), 'opacity', {duration:2000, wait:false, onComplete: function(){}});
	manager = folioManager.initialize();
});
window.addEvent('load',function(){
	if(!loaderFX) loaderFX = new Fx.Style($('plizWait'), 'opacity', {duration:2000, wait:false, onComplete: function(){}});
	loaderFX.start(0)	
	layer = new layerAnimator();
	formErrorManager.init("contactUs", false);
	$('plizWait').addEvent("click", function (){
		loaderFX.start(0)
	})
	if(!manager) manager = folioManager.initialize();
	manager.preloadImg();
	orderIt();
});

/********************************************************************
***														                      	   ***
					Gestion du portfolio
***																	         ***	
********************************************************************/
var folioManager = {
	initialize : function(statut) {
		manager = this;
		if(!statut) this.open = false;
		else this.open = true;
		this.folio = $('folio');
		this.links = $$('#folio a.num');
		this.fake = $('folioFake');
		this.launcher = $('folio_launch');
		this.name = $('mediaName');
		this.desc = $('shortDesc');
		this.Ldesc = $('longDesc');
		this.currentCat = "all";
		// if(window.webkit){
			// $('folioNav').style.left = "642px";
			// $('folioNav').style.top = "147px";
		// }
		
		this.myMorph = new Fx.Styles(this.folio, {duration:500, wait:true, transition:Fx.Transitions.linear, onComplete:function(){
			manager.linkAddBehaviour();
			if (!manager.open){
				manager.desc.style.display = 'block'; 
				manager.Ldesc.style.display = 'none';
				manager.folio.removeClass("opened");
			}
			else {
				manager.Ldesc.style.display = 'block'; 
				manager.desc.style.display = 'none'; 
				manager.folio.addClass("opened");
			
			}
		}});
		
		this.NavMorph = new Fx.Styles($('folioNav'), {duration:300, transition:Fx.Transitions.linear});
		
		this.navInitHeight = $('folioNav').scrollHeight;
		this.currentIndex = 0;
		this.linkAddBehaviour();
		$('folio_launch').onclick = function (e){
			new Event(e).stop();
			if(manager.currentIndex == 0) {
				manager.changeIMG(0);
				manager.links[0].addClass('current');
			}
			manager.toggleFolio();
		};
		
		// btn next 
		$("next").addEvent('click', function(e){
			new Event(e).stop();
			manager.links[manager.currentIndex].removeClass('current');
			manager.currentIndex++;
			if(manager.currentIndex>manager.links.length-1) manager.currentIndex = 0;
			manager.links[manager.currentIndex].addClass('current');
			manager.changeIMG(manager.currentIndex);
			
		});
		// btn previous
		$("previous").addEvent('click', function(e){
			new Event(e).stop();
			manager.links[manager.currentIndex].removeClass('current');
			manager.currentIndex--;
			if(manager.currentIndex<0) manager.currentIndex = manager.links.length-1;
			manager.links[manager.currentIndex].addClass('current');
			manager.changeIMG(manager.currentIndex);
			
		});
		
		// drag & drop
		//$('folioNav').makeDraggable({'handle':$('move'), 'container':$('folio') });
		new Drag.Move($('folioNav'), {'handle': $('move'), 'container': $('folio'), onComplete: function (){
			var l = parseInt($('folioNav').style.left);
			var t = parseInt($('folioNav').style.top);
			if(l>621 && l<663 && t>41 && t<83 || l>600 && l<688 && t<112){
				$('folioNav').style.left = "642px";
				$('folioNav').style.top = "42px";
			}
		} });
		// cat switcher
		this.cats = $$('#folioNav .cat');
		this.cats.each(function(elm,i){
			elm.addEvent('click', function (e){
				new Event(e).stop();
				elm.addClass('ajaxLoading');
				manager.categorieSwitcher(this.title);
			})
		})
		return this;
		
	},
	
	linkAddBehaviour : function (){
		// diff suivant si folio est open ou non
		if(!this.open){
			this.links.each(function(elm, i){
				elm.addEvent("mouseover", function (){
					manager.changeIMG(i);
				})
				elm.addEvent("focus", function (){
					manager.changeIMG(i);
				})
				elm.addEvent("mouseout", function (){
					manager.changeIMG(manager.currentIndex);
				})
				
				elm.addEvent("click", function (e){
					new Event(e).stop();
					manager.links[manager.currentIndex].removeClass('current');
					elm.addClass('current');
					manager.currentIndex = i;
					manager.moveFolio("open");;
				})
			})
		}
		else {
			this.links.each(function(elm, i){
				elm.addEvent("mouseover", function (){
					manager.changeIMG(i);
				})
				elm.addEvent("focus", function (){
					manager.changeIMG(i);
				})
				elm.addEvent("mouseout", function (){
					manager.changeIMG(manager.currentIndex);
				})
				elm.addEvent("click", function (e){
					new Event(e).stop();
					//$('folio').setText("launch Folio");
					manager.links[manager.currentIndex].removeClass('current');
					elm.addClass('current');
					manager.currentIndex = i;
				})
			})
		}
		
	},
	
	linkResetBehaviour : function (){
		this.links.each(function(elm, i){
			elm.removeEvents();
		})
	},
	// modifie l'image appelle directement ou via toggleFolio
	changeIMG : function(index){
		if(!index && index!=0 || index == "noBG"){
			manager.folio.style.backgroundImage = 'none';
			manager.name.setText("");
			manager.desc.setText("");
			manager.Ldesc.setText("");
			return;
		}
		if(manager.links[index]){
			manager.folio.style.background = '#1A1A1A url('+manager.links[index].href+') no-repeat 50% 50%';
			manager.name.setText(manager.links[index].getAttribute('name'));
			manager.desc.setText(manager.links[index].getAttribute('title'));
			manager.Ldesc.setText(manager.links[index].getAttribute('longdesc'));
		}
		},
	// dispatch
	toggleFolio: function (){
		// on annulle les events
		manager.linkResetBehaviour();	
		// ouvre/ferme
		this.open ? this.moveFolio("close") : this.moveFolio("open");
		
		if(manager.currentCat != "all") manager.categorieSwitcher('all', true);
		// flag
	},
	// methode d'anim
	moveFolio : function (arg){
		switch (arg){
			case "open":
				setTimeout(function(){$('contactPress').addClass("hidden");},1000);
				this.myMorph.start({
					'top': 53,
					'height': 580
				});
				this.NavMorph.start({
					'top': 42,
					'height': manager.navInitHeight,
					'left': 642
				});
				manager.open = true;
				break;
			case "close":
				this.myMorph.start({
					'top': 189,
					'height': 440	
					});
				this.NavMorph.start({
					'top': 386,
					'height': 0,
					'left': 642
				});
				manager.open = false;
				break;
		}
		
	},
	
	categorieSwitcher : function (cat, keepImg){
		manager.currentCat = cat;
		myXHR = new XHR({method: 'get', autoCancel: true, onSuccess:function(){
			manager.cats.each(function(elm,i){
				elm.removeClass('ajaxLoading');
			})
			if(myXHR.response) $('number').setHTML(myXHR.response.text);
			if(!keepImg) {
				manager.currentIndex = 0;
				manager.links = $$('#folio a.num');
				manager.linkResetBehaviour();
				manager.changeIMG(0);
				manager.links[0].addClass('current');
			}
			else {
				manager.links = $$('#folio a.num');
				manager.linkResetBehaviour();
			}
			manager.linkAddBehaviour();
			manager.preloadImg();
		}}).send('../php/req_folio.php?cat='+cat);
	},
	
	// prechargement des images
	preloadImg : function (){
				
		this.preload = new Preloader({array: this.links, callback: function (index, src, wasCached, gotError){
			manager.links[index].removeClass('hidden');
		}, noCache:false, isProgressive:true});
	},
	
	
	
	build: function  (index){
		//log("b="+index)
		this.links[index].removeClass('loader2');
		//log(index+1)
		var a = index+1;
		if(a < this.imgTAB.length) this.preloadProgressive(a);
	},
		
	preloadProgressive : function (i){
		
	}
};

/********************************************************************
***														                      	   ***
					Gestion des pages interieures
***																	         ***	
********************************************************************/

var layerAnimator = new Class({
	initialize : function() {
		this.open = false;
		this.layer = $('layer');
		this.as = $$("a.lay");
		this.frame = $("layerFrame");
		this.btn = $('layerBtn');
		this.btn2 = $('correspondBtn');
		this.section = $$('#layer .section');
		this.sectionDepths = 51;
		// evt
		this.btn.addEvent('click', function(){
			layer.animateLayer('close');
		})
		// gestion particuliere du layer contacts
		this.so = new SWFObject("../swf/contacts.swf", "contacts", "800", "500", "9", "#000");
		this.so.addParam('wmode','transparent');
		//
		this.fx = new Fx.Styles(this.layer, {duration:650, wait:false, transition:Fx.Transitions.Expo.easeOut, unit:'%', onStart:function(){}, onComplete:function(){}});
		this.animateLayer('close');
		this.as.each(function(elm, i){
			elm.addEvent('click', function(e){
				new Event(e).stop();
				manager.moveFolio('close');
				//layer.changeSrc();
				layer.changeSrc(this.href);
				//$('contactPress').addClass('hidden');
			});
		});
		// gestion de presse
		if($("connexPress")){
			var press = $('contactPress');
			this.pressFX = new Fx.Style($('connexPress'), 'margin-right', {duration:1000, wait:false, transition:Fx.Transitions.Elastic.easeOut, onStart:function(){}, onComplete:function(){}});
			$('pressBtn').addEvent("click", function (e){
				new Event(e).stop();
				if(readCookie("pressAccess") == "1"){document.location.href = "/v2/press.php";return;}
				
				if(press.hasClass("hidden")){
					manager.moveFolio('close');
					if(layer.open)layer.animateLayer('close');
					setTimeout(function(){
						press.removeClass('hidden');
						$('connexPress').setStyle("margin-right", 500)
						layer.pressFX.start(500, 0);
						//log("laying")
					}, 200);
				}
				else {
					press.addClass('hidden');				
				};	
			})
			$("connexPress").addEvent('submit', function (e){
				new Event(e).stop();
				$$('#connexPress .error')[0].innerHTML = "";
				var QS = this.toQueryString();
				var ajaxCheck = new XHR({method: 'post', onSuccess:function(){
					var fb = eval(ajaxCheck.response.text);
					if(fb) {
						$$('#connexPress .error')[0].innerHTML = "Welcome";
						createCookie("pressAccess","1", "1000");
						document.location.href = "/v2/press.php";
					}
					else {
						$$('#connexPress .error')[0].innerHTML = "Wrong Password";
					}
				}}).send(this.action, QS);
			});
		}
		// 
		if($("contactBtn")) this.initForm();
		
	},
	
	changeSrc : function (id){
		//log(id)
		id = id.substr(id.indexOf("#")+1, id.length);
		this.currentSrc = $(id);
		//if(this.activeSection == this.currentSrc && this.open) return;
		this.sectionFX = new Fx.Style(this.currentSrc, 'width', {wait:false, unit:'%', duration:300});
		if(!layer.open){
			layer.currentSrc.setStyle('zIndex', layer.sectionDepths );
			layer.animateLayer('open');
		}else{
			setTimeout(function(){
				layer.currentSrc.setStyle('zIndex', layer.sectionDepths );
				layer.currentSrc.setStyle('width', '20%');
				layer.sectionFX.start(20,100);
			}, 200);
		}
		this.sectionDepths ++;
		this.activeSection = this.currentSrc;

		
		// if(id == 'contacts'){setTimeout(function (){layer.so.write("flashContact");}, 1000);}
		// if(this.currentSrc == $('contacts')){$('flashContact').empty();}
		//this.currentSrc.setStyle('opacity', 0 );
		//this.sectionFX.start(1);
	},
	
	animateLayer : function (arg){
		switch (arg){
			case "open":
				setTimeout(function(){$('contactPress').addClass("hidden");},1000);
				this.fx.start({
					left: 0,
					width: 100
				})
				this.open = true;
				break;
			case "close":
				this.fx.start({
					left: 0,
					width:0
				})
				this.open = false;
				break;
		}
		
	}
});


/********************************************************************
***														                      	   ***
					Gestion des cookies 
***																	         ***	
********************************************************************/

// var Cookie = {
	
	//CREE UN COOKIE DE NOM name de VALUE value et de DUREE days 
	// create: function (name,value,days){
	// if (days) {
		// var date = new Date();
		// date.setTime(date.getTime()+(days*24*60*60*1000));
		// var expires = "; expires="+date.toGMTString();
	// }
	// else var expires = "";
	// document.cookie = name+"="+value+expires+"; path=/";
	// },
	// LIT le cookie name
	// read: function (name){
		// var nameEQ = name + "=";
		// var ca = document.cookie.split(';');
		// for(var i=0;i < ca.length;i++) {
			// var c = ca[i];
			// while (c.charAt(0)==' ') c = c.substring(1,c.length);
			// if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
		// }
		// return null;
	// },
	// ECRASE un cookie
	// erase: function(name){
		// Cookie.create(name,"",-1);
	// }
	// ECRASE tout les cookies
	//eradiquate: function (){
	//
	//}
// }

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name,"",-1);
}



/********************************************************************
***														                      	   ***
					SUBSCRIBE 
***																	         ***	
********************************************************************/
var to= false;
function subscribeManager(a, type){
	if(to) clearTimeout(to);
	$("unsubscribe").style.textDecoration = "none";
	$("subscribe").style.textDecoration = "none";
	a.style.textDecoration = "underline";
	$('email_field').value = '';
	$('news_input').style.display = "block";
	$('email_field').removeEvents();
	$('email_field').addEvent('blur', function (){
		if ($('email_field').value == ""){
			to = setTimeout(function(){	$('news_input').style.display = "none";$("unsubscribe").style.textDecoration = "none";$("subscribe").style.textDecoration = "none";	},1000);
			return;
		}
		to = setTimeout(function(){	$('news_input').style.display = "none";$("unsubscribe").style.textDecoration = "none";$("subscribe").style.textDecoration = "none";	},3000);
		myXHR = new XHR({method: 'get', autoCancel: true, onSuccess:function(){
			$('email_field').value = myXHR.response.text;
		}}).send('../php/req_subscribe.php?type='+type+'&email='+$('email_field').value);
	});
	$('email_field').addEvent('focus', function (){
		if(to) clearTimeout(to);
	});
	// 
	
	
}
/********************************************************************
***														                      	   ***
					CONTROLE DE FORMULAIRE
***																	         ***	
********************************************************************/



var formErrorManager = {
	init: function (id, endControl){
		//log(id);
		formControl = this;
		this.form = $(id);
		this.isValid = true;
		this.erroredElm = [];
		this.isValidate = true ;
		this.form.onsubmit = function (e){
			new Event(e).stop();
			var fb = $$('.feedback')[0];
			fb.addClass('ajaxLoading');
			fb.innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
			formControl.checkIt();
			var QS = this.toQueryString();
			if(formControl.isValidate){
				formControl.submit(this, QS);
			}
			else{
				fb.removeClass('ajaxLoading');
				fb.innerHTML = i18n.errorExist;
			}
			
		}
		// tuning
		var mess = $('message');
		mess.addEvent('click', function(){
			this.nexNode = this.nextSibling.nodeType == '3' ? this.nextSibling.nextSibling : this.nextSibling ;
			this.nexNode.innerHTML = "";
			this.style.width = "450px";
			this.style.height = "100px";
			this.style.overflowY = "visible";
		})
		mess.addEvent('blur', function(){
			this.style.width = "250px";
			this.style.height = "";
			this.style.overflow = "hidden";
		})
		//
		if(endControl) {
			for(var i=0, f = this.form.elements; i<f.length;i++){
				if(f[i].nodeName.toLowerCase() != "fieldset"){
					switch(f[i].nodeName.toLowerCase()){
						case "input": 
							if(f[i].type == "checkbox") {
								f[i].value = f[i].checked;
							}
							if(f[i].type == "radio") {
								f[i].value = f[i].checked;
							}
						break;
						case "select":
						case "select-one":
						case "select-multiple":
							f[i].value = f[i].selectedIndex;
						break;
					}
				}
			}
		}
		else {
			for(var i=0, f = this.form.elements; i<f.length;i++){
				//log(f[i].nodeName.toLowerCase())
				if(f[i].nodeName.toLowerCase() != "fieldset"){
					switch(f[i].nodeName.toLowerCase()){
						case "input":
							if(f[i].type == "hidden") {break;}
							if(f[i].type == "checkbox") {
								f[i].value = f[i].checked;
								f[i].onclick = function(){ formControl.checkForm(this)}
							}
							if(f[i].type == "radio") {
								f[i].value = f[i].checked;
								f[i].onclick = function(){ formControl.checkForm(this)}
							}
							if(f[i].type == "text") f[i].onblur = function(){ formControl.checkForm(this)}
						break;
						case "textarea": 
							f[i].onkeyup = function(){ formControl.checkForm(this)}
							f[i].onblur = function(){ formControl.checkForm(this)}
						break;
						case "select-multiple":
						case "select-one":
						case "select":
							// f[i].value = f[i].selectedIndex;
							// log(f[i].value);
							f[i].onchange = function(){ formControl.checkForm(this)}
						break;
					}
				}
			}
		}
	},
	
	checkIt : function (){
			this.isValidate = true;
			for(var i=0, f = this.form.elements; i<f.length;i++){
				if(f[i].nodeName.toLowerCase() != "fieldset" && f[i].type != "hidden" && f[i].type != "reset" && f[i].type != "submit"){
					formControl.checkForm(f[i]);
				}
			}
	},
	
	
	// class: FC_isPhoneR_10  
	checkForm: function(elm){
		if(!elm.nexNode) elm.nexNode = elm.nextSibling.nodeType == '3' ? elm.nextSibling.nextSibling : elm.nextSibling ;
		if(elm.nexNode)elm.nexNode.innerHTML = "";
		var reg = elm.className.match(/(FC_[a-zA-Z]+(_\d+)?\b)/g);
		if(!reg) return;
		for(var i=0;i<reg.length;i++){
			var required = false;
			var control = reg[i].split('_')[1];
			if(control.match(/[a-zA-Z]+R$/) ) {
				var required = true;
				var control = control.substr(0, control.length-1);
			}
			formControl.check(elm, control, reg[i].split('_')[2], required);
		}
	},
	
	check: function (elm, control, val, required){
		if(required && (elm.value == "" || elm.value == false || elm.value == 0)) {
			formControl.errorManager(elm, i18n.mandatory);
			return;
		}
		switch(control){
			case "isAlpha": 
				if(!elm.value.match(/^[a-zA-Z ']+$/)){ formControl.errorManager(elm, i18n.alphaError);}
				else if(val && elm.value.length > val) {
					formControl.errorManager(elm, i18n.maxChar, val);
					elm.value = elm.value.substr(0, val);
				}
			break;
			case "isNumeric":
				if(!elm.value.match(/^\d+$/)) formControl.errorManager(elm, i18n.numberError);
				else if(val && elm.value.length != val) formControl.errorManager(elm, i18n.numberErrorVal, val);
			break;
			case "isAlphaNumeric": 
			case "isRequired":
				if(elm.value == "") formControl.errorManager(elm, i18n.mandatory);
			break;
			case "isEmail":
				if(!elm.value.match(/^[a-z0-9+._-]+@[a-z0-9.-]{2,}[.][a-z]{2,6}$/)) formControl.errorManager(elm, i18n.unvalidMail);
			break;
			case "isPhone":
				var flag = val || 10;
				var tel = elm.value
				//if(tel.replace(/+ ?[0-9]{2} ?/)) 
				//log("tel="+tel);
				tel = tel.replace(/[\s\b]/g, "");
				//log("tel="+tel);
				tel = tel.replace(/[a-zA-Z ]/g, "");
				//log("tel="+tel);
				elm.value = tel;
				if(tel[0] == "+") 	tel = tel.substr(3);
				//log("tel="+tel);
				var re = new RegExp('[0-9]{'+flag+'}$', 'g');
				if(!tel.match(re) && !tel.match(/^\d+$/)) formControl.errorManager(elm, i18n.phoneErrorVal, val);
			break;
			case "maxLength": 
				if(elm.value.length > val) formControl.errorManager(elm, i18n.maxLength);
				elm.value = elm.value.substr(0, val);
			break;
			case "isFile": break; 
			case "isChecked": 
				if(!elm.checked) formControl.errorManager(elm, i18n.noChecked);
			break; 
		}
	},
	
	errorManager : function (elm, msg, val){
		if(val) msg = msg.replace(/##/, val);
		this.isValidate = false;
		elm.nexNode.innerHTML += ' '+'<img src="../	css/skin/pictos/tick.png" alt="" />'+msg;
	},
	
	submit: function (elm, QS){
		mySubmiter = new XHR({method: elm.method, autoCancel: true, onSuccess:function(){
			var feedback = mySubmiter.response.text;
			var fb = elm.getElement('.feedback');
			fb.removeClass('ajaxLoading');
			fb.innerHTML = feedback;
			}}).send(elm.action, QS);
	}
	
	
}

/**
	Preloader : class

	objectif: contrôler le chargement d'une serie d'img grace a un array d'url
	
	declaration :
			var tab = ['img.jpg", "img.gif", "img.png"]			
			var loader = 
				new Preloader({array: tab, callback: function (index, src, wasCached, gotError){
					if(!gotError){
						var div = document.createElement("div");
						div.style.backgroundImage = "url("+src+")";
						document.getElementById('monConteneur').appendChild(div)
					}
			}, noCache:true, isProgressive:true});
		
	modes: 
		progressif: charge les imgs une à une dans l'ordre de l'array, chaque img apparait dans l'ordre de l'array
		direct: lance un chargement simultanee, donc le onload de chaque image depend de son poids et de sa place dans l'array
		progressif par bloc: effectue un chargement direct mais en decoupant l'array en bloc de chargement (ie 5 imgs par 5 imgs)
	
	@params:
		array:Array
			array contenant les urls a telecharger sous forme de String
		
		callback:Function
			fonction executee sur le onComplete de chaque image
			recoit en parametre : 
				index, position de l'image dans le param array
				src, url de l'image telechargee
				wasCached, boolean à true si l'image etait dejà dans le cache  !!! PAS SUR AVEC IE !!!
				gotError, boolean à true, si le chargement à rencontrer une erreur
	
	@options : 
			isProgressive : bool || int
				si true, declenche le mode progressif
				si false, declenche le mode direct (defaut)
				si int, declenche le mode progressif par bloc de int images
				
			noCache: bool
				si true, les images ne sont pas lues dans le cache (ajout d'un timestamp en fin d'url)
				si false, comportement de chargement classique (defaut)
				
	BUG:
		safari et ie reagissent bizarrement à la reexecution du code
	**/
	
	
	
	
	var Preloader = function() { 
		this.initialize.apply(this, arguments);
	};
	Preloader.prototype = {
		options : {
			isProgressive: false,
			noCache: false
		},
		
		constructor : Preloader,
		
		initialize : function(options) {
			this.isIE = /MSIE /.test(navigator.userAgent);
			this.setOptions(options);
			this.array = this.options.array;
			this.loaded = 0;
			// detection du mode
			if(!isNaN(parseInt(this.options.isProgressive))){
				this.byBlock = this.options.isProgressive;
				this.preloadBy(0, this.options.isProgressive);
			}
			else if(this.options.isProgressive){this.preloadProgressive(0);}
			else {this.preload();}
		},
		
		create_img: function (i){
			var img = new Image();
			img.alt = "";
			img.style.top = "-10000px";
			img.style.position = "absolute";
			img.setAttribute('index', i);
			// ie necessite que l'image soit dans le DOM pour le onreadystatechange
			var node = document.body.appendChild(img);
			return node;
		},
		
		preloadProgressive: function (i){
			if(i >= this.array.length){ return this.onComplete();}
			this.timestamp = this.options.noCache ? "?"+new Date().getTime() : "";
			this._IMG = this.create_img(i);
			this.loadAndListen(this._IMG, this.array[i]+this.timestamp, true)
		},
		
		preload: function (){
			this.timestamp = this.options.noCache ? "?"+new Date().getTime() : "";
			for(var i=0,arr=this.array,node;i<arr.length;i++){
				node =  this.create_img(i);
				this.loadAndListen(node, this.array[i]+this.timestamp, false);
			}
		},
		
		preloadBy: function (from, to){
			this.timestamp = this.options.noCache ? "?"+new Date().getTime() : "";
			this.currentFrom = from;
			this.currentTo = to;
			for(var i=from,node;i<to;i++){
				node =  this.create_img(i);
				this.loadAndListen(node, this.array[i]+this.timestamp, false);
			}
		},
			
		loadAndListen: function (elm, src, progressive){
			// si l'image est corrompu ou absente du serveur
			elm.onerror =  function(obj){
					return function (e){
					this.onload = function(){}
					var index = this.getAttribute('index');
					obj.options.callback(index, this.src, false, true);
					try {document.body.removeChild(elm)} catch(e) {}
					if(progressive){ obj.preloadProgressive(index*1+1);}
					else {obj.checkFinish(index)}
				}
			}(this);
			// ie onload et onComplete
			if(this.isIE){
				elm.attachEvent("onreadystatechange", function(obj){
					return function (e){
						//for(var a in e) log(a+" = "+e[a])
						if (!e) { e = window.event;}
						var target = e.srcElement;
						if(target.readyState == "complete"){
							target.onload = function(){}
							var index = target.getAttribute('index');
							obj.options.callback(index, target.src, false, false);
							try {document.body.removeChild(elm)} catch(e) {}
							if(progressive) obj.preloadProgressive(index*1+1);
							else {obj.checkFinish(index)}
						}
					}
				}(this));
			
			}
			// w3c onload
			else {
				elm.onload = function(obj){
					return function (e){
						var index = this.getAttribute('index');
						if(this.naturalWidth == 0){ obj.options.callback(index, this.src, false, true);}
						else { obj.options.callback(index, this.src, false, false);}
						try {document.body.removeChild(elm)} catch(e) {}
						if(progressive) { obj.preloadProgressive(index*1+1);}
						else {obj.checkFinish(index)}
					}
				}(this);
			}
			// src
			elm.src = src;
			// w3c complete
			if(elm.complete){ 
				elm.onload = elm.onerror = function (){}
				var index = elm.getAttribute('index');
				if(elm.naturalWidth == 0 || elm.offsetWidth <2 ) { this.options.callback(index, elm.src, false, true);}
				else {this.options.callback(index, elm.src, true, false);}
				try {document.body.removeChild(elm)} catch(e) {}
				if(index>=this.array.length-1) return;
				if(progressive){ this.preloadProgressive(index*1+1);}
				else {this.checkFinish(index)}
			}
		},
		
		checkFinish: function(index){
			this.loaded++;
			if(this.byBlock){
				if(this.loaded == this.array.length){
					this.onComplete();
				}
				else if(this.loaded > 1 && this.loaded%this.byBlock==0) {
					var newFrom = this.currentTo;
					var newTo = this.currentTo + this.byBlock > this.array.length ? this.array.length : this.currentTo + this.byBlock ;
					// demo
					var div = document.createElement("div");
					div.style.clear = "both";
					document.getElementById('ctn').appendChild(div);
					//
					this.preloadBy(newFrom, newTo);
				}
			}
			else if(this.loaded==this.array.length-1){ this.onComplete();}
		},
		
		
		onComplete: function (){
			//alert("load complete !");
		},
		
		setOptions : function(options) {
			if (!options){return;}
			var savedOpt = this.options;
			this.options = {};
			for (var i in savedOpt){ this.options[i] = savedOpt[i];}
			for (var i in options){ this.options[i] = options[i];}
		}
		
	}