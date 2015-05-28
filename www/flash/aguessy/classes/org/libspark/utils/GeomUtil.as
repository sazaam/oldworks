/*
 * Copyright(c) 2006-2008 the Spark project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
 * either express or implied. See the License for the specific language
 * governing permissions and limitations under the License.
 */


package org.libspark.utils
{

    import flash.display.DisplayObject;
    import flash.errors.IllegalOperationError;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.geom.ColorTransform;
    import flash.geom.Transform;
    
    /**
     * 図形計算のためのユーティリティクラスです
     */
	public class GeomUtil
    {
        
        /**
         * @private
         */
        public function GeomUtil()
        {
            throw new IllegalOperationError("Error #2012: GeomUtil class cannot be instantiated.");
        }
        
        /**
         * 2つのPoint間の角度を求めます
         * @param	pt1
         * @param	pt2
         * @return  2点間の角度
         * @author  michi at seyself.com
         */
        public static function angle( pt1:Point, pt2:Point ):Number
        {
            return Math.atan2( pt2.y - pt1.y, pt2.x - pt1.x );
        }
        
        /**
         * 極座標ペアを直交点座標に変換し、指定のポイント（座標）に加算した新しいポイントを作成します。
         * 
         * @param	pt 追加するポイント
         * @param	len 極座標ペアの長さ座標
         * @param	angle 極座標ペアの角度 (ラジアン単位) 
         * @return  新しいポイント
         * @author  michi at seyself.com
         */
        public static function addPolar( pt:Point, len:Number, angle:Number ):Point
        {
            return pt.add( Point.polar( len, angle ) );
        }
        
        /**
        * ３つ以上の直線によって構成された多角形の面積を求めます.
        * 引数には x, y の数値プロパティを持つオブジェクトを3つ以上渡す必要があります.
        * 
        * @param arguments  x, y の数値プロパティを持つオブジェクト
        * @return 面積
        * @author  michi at seyself.com
        */
        public static function polygonArea( ...points ):Number
        {
            var leng:uint = points.length;
            var products:Number = 0;
            for(var i:uint=0;i<leng;i++){
                var n:Number = (i==leng-1)? 0 : i+1;
                var p:Object = points[i];
                var q:Object = points[n];
                var product:Number = (p.x-q.x)*(p.y+q.y);
                products += product;
            }
            return products/2;
        }
        
        /**
        * 楕円形の面積を求めます.
        * 楕円を求めるには最短の直径と最長の直径が分かっていないといけません.
        * 
        * @param width  楕円の最短の直径
        * @param height  楕円の最長の直径
        * @return 面積
        * @author  michi at seyself.com
        */
        public static function ellipseArea( width:Number , height:Number ):Number
        {
            return (width/2)*(height/2)*Math.PI;
        }
        
        /**
        * 楕円形の円周の近似値を求めます（楕円積分）.
        * 楕円を求めるには最短の直径と最長の直径が分かっていないといけません.
        * 
        * @param width  楕円の最短の直径
        * @param height  楕円の最長の直径
        * @return 円周の近似値
        * @author  michi at seyself.com
        */
        public static function circumference( width:Number , height:Number ):Number
        {
            var a:Number = Math.min( width , height );
            var b:Number = Math.max( width , height );
            var c:Number = (a-b)/(a+b);
            return Math.PI*(a+b)*( 1+1/4*Math.pow(c,2)+1/64*Math.pow(c,4)+1/256*Math.pow(c,6));
        }
        
        
        /**
        * 直線AB と直線CD の交点を求めます.
        * 2つの直線が平行である場合は null を返します.
        * 
        * @param a  直線AB の点Aの座標（ x, y の数値プロパティを持つオブジェクト ）
        * @param b  直線AB の点Bの座標（ x, y の数値プロパティを持つオブジェクト ）
        * @param c  直線CD の点Cの座標（ x, y の数値プロパティを持つオブジェクト ）
        * @param d  直線CD の点Dの座標（ x, y の数値プロパティを持つオブジェクト ）
        * @return 2直線の交点座標
        * @author  michi at seyself.com
        */
        public static function intersection( a:Object, b:Object, c:Object, d:Object ):Point
        {
            var pos1:Number = (b.y-a.y)/(b.x-a.x);
            var pos2:Number = (d.y-c.y)/(d.x-c.x);
            var pi:Number = Number.POSITIVE_INFINITY;
            var ni:Number = Number.NEGATIVE_INFINITY;
            
            if(pos1==pos2) return null;
            if( pos1 == ni || pos1 == pi ) pos1 = b.y-a.y;
            if( pos2 == ni || pos2 == pi ) pos2 = d.y-c.y;
            
            var nx:Number = ( ( a.x*pos1 ) - a.y - ( c.x*pos2 ) + c.y )/( pos1-pos2 );
            var ny:Number = pos1*( nx-a.x ) + a.y;
            
            return new Point( nx, ny );
        }
        
        /**
         * 指定オブジェクトのプロパティ x, y から新しい Point インスタンスを作成します。
         * 
         * @param	target 指定オブジェクト
         * @return  新しい Point インスタンス
         * @author  michi at seyself.com
         */
        public static function getPoint( target:Object ):Point
        {
            var pt:Point = new Point();
            if ( target.hasOwnProperty("x") ) pt.x = target.x;
            if ( target.hasOwnProperty("y") ) pt.y = target.y;
            return pt;
        }
        
        /**
         * 指定オブジェクトのプロパティ x, y, width, height から新しい Rectangle インスタンスを作成します。
         * 
         * @param	target 指定オブジェクト
         * @return  新しい Rectangle インスタンス
         * @author  michi at seyself.com
         */
        public static function getRect( target:Object ):Rectangle
        {
            var rect:Rectangle = new Rectangle();
            if ( target.hasOwnProperty("x") )      rect.x      = target.x;
            if ( target.hasOwnProperty("y") )      rect.y      = target.y;
            if ( target.hasOwnProperty("width") )  rect.width  = target.width;
            if ( target.hasOwnProperty("height") ) rect.height = target.height;
            return rect;
        }
        
        /**
         * 指定オブジェクトのプロパティ x, y に、それぞれポイントの値を代入します。
         * 
         * @param	target 指定オブジェクト
         * @param	pt 適応する Point オブジェクト
         * @author  michi at seyself.com
         */
        public static function setPoint( target:Object, pt:Point ):void
        {
            if ( target.hasOwnProperty("x") ) target.x = pt.x;
            if ( target.hasOwnProperty("y") ) target.y = pt.y;
        }
        
        /**
         * 指定オブジェクトのプロパティ x, y, width, height に、それぞれ Rectangle の値を代入します。
         * 
         * @param	target 指定オブジェクト
         * @param	rect 適応する Rectangle オブジェクト
         * @author  michi at seyself.com
         */
        public static function setRect( target:Object, rect:Rectangle ):void
        {
            if ( target.hasOwnProperty("x") )      target.x      = rect.x;
            if ( target.hasOwnProperty("y") )      target.y      = rect.y;
            if ( target.hasOwnProperty("width") )  target.width  = rect.width;
            if ( target.hasOwnProperty("height") ) target.height = rect.height;
        }
        
        /**
         * 指定のマトリックスオブジェクトから回転値（ラジアン単位）を調べます。
         * 
         * @param	mt 対象となるマトリックスオブジェクト
         * @return  回転値（ラジアン単位）
         * @author  michi at seyself.com
         */
        public static function getRotateFromMatrix(mt:Matrix):Number
        {
            var sx:Number = Math.sqrt(mt.a * mt.a + mt.b * mt.b);
            var angle:Number = Math.acos( mt.a / sx );
            if (mt.b < 0) angle *= -1;
            return angle;
        }
        
        /**
         * 指定のマトリックスオブジェクトから拡大・縮小値を調べます。
         * scaleX 、 scaleY は、それぞれ新たに作成されたポイントオブジェクトの x , y に代入されます。
         * 
         * @param	mt 対象となるマトリックスオブジェクト
         * @return  拡大率の情報を持つポイントオブジェクト
         * @author  michi at seyself.com
         */
        public static function getScaleFromMatrix(mt:Matrix):Point
        {
            var sx:Number = Math.sqrt(mt.a * mt.a + mt.b * mt.b);
            var sy:Number = Math.sqrt(mt.c * mt.c + mt.d * mt.d);
            return new Point(sx, sy);
        }
        
        /**
         * 指定のマトリックスオブジェクトから位置情報を調べ、ポイントオブジェクトを作成します。
         * 
         * @param	mt 対象となるマトリックスオブジェクト
         * @return  位置情報を持つポイントオブジェクト
         * @author  michi at seyself.com
         */
        public static function getPositionFromMatrix(mt:Matrix):Point
        {
            return new Point(mt.tx, mt.ty);
        }
        
        /**
         * 指定のマトリックスオブジェクトから Matrix.createBox の逆算を行います。
         * getRotateFromMatrix や getScaleFromMatrix で得られる結果とは異なりますので注意してください。
         * 
         * @param	mt 対象となるマトリックスオブジェクト
         * @return  scaleX, scaleY, rotation, x, y のプロパティを持つオブジェクト
         * 得られた結果オブジェクトは toString() で内容を確認用の文字列に変換します。
         */
        public static function degradeBox(mt:Matrix):Object
        {
            var t:Number = mt.a * mt.d - mt.b * mt.c;
            var sx:Number = Math.sqrt(mt.a * mt.a + mt.c * mt.c);
            var sy:Number = t / sx;
            var angle:Number = Math.acos( mt.a / sx );
            var obj:Object = { scaleX:sx , scaleY:sy, rotation:angle, x:mt.tx, y:mt.ty };
            obj.toString = function():String {
                return "(scaleX="+this.scaleX+" , scaleY="+this.scaleY+
                     ", rotation="+this.rotation+", x="+this.x+", y="+this.y+")";
            }
            return obj;
        }
        
        /**
         * 3つの座標数値から2次ベジェ曲線のコントロールポイントの座標を取得します。
         * 
         * @param	start 始点の座標数値
         * @param	passage 通過点の座標数値
         * @param	anchor 終点の座標数値
         * @return  コントロールポイントの座標数値
         * @author  michi at seyself.com
         */
        public static function getCurveControlPoint( start:Number, passage:Number, anchor:Number ):Number
        {
            return ( passage * 4 - start - anchor ) * 0.5;
        }
        
        /**
         * 3つの座標数値から2次ベジェ曲線の中間座標を取得します。
         * 
         * @param	a 始点の座標数値
         * @param	b コントロールポイントの座標数値
         * @param	c 終点の座標数値
         * @param	t 曲線の進度値。0 から 1 の小数値で指定します。
         * @return  指定された時点におけるベジェ式の値。
         * @author  michi at seyself.com
         */
        public static function quadraticBezier( a:Number, b:Number, c:Number, t:Number ):Number
        {
            var s:Number = 1-t;
            return s*s*a + 2*s*t*b + t*t*c;
        }
        
        /**
         * 4つの座標数値から3次ベジェ曲線の中間座標を取得します。
         * 
         * @param	a 始点の座標数値
         * @param	b 点 a のコントロールポイントの座標数値
         * @param	c 点 b のコントロールポイントの座標数値
         * @param	d 終点の座標数値
         * @param	t 曲線の進度値。0 から 1 の小数値で指定します。
         * @return  指定された時点におけるベジェ式の値。
         * @author  michi at seyself.com
         */
        public static function cubicBezier( a:Number, b:Number, c:Number, d:Number, t:Number ):Number
        {
            var s:Number = 1-t;
            return s*s*s*a + 3*s*s*t*b + 3*s*t*t*c + t*t*t*d;
        }
        
		/**
		 * 4つの座標数値からスプライン曲線の中間座標を取得します。
		 * 
		 * @param	p0 始点座標数値
		 * @param	p1 通過点座標数値（求められる曲線の始点）
		 * @param	p2 通過点座標数値（求められる曲線の終点）
		 * @param	p3 終点座標数値
		 * @param	t 2 つの座標間の補間値。 0 から 1 までの数値
		 * @return  p1 から p2 の間にある t の位置を示す座標値
		 * @author  michi at seyself.com
		 */
        public static function spline(p0:Number, p1:Number, p2:Number, p3:Number, t:Number):Number
        {
            var v0:Number = (p2 - p0) * 0.5;
            var v1:Number = (p3 - p1) * 0.5;
            var t2:Number = t * t;
            var t3:Number = t2 * t;
            return (2 * p1 - 2 * p2 + v0 + v1) * t3 + 
                ( -3 * p1 + 3 * p2 - 2 * v0 - v1) * t2 + v0 * t + p1;
        }
        
        /**
         * 指定されたオブジェクトのストリング表現を返します。
         * 
         * @param	target 出力対象オブジェクト
         * @return  オブジェクトのストリング表現
         * @author  michi at seyself.com
         */
        public static function toString(target:Object):String
        {
            if (target is Rectangle) return target.toString(); 
            if (target is Point) return target.toString(); 
            if (target is ColorTransform) return target.toString(); 
            if (target is Transform) {
                target = target.matrix;
            }
            
            if (target is Matrix) {
                var mt:Matrix = target as Matrix;
                return degradeBox(mt).toString();
            }
            
            return getRect(target).toString();
        }
        
    }

}