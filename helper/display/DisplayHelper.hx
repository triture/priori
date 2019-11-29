package helper.display;

import priori.view.container.PriContainer;
import priori.geom.PriGeomPoint;
import priori.geom.PriColor;
import helper.browser.BrowserEventEngine;
import js.html.Element;
import js.jquery.JQuery;
import haxe.Timer;

private typedef DragData = {
    var originalPointMouse:PriGeomPoint;
    var originalPosition:PriGeomPoint;
    var lastPosition:PriGeomPoint;
    @:optional var t:Timer;
}

class PriMap {

    var keys:Dynamic = {};
    var values:Array<String> = [];

    public function new() {

    }

    public function set(key:String, value:String):Void {

        var val:String = "";

        if (value == null || value.length == 0) val = "";
        else val = key + ":" + value + ";";

        var index:Int = this.keys[cast "$" + key];

        if (index == null) {
            this.keys[cast "$" + key] = this.values.length;
            this.values.push(val);
        } else {
            this.values[index] = val;
        }
    }

    public function remove(key:String):Void this.set(key, null);

    public function getValue():String {
        var c:String = "";

        for (item in this.values) c += item;

        return c;
    }


}

typedef DisplayHelper = {
    var bgColor:PriColor;

    var x:Float;
    var y:Float;
    var width:Float;
    var height:Float;
    var clipping:Bool;
    var depth:Int;
    var pointer:Bool;
    var focusable:Bool;
    var visible:Bool;
    var mouseEnabled:Bool;

    @:optional var dragdata:DragData;

    var anchorX:Float;
    var anchorY:Float;
    var rotation:Float;
    var scaleX:Float;
    var scaleY:Float;
    var alpha:Float;
    var disabled:Bool;

    @:optional var element:JQuery;
    @:optional var elementBorder:Element;
    @:optional var jselement:Element;

    @:optional var parent:PriContainer;

    var eventHelper:BrowserEventEngine;

    var styles:PriMap;
    var styleString:String;
    var holdStyleUpdate:Bool;
}
