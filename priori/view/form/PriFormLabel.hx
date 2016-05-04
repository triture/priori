package priori.view.form;

import priori.style.font.PriFontStyle;

class PriFormLabel extends PriFormElementBase {

    @:isVar public var formElement(default, set):PriFormElementBase;
    @:isVar public var text(default, set):String;

    @:isVar public var fontStyle(default, set):PriFontStyle;
    @:isVar public var fontSize(default, set):Float;

    public function new() {
        super();

        this.text = "";
        this.fontSize = 12;
    }

    override private function getComponentCode():String {
        return "<label></label>";
    }

    @:noCompletion private function set_text(value:String) {
        this.text = value;
        this._baseElement.text(value);

        return value;
    }


    @:noCompletion private function set_fontStyle(value:PriFontStyle):PriFontStyle {
        this.fontStyle = value;

        if (value == null) {
            this._baseElement.css(PriFontStyle.getFontStyleObjectBase());
        } else {
            this._baseElement.css(value.getFontStyleObject());
        }

        return value;
    }

    @:noCompletion private function set_fontSize(value:Float):Float {
        if (this.fontSize != value) {
            this.fontSize = value;
            this._baseElement.css("font-size", Std.int(value) + "px");
        }

        return value;
    }

    private function set_formElement(value:PriFormElementBase) {
        this.formElement = value;

        if (value == null) {
            this._baseElement.removeAttr("for");
        } else {
            this._baseElement.attr("for", this.formElement.fieldId);
        }


        return value;
    }

}
