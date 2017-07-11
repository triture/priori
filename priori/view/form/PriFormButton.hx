package priori.view.form;

class PriFormButton extends PriFormElementBase {

    @:isVar public var text(default, set):String;

    public function new() {
        super();

        this.text = "Button";

        // default button align
        this.dh.jselement.style.textAlign = "center";
    }

    override public function set_pointer(value:Bool):Bool {
        var result:Bool = super.set_pointer(value);

        if (value == true) {
            this._baseElement.css("cursor", "pointer");
        } else {
            this._baseElement.css("cursor", "");
        }

        return value;
    }

    override private function getComponentCode():String {
        return '<button type="button"></button>';
    }

    @:noCompletion private function set_text(value:String) {
        this.text = value;

        this._baseElement.text(value);

        return value;
    }
}
