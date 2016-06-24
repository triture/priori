package priori.view.form;

import priori.app.PriApp;
import jQuery.Event;
import js.JQuery;
import priori.event.PriEvent;

class PriFormInputText extends PriFormElementBase {

    @:isVar public var value(get, set):String;
    @:isVar public var placeholder(default, set):String;
    @:isVar public var password(default, set):Bool;

    public function new() {
        super();

        this.placeholder = "";
        this.password = false;
        this.clipping = false;
    }

    override public function getComponentCode():String {
        return "<input type=\"text\" />";
    }

    override private function onAddedToApp():Void {
        PriApp.g().getBody().on("input", "[id=" + this.fieldId + "]", this._onChange);
    }

    override private function onRemovedFromApp():Void {
        PriApp.g().getBody().off("input", "[id=" + this.fieldId + "]", this._onChange);
    }

    @:noCompletion private function _onChange(event:Event):Void {
        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    @:noCompletion private function set_value(value:String):String {
        this.value = value;
        this._baseElement.val(value);

        return value;
    }

    @noCompletion private function get_value():String {
        var result:String = this.value;

        var isDisabled:Bool = this.disabled;
        if (isDisabled) this.suspendDisabled();

        result = this._baseElement.val();

        if (isDisabled) this.reactivateDisable();

        return result;
    }

    @noCompletion private function set_placeholder(value:String):String {
        this.placeholder = value;

        this._baseElement.attr("placeholder", value);

        return value;
    }

    @noCompletion private function set_password(value:Bool) {
        this.password = value;

        if (value) {
            this._baseElement.attr("type", "password");
        } else {
            this._baseElement.attr("type", "font");
        }

        return value;
    }

}
