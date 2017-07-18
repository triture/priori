package priori.view;

import priori.geom.PriColor;
import priori.app.PriApp;
import priori.system.PriDevice;
import priori.app.PriApp;
import priori.system.PriDeviceBrowser;
import helper.display.DisplayHelper;
import priori.geom.PriGeomPoint;
import helper.browser.DomHelper;
import js.html.Window;
import js.Browser;
import js.html.DOMRect;
import priori.geom.PriGeomBox;
import helper.browser.BrowserEventEngine;
import js.html.Element;
import js.jquery.JQuery;
import priori.style.border.PriBorderStyle;
import priori.style.shadow.PriShadowStyle;
import priori.style.filter.PriFilterStyle;
import priori.event.PriEvent;
import priori.event.PriTapEvent;
import priori.view.container.PriContainer;
import priori.event.PriEventDispatcher;
import priori.app.PriApp;

class PriDisplay extends PriEventDispatcher {

    /**
    * Indicates the width of the PriDisplay object, in pixels. The scale or inner children are not affected.
    * If you set `null`, the PriDisplay object try to get the width of inner elements.
    *
    * `default value : 100`
    **/
    public var width(get, set):Float;

    /**
    * Indicates the width of the PriDisplay object, in pixels, after the scaleX effect applied.
    *
    * If you set a value for this property, the scaleX will change to render the object with the desired value.
    *
    **/
    public var widthScaled(get, set):Float;

    /**
    * Indicates the height of the PriDisplay object, in pixels. The scale or inner children are not affected.
    * If you set `null`, the PriDisplay object try to get the height of inner elements.
    *
    * `default value : 100`
    **/
    public var height(get, set):Float;

    /**
    * Indicates the height of the PriDisplay object, in pixels, after the scaleY effect applied.
    *
    * If you set a value for this property, the scaleY will change to render the object with the desired value.
    *
    **/
    public var heightScaled(get, set):Float;

    /**
    * Indicates the `x` coordinate of the PriDisplay instance relative to the local coordinates of the parent PriContainer.
    * The object's coordinates refer to the left most point.
    *
    * `default value : 0`
    **/
    public var x(get, set):Float;

    /**
    * Indicates the `y` coordinate of the PriDisplay instance relative to the local coordinates of the parent PriContainer.
    * The object's coordinates refer to the element´s top most point.
    *
    * `default value : 0`
    **/
    public var y(get, set):Float;

    /**
    * Indicates the coordinates of the mouse or user input device position relative to this object.
    **/
    public var mousePoint(get, null):PriGeomPoint;

    public var centerX(get, set):Float;
    public var centerY(get, set):Float;
    public var maxX(get, set):Float;
    public var maxY(get, set):Float;

    public var parent(get, null):PriContainer;
    private var _parent:PriContainer;


    public var visible(get, set):Bool;
    public var disabled(get, set):Bool;
    public var mouseEnabled(get, set):Bool;
    public var pointer(get, set):Bool;
    public var clipping(get, set):Bool;
    public var rotation(get, set):Float;

    /**
    * Indicates the object can be focused by mouse or keyboard tab key.
    **/
    public var focusable(get, set):Bool;


    /**
    * Indicates the alpha transparency value of the object specified.
    * Valid values are 0(fully transparent) to 1(fully opaque).
    *
    * `default value : 1`
    **/
    public var alpha(get, set):Float;

    @:isVar public var corners(default, set):Array<Int>;
    @:isVar public var tooltip(default, set):String;

    public var bgColor(get, set):PriColor;


    // STYLES PROPERTIES

    @:isVar public var border(default, set):PriBorderStyle;
    @:isVar public var shadow(default, set):Array<PriShadowStyle>;

    /**
    * Defines visual effects for the object.
    *
    * `default value : null`
    **/
    @:isVar public var filter(default, set):PriFilterStyle;


    public var anchorX(get, set):Float;
    public var anchorY(get, set):Float;

    /**
    * Indicates the horizontal scale (percentage) of the object as applied from the anchorX point.
    *
    * This property only affects the rendering of the object, not the width itself. If you need to get the
    * scaled width, use the property `widthScaled`.
    *
    * `default value : 1`
    **/
    public var scaleX(get, set):Float;

