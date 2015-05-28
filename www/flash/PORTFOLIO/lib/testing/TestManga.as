package testing
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	/**
	 * @author Mao Takagi
	 */
	public class TestManga extends Sprite 
	{
		private var _notes:TextField;
		/**
		 * constructor
		 */
		public function TestManga():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, onStage) ;
		}
		
		private function onStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onStage);
			init() ;
		}
		
		private function init():void 
		{
			_notes = new TextField();
			_notes.autoSize = "left";
			_notes.selectable = false;
			_notes.text = "Click To Explode";
			_notes.x = (stage.stageWidth - _notes.width) / 2;
			_notes.y = (stage.stageHeight - _notes.height) / 2;
			addChild(_notes);
			stage.addEventListener(MouseEvent.CLICK, regenerateBomb);
		}
		/**
		 * regenerateBomb
		 * @param event MouseEvent
		 */
		private function regenerateBomb(event:MouseEvent = null):void 
		{
			if (contains(_notes)) removeChild(_notes);
			var i:uint = 0;
			if (numChildren == 4)
			{
				for (i = 0; i < 4;i++ )
				{
					removeChild(getChildAt(0));
				}
			}
			for (i = 0; i < 2;i++ )
			{
				bomb(2 - i * 0.8, i * 90);
			}
			
			var radiation:Sprite = generateRadiation();
			radiation.x = stage.stageWidth / 2;
			radiation.y = stage.stageHeight / 2;
			addChild(radiation);
			
			var sound:Shape = generateSound();
			sound.x = Math.floor(Math.random() * 100);
			sound.y = Math.floor(Math.random() * 100) + 200;
			addChild(sound);
		}
		/**
		 * 爆発作成
		 * @param scale Number
		 * @param rotation Number
		 */
		private function bomb(scale:Number, rotation:Number):void 
		{
			var front:Sprite = new Sprite();
			var back:Sprite = new Sprite();
			var container:Sprite = new Sprite();
			container.x = stage.stageWidth / 2;
			container.y = stage.stageHeight / 2;
			container.addChild(back);
			container.addChild(front);
			addChild(container);
			container.rotation = rotation;
			
			back.scaleX = back.scaleY = front.scaleX = front.scaleY = scale;
			var max:uint = 12;
			var degreeBase:Number = 360 / max;
			var r:uint = 40;
			for (var i:uint = 0; i < max;i++ )
			{
				var degree:Number = degreeBase * i;
				var radian:Number = Math.PI/180 * degree;
				var unit:Unit = new Unit(Math.cos(radian) * r, Math.sin(radian) * r);
				unit.rotation = 360 / max * i - 90;
				if (i % 2 == 0)back.addChild(unit);
				else if(i % 2 == 1)front.addChild(unit);
			}
		}
		/**
		 * 「ドッ」作成
		 */
		private function generateSound():Shape 
		{
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(3, 0xFFFFFF);
			shape.graphics.beginFill(0x000000);
			shape.graphics.lineTo(27, -3);
			shape.graphics.lineTo(54, 63);
			shape.graphics.lineTo(119, 45);
			shape.graphics.lineTo(140, 74);
			shape.graphics.lineTo(69, 97);
			shape.graphics.lineTo(94, 153);
			shape.graphics.lineTo(39, 168);
			shape.graphics.lineTo(0, 0);
			
			shape.graphics.moveTo(62, 5);
			shape.graphics.lineTo(82, 0);
			shape.graphics.lineTo(102, 32);
			shape.graphics.lineTo(80, 37);
			shape.graphics.lineTo(62, 5);
			
			shape.graphics.moveTo(97, -4);
			shape.graphics.lineTo(117, -9);
			shape.graphics.lineTo(135, 22);
			shape.graphics.lineTo(114, 28);
			shape.graphics.lineTo(97, -4);
			
			shape.graphics.moveTo(171, 82);
			shape.graphics.lineTo(192, 72);
			shape.graphics.lineTo(213, 95);
			shape.graphics.lineTo(193, 108);
			shape.graphics.lineTo(171, 82);
			
			shape.graphics.moveTo(203, 65);
			shape.graphics.lineTo(225, 53);
			shape.graphics.lineTo(248, 79);
			shape.graphics.lineTo(223, 91);
			shape.graphics.lineTo(203, 65);
			
			shape.graphics.moveTo(268, 65);
			shape.graphics.lineTo(283, 72);
			shape.graphics.lineTo(255, 151);
			shape.graphics.lineTo(213, 140);
			shape.graphics.lineTo(268, 65);
			
			return shape;
		}
		/**
		 * 放射状の効果作成
		 */
		private function generateRadiation():Sprite 
		{
			var container:Sprite = new Sprite();
			var max:uint = 100;
			var adjust:uint = 0;
			var r:uint = 130;
			for (var i:uint = 0; i < max;i++ )
			{
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0x000000);
				shape.graphics.lineTo(2, 200);
				shape.graphics.lineTo(-2, 200);
				shape.graphics.lineTo(0, 0);
				shape.scaleX = Math.random() * 2 + 1;
				shape.scaleY = Math.random() * 4 + 1;
				
				var radian:Number = Math.PI / 180 * (360 / max * i);
				shape.x = Math.cos(radian) * r;
				shape.y = Math.sin(radian) * r;
				shape.rotation = 360 / max * i - 90 + adjust;
				
				container.addChild(shape);
			}
			return container;
		}
	}
}
import flash.display.Shape;
import flash.display.Sprite;
class Unit extends Sprite
{
	private const BASE_SIZE:uint = 70;
	private const RANGE:uint = 50;
	/**
	 * constructor
	 */
	public function Unit(posX:Number, posY:Number)
	{
		var w:uint = Math.floor(Math.random() * RANGE) + BASE_SIZE / 2;
		var h:uint = Math.floor(Math.random() * RANGE) + BASE_SIZE;
		var adjust:uint = Math.floor(Math.random() * 4) + 6;
		var white:Shape = generateShape(0x000000, w, h);
		var black:Shape = generateShape(0xFFFFFF, w, h);
		black.y = -adjust;
		
		x = posX;
		y = posY;
		addChild(white);
		if (Math.floor(Math.random() * 2) == 0)
		{
			var needle:Shape = generateNeedle();
			needle.scaleX = needle.scaleY = Math.random() * 1 + 0.5;
			addChild(needle);
		}
		addChild(black);
	}
	/**
	 * generateShape
	 * @return Shape
	 */
	private function generateShape(color:uint, w:uint, h:uint, adjust:uint = 0):Shape
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(color);
		shape.graphics.drawCircle(0, 0, 10);
		shape.graphics.endFill();
		shape.width = w;
		shape.height = h;
		return shape;
	}
	/**
	 * generateNeedle
	 * @return Shape
	 */
	private function generateNeedle():Shape
	{
		var vec:Vector.<Number> = Vector.<Number>([-5, 0, 5, 0, 0, 100]);
		var shape:Shape = new Shape();
		shape.graphics.beginFill(0x000000);
		shape.graphics.drawTriangles(vec);
		shape.graphics.endFill();
		return shape;
	}
}