package priori.view.text;

import priori.style.font.PriFontStyleItalic;
import priori.style.font.PriFontStyleDecoration;
import priori.style.font.PriFontStyleAlign;
import priori.style.font.PriFontStyleVariant;
import priori.style.font.PriFontStyleWeight;
import priori.geom.PriColor;
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

    /**
    * Specify the space between line, in percentage values.
    * 
    * `defaur value: null`
    **/
    public var lineHeight(get, set):Float;

    public var textColor(get, set):PriColor;
    public var fontFamily(get, set):String;
    public var weight(get, set):PriFontStyleWeight;
    public var italic(get, set):PriFontStyleItalic;
    public var variant(get, set):PriFontStyleVariant;
    public var align(get, set):PriFontStyleAlign;
    public var decoration(get, set):PriFontStyleDecoration;

    public var letterSpace(get, set):Float;

    private var dth:DisplayTextHelper = DisplayHelperIgnition.getDisplayTextHelper();

    public function new() {
        super();

        this.startBatchUpdate();
        this.clipping = true;
        this.dh.height = null;
        this.dh.width = null;
        this.endBatchUpdate();
    }

    private function get_lineHeight():Float return this.dth.lineHeight;
    private function set_lineHeight(value:Float):Float {
        this.dth.lineHeight = value;

        if (value == null) this.dh.styles.remove("line-height");
        else this.dh.styles.set("line-height", (value * 100) + "%");

        this.__updateStyle();

        return value;
    }

    private function get_text():String {
        if (this.dth.editable || this.dth.text == null) this.dth.text = this.dh.jselement.innerText;
        return this.dth.text;
    }
    private function set_text(value:String):String {
        if (this.dth.text != value) {
            this.dth.text = value;
            this.dth.html = null;
            this.dh.jselement.innerText = value;
        }
        return value;
    }

    private function get_html():String {
        if (this.dth.editable || this.dth.html == null) this.dth.html = this.dh.jselement.innerHTML;
        return this.dth.html;
    }
    private function set_html(value:String):String {
        if (this.dth.html != value) {
            this.dth.html = value;
            this.dth.text = null;
            this.dh.jselement.innerHTML = value;
        }
        return value;
    }

    private function get_letterSpace():Float return this.dth.letterSpace == null ? 0 : this.dth.letterSpace;
    private function set_letterSpace(value:Float):Float {
        var v:Float = value == 0 ? null : value;
        if (v == this.dth.letterSpace) return value;

        if (v == null) this.dh.styles.remove('letter-spacing');
        else this.dh.styles.set('letter-spacing', v + 'px');

        this.__updateStyle();

        return value;
    }

    private function set_fontStyle(value:PriFontStyle):PriFontStyle {
        this.fontStyle = value;

        if (value == null) {
            this.dth.textColor = null;
            this.dth.fontFamily = null;
            this.dth.weight = null;
            this.dth.italic = null;
            this.dth.align = null;
            this.dth.decoration = null;
            this.dth.variant = null;
            
            StyleHelper.applyFontStyle(this.dh.styles, null);
            
        } else {
            
            this.dth.fontFamily = value.family;
            this.dth.weight = value.weight;
            this.dth.italic = value.italic;
            this.dth.align = value.align;
            this.dth.textColor = value.color;
            this.dth.decoration = value.decoration;
            this.dth.variant = value.variant;

            StyleHelper.applyFontStyle(this.dh.styles, value);

        }

        this.__updateStyle();

        return value;
    }

    private function get_textColor():PriColor return this.dth.textColor;
    private function set_textColor(value:PriColor):PriColor {
        if (dth.textColor == value) return value;
        this.dth.textColor = value;

        if (value == null) this.dh.styles.remove('color');
        else this.dh.styles.set('color', value.toString());
        
        this.__updateStyle();
        return value;
    }
    private function get_fontFamily():String return this.dth.fontFamily;
    private function set_fontFamily(value:String):String {
        if (dth.fontFamily == value) return value;
        this.dth.fontFamily = value;

        if (value == null) this.dh.styles.remove('font-family');
        else this.dh.styles.set('font-family', value);
        
        this.__updateStyle();
        return value;
    }
    private function get_weight():PriFontStyleWeight return this.dth.weight;
    private function set_weight(value:PriFontStyleWeight):PriFontStyleWeight {
        if (dth.weight == value) return value;
        this.dth.weight = value;

        if (value == null) this.dh.styles.remove('font-weight');
        else this.dh.styles.set('font-weight', value.toString());

        this.__updateStyle();
        return value;
    }
    private function get_italic():PriFontStyleItalic return this.dth.italic;
    private function set_italic(value):PriFontStyleItalic {
        if (dth.italic == value) return value;
        this.dth.italic = value;

        if (value == null) this.dh.styles.remove('font-style');
        else this.dh.styles.set('font-style', value.toString());

        this.__updateStyle();
        return value;
    }
    private function get_variant():PriFontStyleVariant return this.dth.variant;
    private function set_variant(value:PriFontStyleVariant):PriFontStyleVariant {
        if (dth.variant == value) return value;
        this.dth.variant = value;

        if (value == null) {
            this.dh.styles.remove('font-style');
            this.dh.styles.remove('text-transform');
        } else {
            if (value == PriFontStyleVariant.ALL_CAPS) {
                this.dh.styles.set('text-transform', 'uppercase');
                this.dh.styles.remove('font-variant');
            } else {
                this.dh.styles.remove('text-transform');
                this.dh.styles.set('font-variant', value.toString());
            }
        }

        this.__updateStyle();
        return value;
    }
    private function get_align():PriFontStyleAlign return this.dth.align;
    private function set_align(value:PriFontStyleAlign):PriFontStyleAlign {
        if (dth.align == value) return value;
        this.dth.align = value;

        if (value == null) this.dh.styles.remove('text-align');
        else this.dh.styles.set('text-align', value.toString());

        this.__updateStyle();
        return value;
    }
    private function get_decoration():PriFontStyleDecoration return this.dth.decoration;
    private function set_decoration(value:PriFontStyleDecoration):PriFontStyleDecoration {
        if (dth.decoration == value) return value;
        this.dth.decoration = value;

        if (value == null) this.dh.styles.remove('text-decoration');
        else this.dh.styles.set('text-decoration', value.toString());

        this.__updateStyle();
        return value;
    }

    private function get_fontSize():Float return this.dth.fontSize;
    private function set_fontSize(value:Float):Float {
        if (this.dth.fontSize != value) {
            if (value == null) {
                this.dth.fontSize = DisplayHelperIgnition.INITIAL_FONT_SIZE;
                this.dh.styles.set("font-size", '${DisplayHelperIgnition.INITIAL_FONT_SIZE}px');
            } else {
                this.dth.fontSize = value;
                this.dh.styles.set("font-size", Std.int(value) + "px");
            }

            this.__updateStyle();
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

            if (this.dth.ellipsis) this.dh.styles.set("text-overflow", "ellipsis");
            else this.dh.styles.remove("text-overflow");

            this.__updateStyle();
        }

        return value;
    }

    private function get_multiLine():Bool return this.dth.multiLine;
    private function set_multiLine(value:Bool):Bool {
        if (this.dth.multiLine != value) {
            this.dth.multiLine = value;

            if (value) this.dh.styles.remove("white-space");
            else this.dh.styles.set("white-space", "nowrap");

            if (value == false && this.dth.autoSize == true) super.set_width(null);

            this.__updateStyle();
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

    private function ___onchange():Void this.dispatchEvent(new PriEvent(PriEvent.CHANGE));

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
        this.dh.styles.set("-webkit-touch-callout", "default");
        this.dh.styles.set("-webkit-user-select", "text");
        this.dh.styles.set("-khtml-user-select", "text");
        this.dh.styles.set("-moz-user-select", "text");
        this.dh.styles.set("-ms-user-select", "text");
        this.dh.styles.set("user-select", "text");

        this.__updateStyle();
    }

    private function __setNotSelectableField():Void {
        this.dh.styles.remove("-webkit-touch-callout");
        this.dh.styles.remove("-webkit-user-select");
        this.dh.styles.remove("-khtml-user-select");
        this.dh.styles.remove("-moz-user-select");
        this.dh.styles.remove("-ms-user-select");
        this.dh.styles.remove("user-select");

        this.__updateStyle();
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

        if (shadowString.length == 0) this.dh.styles.remove("text-shadow");
        else this.dh.styles.set("text-shadow", shadowString);

        this.__updateStyle();

        return value;
    }

    override private function createElement():Void {
        super.createElement();

        this.dh.styles.set("white-space", "nowrap");
        this.dh.styles.set("font-size", '${DisplayHelperIgnition.INITIAL_FONT_SIZE}px');
        this.dh.styles.set("text-overflow", "ellipsis");
        this.dh.styles.remove("width");
        this.dh.styles.remove("height");

        this.__updateStyle();
    }

    override public function kill():Void {
        this.dh.jselement.oninput = null;
        this.dh.jselement.onkeydown = null;
        this.dh.jselement.onkeyup = null;
        this.dh.jselement.onpaste = null;

        super.kill();
    }

}