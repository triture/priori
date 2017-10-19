package priori.view.form;

import priori.app.PriApp;
import priori.event.PriEvent;
import js.jquery.Event;
import js.JQuery;

class PriFormTextArea extends PriFormElementBase {

    public var value(get, set):String;

    @:isVar public var placeholder(default, set):String = "";
    @:isVar public var margin(default, set):Float = 0;

    public function new() {
        super();
        this.clipping = false;
    }

    private function set_margin(value:Float):Float {
        this.margin = value;

        this._baseElement.css("padding", value);

        return value;
    }

    override public function getComponentCode():String {
        return "<textarea style=\"width:100%;height:100%;resize:none;box-sizing:border-box;\"></textarea>";
    }

    override private function onAddedToApp():Void PriApp.g().getBody().on("input", "[id=" + this.fieldId + "]", this._onChange);
    override private function onRemovedFromApp():Void PriApp.g().getBody().off("input", "[id=" + this.fieldId + "]", this._onChange);

    private function _onChange(event:Event):Void this.dispatchEvent(new PriEvent(PriEvent.CHANGE));


    private function set_value(value:String):String {
        this._baseElement.val(value);
        return value;
    }

    private function get_value():String {
        var isDisabled:Bool = this.disabled;
        if (isDisabled) this.suspendDisabled();

        var result:String = this._baseElement.val();

        if (isDisabled) this.reactivateDisable();

        return result;
    }

    private function set_placeholder(value:String):String {
        this.placeholder = value;
        this._baseElement.attr("placeholder", value);
        return value;
    }

}
