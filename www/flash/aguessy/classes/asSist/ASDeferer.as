package asSist
{
	/**
	 * ...
	 * @author saz
	 */

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class ASDeferer {
		private var _next:ASDeferer;
		
		public var callback:Object;
		public var canceller:Function;
		
		public function ASDeferer() {
			init();
		}

		public function init():ASDeferer {
			_next = null;
			
			callback = {
				ok: function( x:* ):* { return x; },
				ng: function( x:* ):* { return x; }
			};
			
			return this;
		}
		
		
		public function next( func:Function ):ASDeferer {
			return _post("ok", func );
		}
		
		public function error( func:Function ):ASDeferer {
			return _post("ng", func );
		}
		
		public function call( value:* = null ):ASDeferer {
			return _fire("ok", value );
		}
		
		public function fail( err:* = null ):ASDeferer {
			return _fire("ng", err );
		}
		
		public function cancel():ASDeferer {
			if ( canceller is Function ) {
				canceller();
			}
			
			return init();
		}
		
		
		private function _post( okng:String, func:Function ):ASDeferer {
			_next = new ASDeferer();
			_next.callback[ okng ] = func;
			
			return _next;
		}
		
		
		private function _fire( okng:String, value:* ):ASDeferer {
			var next:String = "ok";
			
			try {
				value = callback[ okng ].call( this, value );
			} catch ( e:Error ) {
				next = "ng";
				value = e;
			}
			
			if ( value is ASDeferer ) {
				value._next = _next;
			} else {
				if ( _next ) _next._fire( next, value );
			}
			
			return this;
		}
		
		
		public static function loop( n:*, func:Function ):ASDeferer {
			var o:Object = {
				begin : n.hasOwnProperty("begin") ? n.begin : 0,
				end   : n.hasOwnProperty("end") ? n.end : n - 1,
				step  : n.hasOwnProperty("step") ? n.step : 1,
				last  : false,
				prev  : null
			};
			
			var ret:*;
			var step:int = o.step;
			
			
			return ASDeferer.next( function():ASDeferer {
				function _loop( i:int ):* {
					if ( i <= o.end ) {
						if ( i + step > o.end ) {
							o.last = true;
							o.step = o.end - i + 1;
						}
						
						o.prev = ret;
						ret = func.apply( this, [ i, o ] );
						
						if ( ret is ASDeferer ) {
							return ret.next( function( r:* ):* {
								ret = r;
								return _loop( i + step );
							});
						} else {
							_loop( i + step );
						}
					} else {
						return ret;
					}
				}
				return _loop( o.begin );
			});
		}
		
		public static function parallel( dl:Object ):ASDeferer {
			var ret:ASDeferer = new ASDeferer();
			var values:* = ( dl is Array ) ? [] : {};
			var num:int = 0;
			
			for ( var i:String in dl ) {
				if ( dl.hasOwnProperty( i ) ) {
					( function( d:ASDeferer, i:String ):void {
						d.next( function( v:* ):void {
							values[i] = v;
							
							if ( --num <= 0 ) {
								ret.call( values );
							}
						}).error( function( e:* ):void {
							ret.fail( e );
						});
						num++;
						
/*
						// parallel を直列で定義できるようにするための挿入コード
						var timer:Timer = new Timer( 0, 1 );
						var complete:Function = function( e:TimerEvent ):void {
							timer.removeEventListener( e.type, arguments.callee );
							d.call();
						}
						timer.addEventListener( TimerEvent.TIMER_COMPLETE, complete );
						timer.start();
						
						d.canceller = function():void {
							try {
								timer.stop();
								timer.removeEventListener( TimerEvent.TIMER_COMPLETE, complete );
							} catch ( e:Error ) {
								
							}
						}
//*/
					})( dl[i], i );
				}
			}
			
			if ( num == 0 ) {
				ASDeferer.next( function():void { ret.call() } );
			}
			
			ret.canceller = function():void {
				for ( var i:String in dl ) {
					if ( dl.hasOwnProperty( i ) ) {
						dl[i].cancel();
					}
				}
			}
			
			return ret;
		}
		
		
		public static function wait( n:Number ):ASDeferer {
			var d:ASDeferer = new ASDeferer();
			var t:Date = new Date();
			
			var timer:Timer = new Timer( n*1000, 1 );
			var complete:Function = function( e:TimerEvent ):void {
				timer.removeEventListener( e.type, arguments.callee );
				d.call( new Date().getTime() - t.getTime() );
			}
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, complete );
			timer.start();
			
			d.canceller = function():void {
				try {
					timer.stop();
					timer.removeEventListener( TimerEvent.TIMER_COMPLETE, complete );
				} catch ( e:Error ) {
					
				}
			}
			
			return d;
		}
		
		
		public function wait( n:Number ):ASDeferer {
			return next( function():ASDeferer { return ASDeferer.wait( n ) } );
		}
		
		public function loop( n:*, func:Function ):ASDeferer {
			return next( function():ASDeferer { return ASDeferer.loop( n, func ) } );
		}
		
		// parallel を直列で繋げられるようにするための追加メソッド
		public function parallel( dl:Object ):ASDeferer {
			return next( function():ASDeferer { return ASDeferer.parallel( dl ) } );
		}
		
		public static function wrap( func:Function ):Function {
			return function( ...args:Array ):Function {
				return function():Function {
					return func.apply( null, args );
				}
			}
		}
		
		
		public static function next( func:Function ):ASDeferer {
			var d:ASDeferer = new ASDeferer();
			
			var timer:Timer = new Timer( 0, 1 );
			var complete:Function = function( e:TimerEvent ):void {
				timer.removeEventListener( e.type, arguments.callee );
				d.call();
			}
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, complete );
			timer.start();
			
			if ( func != null ) d.callback.ok = func;
			
			d.canceller = function():void {
				try {
					timer.stop();
					timer.removeEventListener( TimerEvent.TIMER_COMPLETE, complete );
				} catch ( e:Error ) {
					
				}
			}
			
			return d;
		}
		
		
		public static function call( func:Function, ...args:Array ):ASDeferer {
			return ASDeferer.next(
				function():* {
					return func.apply( this, args );
				}
			);
		}
		
		public static function define( obj:Object = null, list:Array = null ):Class {
			if ( !list ) list = ["parallel", "wait", "next", "call", "loop"];
			if ( !obj ) obj = ( function():ASDeferer { return this } )();
			
			for ( var i:int = 0; i < list.length; ++i ) {
				obj[ list[i] ] = ASDeferer[ list[i] ];
			}
			
			return ASDeferer;
		}
	}
	
}