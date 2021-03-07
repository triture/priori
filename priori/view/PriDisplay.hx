package priori.view;

import priori.types.PriTransitionType;
import haxe.ds.StringMap;
import priori.app.PriApp;
import helper.browser.BrowserHandler;
import helper.display.DisplayHelperIgnition;
import priori.geom.PriGeomPoint;
import priori.geom.PriGeomBox;
import priori.app.PriApp;
import priori.style.border.PriBorderStyle;
import priori.style.shadow.PriShadowStyle;
import priori.style.filter.PriFilterStyle;
import priori.view.container.PriContainer;
import priori.event.PriEvent;
import priori.event.PriTapEvent;
import priori.event.PriEventDispatcher;
import priori.geom.PriColor;
import helper.display.DisplayHelper;
import helper.browser.DomHelper;
import js.html.Element;
import js.Browser;
import js.jquery.JQuery;

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
    * The object's coordinates refer to the element´s left most point.
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

    /**
    * Indicates the center `x` coordinate of the object relative the local coordinates of the parent PriContainer.
    * The object's coordinates refer to the horizontal center point.
    *
    * `default value : 50`
    **/
    public var centerX(get, set):Float;

    /**
    * Indicates the center `y` coordinate of the object relative the local coordinates of the parent PriContainer.
    * The object's coordinates refer to the vertical center point.
    *
    * `default value : 50`
    **/
    public var centerY(get, set):Float;

    /**
    * Indicates the max `x` coordinate of the object relative the local coordinates of the parent PriContainer.
    * The object's coordinates refer the element´s right most point.
    *
    * `default value : 100`
    **/
    public var maxX(get, set):Float;

    /**
    * Indicates the max `y` coordinate of the object relative the local coordinates of the parent PriContainer.
    * The object's coordinates refer the element´s bottom most point.
    *
    * `default value : 100`
    **/
    public var maxY(get, set):Float;

    public var parent(get, null):PriContainer;

    public var visible(get, set):Bool;
    public var disabled(get, set):Bool;
    public var mouseEnabled(get, set):Bool;
    public var pointer(get, set):Bool;
    public var clipping(get, set):Bool;
    public var rotation(get, set):Float;

    public var testIdentifier(get, set):String;

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

    @:noCompletion
    private var dh:DisplayHelper = DisplayHelperIgnition.getDisplayHerlper();

    public var isDragging(get, null):Bool;

    public function new() {
        super();

        // initialize display
        this.createElement();

        this.dh.eventHelper.jqel = this.dh.element;
        this.dh.eventHelper.jsel = this.dh.jselement;
        this.dh.eventHelper.display = this;
        this.addEventListener(PriEvent.ADDED_TO_APP, this.dh.eventHelper.onAddedToApp);

        this.addEventListener(PriEvent.ADDED, __onAdded);
    }

    private function get_testIdentifier():String {
        #if production
        return '';
        #else
        return this.dh.jselement.getAttribute('test');
        #end
    }

    private function set_testIdentifier(value:String):String {
        #if production
        return value;
        #else
        if (value == "" || value == null) this.dh.jselement.removeAttribute("test");
        else this.dh.jselement.setAttribute("test", value);

        return value;
        #end
    }

    private function get_isDragging():Bool return !(this.dh.dragdata == null);

    public function allowTransition(key:PriTransitionType, time:Float):Void {

        switch (key) {
            case PriTransitionType.POSITION : {
                this.dh.styles.setTransition('left', time);
                this.dh.styles.setTransition('top', time);
            }

            case PriTransitionType.X : {
                this.dh.styles.setTransition('left', time);
            }

            case PriTransitionType.Y : {
                this.dh.styles.setTransition('top', time);
            }

            case PriTransitionType.ALPHA : {
                this.dh.styles.setTransition('opacity', time);
            }

            case PriTransitionType.BACKGROUND_COLOR : {
                this.dh.styles.setTransition('background-color', time);
            }

            case PriTransitionType.TEXT_COLOR : {
                this.dh.styles.setTransition('color', time);
            }
        }

        this.__updateStyle();
    }

    @:noCompletion 
    private function __updateStyle():Void {
        var dh = this.dh;

        if (dh.holdStyleUpdate || dh.jselement == null) return;

        var result:String = dh.styles.getValue();

        if (result != dh.styleString) {
            dh.styleString = result;
            dh.jselement.style.cssText = result;
        }

    }

    @:noCompletion 
    private function __onAdded(e:PriEvent):Void {
        this.updateDepth();
        DomHelper.borderUpdate(this.dh.elementBorder, this.dh);
    }

    @:noCompletion
    private function set_corners(value:Array<Int>):Array<Int> {
        if (value == null || value.length == 0) {
            this.corners = value == null ? null : [];
            this.dh.styles.remove("border-radius");
        } else {
            this.corners = value.copy();
            this.dh.styles.set("border-radius", value.slice(0, 4).join("px ") + "px");
        }

        this.__updateStyle();

        DomHelper.borderUpdate(this.dh.elementBorder, this.dh);

        return value;
    }

    private function set_tooltip(value:String):String {
        if (this.tooltip == value) return value;

        this.tooltip = value;

        if (value == "" || value == null) this.dh.jselement.removeAttribute("title");
        else this.dh.jselement.setAttribute("title", value);

        return value;
    }

    private function set_border(value:PriBorderStyle):PriBorderStyle {
        this.border = value;

        if (value == null) removeBorder();
        else applyBorder();

        return value;
    }

    private function set_shadow(value:Array<PriShadowStyle>):Array<PriShadowStyle> {
        this.shadow = value;

        var shadowString:String = "";

        if (value != null && value.length > 0) shadowString = value.join(",");

        if (shadowString.length == 0) {
            this.dh.styles.remove("box-shadow");
            this.dh.styles.remove("-moz-box-shadow");
            this.dh.styles.remove("-webkit-box-shadow");
        } else {
            this.dh.styles.set("box-shadow", shadowString);
            this.dh.styles.set("-moz-box-shadow", shadowString);
            this.dh.styles.set("-webkit-box-shadow", shadowString);
        }

        this.__updateStyle();

        return value;
    }

    private function set_filter(value:PriFilterStyle):PriFilterStyle {
        this.filter = value;

        var filterString:String = "";
        if (value != null) filterString = value.toString();

        if (filterString.length == 0) {
            this.dh.styles.remove("filter");
            this.dh.styles.remove("-moz-filter");
            this.dh.styles.remove("-webkit-filter");
            this.dh.styles.remove("-o-filter");
            this.dh.styles.remove("-ms-filter");
        } else {
            this.dh.styles.set("filter", filterString);
            this.dh.styles.set("-moz-filter", filterString);
            this.dh.styles.set("-webkit-filter", filterString);
            this.dh.styles.set("-o-filter", filterString);
            this.dh.styles.set("-ms-filter", filterString);
        }

        this.__updateStyle();

        return value;
    }

    private function applyBorder():Void {
        if (this.dh.elementBorder == null) {

            this.dh.elementBorder = js.Browser.document.createElement("div");
            this.dh.elementBorder.className = "priori_stylebase";
            this.dh.elementBorder.style.cssText = 'box-sizing:border-box !important;position:absolute;left:0px;right:0px;bottom:0px;top:0px;pointer-events:none;';
            this.dh.jselement.appendChild(this.dh.elementBorder);
        }

        this.dh.elementBorder.style.border = this.border.toString();

        DomHelper.borderUpdate(this.dh.elementBorder, this.dh);
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
            this.dh.styles.set("overflow", "hidden");
        } else {
            this.dh.clipping = false;
            this.dh.styles.remove("overflow");
        }

        this.__updateStyle();

        return value;
    }

    private function getRandomId(len:Int = 7):String {
        var length:Int = len;
        var charactersToUse:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890";
        var result:String = "";

        result = "";

        for (i in 0...length) {
            result += charactersToUse.charAt(Math.floor((charactersToUse.length * Math.random())));
        }

        result += "_" + Date.now().getTime();

        return result;
    }

    static private var OUTER_DOM_SIZE_CACHE:StringMap<PriGeomBox> = new StringMap<PriGeomBox>();

    private function getOutDOMDimensions():PriGeomBox {
        var element:js.html.DOMElement = this.dh.jselement;

        if (element.cloneNode != null) {
            element = cast this.dh.jselement.cloneNode(true);
            element.style.left = "0px";
            element.style.top = "0px";
            element.style.color = "";
            element.style.zIndex = "";
            element.style.transition = "";
            (cast element.style).pointerEvents = "";
            element.style.cursor = "";
            element.style.backgroundColor = "";
        }
        
        var code:String = element.outerHTML;

        if (OUTER_DOM_SIZE_CACHE.exists(code)) return OUTER_DOM_SIZE_CACHE.get(code);

        PriApp.g().frame.innerHTML = code;

        var box:PriGeomBox = DomHelper.getBoundingClientRect(PriApp.g().frame.getElementsByTagName("div")[0]);

        OUTER_DOM_SIZE_CACHE.set(code, box);

        return box;
    }

    private function get_widthScaled():Float return this.width*this.dh.scaleX;
    private function set_widthScaled(value:Float):Float {
        var thisWidth:Float = this.width;
        if (thisWidth != 0) this.scaleX = (value<0?0:value) / thisWidth;

        return value;
    }

    private function get_heightScaled():Float return this.height*this.dh.scaleY;
    private function set_heightScaled(value:Float):Float {
        var thisHeight:Float = this.height;
        if (thisHeight != 0) this.scaleY = (value<0?0:value) / thisHeight;

        return value;
    }

    private function set_width(value:Float) {
        if (value == null) {
            this.dh.width = null;
            this.dh.styles.remove("width");
        } else {
            this.dh.width = Math.max(0, value);
            this.dh.styles.set("width", this.dh.width + "px");
        }

        this.__updateStyle();

        return value;
    }

    private function get_width():Float {
        var result:Float = this.dh.width;

        if (result == null) {

            result = DomHelper.getBoundingClientRect(this.dh.jselement).width;

            if (result == 0 && !this.hasApp()) {
                result = this.getOutDOMDimensions().width;
                if (this.scaleX != 0 && this.scaleX != 1) result = result/this.scaleX;
            } else {

                var ref = this;
                var refScale:Float = this.scaleX;

                while (ref.parent != null) {
                    ref = ref.parent;
                    refScale = ref.scaleX * refScale;
                }

                if (refScale != 0 && refScale != 1) result = result/refScale;
            }
        }

        return result;
    }

    private function set_height(value:Float):Float {
        if (value == null) {
            this.dh.height = null;
            this.dh.styles.remove("height");
        } else {
            this.dh.height = Math.max(0, value);
            this.dh.styles.set("height", this.dh.height + "px");
        }

        this.__updateStyle();

        return value;
    }

    private function get_height():Float {
        var result:Float = this.dh.height;

        if (result == null) {

            result = result = DomHelper.getBoundingClientRect(this.dh.jselement).height;

            if (result == 0 && !this.hasApp()) {
                result = this.getOutDOMDimensions().height;
                if (this.scaleY != 0 && this.scaleY != 1) result = result/this.scaleY;
            } else {
                var ref = this;
                var refScale:Float = this.scaleY;

                while (ref.parent != null) {
                    ref = ref.parent;
                    refScale = ref.scaleY * refScale;
                }

                if (refScale != 0 && refScale != 1) result = result/refScale;
            }
        }

        return result;
    }


    private function set_maxX(value:Float) {
        this.dh.x = value - this.widthScaled;
        this.dh.styles.set("left", this.dh.x + "px");
        this.__updateStyle();
        return value;
    }

    private function set_maxY(value:Float) {
        this.dh.y = value - this.heightScaled;
        this.dh.styles.set("top", this.dh.y + "px");
        this.__updateStyle();
        return value;
    }

    private function set_centerX(value:Float) {
        this.dh.x = value - this.widthScaled/2;
        this.dh.styles.set("left", this.dh.x + "px");
        this.__updateStyle();

        return value;
    }

    private function set_centerY(value:Float) {
        this.dh.y = value - this.heightScaled/2;
        this.dh.styles.set("top", this.dh.y + "px");
        this.__updateStyle();

        return value;
    }

    private function set_x(value:Float) {
        this.dh.x = value;
        this.dh.styles.set("left", value + "px");
        this.__updateStyle();
        
        return value;
    }

    public function startBatchUpdate():Void this.dh.holdStyleUpdate = true;
    public function endBatchUpdate():Void {
        this.dh.holdStyleUpdate = false;
        this.__updateStyle();
    }


    private function set_y(value:Float) {
        this.dh.y = value;
        this.dh.styles.set("top", value + "px");
        this.__updateStyle();

        return value;
    }

    private function get_x():Float return this.dh.x;
    private function get_y():Float return this.dh.y;
    private function get_maxX():Float return this.x + this.widthScaled;
    private function get_maxY():Float return this.y + this.heightScaled;
    private function get_centerX():Float return this.x + this.widthScaled/2;
    private function get_centerY():Float return this.y + this.heightScaled/2;

    private function get_scaleX():Float return this.dh.scaleX;
    private function set_scaleX(value:Float):Float {
        this.dh.scaleX = value == null ? 1 : value == 0 ? BrowserHandler.MIN_FLOAT_POINT : value;
        DomHelper.apply2dTransformation(this.dh.styles, this.dh.scaleX, this.dh.scaleY, this.dh.rotation, this.dh.anchorX, this.dh.anchorY);
        this.__updateStyle();
        return value;
    }

    private function get_scaleY():Float return this.dh.scaleY;
    private function set_scaleY(value:Float):Float {
        this.dh.scaleY = value == null ? 1 : value == 0 ? BrowserHandler.MIN_FLOAT_POINT : value;
        DomHelper.apply2dTransformation(this.dh.styles, this.dh.scaleX, this.dh.scaleY, this.dh.rotation, this.dh.anchorX, this.dh.anchorY);
        this.__updateStyle();
        return value;
    }

    private function get_anchorX():Float return this.dh.anchorX;
    private function set_anchorX(value:Float):Float {
        this.dh.anchorX = value == null ? 0 : value;
        DomHelper.apply2dTransformation(this.dh.styles, this.dh.scaleX, this.dh.scaleY, this.dh.rotation, this.dh.anchorX, this.dh.anchorY);
        this.__updateStyle();
        return value;
    }

    private function get_anchorY():Float return this.dh.anchorY;
    private function set_anchorY(value:Float):Float {
        this.dh.anchorY = value == null ? 0 : value;
        DomHelper.apply2dTransformation(this.dh.styles, this.dh.scaleX, this.dh.scaleY, this.dh.rotation, this.dh.anchorX, this.dh.anchorY);
        this.__updateStyle();
        return value;
    }

    private function get_rotation():Float return this.dh.rotation;
    private function set_rotation(value:Float):Float {
        this.dh.rotation = value == null ? 0 : value;
        DomHelper.apply2dTransformation(this.dh.styles, this.dh.scaleX, this.dh.scaleY, this.dh.rotation, this.dh.anchorX, this.dh.anchorY);
        this.__updateStyle();
        return value;
    }

    private function get_alpha():Float return this.dh.alpha;
    private function set_alpha(value:Float) {
        this.dh.alpha = value == null ? 1 : value;

        if (value == null || value >= 1) this.dh.styles.remove("opacity");
        else this.dh.styles.set("opacity", Std.string(value));
        this.__updateStyle();

        return value;
    }

    public function hasApp():Bool {
        try {
            var app:PriApp = PriApp.g();
            var tree:Array<PriDisplay> = this.getTreeList();

            if (tree[tree.length - 1] == app) return true;

            return false;
        } catch (e:Dynamic) {
            return false;
        }
    }

    private function get_parent():PriContainer return this.dh.parent;

    private function updateDepth():Void {
        this.dh.depth = this.dh.parent.dh.depth - 1;
        this.dh.styles.set("z-index", Std.string(this.dh.depth));

        if (this.dh.elementBorder != null) this.dh.elementBorder.style.zIndex = Std.string(this.dh.depth);

        this.__updateStyle();
    }

    public function getJSElement():Element return this.dh.jselement;
    public function getElement():JQuery return this.dh.element;


    @:deprecated
    private function setCSS(property:String, value:String):Void {
        this.dh.styles.set(property, value);
        this.__updateStyle();
    }

    @:deprecated
    private function getCSS(property:String):String return this.getElement().css(property);

    private function get_bgColor():PriColor return this.dh.bgColor;
    private function set_bgColor(value:PriColor):PriColor {
        this.dh.bgColor = value;

        if (value == null) this.dh.styles.remove("background-color");
        else this.dh.styles.set("background-color", value.toString());

        this.__updateStyle();

        return value;
    }

    override public function addEventListener(event:String, listener:Dynamic->Void):Void {
        this.dh.eventHelper.registerEvent(event);

        if (event == PriTapEvent.TAP) this.pointer = true;

        super.addEventListener(event, listener);
    }

    override public function removeEventListener(event:String, listener:Dynamic->Void):Void {
        super.removeEventListener(event, listener);

        if (!this.hasEvent(event)) this.dh.eventHelper.removeEvent(event);

        if (event == PriTapEvent.TAP && this.hasEvent(PriTapEvent.TAP) == false) this.pointer = false;
    }

    private function createElement():Void {
        
        var jsElement:Element = js.Browser.document.createElement("div");
        jsElement.className = "priori_stylebase";

        #if prioridebug
        jsElement.setAttribute("priori-class-name", Type.getClassName(Type.getClass(this)));
        #end

        this.dh.jselement = jsElement;

        this.__updateStyle();

        this.dh.element = new JQuery(jsElement);

    }

    public function removeFromParent():Void {
        if (this.dh.parent != null) {
            this.dh.parent.removeChild(this);
        }
    }

    override public function kill():Void {
        this.dh.eventHelper.kill();

        // remove todos os eventos do elemento
        this.getElement().off();
        this.getElement().find("*").off();

        super.kill();
    }

    private function get_visible():Bool return this.dh.visible;
    private function set_visible(value:Bool) {
        if (value == true) {
            this.dh.visible = true;
            this.dh.styles.remove("visibility");
        } else {
            this.dh.visible = false;
            this.dh.styles.set("visibility", "hidden");
        }

        this.__updateStyle();

        return value;
    }

    private function get_pointer():Bool return this.dh.pointer;
    private function set_pointer(value:Bool) {
        if (value == true) {
            this.dh.pointer = true;
            this.dh.styles.set("cursor", "pointer");
        } else {
            this.dh.pointer = false;
            this.dh.styles.remove("cursor");
        }

        this.__updateStyle();

        return value;
    }


    private function get_mouseEnabled():Bool return this.dh.mouseEnabled;
    private function set_mouseEnabled(value:Bool):Bool {
        if (value == true) {
            this.dh.mouseEnabled = true;
            this.dh.styles.remove("pointer-events");
        } else {
            this.dh.mouseEnabled = false;
            this.dh.styles.set("pointer-events", "none");
        }

        this.__updateStyle();

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
            if (!this.hasDisabledParent()) DomHelper.enableAllUpPrioriDisabled(this.dh.jselement);
        }

        return value;
    }


    public function getGlobalBox():PriGeomBox {
        var result:PriGeomBox = new PriGeomBox();

        if (this.hasApp()) {

            var points:PriGeomPoint = this.localToGlobal(new PriGeomPoint(this.x, this.y));

            result.x = points.x;
            result.y = points.y;
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

        for (display in list) {
            result.x -= display.x - display.getJSElement().scrollLeft;
            result.y -= display.y - display.getJSElement().scrollTop;
        }

        return result;
    }

    public function localToGlobal(point:PriGeomPoint):PriGeomPoint {
        var result:PriGeomPoint = point.clone();
        var list:Array<PriDisplay> = this.getTreeList();

        list.shift();

        for (display in list) {
            result.x += display.x - display.getJSElement().scrollLeft;
            result.y += display.y - display.getJSElement().scrollTop;
        }

        return result;
    }


    /**
    * Lets the user drag the specified object. The object remains draggable
    * until explicitly stopped through a call to the PriDisplay.stopDrag() method.
    **/
    public function startDrag(lockCenter:Bool = false, bounds:PriGeomBox = null):Void {
        this.stopDrag();

        this.dispatchEvent(new PriEvent(PriEvent.DRAG_START, false, false, {distance:0.0}));

        this.dh.dragdata = {
            originalPointMouse : PriApp.g().mousePoint,
            originalPosition : new PriGeomPoint(this.x, this.y),
            lastPosition : new PriGeomPoint(this.x, this.y)
        };

        if (lockCenter) {
            if (this.parent != null) {
                var parentMouse:PriGeomPoint = this.parent.mousePoint;
                this.centerX = parentMouse.x;
                this.centerY = parentMouse.y;

                this.dh.dragdata.lastPosition.x = this.x;
                this.dh.dragdata.lastPosition.y = this.y;

                var distance:Float = this.dh.dragdata.originalPosition.distanceFrom(this.dh.dragdata.lastPosition);
                this.dispatchEvent(new PriEvent(PriEvent.DRAG, false, false, {distance:distance}));
            }
        }

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
                this.dh.dragdata.lastPosition.x = this.x;
                this.dh.dragdata.lastPosition.y = this.y;

                var distance:Float = this.dh.dragdata.originalPosition.distanceFrom(this.dh.dragdata.lastPosition);
                this.dispatchEvent(new PriEvent(PriEvent.DRAG, false, false, {distance:distance}));
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
            var distance:Float = this.dh.dragdata.originalPosition.distanceFrom(this.dh.dragdata.lastPosition);

            this.dh.dragdata.t.stop();
            this.dh.dragdata.t.run = null;
            this.dh.dragdata = null;

            this.dispatchEvent(new PriEvent(PriEvent.DRAG_STOP, false, false, {distance:distance}));
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

            var hasAppFocus:Bool = false;

            try {
                hasAppFocus = PriApp.g().hasFocus();
            } catch (e:Dynamic) {

            }

            if (curEl != null && hasAppFocus && DomHelper.hasChild(this.dh.jselement, curEl)) return true;
        } catch (e:Dynamic) {}

        return false;
    }

}
