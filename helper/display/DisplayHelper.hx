package helper.display;

import haxe.ds.StringMap;
import priori.view.container.PriContainer;
import haxe.Timer;
import priori.geom.PriGeomPoint;
import priori.geom.PriColor;
import helper.browser.BrowserEventEngine;
import js.html.Element;
import js.jquery.JQuery;

private typedef DragData = {
    var originalPointMouse:PriGeomPoint;
    var originalPosition:PriGeomPoint;
    var lastPosition:PriGeomPoint;
    @:optional var t:Timer;
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

    var dragdata:DragData;

    var anchorX:Float;
    var anchorY:Float;
    var rotation:Float;
    var scaleX:Float;
    var scaleY:Float;
    var alpha:Float;
    var disabled:Bool;

    var element:JQuery;
    var elementBorder:Element;
    var jselement:Element;

    var parent:PriContainer;

    var eventHelper:BrowserEventEngine;

    var styles:StringMap<String>;
    var styleString:String;
    var holdStyleUpdate:Bool;
}
