package priori.view;

import view.PriGraphic;
import js.html.CanvasRenderingContext2D;
import jQuery.JQuery;
import js.html.CanvasElement;

class PriCanvas extends PriDisplay {

    private var _canvas:CanvasElement;
    private var _graphic:PriGraphic;

    public var graphic(get, null):PriGraphic;

    public function new() {
        super();

        this._canvas = js.Browser.document.createCanvasElement();
        this.getElement().append(this._canvas);
    }

    private function getContext():CanvasRenderingContext2D {
        return this._canvas.getContext2d();
    }

    private function get_graphic():PriGraphic {
        if (this._graphic == null) this._graphic = new PriGraphic(this.getContext());

        return this._graphic;
    }

    override private function set_width(value:Float):Float {
        var result:Float = super.set_width(value);
        new JQuery(this._canvas).width(value);
        return result;
    }

    override private function set_height(value:Float):Float {
        var result:Float = super.set_height(value);
        new JQuery(this._canvas).height(value);
        return result;
    }

}