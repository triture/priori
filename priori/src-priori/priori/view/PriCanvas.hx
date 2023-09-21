package priori.view;

import js.html.CanvasRenderingContext2D;
import js.jquery.JQuery;
import js.html.CanvasElement;

class PriCanvas extends PriDisplay {

    @:isVar public var pixelStyle(default, set):Bool = false;
    @:isVar public var density(default, set):Float = 1.0;

    public var _canvas:CanvasElement;
    private var _graphic:PriGraphic;

    public var graphic(get, null):PriGraphic;

    public function new() {
        super();

        this._canvas = js.Browser.document.createCanvasElement();

        this.getElement().append(this._canvas);
    }

    private function set_density(value:Float):Float {
        if (value == null || value <= 0) return value;

        this.density = value;

        this.updateDensity();

        return value;
    }

    private function set_pixelStyle(value:Bool):Bool {
        if (this.pixelStyle == value) return value;

        this.pixelStyle = value;

        if (value) {

            var currentStyle:String = this._canvas.getAttribute("style");
            if (currentStyle == null) currentStyle = "";

            currentStyle += ";image-rendering: pixelated;";

            this._canvas.setAttribute("style", currentStyle);

        } else {
            var currentStyle:String = this._canvas.getAttribute("style");
            currentStyle = currentStyle.split("image-rendering: pixelated;").join("");
        }

        return value;
    }

    private function updateDensity():Void {

        var curWidth:Float = this.width;
        var curHeight:Float = this.height;

        this._canvas.style.width = curWidth + "px";
        this._canvas.style.height = curHeight + "px";

        var realSizeWidth:Int = Math.round(curWidth*this.density);
        var realSizeHeight:Int = Math.round(curHeight*this.density);

        this._canvas.width = realSizeWidth;
        this._canvas.height = realSizeHeight;
    }

    private function getContext():CanvasRenderingContext2D {
        return this._canvas.getContext2d();
    }

    private function get_graphic():PriGraphic {
        if (this._graphic == null) this._graphic = new PriGraphic(this.getContext());

        return this._graphic;
    }

    override private function set_width(value:Float):Float {
        super.set_width(value);
        this.updateDensity();
        return value;
    }

    override private function set_height(value:Float):Float {
        super.set_height(value);
        this.updateDensity();
        return value;
    }

}



private class PriGraphic {

    private var context:CanvasRenderingContext2D;

    public function new(context:CanvasRenderingContext2D) {
        this.context = context;
    }


    public function restore():Void this.context.restore();
    public function scale(x:Float, y:Float):Void this.context.scale(x, y);
    public function rotate(angle:Float):Void this.context.rotate(angle);
    public function translate(x:Float, y:Float):Void this.context.translate(x, y);
    public function transform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void this.context.transform(a, b, c, d, e, f);

    //function setTransform( a : Float, b : Float, c : Float, d : Float, e : Float, f : Float ) : Void;

    public function resetTransform():Void this.context.resetTransform();

    //function createLinearGradient( x0 : Float, y0 : Float, x1 : Float, y1 : Float ) : CanvasGradient;
    //function createRadialGradient( x0 : Float, y0 : Float, r0 : Float, x1 : Float, y1 : Float, r1 : Float ) : CanvasGradient;

    //function createPattern( image : haxe.extern.EitherType<ImageElement,haxe.extern.EitherType<CanvasElement,haxe.extern.EitherType<VideoElement,ImageBitmap>>>, repetition : String ) : CanvasPattern;

    public function clearRect(x:Float, y:Float, w:Float, h:Float):Void this.context.clearRect(x, y, w, h);
    public function fillRect(x:Float, y:Float, w:Float, h:Float):Void this.context.fillRect(x, y, w, h);
    public function strokeRect(x:Float, y:Float, w:Float, h:Float):Void this.context.strokeRect(x, y, w, h);

    public function beginPath():Void this.context.beginPath();

