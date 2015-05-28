/**
 * Copyright (c) 2008 Bartek Drozdz (http://www.everydayflash.com)
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
package saz.geeks.graphix 
{

        import org.papervision3d.objects.DisplayObject3D;
        import org.papervision3d.objects.parsers.Collada;
        import org.papervision3d.objects.primitives.Cone;
        import org.papervision3d.objects.primitives.Cube;
        import org.papervision3d.objects.primitives.Cylinder;
        import org.papervision3d.objects.primitives.Plane;
        import org.papervision3d.core.proto.MaterialObject3D;
        import org.papervision3d.core.geom.renderables.Vertex3D;
        import org.papervision3d.objects.primitives.Sphere;

        /**
         * Bend modifier for Papervision3D objects
         *
         * Version 1.2. Features:
         *
         * 1. Bends primitives only (no Collada objects)
         * 2. Allows to constraint
         * 3. Works with Tweener
         *
         * Author: Bartek Drozdz
         * Version: 1.2
         */
        public class Bend {
               
                private var target:DisplayObject3D;
               
                private var w:Number;
                private var h:Number;
                private var d:Number;
                private var mx:Number;
                private var my:Number;
                private var mz:Number;
               
                public static var X:int = 0;
                public static var Y:int = 1;
                public static var Z:int = 2;
               
                public static var NONE:int = 0;
                public static var LEFT:int = 1;
                public static var RIGHT:int = 2;
                public var constraint:int = NONE;
               
                private var base:Array;
               
                public var _force:Number;
                public var _offset:Number;
                public var U_AXIS:int;
                public var V_AXIS:int;
               
                /**
                 *  If this is set to true, the object will not be bended bu rather squeezed.
                 *
                 *      This feature is used here: http://www.everydayflash.com/blog/index.php/2008/06/11/bending-modifier-papervision3d/
                 *      to make the shadow...
                 */
                public var shadowMode:Boolean = false;

                /**
                 * Creates a bend modifier for a DisplayObject3D.
                 *
                 * @param       _target the DisplayObject3D to bend. Currently supported types are all primitives
                 * and any other DisplayObject3D that has all its vertices available in the 'geometry.vertices'
                 * array.
                 */
                public function Bend(_target:DisplayObject3D) {
                        target = _target;
                       
                        if (_target is Collada) throw new Error("Bend does not work with Collada objects.");

                        base = new Array();
                        var vs:Array = target.geometry.vertices;
                        var vc:int = vs.length;

                        for (var i:int = 0; i < vc; i++) {
                                var v:Vertex3D = vs[i] as Vertex3D;
                               
                                base.push([v.x, v.y, v.z]);
                               
                                if (i == 0) {
                                        mx = w = v.x;
                                        my = h = v.y;
                                        mz = d = v.z;
                                } else  {
                                        mx = Math.min(mx, v.x);
                                        my = Math.min(my, v.y);
                                        mz = Math.min(mz, v.z);
                                        w = Math.max(w, v.x);
                                        h = Math.max(h, v.y);
                                        d = Math.max(d, v.z);
                                }
                        }
                       
                        w = w - mx;
                        h = h - my;
                        d = d - mz;
                       
                        var maxe:Number = Math.max(d, Math.max(w, h));
                       
                        if (d == h && d == w) {                
                                // This is a sphere, bending spheres look weird for any option
                                U_AXIS = 2;
                                V_AXIS = 2;
                        } else if (maxe == w) {
                                U_AXIS = 0;
                                V_AXIS = 2;
                        } else if (maxe == h) {
                                U_AXIS = 1;
                                V_AXIS = 2;
                        } else if (maxe == d) {
                                U_AXIS = 2;
                                V_AXIS = 1;
                        }
                }

                /**
                 * Resets all the vertices to the original positions.
                 */
                public function reset():void {
                        var vs:Array = target.geometry.vertices;
                        var vc:int = vs.length;
                       
                        for (var i:int = 0; i < vc; i++) {
                                var v:Vertex3D = vs[i] as Vertex3D;
                                v.x = base[i][0] as Number;
                                v.y = base[i][1] as Number;
                                v.z = base[i][2] as Number;
                        }
                }
               
                /**
                 * Bends a primitive in a 'most wanted' way.
                 *
                 * The primitives in PV3D are build in different way, so ex. bending a cube on some axes
                 * can give regualr results while bengind a cylinder on the same axes can be weird. This method
                 * check the type of the primitive and bends it along thie optimal axes for that type.
                 *
                 * If you have special needs use rather the 'bend' method below.
                 *
                 * @param       force the force of the bending, 0 to restore original, 2 or -2 for 360 degrees bend
                 * @param       offset Value between 0 and 1.
                 *          If its 0.5 the bending is centered on the object, values 0 and 1 bend around one of the edges.
                 */
                public function quickBend(force:Number, offset:Number):void {
                        bend(U_AXIS, V_AXIS, force, offset);
                }
               
                /**
                 * Use static X, Y and Z fields to specify the axis and paxis arguments.
                 *
                 * The axis and paxis arguments can be combined in severl adifferent ways, some of those
                 * combinations result in really interesting shapes! :) Play with those to see.
                 *
                 * If you need to bend a primitive in just a regular way, use the 'quickBend' method above.
                 *
                 * @param   axis the axis along which to bend.
                 * @param       paxis the axis where the point around which the bending occurs is located
                 * @param       force the force of the bending, 0 to restore original, 2 or -2 for 360 degrees bend
                 * @param       offset Value between 0 and 1.
                 *          If its 0.5 the bending is centered on the object, values 0 and 1 bend around one of the edges.
                 */
                public function bend(uaxis:int, vaxis:int, force:Number, offset:Number):void {
                        reset();
                        if (force == 0) {
                                return;
                        }
                       
                        offset = Math.max(0, offset);
                        offset = Math.min(1, offset);
                       
                        _bend(uaxis, vaxis, force, offset);
                }
               
                private function _bend(uaxis:int, vaxis:int, force:Number, offset:Number):void {
                               
                        var pto:Number;
                        var ptd:Number;
                               
                        if (uaxis == 0) {
                                pto = mx;
                                ptd = w;
                        } else if (uaxis == 1) {
                                pto = my;
                                ptd = h;
                        } else if (uaxis == 2) {
                                pto = mz;
                                ptd = d;
                        }
                               
                        var vs:Array = target.geometry.vertices;
                        var vc:int = vs.length;
                       
                        var distance:Number = pto + ptd * offset;
                        var radius:Number = ptd / Math.PI / force;
                        var angle:Number = Math.PI * 2 * (ptd / (radius * Math.PI * 2));
                       
                        for (var i:int = 0; i < vc; i++) {
                                var v:Vertex3D = vs[i] as Vertex3D;
                                var portion:Number = (base[i][uaxis] - pto) / ptd;
                                var fa:Number = ((Math.PI / 2) - angle * offset) + (angle * portion);
                               
                                if (constraint == LEFT && portion <= offset) continue;
                                if (constraint == RIGHT && portion >= offset) continue;


                                var op:Number = Math.sin(fa) * (radius + base[i][vaxis]) - radius;
                                var ow:Number = distance - Math.cos(fa) * (radius + base[i][vaxis]);
                               
                                if (!shadowMode) {
                                        if (vaxis == X) v.x = op;
                                        else if (vaxis == Y) v.y = op;
                                        else if (vaxis == Z) v.z = op;
                                }
                               
                                if(uaxis == X) v.x = ow;
                                else if (uaxis == Y) v.y = ow;
                                else if(uaxis == Z) v.z = ow;
                        }
                }
               
                public function get force():Number {
                        return _force;
                }
               
                public function set force(f:Number):void {
                        _force = f;
                        bend(U_AXIS, V_AXIS, _force, _offset);
                }
               
                public function get offset():Number {
                        return _offset;
                }
               
                public function set offset(o:Number):void {
                        _offset = o;
                        bend(U_AXIS, V_AXIS, _force, _offset);
                }
        }
}
