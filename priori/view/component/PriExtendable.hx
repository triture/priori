package priori.view.component;

import priori.event.PriEvent;
import jQuery.JQuery;

class PriExtendable extends PriDisplay {

    private var _baseElement:JQuery;

    public function new() {
        super();

        this.createBaseElement();
        this.width = null;
        this.height = null;

        this.addEventListener(PriEvent.ADDED_TO_APP, this.__appAdd);
    }

    private function onAddedToApp():Void {

    }

    private function onRemovedFromApp():Void {

    }

    private function __appAdd(e:PriEvent):Void {
        this.removeEventListener(PriEvent.ADDED_TO_APP, this.__appAdd);
        this.addEventListener(PriEvent.REMOVED_FROM_APP, this.__appRemove);

        this.onAddedToApp();
    }

    private function __appRemove(e:PriEvent):Void {
        this.onRemovedFromApp();

        this.addEventListener(PriEvent.ADDED_TO_APP, this.__appAdd);
        this.removeEventListener(PriEvent.REMOVED_FROM_APP, this.__appRemove);
    }

    @:noCompletion override private function set_width(value:Float):Float {
        if (_baseElement != null) {
            if (value == null) {
                _baseElement.css("width", "");
            } else {
                _baseElement.css("width", "100%");
            }
        }

        super.set_width(value);

        return value;
    }

    @:noCompletion override private function set_height(value:Float):Float {
        if (_baseElement != null) {
            if (value == null) {
                _baseElement.css("height", "");
            } else {
                _baseElement.css("height", "100%");
            }
        }

        super.set_height(value);

        return value;
    }

    private function createBaseElement():Void {
        this._baseElement = new JQuery(this.getComponentCode());
        this.getElement().append(this._baseElement);
    }

    private function getComponentCode():String {
        return "<div></div>";
    }

    override public function kill():Void {
        this.getElement().off();

        super.kill();
    }
}
