package priori.view.form;

import helper.browser.StyleHelper;
import priori.style.font.PriFontStyle;
import priori.geom.PriColor;
import priori.app.PriApp;
import priori.event.PriEvent;
import priori.types.PriFormInputTextFieldType;
import js.html.Element;
import js.jquery.Event;

class PriFormInputText extends PriFormElementBase {

    public var value(get, set):String;

    @:isVar public var placeholder(default, set):String = "";
    @:isVar public var placeholderStyle(get, set):PriFontStyle;

    public var placeholderColor(get, set):PriColor;

    private var __placeholderElement:Element;
    private var __placeHolderColorValue:PriColor = null;

    @:isVar public var password(default, set):Bool = false;

    @:isVar public var marginLeft(default, set):Float;
    @:isVar public var marginRight(default, set):Float;

    @:isVar public var fieldType(default, set):PriFormInputTextFieldType = PriFormInputTextFieldType.TEXT;

    public function new() {
        super();

        this.clipping = false;
        this.width = 160;

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
            this.__placeholderElement.style.cssText = 'transform:translate(0px,-50%);-webkit-transform:translate(0px,-50%);-ms-transform:translate(0px,-50%);top:50%;left:${this.marginLeft}px;width:auto;height:auto;overflow:hidden;pointer-events:none;font-size:inherit;';

            if (this.__placeHolderColorValue != null) this.__placeholderElement.style.color = this.__placeHolderColorValue;
            if (this.placeholderStyle != null) StyleHelper.applyFontStyle(this.__placeholderElement, this.placeholderStyle);

            this.__placeholderValidate();
        }
    }

    private function get_placeholderStyle():PriFontStyle return this.placeholderStyle;
    private function set_placeholderStyle(value:PriFontStyle):PriFontStyle {
        this.placeholderStyle = value;

        if (this.__placeholderElement != null) {
            if (value == null) StyleHelper.applyCleanFontStyle(this.__placeholderElement);
            else StyleHelper.applyFontStyle(this.__placeholderElement, value);
        }

        return value;
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

    private function set_fieldType(value:PriFormInputTextFieldType):PriFormInputTextFieldType {
        this.fieldType = value;
        this._baseElement.attr("type", cast value);
        return value;
    }

    private function set_marginLeft(value:Float):Float {
        this.marginLeft = value;
        this._baseElement.css("padding-left", value == null ? "" : value + "px");
        if (this.__placeholderElement != null) this.__placeholderElement.style.left = value == null ? "" : value + "px";
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

    private function set_password(value:Bool) {
        this.password = value;

        if (value) this.fieldType = PriFormInputTextFieldType.PASSWORD;
        else this.fieldType = PriFormInputTextFieldType.TEXT;


        return value;
    }

}
