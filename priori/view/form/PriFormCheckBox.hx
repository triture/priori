package priori.view.form;

import priori.event.PriEvent;
import jQuery.Event;
class PriFormCheckBox extends PriFormElementBase {

    @:isVar public var value(get, set):Bool;

    public function new() {
        super();

        this.value = false;
    }

    override private function getComponentCode():String {
        return "<input type=\"checkbox\" />";
    }

    override private function onAddedToApp():Void {
        this._baseElement.on("change", this._onCheckChange);
    }

    override private function onRemovedFromApp():Void {
        this._baseElement.off("change", this._onCheckChange);
    }

    @:noCompletion private function _onCheckChange(event:Event):Void {
        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    @:noCompletion private function set_value(value:Bool):Bool {
        this.value = value;

        this._baseElement.prop("checked", value);

        return value;
    }

    @noCompletion private function get_value():Bool {
        var result:Bool = this.value;

        var isDisabled:Bool = this.disabled;
        if (isDisabled) this.disabled = false;

        result = this._baseElement.prop("checked");

        if (isDisabled) this.disabled = true;

        return result;
    }
}
