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
import js.jquery.JQuery;

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
    * Render an ellipsis ("...") to represent clipped text.
    *
    * `default value : true`
    **/
    public var ellipsis(get, set):Bool;
    private var __ellipsis:Bool = true;

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

        this.dh.height = null;
        this.dh.width = null;
    }

    public function get_text():String {
        if (this.__editable) this.__text = this.dh.jselement.innerText;
        return this.__text;
    }
    private function set_text(value:String):String {
        this.__text = value;
        this.dh.jselement.innerText = value;
        return value;
    }

    private function get_html():String return this.dh.jselement.innerHTML;
    private function set_html(value:String):String {
        this.dh.jselement.innerHTML = value;
        return value;
    }


    private function set_fontStyle(value:PriFontStyle):PriFontStyle {
        this.fontStyle = value;

        if (value == null) StyleHelper.applyCleanFontStyle(this.dh.jselement);
        else StyleHelper.applyFontStyle(this.dh.jselement, value);

        return value;
    }

    private function get_fontSize():Float return this.__fontSize;
    private function set_fontSize(value:Float):Float {
        if (this.__fontSize != value) {
            if (value == null) {
                this.__fontSize = INITIAL_FONT_SIZE;
                this.dh.jselement.style.fontSize = "${INITIAL_FONT_SIZE}px";
            } else {
                this.__fontSize = value;
                this.dh.jselement.style.fontSize = Std.int(value) + "px";
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

    private function get_ellipsis():Bool return this.__ellipsis;
    private function set_ellipsis(value:Bool):Bool {
        if (this.__ellipsis != value) {
            this.__ellipsis = value;

            if (this.__ellipsis) this.dh.jselement.style.textOverflow = "ellipsis";
            else this.dh.jselement.style.textOverflow = "";
        }

        return value;
    }

    private function get_multiLine():Bool return this.__multiLine;
    private function set_multiLine(value:Bool):Bool {
        if (this.__multiLine != value) {
            this.__multiLine = value;

            if (value) this.dh.jselement.style.whiteSpace = "";
            else this.dh.jselement.style.whiteSpace = "nowrap";
        }

        return value;
    }


    private function get_editable():Bool return this.__editable;
    private function set_editable(value:Bool):Bool {
        if (this.__editable != value) {
            this.__editable = value;

            if (value) {
                this.dh.jselement.setAttribute("contentEditable", "true");

                if (PriDevice.browser() == PriDeviceBrowser.MSIE) {
                    this.dh.jselement.onkeydown = this.___onchange;
                    this.dh.jselement.onkeyup = this.___onchange;
                    this.dh.jselement.onpaste = this.___onchange;
                } else {
                    this.dh.jselement.oninput = this.___onchange;
                }
            } else {
                this.dh.jselement.removeAttribute("contentEditable");
                this.dh.jselement.oninput = null;
                this.dh.jselement.onkeydown = null;
                this.dh.jselement.onkeyup = null;
                this.dh.jselement.onpaste = null;
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
        this.dh.jselement.style.setProperty("-webkit-touch-callout", "default");
        this.dh.jselement.style.setProperty("-webkit-user-select", "text");
        this.dh.jselement.style.setProperty("-khtml-user-select", "text");
        this.dh.jselement.style.setProperty("-moz-user-select", "text");
        this.dh.jselement.style.setProperty("-ms-user-select", "text");
        this.dh.jselement.style.setProperty("user-select", "text");
    }

    private function __setNotSelectableField():Void {
        this.dh.jselement.style.removeProperty("-webkit-touch-callout");
        this.dh.jselement.style.removeProperty("-webkit-user-select");
        this.dh.jselement.style.removeProperty("-khtml-user-select");
        this.dh.jselement.style.removeProperty("-moz-user-select");
        this.dh.jselement.style.removeProperty("-ms-user-select");
        this.dh.jselement.style.removeProperty("user-select");
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

        this.dh.jselement.style.whiteSpace = "nowrap";
        this.dh.jselement.style.fontSize = "${INITIAL_FONT_SIZE}px";
        this.dh.jselement.style.width = "";
        this.dh.jselement.style.height = "";
        this.dh.jselement.style.textOverflow = "ellipsis";

    }

    override public function kill():Void {
        this.dh.jselement.oninput = null;
        this.dh.jselement.onkeydown = null;
        this.dh.jselement.onkeyup = null;
        this.dh.jselement.onpaste = null;

        super.kill();
    }

}