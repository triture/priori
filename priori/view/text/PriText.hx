package priori.view.text;

import priori.style.shadow.PriShadowStyle;
import priori.style.font.PriFontStyle;
import jQuery.JQuery;

class PriText extends PriDisplay {

    inline private static var INITIAL_FONT_SIZE:Int = 13;


    public var html(get, set):String;

    @:isVar public var fontStyle(default, set):PriFontStyle;


    public var text(get, set):String;
    private var __text:String = "";

    public var fontSize(get, set):Float;
    private var __fontSize:Float = INITIAL_FONT_SIZE;

    public var autoSize(get, set):Bool;
    private var __autoSize:Bool = true;


    public var multiLine(get, set):Bool;
    private var __multiLine:Bool = false;

    public function new() {
        super();

        this.__text = "";

        this.___height = null;
        this.___width = null;
    }

    public function get_text():String return this.__text;
    private function set_text(value:String):String {
        this.__text = value;
        this._jselement.innerText = value;
        return value;
    }

    private function get_html():String return this._jselement.innerHTML;
    private function set_html(value:String):String {
        this._jselement.innerHTML = value;
        return value;
    }


    private function set_fontStyle(value:PriFontStyle):PriFontStyle {
        this.fontStyle = value;

        if (value == null) {
            this._element.css(PriFontStyle.getFontStyleObjectBase());
        } else {
            this._element.css(value.getFontStyleObject());
        }

        return value;
    }

    private function get_fontSize():Float return this.__fontSize;
    private function set_fontSize(value:Float):Float {
        if (this.__fontSize != value) {
            if (value == null) {
                this.__fontSize = INITIAL_FONT_SIZE;
                this._jselement.style.fontSize = "${INITIAL_FONT_SIZE}px";
            } else {
                this.__fontSize = value;
                this._jselement.style.fontSize = Std.int(value) + "px";
            }
        }

        return value;
    }

    private function get_autoSize():Bool return this.__autoSize;
    private function set_autoSize(value:Bool):Bool {
        if (this.__autoSize != value) {
            this.__autoSize = value;

            if (!this.__multiLine) super.set_width(null);
            if (this.__autoSize) super.set_height(null);
        }

        return value;
    }

    private function get_multiLine():Bool return this.__multiLine;
    private function set_multiLine(value:Bool):Bool {
        if (this.__multiLine != value) {
            this.__multiLine = value;

            if (value) this._jselement.style.whiteSpace = "";
            else this._jselement.style.whiteSpace = "nowrap";
        }

        return value;
    }

    override private function set_width(value:Float):Float {
        if (this.__autoSize == false || this.__multiLine == true) {
            super.set_width(value);
        }

        return value;
    }

    override private function set_height(value:Float):Float {
        if (this.__autoSize == false) {
            super.set_height(value);
        }

        return value;
    }

    override private function set_shadow(value:Array<PriShadowStyle>):Array<PriShadowStyle> {
        this.shadow = value;

        var shadowString:String = "";
        if (value != null && value.length > 0) {
            for (i in 0 ... value.length) {
                if (i > 0) shadowString += ",";
                shadowString += value[i].toString(1);
            }
        }

        this.setCSS("text-shadow", shadowString);

        return value;
    }

    override private function createElement():Void {
        super.createElement();

        this._jselement.style.whiteSpace = "nowrap";
        this._jselement.style.fontSize = "${INITIAL_FONT_SIZE}px";
        this._jselement.style.width = "";
        this._jselement.style.height = "";
    }

}