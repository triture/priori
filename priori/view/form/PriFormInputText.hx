package priori.view.form;

import priori.app.PriApp;
import js.jquery.Event;
import priori.event.PriEvent;

class PriFormInputText extends PriFormElementBase {

    @:isVar public var value(get, set):String;
    @:isVar public var placeholder(default, set):String;
    @:isVar public var password(default, set):Bool;

    @:isVar public var marginLeft(default, set):Float;
    @:isVar public var marginRight(default, set):Float;

    public function new() {
        super();

        this.placeholder = "";
        this.password = false;
        this.clipping = false;
        this.width = 160;
    }

    private function set_marginLeft(value:Float):Float {
        this.marginLeft = value;
        this._baseElement.css("padding-left", value == null ? "" : value + "px");
        return value;
    }

    private function set_marginRight(value:Float):Float {
        this.marginRight = value;
        this._baseElement.css("padding-right", value == null ? "" : value + "px");
        return value;
    }

    override public function getComponentCode():String {
        return '<input type="text" style="height:100%;padding:0px;box-sizing:border-box;" />';
    }

    override private function onAddedToApp():Void {
        super.onAddedToApp();
        PriApp.g().getBody().on("input", "[id=" + this.fieldId + "]", this._onChange);
    }

    override private function onRemovedFromApp():Void {
        super.onRemovedFromApp();
        PriApp.g().getBody().off("input", "[id=" + this.fieldId + "]", this._onChange);
    }

    private function _onChange(event:Event):Void {
        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    private function set_value(value:String):String {
        this.value = value;
        this._baseElement.val(value);

        return value;
    }

    private function get_value():String {
        var result:String = this.value;

        var isDisabled:Bool = this.disabled;
        if (isDisabled) this.suspendDisabled();

        result = this._baseElement.val();

        if (isDisabled) this.reactivateDisable();

        return result;
    }

    private function set_placeholder(value:String):String {
        this.placeholder = value;

        this._baseElement.attr("placeholder", value);

        return value;
    }

    private function set_password(value:Bool) {
        this.password = value;

        if (value) {
            this._baseElement.attr("type", "password");
        } else {
            this._baseElement.attr("type", "font");
        }

        return value;
    }

}
