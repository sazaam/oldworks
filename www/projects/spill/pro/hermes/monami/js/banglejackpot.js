
/**
 * @author saz
 */


var Jackpot = NS('Jackpot', NS(Class.$extend({
	__classvars__:{
		ns:'spill::Jackpot',
		toString:function(){
			return '[class '+this.ns+']' ;
		}
	},
	__init__:function(id, launchbtn, backgroundid, patternsclass, backgroundsclass, legendid){
		// JACKPOT SYSTEM
		this.initJackpot(id, launchbtn, backgroundid, patternsclass, backgroundsclass, legendid) ;
		return this ;
	},
	initJackpot : function(id, launchbtn, backgroundid, patternsclass, backgroundsclass, legendid){
		// MAIN TARGET
		var tg = this.tg = $(id) ;
		// LAUNCH BUTTON
		var launch = this.launch = $(launchbtn) ;
		// 4 VISUALS DIVS CORRESPONDING TO SPRITES
		var visual = $(backgroundid) ;
		var divs = $(patternsclass) ;
		var visuals = $(backgroundsclass) ;
		var legend = $(legendid) ;
		// PATTERNS ARRAYS
		var patterns = [] ;
		divs.each(function(i, el){
			patterns[patterns.length] =  $(el).children('img').map(function(){
				return this ;
			}).toArray() ;
		})
		
		// CONTROLS VARIABLES
		var patternIndex = 0 ;
		var randomIndex = -1 ;
		
		
		
		// RANDOMIZE FUNCTION
		function randomize(){
        	randomIndex = patternIndex ;
        	while(randomIndex == patternIndex){
        		randomIndex = parseInt(Math.random() * (patterns.length)) ;
        	}
        } ;
        randomize() ;
		// DISPLAY VARIABLES
		
		// CANVAS ELEMENT TO DRAW TEXTURES
		var screenshooter = document.createElement('canvas') ;
		var ctx = screenshooter.getContext('2d') ;
		
		// INVERTING TEXTURES
		function drawImage(img, inverted){
			var w = 415 ;
			screenshooter.setAttribute('width', w ) ;
			screenshooter.setAttribute('height', w ) ;
			ctx.save()
			if(!!inverted){
				ctx.translate(w, w) ;
				ctx.rotate(Math.PI) ;
				
			}
			ctx.drawImage(img,0,0);
		    ctx.beginPath();
		    ctx.lineTo(w,0);
		    ctx.lineTo(w,w);
		    ctx.lineTo(0,w);
		    ctx.restore() ;
			return screenshooter.toDataURL() ;
		}
		// RETRIEVING TEXTURES
		function getTexture(img, inverted){
			return THREE.ImageUtils.loadTexture( drawImage(img, inverted) ) ;
		}
		
		
		// CORE THREE VIEWPORT 
		var container, camera, scene, renderer, canvas, cubes, materials;
        var __w, __h, __midW, __midH ;
        var total = 4 ;
        
        function setCoords(){
        	__w = tg.width() ;
        	__h = tg.height();
			__midW = __w >> 1 ;
			__midW = __h >> 1 ;
        } ;
        setCoords() ;
        
        
        function fillLegend(first){
        	var nav = $(divs[first === undefined ? randomIndex : patternIndex]).children('ul').clone() ;
        	var cqNav = new CommandQueue() ;
        	if(first === undefined){
        		cqNav.add(new Command(null, function(){
	    			legend.children('ul').remove() ;
	    		})) ;
        	}
        	cqNav.add(new Command(null, function(){
    			legend.append(nav) ;
    		})) ;
        	cqNav.execute() ;
        }
        
        fillLegend(true) ;
        // RESIZE HANDLING
        $(window).bind({
        	resize:function(e){
        		e.preventDefault() ;
        		
        		_.debounce(function(e){
        			if(canvas) canvas.remove() ;
					setCoords() ;
					//
					
					camera = new THREE.Camera( 80, __w / __h, 1, 1000 );
			        camera.position.y = 150;
			        camera.position.z = 500;
			        camera.target.position.y = 150;
			        
					// SCENE REQUIRED
			        scene = new THREE.Scene();
			        
			        // CUBES GENERATION
					
			        
			        cubes = [] ;
			        materials = [] ;

					var oldTextures = patterns[patternIndex] ;
					var newTextures = patterns[randomIndex] ;
			        var itemW = 200 ;
			        
			        for(var i = 0; i < total; i ++){
			        	
			        	var mat = materials[materials.length] = [
			            	[ new THREE.MeshBasicMaterial( { color : 0xCCCCCC } ) ], // right
			            	[ new THREE.MeshBasicMaterial( { color : 0xCCCCCC } ) ], // left
			            	[ new THREE.MeshBasicMaterial( { color : 0xCCCCCC } ) ], // top
			            	[ new THREE.MeshBasicMaterial( { color : 0xCCCCCC } ) ], // bottom
			            	[ new THREE.MeshBasicMaterial( { map : getTexture(oldTextures[i]) } ) ], // front
			            	[ new THREE.MeshBasicMaterial( { map : getTexture(newTextures[i], true) } ) ]  // back
			            ] ;
			        	
			        	
			        	var cube = cubes[cubes.length] = new THREE.Mesh( new THREE.CubeGeometry( itemW, 200, 200, 1, 1, 1, mat ), new THREE.MeshFaceMaterial() );
				        cube.position.y = 150;
				        cube.position.x = -(itemW*1.5) + (i*itemW) ;
				        cube.overdraw = true;
				        scene.addObject( cube );
			        } ;
					
			        renderer = new THREE.CanvasRenderer();
					renderer.setSize( __w, __h ) ;
					renderer.render( scene, camera ) ;
					renderer.domElement.setAttribute('id', 'viewport');
					renderer.domElement.setAttribute('class', 'viewport');
					
					
					canvas = $(renderer.domElement) ;
					canvas.css({'opacity':0}) ;
					tg.append( canvas );
					
					
				}, 150)(e);
        	}
        })
        $(window).trigger('resize') ;
		
		
        
		
        var uid = -1;
        var camerapos = 300 ;
        var commands = [] ;
        
        
        commands[commands.length] = 
    	new CommandQueue([
			new Command(null, function(){
				
				canvas.animate({'opacity':1}, 250) ;
				visual.animate({'opacity':0}, 250, function(){
					fillLegend() ;
				}) ;
				
				var command = this ;
				var c = camera ;
				var position = {z: c.position.z};
				var r = $(position) ;
				var rz = position.z ;
				
				r.animate({z: position.z + camerapos}, {
        			duration:500,
        			step:function(now){
        				c.position.z = now ;
        			},
        			complete:function(){
        				command.dispatchComplete() ;
        			}
        		}) ;
	        		
				return this ;
			}), new WaitCommand(0)
		]);
		
		
        for(var i = 0 ; i < total ; i++){
		    commands[commands.length] = 
			new CommandQueue([
				new Command(null, function(ind){
					var command = this ;
					var c = cubes[ind] ;
					var rotation = {x: c.rotation.x, rolling:true};
					var r = $(rotation) ;
					var rx = rotation.x ;
					r.animate({x: rotation.x + Math.PI}, {
	        			duration:500,
	        			step:function(now){
	        				if(now - rx >= Math.PI/(total - ind)) {
	        					
	        					if(rotation.rolling === true) {
	        						rotation.rolling = false ;
	        						command.dispatchComplete() ;
	        					}
	        				}
	        				c.rotation.x = now ;
	        			},
	        			complete:function(){
	        				rotation.rolling = true ;
	        			}
	        		}) ;
					return this ;
				}, i),new WaitCommand(0)
			]) ;
		};
		
		commands[commands.length] = new CommandQueue([
			new Command(null, function(){
				
				var command = this ;
				var c = camera ;
				var position = {z: c.position.z};
				var r = $(position) ;
				var rz = position.z ;
				
				r.animate({z: position.z - camerapos}, {
        			duration:500,
        			step:function(now){
        				c.position.z = now ;
        			},
        			complete:function(){
        				command.dispatchComplete() ;
        				canvas.animate({'opacity':0}, 250) ;
        			}
        		}) ;
	        	
				var newTextures = patterns[randomIndex] ;
				visuals.each(function(i, el){
					
					$(el).css({'background-image':'url('+ newTextures[i].getAttribute('src') +')'})
					
				})
				
				
				return this ;
			}), new WaitCommand(200), 
			new Command(null, function(){
				var command = this ;
	        	visual.animate({'opacity':1}, 250, function(){
	        		command.dispatchComplete() ;
	        		
	        		
	        	}) ;
	        	return this ;
			})
		]) ;
		
		var cq = new CommandQueue(commands) ;
		
         // CLICK ON LAUNCH
        launch.bind({
        	click:function(e){
        		e.preventDefault() ;
        		
        		if(uid !== -1) return ;
        		
        		uid = setInterval(animate, 0) ;
        		cq.execute() ;
        		
        		cq.addEventListener('$', function(){
    				cq.removeEventListener('$',arguments.callee) ;
        			cq.reset() ;
        			clearInterval(uid) ;
        			uid = -1 ;
        			
        			// randomIndex to define....
        			patternIndex = randomIndex ;
        			setTimeout(function(){
        				randomize() ;
        				$(window).trigger('resize') ;
        			}, 10) ;
        		})
        	}
        });
        
        // ANIMATE & RENDER
        function animate() {
            render();
        }
		
        function render() {
            renderer.render( scene, camera );
        }
	},
	toString : function(){
		return '[ object ' + this.$class.ns +']';
	}
}))) ;



























