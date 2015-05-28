var TestCubesShading = NS('TestCubesShading', NS('test::TestCubesShading', Class.$extend({
	__classvars__ : {
		version:'0.0.1',
		toString:function(){
			return '[class TestCubesShading]' ;
		}
	},
	__init__ : function(id, launchBtn) {
		var tg = this.tg = $(id) ;
		var launch = this.launch = $(launchBtn) ;
		
		// CORE THREE VIEWPORT 
		var container, camera, scene, renderer, canvas, cubes, materials = [];
        var __w, __h, __midW, __midH ;
        var total = 4 ;
        
		/*
		 var mat = materials[materials.length] = [
			[ new THREE.MeshBasicMaterial( { color : 0x888888 } ) ], // right
			[ new THREE.MeshBasicMaterial( { color : 0x888888 } ) ], // left
			[ new THREE.MeshBasicMaterial( { color : 0x888888 } ) ], // top
			[ new THREE.MeshBasicMaterial( { color : 0x888888 } ) ], // bottom
			[ new THREE.MeshBasicMaterial( { color : 0xFF6600 } ) ], // front
			[ new THREE.MeshBasicMaterial( { color : 0xFF6600 } ) ]  // back
		] ; 
		*/
		var mat = materials[materials.length] = [
			[  new THREE.MeshLambertMaterial( {opacity:1, shading:THREE.SmoothShading, color:0xFF6600 }) ], // right
			[  new THREE.MeshLambertMaterial( {opacity:1, shading:THREE.SmoothShading, color:0xFF6600 }) ], // left
			[  new THREE.MeshLambertMaterial( {opacity:1, shading:THREE.SmoothShading, color:0xFF6600 }) ], // top
			[  new THREE.MeshLambertMaterial( {opacity:1, shading:THREE.SmoothShading, color:0xFF6600 }) ], // bottom
			[  new THREE.MeshLambertMaterial( {opacity:1, shading:THREE.SmoothShading, color:0xFF6600 }) ], // front
			[  new THREE.MeshLambertMaterial( {opacity:.5, shading:THREE.SmoothShading, color:0xFF6600 }) ]  // back
		] ; 
		
		
		/*
		var mat = [
			[ new THREE.MeshDepthMaterial( { near: 1, far: 2000 } ) ], // right
			[ new THREE.MeshDepthMaterial( { near: 1, far: 2000 } ) ], // left
			[ new THREE.MeshDepthMaterial( { near: 1, far: 2000 } ) ], // top
			[ new THREE.MeshDepthMaterial( { near: 1, far: 2000 } ) ], // bottom
			[ new THREE.MeshDepthMaterial( { near: 1, far: 2000 } ) ], // front
			[ new THREE.MeshDepthMaterial( { near: 1, far: 2000 } ) ]  // back
		] ; 
		
		*/
		// var material = new THREE.MeshFaceMaterial({shading:THREE.FlatShading}) ;
		var material = new THREE.MeshLambertMaterial( {opacity:.8, shading:THREE.FlatShading, color:0xd4d0c8 }) ;
		var directionalLight ;
		
        function setCoords(){
        	__w = tg.width() ;
        	__h = tg.height();
			__midW = __w >> 1 ;
			__midW = __h >> 1 ;
        } ;
        setCoords() ;
        $(window).bind({
        	resize:function(e){
        		e.preventDefault() ;
        		
        		_.debounce(function(e){
        			if(canvas) canvas.remove() ;
					setCoords() ;
					
					
					camera = new THREE.Camera( 80, __w / __h, 1, 1000 );
			        camera.position.y = 150;
			        camera.position.z = 500;
			        camera.target.position.y = 150;
			        
					// SCENE REQUIRED
			        scene = new THREE.Scene();
			        
			        // CUBES GENERATION
					
			        
			        cubes = [] ;

					var itemW = 200 ;
			        
			        for(var i = 0; i < total; i ++){
			        	
			        	// var cube = cubes[cubes.length] = new THREE.Mesh( new THREE.CubeGeometry( itemW, 200, 200, 1, 1, 1, mat ), new THREE.MeshDepthMaterial( { near: 1, far: 2000 } ) );
			        	var cube = cubes[cubes.length] = new THREE.Mesh( new THREE.CubeGeometry( itemW, 200, 200, 1, 1, 1, mat ), material );
			        	// var cube = cubes[cubes.length] = new THREE.Mesh( new THREE.CubeGeometry( itemW, 200, 200, 1, 1, 1, mat ), new THREE.MeshNormalMaterial( {opacity:.5}) );
			        	// var cube = cubes[cubes.length] = new THREE.Mesh( new THREE.CubeGeometry( itemW, 200, 200, 1, 1, 1, mat ), new THREE.MeshPhongMaterial( { color : 0x333333 , reflectivity:2, opacity:.4, ambient:0xFF6600} ) );
				        //cube.doubleSided = true;
						cube.position.y = 150;
				        // cube.position.x = -((itemW+100)*1.5) + (i*(itemW+100)) ;
				        cube.position.x = -((itemW+10)*1.5) + (i*(itemW+10)) ;
				        cube.overdraw = true;
				        scene.addObject( cube );
			        } ;
					/*
					var ambientLight = new THREE.AmbientLight( 0xFFFFFF );
					scene.addLight( ambientLight );
					*/
					directionalLight = new THREE.DirectionalLight( 0xffffff , 1);
					//directionalLight.position.x = Math.random() - 0.5;
					directionalLight.position.x = 0;
					// directionalLight.position.y = Math.random() - 0.5;
					directionalLight.position.y = 0;
					// directionalLight.position.z = Math.random() - 0.5;
					directionalLight.position.z = 400;
					directionalLight.position.normalize();
					scene.addLight( directionalLight );

					var pointLight = new THREE.PointLight( 0xFFFFFF, 1 );
					pointLight.position.z = -450;
					pointLight.position.y = 250;
					scene.addLight( pointLight );
/**/
					
					
			        renderer = new THREE.CanvasRenderer();
					renderer.setSize( __w, __h ) ;
					renderer.render( scene, camera ) ;
					renderer.domElement.setAttribute('id', 'viewport');
					renderer.domElement.setAttribute('class', 'viewport');
					
					
					canvas = $(renderer.domElement) ;
					//canvas.css({'opacity':0}) ;
					tg.append( canvas );					
				}, 150)(e);
        	}
        })
        $(window).trigger('resize') ;
		
		
        
		
        var uid = -1, uidresize;
        var camerapos = 200 ;
        var commands = [] ;
        
        
        commands[commands.length] = 
    	new CommandQueue([
			new Command(null, function(){
				//canvas.animate({'opacity':1}, 250) ;
				
				var command = this ;
				var c = camera ;
				var position = {z: c.position.z};
				var r = $(position) ;
				var rz = position.z ;
				
				r.animate({z: position.z + camerapos}, {
        			duration:500,
        			step:function(now){
        				c.position.z = now ;
						//directionalLight.position.z = 400 + now ;
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
	        				//c.rotation.y = now ;
	        				//c.rotation.z = now ;
	        			},
	        			complete:function(){
	        				rotation.rolling = true ;
	        			}
	        		}) ;
					return this ;
				}, i),new WaitCommand(0)
			]) ;
		};
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
	        				//c.rotation.y = now ;
	        				//c.rotation.z = now ;
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
						//directionalLight.position.z = 400 + now ;
        			},
        			complete:function(){
        				command.dispatchComplete() ;
        				//canvas.animate({'opacity':0}, 250) ;
        			}
        		}) ;								
				return this ;
			}), new WaitCommand(200)
		]) ;
		
		var cq = new CommandQueue(commands) ;
		
         // CLICK ON LAUNCH
        launch.bind({
        	click:function(e){
        		e.preventDefault() ;
        		if(uid !== -1) return ;
        		
        		uid = setInterval(animate, 0) ;
				
        		cq.execute() ;
        		
        		$(cq).bind('$', function(){
    				$(cq).unbind('$',arguments.callee) ;
					clearInterval(uid) ;
        			uid = -1 ;
					cq.reset() ;
					if(uidresize!== -1) clearTimeout(uidresize) ;
					uidresize = setTimeout(function(){
						uidresize = -1;
        				$(window).trigger('resize') ;
        			}, 100) ;
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
		
		
		
		
		
		
		return this ;
	},
	toString : function(){
		return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
	}
}))) ;



