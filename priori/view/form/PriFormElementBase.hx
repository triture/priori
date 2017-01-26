package priori.view.form;

import priori.event.PriEvent;
import priori.app.PriApp;
import js.html.Element;
import js.Browser;
import jQuery.Event;
import priori.view.component.PriExtendable;

class PriFormElementBase extends PriExtendable {

    @:isVar public var fieldId(get, null):String;

    private var _fieldId:String;

    public function new() {
        super();
    }

    override private function onAddedToApp():Void {
        super.onAddedToApp();
        if (this.hasEvent(PriEvent.PRESS_ENTER)) {
            this._baseElement.off("keydown", this._onPressEnter);
            this._baseElement.on("keydown", this._onPressEnter);

        }
    }

    override private function onRemovedFromApp():Void {
        super.onRemovedFromApp();
        this._baseElement.off("keydown", this._onPressEnter);
    }

    private function _onPressEnter(event:Event):Void {
        if (event.which == 13 ) {
            this.dispatchEvent(new PriEvent(PriEvent.PRESS_ENTER));
        }
    }

    override public function addEventListener(event:String, listener:Dynamic->Void):Void {
        super.addEventListener(event, listener);

        if (event == PriEvent.PRESS_ENTER) {
            this._baseElement.off("keydown", this._onPressEnter);
            this._baseElement.on("keydown", this._onPressEnter);
        }
    }

    private function suspendDisabled():Void {
        this.getElement().removeAttr("disabled");
        this.getElement().find("*").removeAttr("disabled");
    }

    private function reactivateDisable():Void {
        this.getElement().attr("disabled", "disabled");
        this.getElement().find("*").attr("disabled", "disabled");
    }


    private function applyIdToFormElement():Void {
        this._fieldId = "field_" + this.getRandomId(4);
        this._baseElement.attr("id", this.fieldId);
    }

    override private function createBaseElement():Void {
        super.createBaseElement();
        this.applyIdToFormElement();
    }

    override public function setFocus():Void {
        var el:Element = Browser.document.getElementById(this.fieldId);
        if (el != null) el.focus();
    }

    override public function removeFocus():Void {
        var el:Element = Browser.document.getElementById(this.fieldId);
        if (el != null) el.blur();
    }

    override public function hasFocus():Bool {
        var el:Element = Browser.document.getElementById(this.fieldId);

        if (el != null) {
            try {
                var curEl:Element = Browser.document.activeElement;
                if (curEl == el) return true;
            } catch (e:Dynamic) {

            }
        }

        return false;
    }

    @noCompletion private function get_fieldId():String {
        return this._fieldId;
    }

}
