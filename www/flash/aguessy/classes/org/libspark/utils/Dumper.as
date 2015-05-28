package org.libspark.utils {
    import flash.external.ExternalInterface;
    import flash.utils.getQualifiedClassName;

    /**
     * <listing>
     * package {
     *    import org.libspark.utils.Dumper;
     *    public Class Hoge {
     *        var test:Object = { a:'hoge', b:'fuga'};
     *        Dumper.debug(test);
     *        trace(Dumper.toString(test));
     *    }
     *    // output
     *         $var0 = {
     *                     'a' => 'hoge', 
     *                     'b' => 'fuga', 
     *                 } 
     *     
     * }</listing>
     * @author dealforest
     * @version 0.102
     */

    public class Dumper {
        private static const INDENT:String = "    ";
        private static var _dumpString:String = "";


        public static function toString(... args):String {
            var _txt:String = _dumpString = '';
            for (var a:String in args)
                _txt += parse(args[a]);
            return _txt;
        }

        public static function debug(... args):void {
            if (!ExternalInterface.available) return;

            var _txt:String = _dumpString = '';
            for (var a:String in args)
                _txt += parse(args[a]);
            //interim action for IE
            ExternalInterface.call('function (txt) { try { console.log(txt); } catch (e) {}; }', _txt);
        }

        public static function info(... args):void {
            if (!ExternalInterface.available) return;

            var _txt:String = _dumpString = '';
            for (var a:String in args)
                _txt += parse(args[a]);
            //interim action for IE
            ExternalInterface.call('function (txt) { try { console.info(txt); } catch (e) {}; }', _txt);
        }


        public static function warn(... args):void {
            if (!ExternalInterface.available) return;

            var _txt:String = _dumpString = '';
            for (var a:String in args)
                _txt += parse(args[a]);
            //interim action for IE
            ExternalInterface.call('function (txt) { try { console.warn(txt); } catch (e) {}; }', _txt);
        }

        public static function error(... args):void {
            if (!ExternalInterface.available) return;

            var _txt:String = _dumpString = '';
            for (var a:String in args)
                _txt += parse(args[a]);
            //interim action for IE
            ExternalInterface.call('function (txt) { try { console.error(txt); } catch (e) {}; }', _txt);
        }

        public static function parse(arg:*):String {
            var argIndent:String = ('$var'+ ' = ');
            _dumpString += argIndent;
            inspect(arg, argIndent.replace(/./g, ' '));
            _dumpString += '\n';
            return _dumpString;
        }
       
        private static function inspect(arg:*, indent:String):void {
            var bracket:Object;

            switch (getQualifiedClassName(arg)) {
                case 'Object':
                    bracket = {start: '{', end: '}'};
                case 'Array':
                    bracket ||= {start: '[', end: ']'};
                    _dumpString += bracket.start + '\n';
                    recursion(arg, indent + INDENT);
                    _dumpString += (indent +bracket.end);
                    break;
                default:
                    _dumpString += format(arg, indent, true);
            }
        }

        private static function recursion(arg:*, indent:String):void {
            for (var index:String in arg) {
                var tmp:* = arg[index];
                var className:String = getQualifiedClassName(tmp);
                var bracket:Object;

                switch(className) {
                    case 'Object':
                        bracket = {start: '{', end: '}'};
                    case 'Array':
                        bracket ||= {start: '[', end: ']'};
                        var str:String = (getQualifiedClassName(arg) == 'Object')
                            ? '\'' + index + '\' => ' : '';
                        var indent_str:String = str.replace(/./g, ' ');

                        _dumpString += (indent + str + bracket.start + "\n");
                        recursion(tmp, indent + indent_str + INDENT);
                        _dumpString += (indent + indent_str + bracket.end + ",");
                        break;
                    default:
                        _dumpString += format(tmp, indent, false, arg, index);
                }
                _dumpString += "\n";
            }
        }

        private static function format(target:Object, indent:String, bracket:Boolean, parent:* = null, index:String = null):String {
            var className:String = getQualifiedClassName(target);
            var str:String = "";

            if (getQualifiedClassName(parent) == 'Object')
                return indent +  "\'" + index + "\'" + " => " + target + (bracket ? '' : ',');

            switch (className) {
                case 'String':
                    return (bracket) 
                        ? "\'" + target + "\'"
                        : indent + "\'" + target + "\',";

                case 'Array':
                case 'int':
                case 'uint':
                case 'Number':
                case 'Boolean':
                    return (bracket) 
                        ? target.toString()
                        : indent + target.toString() + ",";
                default:
                    return 'don\'t analyze';
            }
        }
    }
}
