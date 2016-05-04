package priori.view.component;

import jQuery.JQuery;
import priori.assets.AssetManager;

class PriComponentBase extends PriDisplay {

    @:isVar public var resizable(get, set):Bool;

    public var baseElement:JQuery;


    public function new() {
        super();
        this.resizable = true;
        this.setup();
    }

    @noCompletion private function get_resizable():Bool {
        return resizable;
    }
    @noCompletion private function set_resizable(value:Bool) {

        if (value == false) {
            this.width = null;
            this.height = null;
        }

        return this.resizable = value;
    }


    public function setup():Void {

    }

    static public function loadComponentAssets(manager:AssetManager) {

    }

    @noCompletion override private function set_width(value:Float):Float {
        if (this.resizable) {
            if (baseElement != null) {
                if (value == null) {
                    baseElement.css("width", "");
                } else {
                    baseElement.css("width", "100%");
                }
            }

            super.set_width(value);
        }

        return value;
    }

    @noCompletion override private function set_height(value:Float):Float {
        if (this.resizable) {
            if (baseElement != null) {
                if (value == null) {
                    baseElement.css("height", "");
                } else {
                    baseElement.css("height", "100%");
                }
            }

            super.set_height(value);
        }

        return value;
    }

    override public function kill():Void {
        if (this.baseElement != null) {
            this.baseElement.off();
            this.baseElement.remove();
            this.baseElement = null;
        }

        super.kill();
    }

}
