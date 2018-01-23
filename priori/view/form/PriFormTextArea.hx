package priori.view.form;

import js.html.Element;
import priori.geom.PriColor;
import priori.app.PriApp;
import priori.event.PriEvent;
import js.jquery.Event;
import js.JQuery;

class PriFormTextArea extends PriFormElementBase {

    public var value(get, set):String;

    @:isVar public var margin(default, set):Float = 0;

    @:isVar public var placeholder(default, set):String = "";
    public var placeholderColor(get, set):PriColor;
    private var __placeholderElement:Element;
    private var __placeHolderColorValue:PriColor = null;

    public function new() {
        super();
        this.clipping = false;

        this.addEventListener(PriEvent.CHANGE, function(e:PriEvent):Void this.__placeholderValidate());
    }

    private function __placeholderValidate():Void {
        if (this.__placeholderElement != null) {
            var val:String = this._baseElement.val();
            if (val.length > 0) this.__placeholderElement.style.display = "none";
            else this.__placeholderElement.style.display = "";
        }
    }

    private function __createPlaceholderElement():Void {
        if (this.__placeholderElement == null) {
            this.__placeholderElement = js.Browser.document.createElement("div");
            this.__placeholderElement.className = "priori_stylebase";
            this.__placeholderElement.style.cssText = 'top:${this.margin}px;left:${this.margin}px;width:auto;height:auto;overflow:hidden;pointer-events:none;';

            if (this.__placeHolderColorValue != null) this.__placeholderElement.style.color = this.__placeHolderColorValue;
        }
    }

    private function get_placeholderColor():PriColor return this.__placeHolderColorValue;
    private function set_placeholderColor(value:PriColor):PriColor {
        this.__placeHolderColorValue = value;
        if (this.__placeholderElement != null) {
            if (value == null) this.__placeholderElement.style.color = "";
            else this.__placeholderElement.style.color = value;
        }
        return value;
    }

    private function set_placeholder(value:String):String {
        if (value != null && value != "") {
            this.__createPlaceholderElement();
            this.dh.jselement.appendChild(this.__placeholderElement);
            this.__placeholderElement.innerText = value;
        }
        else if (this.__placeholderElement != null) {
            try {
                this.dh.jselement.removeChild(this.__placeholderElement);
            } catch (e:Dynamic) {}
        }

        this.placeholder = value;
        return value;
    }

    private function set_margin(value:Float):Float {
        this.margin = value;

        this._baseElement.css("padding", value);

        if (this.__placeholderElement != null) {
            this.__placeholderElement.style.top = value == null ? "" : value + "px";
            this.__placeholderElement.style.left = value == null ? "" : value + "px";
        }

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
        this.__placeholderValidate();
        return value;
    }

    private function get_value():String {
        var isDisabled:Bool = this.disabled;
        if (isDisabled) this.suspendDisabled();

        var result:String = this._baseElement.val();

        if (isDisabled) this.reactivateDisable();

        return result;
    }

}
