package priori.view.text;

import helper.display.DisplayHelperIgnition;
import helper.display.DisplayTextHelper;
import helper.browser.StyleHelper;
import priori.system.PriDeviceBrowser;
import priori.system.PriDevice;
import priori.event.PriEvent;
import priori.style.shadow.PriShadowStyle;
import priori.style.font.PriFontStyle;

class PriText extends PriDisplay {

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

    /**
    * Changes the font size of the text.
    *
    * `default value : 14`
    **/
    public var fontSize(get, set):Float;

    /**
    * Controls automatic sizing of text fields.
    * If autoSize is set to FALSE no resizing occurs.
    * If autoSize is set to TRUE, the text field resizes to show all text content.
    *
    * `default value : true`
    **/
    public var autoSize(get, set):Bool;

    /**
    * Indicates whether field is a multiline text field.
    * If the value is true, the text field is multiline; if the value is false, the text field is a single-line text field.
    *
    * `default value : false`
    **/
    public var multiLine(get, set):Bool;

    /**
    * A Boolean value that indicates whether the text field is selectable.
    * An `editable=true` text field is always selectable.
    *
    * `default value : false`
    **/
    public var selectable(get, set):Bool;

    /**
    * Render an ellipsis ("...") to represent clipped text.
    *
    * `default value : true`
    **/
    public var ellipsis(get, set):Bool;

    /**
    * A Boolean value that indicates whether the text field is editable.
    *
    * Editable text fields dispacth `PriEvent.CHANGE` on user interactions.
    *
    * `default value : false`
    **/
    public var editable(get, set):Bool;

    private var dth:DisplayTextHelper = DisplayHelperIgnition.getDisplayTextHelper();

    public function new() {
        super();

        this.clipping = false;
        this.dh.height = null;
        this.dh.width = null;
    }

    public function get_text():String {
        if (this.dth.editable) this.dth.text = this.dh.jselement.innerText;
        return this.dth.text;
    }
    private function set_text(value:String):String {
        this.dth.text = value;
        this.dh.jselement.innerText = value;
        return value;
    }

    private function get_html():String return this.dh.jselement.innerHTML;
    private function set_html(value:String):String {
        this.dh.jselement.innerHTML = value;
        this.dth.text = this.dh.jselement.innerText;
        return value;
    }


    private function set_fontStyle(value:PriFontStyle):PriFontStyle {
        this.fontStyle = value;

        if (value == null) StyleHelper.applyCleanFontStyle(this.dh.jselement);
        else StyleHelper.applyFontStyle(this.dh.jselement, value);

        return value;
    }

    private function get_fontSize():Float return this.dth.fontSize;
    private function set_fontSize(value:Float):Float {
        if (this.dth.fontSize != value) {
            if (value == null) {
                this.dth.fontSize = DisplayHelperIgnition.INITIAL_FONT_SIZE;
                this.dh.jselement.style.fontSize = '${DisplayHelperIgnition.INITIAL_FONT_SIZE}px';
            } else {
                this.dth.fontSize = value;
                this.dh.jselement.style.fontSize = Std.int(value) + "px";
            }
        }

        return value;
    }

    private function get_autoSize():Bool return this.dth.autoSize;
    private function set_autoSize(value:Bool):Bool {
        if (this.dth.autoSize != value) {
            this.dth.autoSize = value;

            if (!this.dth.multiLine) super.set_width(null);
            if (this.dth.autoSize) super.set_height(null);
        }

        return value;
    }

    private function get_ellipsis():Bool return this.dth.ellipsis;
    private function set_ellipsis(value:Bool):Bool {
        if (this.dth.ellipsis != value) {
            this.dth.ellipsis = value;

            if (this.dth.ellipsis) this.dh.jselement.style.textOverflow = "ellipsis";
            else this.dh.jselement.style.textOverflow = "";
        }

        return value;
    }

    private function get_multiLine():Bool return this.dth.multiLine;
    private function set_multiLine(value:Bool):Bool {
        if (this.dth.multiLine != value) {
            this.dth.multiLine = value;

            if (value) this.dh.jselement.style.whiteSpace = "";
            else this.dh.jselement.style.whiteSpace = "nowrap";

            if (value == false && this.dth.autoSize == true) super.set_width(null);
        }

        return value;
    }


    private function get_editable():Bool return this.dth.editable;
    private function set_editable(value:Bool):Bool {
        if (this.dth.editable != value) {
            this.dth.editable = value;

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

            if (this.dth.selectable || this.dth.editable) this.__setSelectableField();
            else this.__setNotSelectableField();
        }

        return value;
    }

    private function ___onchange():Void {
        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    private function get_selectable():Bool return this.dth.selectable;
    private function set_selectable(value:Bool):Bool {
        if (this.dth.selectable != value) {
            this.dth.selectable = value;

            if (this.dth.selectable || this.dth.editable) this.__setSelectableField();
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
        if (this.dth.autoSize == false || this.dth.multiLine == true) super.set_width(value);
        return value;
    }

    override private function set_height(value:Float):Float {
        if (this.dth.autoSize == false) super.set_height(value);
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

        this.dh.jselement.style.textShadow = shadowString;

        return value;
    }

    override private function createElement():Void {
        super.createElement();

        this.dh.jselement.style.whiteSpace = "nowrap";
        this.dh.jselement.style.fontSize = '${DisplayHelperIgnition.INITIAL_FONT_SIZE}px';
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