package tools.access 
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.FocusEvent;

	/**
	 * 
	 * @example The following assumes there are three object on the stage, a movieClip(button_mc), a comboBox(drop_cb), and a textField(textArea_txt). This implementation creates a white focus rectangle with a stroke weight of 2 and a margin of 5.
	* <listing version="3.0" > 
	* package  {
    * 
    * 
    *   public class Example extends MovieClip {
    * 
    *       private var tabulate:Tabulate;
	* 
	* 		public function Example() {
	* 			tabulate = new Tabulate(stage);
	* 			tabulate.rectStrokeColor = 0xFFFFFF;
	* 			tabulate.rectStrokeWeight = 2;
	* 			tabulate.rectStrokeMargin = 2;
	* 			tabulate.setTabs([button_mc, drop_cb, textArea_txt]);
	* 			tabulate.activate();
	*       }
    *   }
    * }
	* 
	* </listing> 
	*/
	public class Tabulations{
		
		/**
		 * The color of the custom focus rectangle's stroke.
		 * @default 0x00000
		 */
		public var rectStrokeColor:Number = 0x000000;
		
		/**
		 * The weight of the custom focus rectangle's stroke.
		 * @default 1
		 */
		public var rectStrokeWeight:Number = 1;
		
		/**
		 * The margin to apply between the focused object and the focus rectangle.
		 * @default 0
		 */
		public var rectStrokeMargin:Number = 0;
		
		private var _tabBeginIndex:uint = 100;
		private var _active:Boolean = false;
		private var stage:Stage;
		private var tabArray:Array;
		
		/**
		 * Instantiates a tabulate instance.
		 * @param	$stage A reference to the stage.
		 */
		public function Tabulations($stage:Stage) {
			stage = $stage;
			stage.stageFocusRect = false;
		}
		
		/**
		 * Sets the items in the tab list from the provided array in order based on their order within the array.
		 * @param	$tabArray An array of interactiveObjects, including components.
		 */
		public function setTabs($tabArray:Array):void {
			tabArray = [];
			for (var i:uint = 0; i < $tabArray.length; i++) tabArray.push([$tabArray[i], null]);
			if (active) activate();
		}
		
		/**
		 * Adds event listeners for focusing and focuses on the first item in the tab list.
		 */
		public function activate():void {
			_active = true;
			stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, eKeyFocusChangeHandler);
			for (var i:uint = 0; i < tabArray.length; i++) {
				var target:Object = tabArray[i][0];
				try{
					var skin:Sprite = new Sprite();
					skin.visible = false;
					skin.graphics.lineStyle(rectStrokeWeight, rectStrokeColor);
					skin.graphics.drawRect(0 - rectStrokeMargin, 0 - rectStrokeMargin, target.width + rectStrokeMargin * 2, target.height + rectStrokeMargin * 2);
					target.addChild(skin);
					tabArray[i][1] = skin;
				} catch (e:Error) {
				}
				if (target.hasOwnProperty("focusEnabled")) target.focusEnabled = false;
				if (target.hasOwnProperty("focusManager")) target.focusManager.deactivate();
				target.focusRect = null;
				target.tabEnabled = true;
				target.tabIndex = tabBeginIndex + i;
				target.addEventListener(FocusEvent.FOCUS_IN, eFocusInHandler, false, 0, true);
				target.addEventListener(FocusEvent.FOCUS_OUT, eFocusOutHandler, false, 0, true);
			}
			drawFocus(0);
		}
			
		/**
		 * Removes the event listeners for this tab list.
		 */
		public function deactivate():void {
			if(stage.hasEventListener(FocusEvent.KEY_FOCUS_CHANGE)) stage.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, eKeyFocusChangeHandler);
			for (var i:uint = 0; i < tabArray.length; i++) {
				var target:Object = tabArray[i][0];
				if(target.hasEventListener(FocusEvent.FOCUS_IN))target.removeEventListener(FocusEvent.FOCUS_IN, eFocusInHandler);
				if(target.hasEventListener(FocusEvent.FOCUS_OUT))target.removeEventListener(FocusEvent.FOCUS_OUT, eFocusOutHandler);
			}
			_active = false;
		}
		
		private function eFocusInHandler(e:FocusEvent):void {
			drawFocus(getItemID(e.target));
			e.stopImmediatePropagation();
		}
		
		private function getItemID(target:Object):uint {
			var retID:uint;
			for (var i:uint = 0; i < tabArray.length; i++) if (tabArray[i][0] == target) retID = i;
			return retID;
		}
		
		private function drawFocus(id:uint):void {
			var target:Object = tabArray[id][0];
			if (target.hasOwnProperty("setFocus")) target.setFocus();
			if (target.hasOwnProperty("drawFocus")) target.drawFocus(false);
			stage.focus = InteractiveObject(target);
			if (tabArray[id][1] != null) tabArray[id][1].visible = true;
		}
		
		private function eFocusOutHandler(e:FocusEvent):void {
			var id:uint = getItemID(e.target);
			if (tabArray[id][1] != null) tabArray[id][1].visible = false;
		}
		
		private function eKeyFocusChangeHandler(e:FocusEvent):void {
			if (changeFocus(e.target, e.shiftKey))	e.preventDefault();
		}
		
		private function changeFocus(target:Object, shiftKey:Boolean):Boolean {
			if (shiftKey && target == tabArray[0][0]) {
				drawFocus(tabArray.length - 1);
				return true;
			} else if (!shiftKey && target == tabArray[tabArray.length - 1][0]) {
				drawFocus(0);
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Specifies the beginning value for the index. It id recommended that each tabulate instance have different different tab index values. Values at or approaching 0 are known to cause issues due to stage instances in this alpha release. 100 and up is recommended.
		 * @default 100
		 */
		public function get tabBeginIndex():uint { return _tabBeginIndex; }
		
		public function set tabBeginIndex(value:uint):void {
			_tabBeginIndex = value;
			if (active) activate();
		}
		
		/**
		 * Specifies if the tabulate instance has been activated.
		 */
		public function get active():Boolean { return _active; }
		
	}
	
}