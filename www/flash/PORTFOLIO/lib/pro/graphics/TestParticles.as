package pro.graphics 
{
	import flash.display.Sprite;
    import flash.display.MovieClip;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class TestParticles {
        //カンバスの生成
        private var __target:Sprite;
        private var canvas:BitmapData;
        private var textCanvas:BitmapData;
        private var particles:Array;
        private var _num:int;
        private var maxDis:int = 400;
		
        public function TestParticles(target:Sprite) {
            //bitmapdataを最初に格納をします。
			__target = target ;
            canvas = new BitmapData(__target.stage.stageWidth, __target.stage.stageHeight, false, 0x0);
            var __bmp:Bitmap = new Bitmap(canvas) ;
			__target.addChild( __bmp);
            //テキストフィールドを作成します。
            var tf:TextField = new TextField;
            tf.defaultTextFormat = new TextFormat("Kozuka Gothic Pro EL",60,0xFF0000);
            tf.autoSize = TextFieldAutoSize.LEFT;
            tf.text = "思無愛" ;
            textCanvas = new BitmapData(tf.textWidth, tf.textHeight, true, 0x0);
            textCanvas.draw(tf);
            particles = new Array();
            createText();
            __target.addEventListener(Event.ENTER_FRAME,onEnterFrame);
            __target.stage.addEventListener(MouseEvent.CLICK,onClick);
        }
        public function createText():void{
            //すべてを１pixelごとに色を取得していき、もし黒以外の色であれば、ピクセルを作成
            var ofx:Number = __target.stage.stageWidth/2 - textCanvas.width/2;
            var ofy:Number = __target.stage.stageHeight/2 - textCanvas.height/2;
            for ( var ex:Number = 0;ex < textCanvas.width;ex++){
                for (var ey:Number = 0;ey < textCanvas.height;ey++){
                    var c:uint = textCanvas.getPixel(ex,ey);
                    if(c != 0x000000){
                        createParticle(ex + ofx,ey + ofy,c);
                    }
                }
            }
        }
        public function createParticle(ex:Number,ey:Number,c:int):void{
            //色の情報と、位置の情報を取得しえて格納する。
            var p:Particle = new Particle();
            p.ex = ex;
            p.ey = ey;
            p.c = c;
            initParticle(p);
            particles.push(p)
            _num = 0;
        }
        public function initParticle(p:Particle):void{
            //位置の情報を元に、ランダムで散らばるようなファンクションを作成する。
            var rad:Number = Math.random()*(Math.PI*2);
            var dis:Number = Math.random()*maxDis;
            p.x = p.ex+ dis * Math.cos(rad);
            p.y = p.ey + dis * Math.sin(rad);
        }
        private function onEnterFrame( evt:Event ):void{
            //キャンバス自体は黒でロックをしておく。
            canvas.lock();
            canvas.fillRect( canvas.rect,0x000000);
            for (var i:int = 0;i<_num;i++){
                var p:Particle = particles[i];
                if(Math.abs(p.ex - p.x)<0.5 &&Math.abs(p.ey-p.y)<0.5){
                    p.x = p.ex;
                    p.y = p.ey;
                }else{
                    p.x += (p.ex - p.x)*0.4;
                    p.y += (p.ey - p.y)*0.4;
                }
                canvas.setPixel(p.x,p.y,p.c);
            }
            var n:int = particles.length;
            _num = (_num +10<n)?_num + 10:n;
            //１０を足す。もし、１０を足すと超えてしまうならマックスの値をとる()サンプルだと１００だった。
            canvas.unlock();
        }
        
        public function onClick( evt:MouseEvent):void{
            //ボタンを押した瞬間に初期の値に戻るように設定。
            var n:int = particles.length;
            while(n--){
                var p:Particle = particles[n];
                initParticle(p)
            }
            _num = 0;
       }
    }
}
//主にどういう値で格納をする必要があるのかを記述。
class Particle{
    public var x:Number;
    public var y:Number;
    public var ex:Number;
    public var ey:Number;
    public var c:int;
    public function Particle(){
        x = 0;
        y = 0;
        ex = 0;
        ey = 0;
        c = 0;
    }
}

