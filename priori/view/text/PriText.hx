package priori.view.text;

import helper.browser.StyleHelper;
import priori.system.PriDeviceBrowser;
import priori.system.PriDevice;
import priori.event.PriFocusEvent;
import priori.event.PriKeyboardEvent;
import priori.system.PriKey;
import priori.event.PriEvent;
import priori.style.shadow.PriShadowStyle;
import priori.style.font.PriFontStyle;
import jQuery.JQuery;

class PriText extends PriDisplay {

    inline private static var INITIAL_FONT_SIZE:Int = 14;

    /**
    * Set or retrieve the HTML representation of the text field contents.
    **/
    public var html(get, set):String;

    @:isVar public var fontStyle(default, set):PriFontStyle;

    /**
    * A string that is the current text in the text field.
    * This property contains unformatted text in the text field, without HTML tags.
    * To get the text in HTML form, use the `html` property.
    *
    * `default value : an empty string`
    **/
    public var text(get, set):String;
    private var __text:String = "";

    /**
    * Changes the font size of the text.
    *
    * `default value : 14`
    **/
    public var fontSize(get, set):Float;
    private var __fontSize:Float = INITIAL_FONT_SIZE;

    /**
    * Controls automatic sizing of text fields.
    * If autoSize is set to FALSE no resizing occurs.
    * If autoSize is set to TRUE, the text field resizes to show all text content.
    *
    * `default value : true`
    **/
    public var autoSize(get, set):Bool;
    private var __autoSize:Bool = true;

    /**
    * Indicates whether field is a multiline text field.
    * If the value is true, the text field is multiline; if the value is false, the text field is a single-line text field.
    *
    * `default value : false`
    **/
    public var multiLine(get, set):Bool;
    private var __multiLine:Bool = false;

    /**
    * A Boolean value that indicates whether the text field is selectable.
    * An `editable=true` text field is always selectable.
    *
    * `default value : false`
    **/
    public var selectable(get, set):Bool;
    private var __selectable:Bool = false;

    /**
    * A Boolean value that indicates whether the text field is editable.
    *
    * Editable text fields dispacth `PriEvent.CHANGE` on user interactions.
    *
    * `default value : false`
    **/
    public var editable(get, set):Bool;
    private var __editable:Bool = false;

    public function new() {
        super();

        this.__text = "";

        this.___height = null;
        this.___width = null;
    }

    public function get_text():String {
        if (this.__editable) this.__text = this._jselement.innerText;
        return this.__text;
    }
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

        if (value == null) StyleHelper.applyCleanFontStyle(this._jselement);
        else StyleHelper.applyFontStyle(this._jselement, value);

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


    private function get_editable():Bool return this.__editable;
    private function set_editable(value:Bool):Bool {
        if (this.__editable != value) {
            this.__editable = value;

            if (value) {
                this._jselement.setAttribute("contentEditable", "true");

                if (PriDevice.browser() == PriDeviceBrowser.MSIE) {
                    this._jselement.onkeydown = this.___onchange;
                    this._jselement.onkeyup = this.___onchange;
                    this._jselement.onpaste = this.___onchange;
                } else {
                    this._jselement.oninput = this.___onchange;
                }
            } else {
                this._jselement.removeAttribute("contentEditable");
                this._jselement.oninput = null;
                this._jselement.onkeydown = null;
                this._jselement.onkeyup = null;
                this._jselement.onpaste = null;
            }

            if (this.__selectable || this.__editable) this.__setSelectableField();
            else this.__setNotSelectableField();
        }

        return value;
    }

    private function ___onchange():Void {
        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    private function get_selectable():Bool return this.__selectable;
    private function set_selectable(value:Bool):Bool {
        if (this.__selectable != value) {
            this.__selectable = value;

            if (this.__selectable || this.__editable) this.__setSelectableField();
            else this.__setNotSelectableField();
        }

        return value;
    }

    private function __setSelectableField():Void {
        this._jselement.style.setProperty("-webkit-touch-callout", "default");
        this._jselement.style.setProperty("-webkit-user-select", "text");
        this._jselement.style.setProperty("-khtml-user-select", "text");
        this._jselement.style.setProperty("-moz-user-select", "text");
        this._jselement.style.setProperty("-ms-user-select", "text");
        this._jselement.style.setProperty("user-select", "text");
    }

    private function __setNotSelectableField():Void {
        this._jselement.style.removeProperty("-webkit-touch-callout");
        this._jselement.style.removeProperty("-webkit-user-select");
        this._jselement.style.removeProperty("-khtml-user-select");
        this._jselement.style.removeProperty("-moz-user-select");
        this._jselement.style.removeProperty("-ms-user-select");
        this._jselement.style.removeProperty("user-select");
    }

    override private function set_width(value:Float):Float {
        if (this.__autoSize == false || this.__multiLine == true) super.set_width(value);
        return value;
    }

    override private function set_height(value:Float):Float {
        if (this.__autoSize == false) super.set_height(value);
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

    override public function kill():Void {
        this._jselement.oninput = null;
        this._jselement.onkeydown = null;
        this._jselement.onkeyup = null;
        this._jselement.onpaste = null;

        super.kill();
    }

}