    /**
    * Indicates the vertical scale (percentage) of the object as applied from the anchorY point.
    *
    * This property only affects the rendering of the object, not the height itself. If you need to get the
    * scaled height, use the property `heightScaled`.
    *
    * `default value : 1`
    **/
    public var scaleY(get, set):Float;



    private var dh:DisplayHelper = new DisplayHelper();

    public function new() {
        super();

        // initialize display
        this.dh.priId = this.getRandomId();
        this.createElement();

        this.dh.eventHelper = new BrowserEventEngine();
        this.dh.eventHelper.jqel = this.dh.element;
        this.dh.eventHelper.jsel = this.dh.jselement;
        this.dh.eventHelper.display = this;
        this.addEventListener(PriEvent.ADDED_TO_APP, this.dh.eventHelper.onAddedToApp);

        this.addEventListener(PriEvent.ADDED, __onAdded);
    }

    private function __onAdded(e:PriEvent):Void {
        this.updateDepth();
        this.updateBorderDisplay();
    }

    private function set_corners(value:Array<Int>):Array<Int> {
        this.corners = value;

        if (value == null) {
            this.dh.jselement.style.borderRadius = "";
        } else {

            var tempArray:Array<Int> = value.copy();

            var n:Int = tempArray.length;

            if (n == 0) {
                this.dh.jselement.style.borderRadius = "";
            } else {
                if (n > 4) tempArray = tempArray.splice(0, 4);
                this.dh.jselement.style.borderRadius = tempArray.join("px ") + "px";
            }
        }

        this.updateBorderDisplay();

        return value;
    }

    private function set_tooltip(value:String):String {
        this.tooltip = value;
        this.getElement().attr("title", value == "" ? null : value);
        return value;
    }

    private function set_border(value:PriBorderStyle):PriBorderStyle {
        this.border = value;

        if (value == null) {
            removeBorder();
        } else {
            applyBorder();
        }

        return value;
    }

    private function set_shadow(value:Array<PriShadowStyle>):Array<PriShadowStyle> {
        this.shadow = value;

        var shadowString:String = "";
        if (value != null && value.length > 0) shadowString = value.join(",");

        this.setCSS("-webkit-box-shadow", shadowString);
        this.setCSS("-moz-box-shadow", shadowString);
        this.setCSS("-o-box-shadow", shadowString);
        this.setCSS("box-shadow", shadowString);

        return value;
    }

    private function set_filter(value:PriFilterStyle):PriFilterStyle {
        this.filter = value;

        var filterString:String = "";
        if (value != null) filterString = value.toString();

        this.setCSS("-webkit-filter", filterString);
        this.setCSS("-ms-filter", filterString);
        this.setCSS("-o-filter", filterString);
        this.setCSS("filter", filterString);

        return value;
    }

    private function applyBorder():Void {
        if (this.dh.elementBorder == null) {

            this.dh.elementBorder = js.Browser.document.createElement("div");
            this.dh.elementBorder.id = this.dh.priId;
            this.dh.elementBorder.className = "priori_stylebase";
            this.dh.elementBorder.style.cssText = 'box-sizing:border-box !important;position:absolute;left:0px;right:0px;bottom:0px;top:0px;pointer-events:none;';
            this.dh.jselement.appendChild(this.dh.elementBorder);
        }

        this.dh.elementBorder.style.border = this.border.toString();

        this.updateBorderDisplay();
    }

    private function updateBorderDisplay():Void {
        if (this.dh.elementBorder != null) {
            this.dh.elementBorder.style.borderRadius = this.dh.jselement.style.borderRadius;
            this.dh.elementBorder.style.zIndex = this.dh.jselement.style.zIndex;
        }
    }

    private function removeBorder():Void {
        if (this.dh.elementBorder != null) {
            this.dh.jselement.removeChild(this.dh.elementBorder);
            this.dh.elementBorder = null;
        }
    }

    private function get_clipping():Bool return this.dh.clipping;
    private function set_clipping(value:Bool) {
        if (value) {
            this.dh.clipping = true;
            this.dh.jselement.style.overflow = "hidden";
        } else {
            this.dh.clipping = false;
            this.dh.jselement.style.overflow = "";
        }

        return value;
    }

