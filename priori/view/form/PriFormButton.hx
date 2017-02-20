package priori.view.form;

class PriFormButton extends PriFormElementBase {

    @:isVar public var text(default, set):String;

    public function new() {
        super();

        this.text = "Button";

        // default button align
        this._jselement.style.textAlign = "center";
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
