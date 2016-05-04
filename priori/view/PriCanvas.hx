package priori.view;

import js.html.CanvasRenderingContext2D;
import jQuery.JQuery;
import js.html.CanvasElement;

class PriCanvas extends PriDisplay {

    private var _canvas:CanvasElement;


    public function new() {
        super();

        this._canvas = js.Browser.document.createCanvasElement();
        this.getElement().append(this._canvas);
    }

    public function getContext():CanvasRenderingContext2D {
        return this._canvas.getContext2d();
    }

    @noCompletion override private function set_width(value:Float):Float {
        var result:Float = super.set_width(value);
        new JQuery(this._canvas).width(value);
        return result;
    }

    @noCompletion override private function set_height(value:Float):Float {
        var result:Float = super.set_height(value);
        new JQuery(this._canvas).height(value);
        return result;
    }

}