    private function getRandomId(len:Int = 7):String {
        var length:Int = len;
        var charactersToUse:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        var result:String = "";

        result = "";

        for (i in 0...length) {
            result += charactersToUse.charAt(Math.floor((charactersToUse.length * Math.random())));
        }

        result += "_" + Date.now().getTime();

        return result;
    }

    private function getOutDOMDimensions():{w:Float, h:Float} {
        var w:Float = 0;
        var h:Float = 0;

        var clone:JQuery = this.dh.element.clone(false);

        var body:JQuery = new JQuery("body");
        body.append(clone);

        w = clone[0].getBoundingClientRect().width;
        h = clone[0].getBoundingClientRect().height;

        clone.remove();

        clone = null;

        return {
            w : w,
            h : h
        };
    }

    private function get_widthScaled():Float return this.width*this.dh.scaleX;
    private function set_widthScaled(value:Float):Float {
        this.scaleX = value / this.width;
        return value;
    }

    private function get_heightScaled():Float return this.height*this.dh.scaleY;
    private function set_heightScaled(value:Float):Float {
        this.scaleY = value / this.height;
        return value;
    }

    private function set_width(value:Float) {
        if (value == null) {
            this.dh.width = null;
            this.dh.jselement.style.width = "";
        } else {
            this.dh.width = Math.max(0, value);
            this.dh.jselement.style.width = this.dh.width + "px";
        }

        return value;
    }

    private function get_width():Float {
        var result:Float = this.dh.width;

        if (result == null) {
            result = this.dh.jselement.getBoundingClientRect().width;

            if (result == 0 && !this.hasApp()) result = this.getOutDOMDimensions().w;
        }

        return result;
    }

    private function set_height(value:Float):Float {
        if (value == null) {
            this.dh.height = null;
            this.dh.jselement.style.height = "";
        } else {
            this.dh.height = Math.max(0, value);
            this.dh.jselement.style.height = this.dh.height + "px";
        }

        return value;
    }

    private function get_height():Float {
        var result:Float = this.dh.height;

        if (result == null) {
            result = this.dh.jselement.getBoundingClientRect().height;
            if (result == 0 && !this.hasApp()) result = this.getOutDOMDimensions().h;
        }
        return result;
    }


    private function set_maxX(value:Float) {
        this.x = value - this.width;
        return value;
    }

    private function set_maxY(value:Float) {
        this.y = value - this.height;
        return value;
    }

    private function set_centerX(value:Float) {
        this.x = value - this.width/2;
        return value;
    }

    private function set_centerY(value:Float) {
        this.y = value - this.height/2;
        return value;
    }

    private function set_x(value:Float) {
        this.dh.x = value;
        this.dh.jselement.style.left = value + "px";
        return value;
    }


    private function set_y(value:Float) {
        this.dh.y = value;
        this.dh.jselement.style.top = value + "px";
        return value;
    }

    private function get_x():Float return this.dh.x;
    private function get_y():Float return this.dh.y;
    private function get_maxX():Float return this.x + this.width;
    private function get_maxY():Float return this.y + this.height;
    private function get_centerX():Float return this.x + this.width/2;
    private function get_centerY():Float return this.y + this.height/2;

