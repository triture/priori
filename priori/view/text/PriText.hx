package priori.view.text;

import priori.style.shadow.PriShadowStyle;
import priori.style.font.PriFontStyle;
import jQuery.JQuery;

class PriText extends PriDisplay {

    @:isVar public var text(default, set):String;
    @:isVar public var html(default, set):String;

    @:isVar public var fontStyle(default, set):PriFontStyle;
    @:isVar public var fontSize(default, set):Float;

    @:isVar public var autoSize(default, set):Bool;
    @:isVar public var multiLine(default, set):Bool;


    public function new() {
        super();

        this.text = "";
        this.fontSize = null;
        this.autoSize = true;
        this.multiLine = false;
    }

    private function set_text(value:String):String {
        this.text = value;
        this._element.text(value);

        return value;
    }

    private function set_html(value:String):String {
        this.html = value;
        this._element.html(value);

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

    private function set_fontSize(value:Float):Float {
        if (this.fontSize != value) {
            if (value == null) {
                this.getElement().css("font-size", "");
            } else {
                this.fontSize = value;
                this.getElement().css("font-size", Std.int(value) + "px");
            }
        }

        return value;
    }

    private function get_fontSize():Float {
        if (this.fontSize == null) {
            return 12;
        }

        return this.fontSize;
    }

    private function set_autoSize(value:Bool):Bool {
        if (this.autoSize != value) {
            this.autoSize = value;

            if (!this.multiLine) {
                super.set_width(null);
            }

            super.set_height(null);
        }

        return value;
    }

    private function set_multiLine(value:Bool):Bool {
        if (this.multiLine != value) {

            this.multiLine = value;

            if (value) {
                this.getElement().css("white-space", "");
            } else {
                this.getElement().css("white-space", "nowrap");
            }
        }

        return value;
    }

    override private function set_width(value:Float):Float {
        if (this.autoSize == false || this.multiLine == true) {
            super.set_width(value);
        }

        return value;
    }

    override private function set_height(value:Float):Float {
        if (this.autoSize == false) {
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

}
