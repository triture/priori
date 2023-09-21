package priori.view.form;

import priori.style.font.PriFontStyle;

class PriFormLabel extends PriFormElementBase {

    @:isVar public var formElement(default, set):PriFormElementBase;
    @:isVar public var text(default, set):String;

    public var multiLine(get, set):Bool;
    private var __multiLine:Bool = true;

    public function new() {
        super();

        this.text = "label";
        this.fontSize = 12;
    }

    override private function getComponentCode():String {
        return '<label style="margin:0px;padding:0px;"></label>';
    }

    @:noCompletion private function set_text(value:String) {
        this.text = value;
        this._baseElement.text(value);

        return value;
    }

    private function get_multiLine():Bool return this.__multiLine;
    private function set_multiLine(value:Bool):Bool {
        if (this.__multiLine != value) {
            this.__multiLine = value;

            if (value) this._baseElement.css("white-space", "");
            else this._baseElement.css("white-space", "nowrap");
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
