package priori.view.form;

import priori.view.component.PriExtendable;

class PriFormElementBase extends PriExtendable {

    @:isVar public var fieldId(get, null):String;

    private var _fieldId:String;

    public function new() {
        super();
    }


    private function applyIdToFormElement():Void {
        this._fieldId = "field_" + this.getRandomId(4);
        this._baseElement.attr("id", this.fieldId);
    }

    override private function createBaseElement():Void {
        super.createBaseElement();
        this.applyIdToFormElement();
    }

    @noCompletion private function get_fieldId():String {
        return this._fieldId;
    }

}
