package priori.view.form;

import priori.style.font.PriFontStyle;
import helper.browser.StyleHelper;
import priori.event.PriEvent;
import js.html.Element;
import js.Browser;
import js.jquery.Event;
import priori.view.component.PriExtendable;

class PriFormElementBase extends PriExtendable {

    inline private static var INITIAL_FONT_SIZE:Int = 14;

    @:isVar public var fontStyle(default, set):PriFontStyle;
    @:isVar public var fieldId(get, null):String;

    /**
    * Changes the font size of the text.
    *
    * `default value : 14`
    **/
    public var fontSize(get, set):Float;
    private var __fontSize:Float = INITIAL_FONT_SIZE;

    private var _fieldId:String;

    public function new() {
        super();
    }

    private function get_fontSize():Float return this.__fontSize;
    private function set_fontSize(value:Float):Float {
        if (this.__fontSize != value) {
            if (value == null) {
                this.__fontSize = INITIAL_FONT_SIZE;
                this.dh.styles.set("font-size", '${INITIAL_FONT_SIZE}px');

            } else {
                this.__fontSize = value;
                this.dh.styles.set("font-size", Std.int(value) + "px");
            }

            this.__updateStyle();
        }

        return value;
    }

    private function set_fontStyle(value:PriFontStyle):PriFontStyle {
        this.fontStyle = value;

        StyleHelper.applyFontStyle(this.dh.styles, value);

        this.__updateStyle();

        return value;
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

    @noCompletion private function get_fieldId():String {
        return this._fieldId;
    }

}