    //@:overload( function( ?winding : CanvasWindingRule = "nonzero" ) : Void {} )
    //function fill( path : Path2D, ?winding : CanvasWindingRule = "nonzero" ) : Void;

    //@:overload( function() : Void {} )
    //function stroke( path : Path2D ) : Void;

    //function drawFocusIfNeeded( element : Element ) : Void;
    //function drawCustomFocusRing( element : Element ) : Bool;
    //@:overload( function( ?winding : CanvasWindingRule = "nonzero" ) : Void {} )
    //function clip( path : Path2D, ?winding : CanvasWindingRule = "nonzero" ) : Void;
    //@:overload( function( x : Float, y : Float, ?winding : CanvasWindingRule = "nonzero" ) : Bool {} )
    //function isPointInPath( path : Path2D, x : Float, y : Float, ?winding : CanvasWindingRule = "nonzero" ) : Bool;
    //@:overload( function( x : Float, y : Float ) : Bool {} )
    //function isPointInStroke( path : Path2D, x : Float, y : Float ) : Bool;

    //function fillText(text:String, x:Float, y:Float, ?maxWidth:Float):Void this.context.fillText(text, x, y, maxWidth);
    //function strokeText(text:String, x:Float, y:Float, ?maxWidth:Float):Void this.context.strokeText(text, x, y, maxWidth);
    //function measureText(text:String):TextMetrics;

    //@:overload( function( image : haxe.extern.EitherType<ImageElement,haxe.extern.EitherType<CanvasElement,haxe.extern.EitherType<VideoElement,ImageBitmap>>>, dx : Float, dy : Float ) : Void {} )
    //@:overload( function( image : haxe.extern.EitherType<ImageElement,haxe.extern.EitherType<CanvasElement,haxe.extern.EitherType<VideoElement,ImageBitmap>>>, dx : Float, dy : Float, dw : Float, dh : Float ) : Void {} )
    //function drawImage( image : haxe.extern.EitherType<ImageElement,haxe.extern.EitherType<CanvasElement,haxe.extern.EitherType<VideoElement,ImageBitmap>>>, sx : Float, sy : Float, sw : Float, sh : Float, dx : Float, dy : Float, dw : Float, dh : Float ) : Void;

    //function addHitRegion( ?options : HitRegionOptions ) : Void;
    //function removeHitRegion( id : String ) : Void;
    //function clearHitRegions() : Void;

    //@:overload( function( sw : Float, sh : Float ) : ImageData {} )
    //function createImageData( imagedata : ImageData ) : ImageData;

    //function getImageData( sx : Float, sy : Float, sw : Float, sh : Float ) : ImageData;
    //@:overload( function( imagedata : ImageData, dx : Float, dy : Float ) : Void {} )
    //function putImageData( imagedata : ImageData, dx : Float, dy : Float, dirtyX : Float, dirtyY : Float, dirtyWidth : Float, dirtyHeight : Float ) : Void;

    public function setLineDash(segments:Array<Float>):Void this.context.setLineDash(segments);
    public function getLineDash():Array<Float> return this.context.getLineDash();
    public function closePath():Void this.context.closePath();

    public function moveTo(x:Float, y:Float):Void this.context.moveTo(x, y);
    public function lineTo(x:Float, y:Float):Void this.context.lineTo(x, y);

    public function quadraticCurveTo(cpx:Float, cpy:Float, x:Float, y:Float):Void this.context.quadraticCurveTo(cpx, cpy, x, y);
    public function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float):Void this.context.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);

    public function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void this.context.arcTo(x1, y1, x2, y2, radius);
    public function rect(x:Float, y:Float, w:Float, h:Float):Void this.context.rect(x, y, w, h);

    public function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool = false):Void this.arc(x, y, radius, startAngle, endAngle, anticlockwise);
    public function ellipse(x:Float, y:Float, radiusX:Float, radiusY:Float, rotation:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool = false):Void this.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise);
}
