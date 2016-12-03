package priori.view;

import js.html.CanvasRenderingContext2D;

class PriGraphic {

    private var context:CanvasRenderingContext2D;

    public function new(context:CanvasRenderingContext2D) {
        this.context = context;
    }


    function restore():Void this.context.restore();
    function scale(x:Float, y:Float):Void this.context.scale(x, y);
    function rotate(angle:Float):Void this.context.rotate(angle);
    function translate(x:Float, y:Float):Void this.context.translate(x, y);
    function transform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void this.context.transform(a, b, c, d, e, f);

    //function setTransform( a : Float, b : Float, c : Float, d : Float, e : Float, f : Float ) : Void;

    function resetTransform():Void this.context.resetTransform();

    //function createLinearGradient( x0 : Float, y0 : Float, x1 : Float, y1 : Float ) : CanvasGradient;
    //function createRadialGradient( x0 : Float, y0 : Float, r0 : Float, x1 : Float, y1 : Float, r1 : Float ) : CanvasGradient;

    //function createPattern( image : haxe.extern.EitherType<ImageElement,haxe.extern.EitherType<CanvasElement,haxe.extern.EitherType<VideoElement,ImageBitmap>>>, repetition : String ) : CanvasPattern;

    function clearRect(x:Float, y:Float, w:Float, h:Float):Void this.context.clearRect(x, y, w, h);
    function fillRect(x:Float, y:Float, w:Float, h:Float):Void this.context.fillRect(x, y, w, h);
    function strokeRect(x:Float, y:Float, w:Float, h:Float):Void this.context.strokeRect(x, y, w, h);

    function beginPath():Void this.context.beginPath();

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

    function setLineDash(segments:Array<Float>):Void this.context.setLineDash(segments);
    function getLineDash():Array<Float> return this.context.getLineDash();
    function closePath():Void this.context.closePath();

    function moveTo(x:Float, y:Float):Void this.context.moveTo(x, y);
    function lineTo(x:Float, y:Float):Void this.context.lineTo(x, y);

    function quadraticCurveTo(cpx:Float, cpy:Float, x:Float, y:Float):Void this.context.quadraticCurveTo(cpx, cpy, x, y);
    function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float):Void this.context.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);

    function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void this.context.arcTo(x1, y1, x2, y2, radius);
    function rect(x:Float, y:Float, w:Float, h:Float):Void this.context.rect(x, y, w, h);

    function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool = false):Void this.arc(x, y, radius, startAngle, endAngle, anticlockwise);
    function ellipse(x:Float, y:Float, radiusX:Float, radiusY:Float, rotation:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool = false):Void this.ellipse(x, y, radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise);
}
