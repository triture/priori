package helper.display;

import helper.browser.BrowserEventEngine;
import js.html.Element;
import jQuery.JQuery;

class DisplayHelper {

    public var bgColor:Int = null;

    public var x:Float = 0;
    public var y:Float = 0;
    public var width:Float = 100;
    public var height:Float = 100;
    public var clipping:Bool = true;
    public var depth:Int = 1000;
    public var pointer:Bool = false;
    public var focusable:Bool = false;

    public var dragdata:Dynamic;

    public var anchorX:Float = 0.5;
    public var anchorY:Float = 0.5;
    public var rotation:Float = 0;
    public var scaleX:Float = 1;
    public var scaleY:Float = 1;
    public var alpha:Float = 1;
    public var disabled:Bool = false;

    public var priId:String;
    public var element:JQuery;
    public var elementBorder:Element;
    public var jselement:Element;

    public var eventHelper:BrowserEventEngine;

    public function new() {

    }
}
