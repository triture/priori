package helper.browser;

import js.html.DOMRect;
import priori.geom.PriGeomBox;
import priori.system.PriDeviceBrowser;
import priori.system.PriDevice;
import priori.system.PriDeviceBrowser;
import js.html.svg.Element;
import js.html.Element;

class DomHelper {

    public static function disableAll(el:Element):Void {

        el.setAttribute("disabled", "disabled");

        for (i in 0 ... el.children.length) {
            disableAll(el.children.item(i));
        }
    }

    public static function enableAllUpPrioriDisabled(el:Element):Void {
        if (!el.hasAttribute("priori-disabled")) {
            el.removeAttribute("disabled");

            for (i in 0 ... el.children.length) {
                enableAllUpPrioriDisabled(el.children.item(i));
            }
        }
    }

    public static function hasChild(el:Element, seekChild:Element):Bool {

        if (el == seekChild) return true;
        else
            for (i in 0 ... el.children.length) {
                if (hasChild(el.children.item(i), seekChild)) {
                    return true;
                }
            }

        return false;
    }

    public static function getBoundingClientRect(el:Element):PriGeomBox {
        try {
            var domRect:DOMRect = el.getBoundingClientRect();
            return new PriGeomBox(domRect.x, domRect.y, domRect.width, domRect.height);

        } catch(e:Dynamic) {
            return new PriGeomBox();
        }
    }

    public static function apply2dTransformation(el:Element, sx:Float, sy:Float, rot:Float, anchorX:Float, anchorY:Float):Void {
        /* matrix reference */
        // SCALE
        // x 0 0
        // 0 y 0
        // 0 0 1

        // ROTATE
        // cosX -sinX   0
        // sinX  cosX   0
        //  0     0     1

//        var rot:Float = this.dh.rotation;
//        var sx:Float = this.dh.scaleX;
//        var sy:Float = this.dh.scaleY;
//
//        var anchorX:Float = this.dh.anchorX*100;
//        var anchorY:Float = this.dh.anchorY*100;

        anchorX = anchorX*100;
        anchorY = anchorY*100;

        var valOrigin:String = '';
        var valMatrix:String = '';

        if ((sx != 1 || sy != 1) && rot == 0) {

            valOrigin = '$anchorX% $anchorY%';
            valMatrix = 'matrix($sx, 0, 0, $sy, 0, 0)';

        } else if (sx != 1 || sy != 1 || rot != 0) {

            var angle:Float = rot * (0.017453292519943295); // (Math.PI/180);
            var aSin:Float = Math.sin(angle);
            var aCos:Float = Math.cos(angle);

            var m1:Array<Array<Float>> = [
                [aCos,      -aSin,      0],
                [aSin,      aCos,       0],
                [0,         0,          1]
            ];

            var m2:Array<Array<Float>> = [
                [sx,        0,          0],
                [0,         sy,         0],
                [0,         0,          1]
            ];

            var calc:Int->Int->Float = function(row:Int, col:Int):Float {
                return (
                    m1[row][0] * m2[0][col] +
                    m1[row][1] * m2[1][col] +
                    m1[row][2] * m2[2][col]
                );
            }

//            var m3:Array<Array<Float>> = [
//                [calc(0, 0), calc(0, 1), calc(0, 2)],
//                [calc(1, 0), calc(1, 1), calc(1, 2)],
//                [calc(2, 0), calc(2, 1), calc(2, 2)]
//            ];

            valOrigin = '$anchorX% $anchorY%';
            valMatrix = 'matrix(${calc(0, 0)}, ${calc(1, 0)}, ${calc(0, 1)}, ${calc(1, 1)}, ${calc(0, 2)}, ${calc(1, 2)})';
        }


        el.style.transformOrigin = valOrigin;
        el.style.transform = valMatrix;

        var browser:PriDeviceBrowser = PriDevice.browser();

        if (browser == PriDeviceBrowser.CHROME || browser == PriDeviceBrowser.WEBKIT) {
            el.style.setProperty("-webkit-transform-origin", valOrigin);
            el.style.setProperty("-webkit-transform", valMatrix);
        } else if (browser == PriDeviceBrowser.MSIE) {
            el.style.setProperty("-ms-transform-origin", valOrigin);
            el.style.setProperty("-ms-transform", valMatrix);
        }

    }
}