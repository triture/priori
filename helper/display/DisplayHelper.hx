package helper.display;

import haxe.ds.StringMap;
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

    private var map:StringMap<String>;
    private var transition:StringMap<String>;

    private var cache:String;

    public function new() {
        this.map = new StringMap<String>();
        this.transition = new StringMap<String>();
    }

    public function set(key:String, value:String):Void {
        if (value == null || value.length == 0) {
            this.remove(key);
        } else if (this.map.get(key) != value) {
            this.map.set(key, value);
            this.cache = null;
        }
    }

    public function setTransition(key:String, seconds:Float):Void {
        if (seconds == null || seconds <= 0) {
            this.transition.remove(key);
            this.cache = null;
        } else if (this.transition.get(key) != seconds + 's') {
            this.transition.set(key, seconds + 's');
            this.cache = null;
        }
    }

    public function remove(key:String):Void {
        if (!this.map.exists(key)) return;

        this.cache = null;
        this.map.remove(key);
    }

    public function getValue():String {
        if (this.cache != null) return this.cache;
        
        var c:String = "";

        for (key in this.map.keys()) c += key + ':' + this.map.get(key) + ';';
        
        var t:String = "";
        for (key in this.transition.keys()) t = t + (t.length > 0 ? ',' : '') + key + ' ' + this.transition.get(key);
        
        if (t.length > 0) {
            c += 'transition:' + t + ';';
            c += '-webkit-transition:' + t + ';';
        }

        this.cache = c;

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
