package priori.view;

import js.html.Element;
import jQuery.Event;
import jQuery.JQuery;
import priori.style.shadow.PriShadowStyle;
import priori.event.PriEvent;
import priori.style.border.PriBorderStyle;
import priori.event.PriMouseEvent;
import priori.event.PriSwipeEvent;
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
    public var widthScaled(get, set):Float;

    /**
    * Indicates the height of the PriDisplay object, in pixels. The scale or inner children are not affected.
    * If you set `null`, the PriDisplay object try to get the height of inner elements.
    *
    * `default value : 100`
    **/
    public var height(get, set):Float;
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

    public var centerX(get, set):Float;
    public var centerY(get, set):Float;
    public var maxX(get, set):Float;
    public var maxY(get, set):Float;

    public var parent(get, null):PriContainer;
    public var visible(get, set):Bool;

    public var disabled(get, set):Bool;
    public var mouseEnabled(get, set):Bool;
    public var pointer(get, set):Bool;
    public var clipping(get, set):Bool;

    private var _alpha:Float = 1;
    /**
    * Indicates the alpha transparency value of the object specified.
    * Valid values are 0(fully transparent) to 1(fully opaque).
    *
    * `default value : 1`
    **/
    public var alpha(get, set):Float;

    @:isVar public var rotation(default, set):Float;
    @:isVar public var corners(default, set):Array<Int>;
    @:isVar public var border(default, set):PriBorderStyle;
    @:isVar public var shadow(default, set):Array<PriShadowStyle>;
    @:isVar public var tooltip(default, set):String;

    @:isVar public var bgColor(default, set):Int;

    @:isVar public var anchorX(default, set):Float = 0;
    @:isVar public var anchorY(default, set):Float = 0;

    private var _scaleX:Float = 1;
    private var _scaleY:Float = 1;

    public var scaleX(get, set):Float;
    public var scaleY(get, set):Float;

    private var _priId:String;
    private var _element:JQuery;
    private var _elementBorder:JQuery;
    private var _jselement:Element;

    private var _parent:PriContainer;

    private var _specialEventList:Array<String>;
    private var _specialEventStack:Array<Dynamic>;

    public function new() {
        super();

        this._specialEventStack = [];
        this._specialEventList = [];

        // initialize display
        this._priId = this.getRandomId();
        this.createElement();

        this.x = 0;
        this.y = 0;
        this.width = 100;
        this.height = 100;

        this.rotation = 0;

        this.addEventListener(PriEvent.ADDED, __onAdded);
    }

    private function __onAdded(e:PriEvent):Void {
        this.updateDepth();
        this.updateBorderDisplay();
    }

    private function set_corners(value:Array<Int>):Array<Int> {
        this.corners = value;

        if (value == null) {
            this.getElement().css("border-radius", "");
        } else {

            var tempArray:Array<Int> = value.copy();

            var n:Int = tempArray.length;

            if (n == 0) {
                this.getElement().css("border-radius", "");
            } else {
                if (n > 4) tempArray = tempArray.splice(0, 4);

                this.getElement().css("border-radius", tempArray.join("px ") + "px");
            }
        }


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

        if (value == null || value.length == 0) {
            this.setCSS("-webkit-box-shadow", "");
            this.setCSS("-moz-box-shadow", "");
            this.setCSS("box-shadow", "");
        } else {
            var shadowString:String = value.join(",");

            this.setCSS("-webkit-box-shadow", shadowString);
            this.setCSS("-moz-box-shadow", shadowString);
            this.setCSS("box-shadow", shadowString);
        }

        return value;
    }

    private function applyBorder():Void {
        if (this._elementBorder == null) {
            this._elementBorder = new JQuery('<div style="
                box-sizing:border-box !important;
                position:absolute;
                width:inherit;
                height:inherit;
                pointer-events:none;"></div>');

            this.getElement().append(this._elementBorder);

            this.addEventListener(PriEvent.SCROLL, onScrollUpdateBorder);
        }

        this._elementBorder.css("border", this.border.toString());

        this.updateBorderDisplay();
    }

    private function onScrollUpdateBorder(e:PriEvent):Void {
        this.updateBorderDisplay();
    }

    private function updateBorderDisplay():Void {
        if (this._elementBorder != null) {
            this._elementBorder.css("top", this.getElement().scrollTop() + "px");
            this._elementBorder.css("left", this.getElement().scrollLeft() + "px");
            this._elementBorder.css("border-radius", this.getElement().css("border-radius"));
            this._elementBorder.css("z-index", this.getElement().css("z-index"));
        }
    }

    private function removeBorder():Void {
        if (_elementBorder != null) {
            this.removeEventListener(PriEvent.SCROLL, onScrollUpdateBorder);

            this._elementBorder.remove();
            this._elementBorder = null;
        }
    }

    private function get_clipping():Bool {
        if (this.getCSS("overflow") == "hidden") return true;
        return false;
    }

    private function set_clipping(value:Bool) {
        if (value) {
            this.setCSS("overflow", "hidden");
        } else {
            this.setCSS("overflow", "");
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

        var clone:JQuery = this._element.clone(false);

        var body:JQuery = new JQuery("body");
        body.append(clone);

        w = clone.width();
        h = clone.height();

        clone.remove();

        clone = null;

        return {
            w : w,
            h : h
        };
    }


    private function get_widthScaled():Float return this.width*this._scaleX;
    private function set_widthScaled(value:Float):Float {
        this.width = value / this._scaleX;
        return value;
    }

    private function get_heightScaled():Float return this.height*this._scaleY;
    private function set_heightScaled(value:Float):Float {
        this.height = value / this._scaleY;
        return value;
    }

    private function set_width(value:Float) {
        if (value == null) {
            this.setCSS("width", "");
        } else {
            this.setCSS("width", Std.int(value) + "px");
        }
        return value;
    }

    private function get_width():Float {
        var value = this.getElement().width();
        if (value == 0 && !this.hasApp()) value = this.getOutDOMDimensions().w;
        return value;
    }

    private function set_height(value:Float):Float {
        if (value == null) {
            this.setCSS("height", "");
        } else {
            this.setCSS("height", Std.int(value) + "px");
        }

        return value;
    }

    private function get_height():Float {
        var value = this.getElement().height();
        if (value == 0 && !this.hasApp()) value = this.getOutDOMDimensions().h;
        return value;
    }

    private function get_maxX():Float {
        return this.x + this.width;
    }

    private function set_maxX(value:Float) {
        this.x = value - this.width;
        return value;
    }

    private function get_maxY():Float {
        return this.y + this.height;
    }

    private function set_maxY(value:Float) {
        this.y = value - this.height;
        return value;
    }


    private function set_centerX(value:Float) {
        this.x = value - this.width/2;
        return value;
    }

    private function get_centerX():Float {
        return this.x + this.width/2;
    }

    private function set_centerY(value:Float) {
        this.y = value - this.height/2;
        return value;
    }

    private function get_centerY():Float {
        return this.y + this.height/2;
    }


    private function set_x(value:Float) {
        this.getJSElement().style.left = untyped value.toString(10) + "px";
        return value;
    }

    private function get_x():Float {
        return Std.parseInt(this.getJSElement().style.left.split("px")[0]);
    }

    private function set_y(value:Float) {
        this.getJSElement().style.top = untyped value.toString(10) + "px";
        return value;
    }

    private function get_y():Float {
        return Std.parseInt(this.getJSElement().style.top.split("px")[0]);
    }

    private function get_scaleX():Float return this._scaleX;
    private function set_scaleX(value:Float):Float {
        trace(value);
        this._scaleX = value == null ? 1 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function get_scaleY():Float return this._scaleY;
    private function set_scaleY(value:Float):Float {
        this._scaleY = value == null ? 1 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function set_anchorX(value:Float):Float {
        this.anchorX = value == null ? 0 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function set_anchorY(value:Float):Float {
        this.anchorY = value == null ? 0 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function set_rotation(value:Float):Float {
        this.rotation = value > 360 ? value = value % 360 : value;
        this.__applyMatrixTransformation();
        return value;
    }

    private function __applyMatrixTransformation():Void {
//        var angle:Float = this.rotation;
//        var aSin:Float = Math.sin(angle);
//        var aCos:Float = Math.cos(angle);

        var sx:Float = this.scaleX;
        var sy:Float = this.scaleY;
        var anchorX:Float = this.anchorX*100;
        var anchorY:Float = this.anchorY*100;

        var valOrigin:String = '';
        var valMatrix:String = '';

        if (sx != 1 || sy != 1) {
            valOrigin = '$anchorX% $anchorY%';
            valMatrix = 'matrix($sx, 0, 0, $sy, 0, 0)';
        }

        this.setCSS("-ms-transform-origin", valOrigin);
        this.setCSS("-webkit-transform-origin", valOrigin);
        this.setCSS("transform-origin", valOrigin);

        this.setCSS("-ms-transform", valMatrix);
        this.setCSS("-webkit-transform", valMatrix);
        this.setCSS("transform", valMatrix);
    }

    private function get_alpha():Float return this._alpha;
    private function set_alpha(value:Float) {
        this._alpha = value;
        if (this._alpha == 1) this.setCSS("opacity", "");
        else this.setCSS("opacity", Std.string(value));
        return value;
    }

    public function hasApp():Bool {
        var priAppId:String = PriApp.g().getPrid();
        if (this.getElement().parents("#" + priAppId).length > 0) return true;
        return false;
    }

    private function get_parent():PriContainer {
        return this._parent;
    }

    public function getPrid():String {
        return this._priId;
    }

    public function updateDepth():Void {
        var dep:Int = this.getElement().parents().length;
        this.getElement().css("z-index", 1000 - dep);
        if (this._elementBorder != null) this._elementBorder.css("z-index", 1000 - dep);

    }

    public function getJSElement():Element {
        return _jselement;
    }

    public function getElement():JQuery {
        return this._element;
    }

    private function setCSS(property:String, value:String):Void {
        this.getElement().css(property, value);
    }

    private function getCSS(property:String):String {
        return this.getElement().css(property);
    }

    private function set_bgColor(value:Int):Int {
        this.bgColor = value;

        if (value == null) {
            this.setCSS("background-color", "");
        } else {
            this.setCSS("background-color", "#" + StringTools.hex(value, 6));
        }

        return value;
    }

    override public function addEventListener(event:String, listener:Dynamic->Void):Void {

        // tap events
        if (event == PriTapEvent.TAP && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriTapEvent.TAP, _onJTouch_tap);
        } else if (event == PriTapEvent.TAP_DOWN && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriTapEvent.TAP_DOWN, _onJTouch_tapdown);
        } else if (event == PriTapEvent.TAP_UP && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriTapEvent.TAP_UP, _onJTouch_tapup);
        } else if (event == PriTapEvent.TAP_START && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriTapEvent.TAP_START, _onJTouch_tapstart);
        } else if (event == PriTapEvent.TAP_END && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriTapEvent.TAP_END, _onJTouch_tapend);
        } else if (event == PriTapEvent.TAP_MOVE && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriTapEvent.TAP_MOVE, _onJTouch_tapmove);
        }

        // swipe events
        if (event == PriSwipeEvent.SWIPE && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriSwipeEvent.SWIPE, _onJTouch_swipe);
        } else if (event == PriSwipeEvent.SWIPE_UP && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriSwipeEvent.SWIPE_UP, _onJTouch_swipeup);
        }else if (event == PriSwipeEvent.SWIPE_RIGHT && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriSwipeEvent.SWIPE_RIGHT, _onJTouch_swiperight);
        }else if (event == PriSwipeEvent.SWIPE_DOWN && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriSwipeEvent.SWIPE_DOWN, _onJTouch_swipedown);
        }else if (event == PriSwipeEvent.SWIPE_LEFT && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriSwipeEvent.SWIPE_LEFT, _onJTouch_swipeleft);
        }else if (event == PriSwipeEvent.SWIPE_END && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent(PriSwipeEvent.SWIPE_END, _onJTouch_swipeend);
        }

        if (event == PriMouseEvent.MOUSE_OUT && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent("mouseleave", _SPEVENT_mouseleave);
        } else if (event == PriMouseEvent.MOUSE_OVER && this._specialEventList.indexOf(event) == -1) {
            this.addSpecialEvent("mouseenter", _SPEVENT_mouseenter);
        }


        if (event == PriTapEvent.TAP) {
            this.pointer = true;
        }

        super.addEventListener(event, listener);
    }

    override public function removeEventListener(event:String, listener:Dynamic->Void):Void {
        super.removeEventListener(event, listener);

        if (event == PriTapEvent.TAP && this.hasEvent(PriTapEvent.TAP) == false) {
            this.pointer = false;
        }
    }

    private function addSpecialEvent(event:String, callback:Dynamic):Void {
        this._specialEventList.push(event);
        this._specialEventStack.push({
            event : event,
            callback : callback
        });

        (new JQuery("body")).on(event, "#" + this.getPrid(), callback);
    }

    private function killSpecialEvents():Void {
        var i:Int = 0;
        var n:Int = this._specialEventStack.length;

        // TODO : Verificar forma de nao remover o clique de todo sistema - problema do plugin de taps

        while (i < n) {

            (new JQuery("body")).off(
                this._specialEventStack[i].event,
                "#" + this._priId,
                this._specialEventStack[i].callback
            );

            i++;
        }


        // remove todos os eventos associados ao objeto
        this._specialEventList = [];
        this._specialEventStack = [];
    }


    private function _SPEVENT_mouseenter(e:Event, d):Void {
        //e.stopPropagation();

        // todo fazer o bubble dos eventos atraves dos evrntos priori
        // todo criar o clone de event de forma melhorada usando serializacao

        var event:PriMouseEvent = new PriMouseEvent(PriMouseEvent.MOUSE_OVER);
        if (!this.disabled) this.dispatchEvent(event);
    }

    private function _SPEVENT_mouseleave(e:Event, d):Void {
        //e.stopPropagation();

        var event:PriMouseEvent = new PriMouseEvent(PriMouseEvent.MOUSE_OUT);
        if (!this.disabled) this.dispatchEvent(event);
    }

    private function _onJTouch_tap(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriTapEvent.TAP, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_tapdown(e:Dynamic, touch):Void {
        e.stopPropagation();

        var data:Dynamic = {
            //screenY : e.screenY,
            //screenX : e.screenX,
            //clientY : e.clientY,
            //clientX : e.clientX,
            pageY : e.pageY,
            pageX : e.pageX,
            y : e.offsetY,
            x : e.offsetX

        };

        //trace(data);

        var event:PriTapEvent = new PriTapEvent(PriTapEvent.TAP_DOWN, false, false, data);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_tapup(e:Dynamic, touch):Void {
        e.stopPropagation();

        var data:Dynamic = {
            //screenY : e.screenY,
            //screenX : e.screenX,
            //clientY : e.clientY,
            //clientX : e.clientX,
            pageY : e.pageY,
            pageX : e.pageX,
            y : e.offsetY,
            x : e.offsetX
        };

        //trace(data);

        var event:PriTapEvent = new PriTapEvent(PriTapEvent.TAP_UP, false, false, data);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_tapstart(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriTapEvent.TAP_START, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_tapend(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriTapEvent.TAP_END, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_tapmove(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriTapEvent.TAP_MOVE, false);
        if (!this.disabled) this.dispatchEvent(event);
    }


    private function _onJTouch_swipe(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriSwipeEvent.SWIPE, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_swipeup(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriSwipeEvent.SWIPE_UP, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_swiperight(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriSwipeEvent.SWIPE_RIGHT, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_swipedown(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriSwipeEvent.SWIPE_DOWN, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_swipeleft(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriSwipeEvent.SWIPE_LEFT, false);
        if (!this.disabled) this.dispatchEvent(event);
    }
    private function _onJTouch_swipeend(e:Event, touch):Void {
        e.stopPropagation();

        var event:PriTapEvent = new PriTapEvent(PriSwipeEvent.SWIPE_END, false);
        if (!this.disabled) this.dispatchEvent(event);
    }


    private function createElement():Void {
        
        var jsElement:Element = js.Browser.document.createElement("div");
        jsElement.setAttribute("id", this._priId);
        jsElement.setAttribute("prioriid", this._priId);
        jsElement.setAttribute("class", "priori_noselect");
        jsElement.setAttribute("style", "position:absolute;margin:0px;padding:0px;overflow:hidden;");

        this._jselement = jsElement;
        this._element = new JQuery(jsElement);

    }

    public function removeFromParent():Void {
        if (this.parent != null) {
            this.parent.removeChild(this);
        }
    }

    override public function kill():Void {
        this.killSpecialEvents();

        // remove todos os eventos do elemento
        this.getElement().off();
        this.getElement().find("*").off();

        if (this.parent != null) parent.removeChild(this);

        this._element = null;
        this._jselement = null;

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

    private function get_pointer():Bool {
        if (this.getCSS("cursor") == "pointer") return false;
        return true;
    }

    private function set_pointer(value:Bool) {
        if (value == true) {
            this.setCSS("cursor", "pointer");
        } else {
            this.setCSS("cursor", "");
        }

        return value;
    }

    private function isDisabledByInherit():Bool {
        return !(this.getElement().attr("priori-disabled") == "disabled");
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

    private function get_disabled():Bool {
        if (this.getElement().is("[disabled]")) return true;
        return false;
    }

    private function set_disabled(value:Bool) {
        if (value == true) {
            this.getElement().attr("priori-disabled", "disabled");
            this.getElement().attr("disabled", "disabled");
            this.getElement().find("*").attr("disabled", "disabled");
        } else {

            this.getElement().removeAttr("priori-disabled");

            // verifica se algum parent esta desabilitado
            if (this.getElement().parents("*[priori-disabled='disabled']").length == 0) {
                this.getElement().removeAttr("disabled");
                this.getElement().find("*").not("*[priori-disabled='disabled'], *[priori-disabled='disabled'] *").removeAttr("disabled");
            }
        }

        return value;
    }


}