var TestCanvas = NS('TestCanvas', NS('test::TestCanvas', Class.$extend({
    __classvars__ : {
        version:'0.0.1',
        toString:function(){
            return '[class TestCanvas]' ;
        }
    },
    __init__ : function(id, launchBtn, closeBtn) {
        var tg = this.tg = $(id) ;
        var launch = this.launch = $(launchBtn) ;
        var close = this.close = $(closeBtn) ;
        
        var canvas = document.createElement('canvas') ;
        
        var __w = canvas.width = tg.width() ;
        var __h = canvas.height = tg.height() ;
        var PiDiv3 = Math.PI*2/3;
        var PiDiv5 = Math.PI*2/5;
        var midW = __w >> 1 ;
        var midH = __h >> 1 ;
        
        
        var radius = 100 ;
        var thickness = 2 ;
        
        var ctx = canvas.getContext('2d') ;
        
        tg.append(canvas) ;
        
        
        ctx.fillStyle = "DodgerBlue" ;
        
        var rotation = {x:0} ;
        
        var uid = -1 ;
        
        var commands = [
            new Command(null, function(){
                var command = this ;
                $(rotation).animate({x:Math.PI*2}, {
                    duration:15000,
                    easing:'linear',
                    step:function(now){
                        render() ;
                    },
                    complete:function(){
                        rotation.x = 0 ;
                        command.dispatchComplete() ;
                    }
                })
                return this ;
            }),
            new Command(null, function(){
                trace('completed') ;
            })
        ] ;
        
        
        
        
        var cq = new CommandQueue(commands) ;
        
        $(cq).bind('$', function(){
            cq.reset().execute() ;
        }) ;
        
        
        launch.bind('click', function(e){
            e.preventDefault() ;
            e.stopPropagation() ;
            
            trace('clicked') ;
            
            cq.execute() ;
            
            
            
        }) ;
		
		close.bind('click', function(e){
            e.preventDefault() ;
            e.stopPropagation() ;
            
            saz.template.unload() ;
        }) ;
        
        ctx.translate(midW,midH) ;
        ctx.save() ;
        
        
        function render(){
            
            ctx.clearRect ( -midW , -midH , __w , __h);
            
            var x = rotation.x ;
            
            fillArc(thickness , radius *.9, -x+5, 15, -1) ;
            fillArc(thickness * 3 , radius , x, PiDiv3, 1) ;
            fillArc(thickness * 2 , radius *.75, -(x*2), PiDiv3, 1) ;
            fillArc(thickness * 4 , radius, x+Math.PI, PiDiv5, 1) ;
            
            
            //ctx.restore() ;
        }
        function fillArc(thickness, rad, start, stop , direction){
            
            var angle = start + (stop * direction);
            
            ctx.beginPath() ;
            
            ctx.arc(0, 0, rad, start, angle) ;
            ctx.arc(0, 0, rad - thickness, angle, start, true) ;
            
            
            ctx.closePath() ;
            ctx.fill() ;
        } ;
        
        
        
        return this ;
    },
    toString : function(){
        return '[ object ' + this.$class.ns + ' v.'+this.$class.version +']';
    }
}))) ;