    private function get_scaleX():Float return this.dh.scaleX;
    private function set_scaleX(value:Float):Float {
        this.dh.scaleX = value == null ? 1 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function get_scaleY():Float return this.dh.scaleY;
    private function set_scaleY(value:Float):Float {
        this.dh.scaleY = value == null ? 1 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function get_anchorX():Float return this.dh.anchorX;
    private function set_anchorX(value:Float):Float {
        this.dh.anchorX = value == null ? 0 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function get_anchorY():Float return this.dh.anchorY;
    private function set_anchorY(value:Float):Float {
        this.dh.anchorY = value == null ? 0 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function get_rotation():Float return this.dh.rotation;
    private function set_rotation(value:Float):Float {
        this.dh.rotation = value == null ? 0 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function __applyMatrixTransformation():Void {

        /* matrix reference */
        // SCALE
        // x 0 0
        // 0 y 0
        // 0 0 1

        // ROTATE
        // cosX -sinX   0
        // sinX  cosX   0
        //  0     0     1

        var rot:Float = this.dh.rotation;
        var sx:Float = this.dh.scaleX;
        var sy:Float = this.dh.scaleY;

        var anchorX:Float = this.dh.anchorX*100;
        var anchorY:Float = this.dh.anchorY*100;

        var valOrigin:String = '';
        var valMatrix:String = '';

        if ((sx != 1 || sy != 1) && rot == 0) {

            valOrigin = '$anchorX% $anchorY%';
            valMatrix = 'matrix($sx, 0, 0, $sy, 0, 0)';

        } else if (sx != 1 || sy != 1 || rot != 0) {

            var angle:Float = rot * (Math.PI/180);
            var aSin:Float = Math.sin(angle);
            var aCos:Float = Math.cos(angle);

            var m1:Array<Array<Float>> = [[aCos, -aSin, 0], [aSin, aCos, 0], [0, 0, 1]];
            var m2:Array<Array<Float>> = [[sx, 0, 0], [0, sy, 0], [0, 0, 1]];

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

        this.setCSS("-ms-transform-origin", valOrigin);
        this.setCSS("-webkit-transform-origin", valOrigin);
        this.setCSS("transform-origin", valOrigin);

        this.setCSS("-ms-transform", valMatrix);
        this.setCSS("-webkit-transform", valMatrix);
        this.setCSS("transform", valMatrix);
    }

    private function get_alpha():Float return this.dh.alpha;
    private function set_alpha(value:Float) {
        this.dh.alpha = value;
        if (this.dh.alpha == 1) this.setCSS("opacity", "");
        else this.setCSS("opacity", Std.string(value));
        return value;
    }

    public function hasApp():Bool {
        var app:PriApp = PriApp.g();
        var tree:Array<PriDisplay> = this.getTreeList();

        if (tree[tree.length - 1] == app) return true;

        return false;
    }

    private function get_parent():PriContainer {
        return this._parent;
    }

    public function getPrid():String {
        return this.dh.priId;
    }

    private function updateDepth():Void {
        this.dh.depth = this._parent.dh.depth - 1;
        this.dh.jselement.style.zIndex = Std.string(this.dh.depth);

        if (this.dh.elementBorder != null) this.dh.elementBorder.style.zIndex = Std.string(this.dh.depth);

    }

    public function getJSElement():Element {
        return this.dh.jselement;
    }

    public function getElement():JQuery {
        return this.dh.element;
    }

    private function setCSS(property:String, value:String):Void this.dh.element.css(property, value);
    private function getCSS(property:String):String return this.getElement().css(property);

    private function get_bgColor():PriColor return this.dh.bgColor;
    private function set_bgColor(value:PriColor):PriColor {
        this.dh.bgColor = value;

        if (value == null) {
            this.dh.jselement.style.backgroundColor = "";
        } else {
            this.dh.jselement.style.backgroundColor = value;
        }

        return value;
    }

    override public function addEventListener(event:String, listener:Dynamic->Void):Void {
        this.dh.eventHelper.registerEvent(event);

        if (event == PriTapEvent.TAP) {
            this.pointer = true;
        }

        super.addEventListener(event, listener);
    }

    override public function removeEventListener(event:String, listener:Dynamic->Void):Void {
        super.removeEventListener(event, listener);

        if (!this.hasEvent(event)) this.dh.eventHelper.removeEvent(event);

        if (event == PriTapEvent.TAP && this.hasEvent(PriTapEvent.TAP) == false) {
            this.pointer = false;
        }
    }

    private function createElement():Void {
        
        var jsElement:Element = js.Browser.document.createElement("div");
        jsElement.id = this.dh.priId;
        jsElement.className = "priori_stylebase";
        jsElement.style.cssText = 'left:0px;top:0px;width:${this.dh.width}px;height:${this.dh.height}px;overflow:hidden;';

        this.dh.jselement = jsElement;
        this.dh.element = new JQuery(jsElement);

    }

    public function removeFromParent():Void {
        if (this._parent != null) {
            this._parent.removeChild(this);
        }
    }

    override public function kill():Void {
        this.dh.eventHelper.kill();

        // remove todos os eventos do elemento
        this.getElement().off();
        this.getElement().find("*").off();

        super.kill();
    }

    private function get_visible():Bool {
        if (this.getCSS("visibility") == "hidden") return false;
        return true;
    }

    private function set_visible(value:Bool) {
        if (value == true) {
            this.setCSS("visibility", "");
        } else {
            this.setCSS("visibility", "hidden");
        }

        return value;
    }

    private function get_pointer():Bool return this.dh.pointer;
    private function set_pointer(value:Bool) {
        if (value == true) {
            this.dh.pointer = true;
            this.dh.jselement.style.cursor = "pointer";
        } else {
            this.dh.pointer = false;
            this.dh.jselement.style.cursor = "";
        }

        return value;
    }


    private function get_mouseEnabled():Bool {
        return (this.getElement().css("pointer-events") != "none");
    }

    private function set_mouseEnabled(value:Bool):Bool {
        if (!value) {
            this.getElement().css("pointer-events", "none");
        } else {
            this.getElement().css("pointer-events", "");
        }

        return value;
    }


    public function hasDisabledParent():Bool {
        if (this.parent != null) {
            if (this.parent.disabled) return true;
            else if (this.parent.hasDisabledParent()) return true;
        }
        return false;
    }

    private function get_disabled():Bool {
        if (this.dh.disabled || this.dh.jselement.hasAttribute("disabled")) return true;
        return false;
    }

    private function set_disabled(value:Bool) {
        this.dh.disabled = value;

        if (value) {
            this.dh.jselement.setAttribute("priori-disabled", "disabled");
            DomHelper.disableAll(this.dh.jselement);
        } else {
            this.dh.jselement.removeAttribute("priori-disabled");

            if (!this.hasDisabledParent()) {
                DomHelper.enableAllUpPrioriDisabled(this.dh.jselement);
            }
        }

        return value;
    }


    public function getGlobalBox():PriGeomBox {
        var result:PriGeomBox = new PriGeomBox();

        if (this.hasApp()) {
            if (this.dh.jselement.getBoundingClientRect != null) {
                var box:DOMRect = this.dh.jselement.getBoundingClientRect();

                var body:Element = Browser.document.body;
                var docElem:Element = Browser.document.documentElement;
                var window:Window = Browser.window;

                var scrollTop:Int =
                    window.pageYOffset != null ? window.pageYOffset :
                    docElem.scrollTop != null ? docElem.scrollTop : body.scrollTop;

                var scrollLeft:Int =
                    window.pageXOffset != null ? window.pageXOffset :
                    docElem.scrollLeft != null ? docElem.scrollLeft : body.scrollLeft;

                var clientTop:Int =
                    docElem.clientTop != null ? docElem.clientTop :
                    body.clientTop != null ? body.clientTop : 0;

                var clientLeft:Int =
                    docElem.clientLeft != null ? docElem.clientLeft :
                    body.clientLeft != null ? body.clientLeft : 0;

                var top:Int  = Std.int(box.top +  scrollTop - clientTop);
                var left:Int = Std.int(box.left + scrollLeft - clientLeft);

                result.x = Math.fround(left);
                result.y = Math.fround(top);
            } else {
                var el:Element = this.dh.jselement;

                var top:Int = 0;
                var left:Int = 0;

                while (el != null) {
                    top += el.offsetTop;
                    left += el.offsetLeft;

                    el = el.offsetParent;
                }

                result.x = top;
                result.y = top;
            }
        }

        result.width = this.width;
        result.height = this.height;

        return result;
    }


    public function getTreeList():Array<PriDisplay> {
        var result:Array<PriDisplay> = [];

        result.push(this);

        var p:PriDisplay = this.parent;

        while(p != null) {
            result.push(p);
            p = p.parent;
        }

        return result;
    }

    private function get_mousePoint():PriGeomPoint {
        var app:PriApp = PriApp.g();
        return this.globalToLocal(new PriGeomPoint(app.mousePoint.x, app.mousePoint.y));
    }

    public function globalToLocal(point:PriGeomPoint):PriGeomPoint {
        var result:PriGeomPoint = point.clone();
        var list:Array<PriDisplay> = this.getTreeList();

        list.reverse();

        for (i in 0 ... list.length) {
            var el:PriDisplay = list[i];

            result.x -= el.x + el.getJSElement().scrollLeft;
            result.y -= el.y + el.getJSElement().scrollTop;
        }

        return result;
    }

    public function localToGlobal(point:PriGeomPoint):PriGeomPoint {
        var result:PriGeomPoint = point.clone();
        var list:Array<PriDisplay> = this.getTreeList();

        list.shift();

        for (i in 0 ... list.length) {
            var el:PriDisplay = list[i];

            result.x += el.x - el.getJSElement().scrollLeft;
            result.y += el.y - el.getJSElement().scrollTop;
        }

        return result;
    }


    /**
    * Lets the user drag the specified object. The object remains draggable
    * until explicitly stopped through a call to the PriDisplay.stopDrag() method.
    **/
    public function startDrag(lockCenter:Bool = false, bounds:PriGeomBox = null):Void {
        this.stopDrag();

        if (lockCenter) {
            if (this.parent != null) {
                var parentMouse:PriGeomPoint = this.parent.mousePoint;
                this.centerX = parentMouse.x;
                this.centerY = parentMouse.y;

                this.dispatchEvent(new PriEvent(PriEvent.DRAG));
            }
        }

        this.dh.dragdata = {};
        this.dh.dragdata.originalPointMouse = PriApp.g().mousePoint;
        this.dh.dragdata.originalPosition = new PriGeomPoint(this.x, this.y);
        this.dh.dragdata.lastPosition = new PriGeomPoint(this.x, this.y);

        var runFunction = function():Void {
            var curPoint:PriGeomPoint = PriApp.g().mousePoint;
            var diffx:Float = curPoint.x - this.dh.dragdata.originalPointMouse.x;
            var diffy:Float = curPoint.y - this.dh.dragdata.originalPointMouse.y;

            if (bounds == null) {
                this.x = this.dh.dragdata.originalPosition.x + diffx;
                this.y = this.dh.dragdata.originalPosition.y + diffy;
            } else {
                this.x = Math.max(Math.min(this.dh.dragdata.originalPosition.x + diffx, bounds.x + bounds.width), bounds.x);
                this.y = Math.max(Math.min(this.dh.dragdata.originalPosition.y + diffy, bounds.y + bounds.height), bounds.y);
            }

            if (this.dh.dragdata.lastPosition.x != this.x || this.dh.dragdata.lastPosition.y != this.y) {
                this.dispatchEvent(new PriEvent(PriEvent.DRAG));
                this.dh.dragdata.lastPosition.x = this.x;
                this.dh.dragdata.lastPosition.y = this.y;
            }
        }

        var timer:haxe.Timer = new haxe.Timer(30);
        timer.run = runFunction;
        this.dh.dragdata.t = timer;

        runFunction();
    }
    
    /**
    * Ends the startDrag() method. An object that was made draggable with the startDrag() method
    * remains draggable until a stopDrag() method is called.
    **/
    public function stopDrag():Void {
        if (this.dh.dragdata != null) {
            this.dh.dragdata.t.stop();
            this.dh.dragdata = null;
        }
    }


    private function get_focusable():Bool return this.dh.focusable;
    private function set_focusable(value:Bool):Bool {
        if (this.dh.focusable != value) {
            this.dh.focusable = value;
            this.dh.jselement.tabIndex = value ? 0 : null;
        }
        return value;
    }

    /**
    * Sets focus to this object if focusable. Does not check for visibility, enabled state, or any other conditions.
    **/
    public function setFocus():Void if (this.focusable) this.dh.jselement.focus();

    /**
    * Removes focus of this object if focusable. Does not check for visibility, enabled state, or any other conditions.
    **/
    public function removeFocus():Void if (this.focusable) this.dh.jselement.blur();

    /**
    * Check if this object has the browser focus at the moment.
    **/
    public function hasFocus():Bool {
        try {
            var curEl:Element = Browser.document.activeElement;
            if (curEl != null && PriApp.g().hasFocus() && DomHelper.hasChild(this.dh.jselement, curEl)) return true;
        } catch (e:Dynamic) {}

        return false;
    }

}
