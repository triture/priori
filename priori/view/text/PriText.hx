package priori.view.text;

import priori.style.font.PriFontStyle;
import jQuery.JQuery;

class PriText extends PriDisplay {

    @:isVar public var text(get, set):String;
    @:isVar public var html(get, set):String;

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

    @:noCompletion private function set_text(value:String):String {
        this.text = value;
        this.getElement().text(value);

        return value;
    }

    @:noCompletion private function get_text():String {
        return this.getElement().text();
    }

    @:noCompletion private function set_html(value:String):String {
        this.html = value;
        this.getElement().html(value);

        return value;
    }

    @:noCompletion private function get_html():String {
        return this.getElement().html();
    }


    @:noCompletion private function set_fontStyle(value:PriFontStyle):PriFontStyle {
        this.fontStyle = value;

        if (value == null) {
            this.getElement().css(PriFontStyle.getFontStyleObjectBase());
        } else {
            this.getElement().css(value.getFontStyleObject());
        }

        return value;
    }

    @:noCompletion private function set_fontSize(value:Float):Float {
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

    @:noCompletion private function get_fontSize():Float {
        if (this.fontSize == null) {
            return 12;
        }

        return this.fontSize;
    }

    @:noCompletion private function set_autoSize(value:Bool):Bool {
        if (this.autoSize != value) {
            this.autoSize = value;

            if (!this.multiLine) {
                super.set_width(null);
            }

            super.set_height(null);
        }

        return value;
    }

    @:noCompletion private function set_multiLine(value:Bool):Bool {
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

    @:noCompletion override private function set_width(value:Float):Float {
        if (this.autoSize == false || this.multiLine == true) {
            super.set_width(value);
        }

        return value;
    }

    @:noCompletion override private function set_height(value:Float):Float {
        if (this.autoSize == false) {
            super.set_height(value);
        }

        return value;
    }



}
