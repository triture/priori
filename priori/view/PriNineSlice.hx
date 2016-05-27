package priori.view;

import priori.geom.PriGeomBox;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import js.html.Image;
import priori.event.PriEvent;
import priori.assets.AssetManager;
import priori.assets.Asset;
import priori.assets.AssetImage;
import jQuery.JQuery;

class PriNineSlice extends PriDisplay {

    private var _originalImageWidth:Int;
    private var _originalImageHeight:Int;

    private var _loader:AssetImage;
    private var _canvas:CanvasElement;
    private var _imageElement:JQuery;

    private var _left:Float;
    private var _top:Float;
    private var _right:Float;
    private var _bottom:Float;

    private var cropPixels:Dynamic;
    private var _smallerWidth:Float;
    private var _smallerHeight:Float;

    @:isVar public var smoothEdges(default, set):Bool;
    @:isVar public var smoothSides(default, set):Bool;
    @:isVar public var smoothCenter(default, set):Bool;
    @:isVar public var smoothAll(get, set):Bool;

    public function new(assetId:String = null, left:Float = 0.2, top:Float = 0.2, right:Float = 0.2, bottom:Float = 0.2) {
        this._canvas = js.Browser.document.createCanvasElement();

        super();
        this.clipping = true;
        this.smoothAll = true;

        this._canvas.setAttribute("style", "width:100%;height:100%;");
        this.getElement().append(this._canvas);

        this._originalImageWidth = 1;
        this._originalImageHeight = 1;

        this.updateSliceCrop(left, top, right, bottom);

        if (assetId != null && assetId != "") {
            var asset:Asset = AssetManager.g().getAsset(assetId);

            if (asset != null) {
                if (Std.is(asset, AssetImage)) {
                    this.loadByAsset(cast(asset, AssetImage), left, top, right, bottom);
                } else {
                    throw "Asset is not an AssetImage";
                }
            } else {
                throw "Asset not found or not loaded yet.";
            }
        }
    }

    function get_smoothAll():Bool {
        return (this.smoothEdges && this.smoothSides && this.smoothCenter);
    }

    function set_smoothAll(value:Bool) {
        this.smoothEdges = this.smoothSides = this.smoothCenter = value;
        this.updateSliceDraw();
        return value;
    }

    function set_smoothEdges(value:Bool) {
        this.smoothEdges = value;
        this.updateSliceDraw();
        return value;
    }

    function set_smoothSides(value:Bool) {
        this.smoothSides = value;
        this.updateSliceDraw();
        return value;
    }

    function set_smoothCenter(value:Bool) {
        this.smoothCenter = value;
        this.updateSliceDraw();
        return value;
    }


    public function load(imageURL:String, left:Float = 0.2, top:Float = 0.2, right:Float = 0.2, bottom:Float = 0.2):Void {
        this.updateSliceCrop(left, top, right, bottom);

        if (this._loader != null) {
            _loader.kill();
            _loader = null;
        }

        this._loader = new AssetImage("_internalasset", imageURL);
        this._loader.addEventListener(PriEvent.COMPLETE, this.onAssetComplete);
        this._loader.addEventListener(PriEvent.ERROR, this.onAssetError);
        this._loader.load();
    }

    private function onAssetComplete(e:PriEvent):Void {
        var pixels:Dynamic = this.cropPixels;

        this.loadByAsset(this._loader, this._left, this._top, this._right, this._bottom);

        if (pixels != null) {
            this.updateSliceCropInPixels(
                pixels.left,
                pixels.top,
                pixels.right,
                pixels.bottom
            );
        }

        this._loader.kill();
        this._loader = null;

        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
    }

    private function onAssetError(e:PriEvent):Void {
        this._loader.kill();
        this._loader = null;

        this.dispatchEvent(new PriEvent(PriEvent.ERROR));
    }

    public function loadByAsset(asset:AssetImage, left:Float = 0.2, top:Float = 0.2, right:Float = 0.2, bottom:Float = 0.2):Void {
        if (asset != null) {
            this._originalImageWidth = asset.imageWidth;
            this._originalImageHeight = asset.imageHeight;

            this._imageElement = asset.getElement();

            this.width = this._originalImageWidth;
            this.height = this._originalImageHeight;

            this.updateSliceCrop(left, top, right, bottom);
        } else {
            this.updateSliceCrop(left, top, right, bottom);
        }
    }

    public function updateSliceCropInPixels(left:Int = null, top:Int = null, right:Int = null, bottom:Int = null):Void {

        this.cropPixels = {
            left : left,
            top : top,
            right : right,
            bottom : bottom
        };

        if (this._imageElement != null) {
            var w:Float = this._originalImageWidth;
            var h:Float = this._originalImageHeight;

            if (left != null) this._left = left/w;
            if (top != null) this._top = top/h;
            if (right != null) this._right = right/w;
            if (bottom != null) this._bottom = bottom/h;

            this._smallerWidth = Math.ffloor(left + right);
            this._smallerHeight = Math.ffloor(top + bottom);

            this.updateCanvasWidth();
            this.updateCanvasHeight();

            this.updateSliceDraw();

        } else {
            this._smallerWidth = 0;
            this._smallerHeight = 0;
        }
    }

    public function updateSliceCrop(left:Float = null, top:Float = null, right:Float = null, bottom:Float = null):Void {

        this.cropPixels = null;

        if (left != null) this._left = left;
        if (top != null) this._top = top;
        if (right != null) this._right = right;
        if (bottom != null) this._bottom = bottom;

        if (this._imageElement != null) {
            var w:Float = this._originalImageWidth;
            var h:Float = this._originalImageHeight;

            this._smallerWidth = Math.ffloor(w * left + w * right);
            this._smallerHeight = Math.ffloor(h * top + h * bottom);
        } else {
            this._smallerWidth = 0;
            this._smallerHeight = 0;
        }

        this.updateCanvasWidth();
        this.updateCanvasHeight();

        this.updateSliceDraw();
    }

    private function updateSliceDraw():Void {
        if (this._imageElement != null) {

            var context:CanvasRenderingContext2D = this._canvas.getContext2d();

            var w:Float = this._originalImageWidth;
            var h:Float = this._originalImageHeight;

            var lw:Float = 0;
            var cw:Float = 0;
            var rw:Float = 0;

            var th:Float = 0;
            var ch:Float = 0;
            var bh:Float = 0;

            if (this.cropPixels != null) {
                lw = Math.ffloor(this.cropPixels.left);
                cw = Math.ffloor(w - (this.cropPixels.left + this.cropPixels.right));
                rw = Math.ffloor(this.cropPixels.right);

                th = Math.ffloor(this.cropPixels.top);
                ch = Math.ffloor(h - (this.cropPixels.top + this.cropPixels.bottom));
                bh = Math.ffloor(this.cropPixels.bottom);
            } else {
                lw = Math.ffloor(w*this._left);
                cw = Math.ffloor(w - (w*this._left + w*this._right));
                rw = Math.ffloor(w*this._right);

                th = Math.ffloor(h*this._top);
                ch = Math.ffloor(h - (h*this._top + h*this._bottom));
                bh = Math.ffloor(h*this._bottom);
            }

            // getting slice boxes
            var TLR:PriGeomBox = new PriGeomBox(0, 0, lw, th);
            var TCR:PriGeomBox = new PriGeomBox(lw, 0, cw, th);
            var TRR:PriGeomBox = new PriGeomBox(w - rw, 0, rw, th);

            var CLR:PriGeomBox = new PriGeomBox(0, th, lw, ch);
            var CCR:PriGeomBox = new PriGeomBox(lw, th, cw, ch);
            var CRR:PriGeomBox = new PriGeomBox(w - rw, th, rw, ch);

            var BLR:PriGeomBox = new PriGeomBox(0, h - bh, lw, bh);
            var BCR:PriGeomBox = new PriGeomBox(lw, h - bh, cw, bh);
            var BRR:PriGeomBox = new PriGeomBox(w - rw, h - bh, rw, bh);


            // drawing
            var curW:Float = Math.ffloor(this._canvas.width);
            var curH:Float = Math.ffloor(this._canvas.height);

            var cFinalW:Float = curW - lw - rw;
            var cFinalH:Float = curH - th - bh;

            if (cw < 0) cw = 0;
            if (ch < 0) ch = 0;

            var cwscale:Float = cFinalW/CCR.width;
            var chscale:Float = cFinalH/CCR.height;


            var imageElement:Image = cast this._imageElement.get()[0];

            context.clearRect(0, 0, this._canvas.width, this._canvas.height);

            if (this.smoothCenter) {
                (cast context).mozImageSmoothingEnabled = true;
                (cast context).webkitImageSmoothingEnabled = true;
                (cast context).msImageSmoothingEnabled = true;
                context.imageSmoothingEnabled = true;
            } else {
                (cast context).mozImageSmoothingEnabled = false;
                (cast context).webkitImageSmoothingEnabled = false;
                (cast context).msImageSmoothingEnabled = false;
                context.imageSmoothingEnabled = false;
            }
            if (cw > 0 && ch > 0) context.drawImage(imageElement, CCR.x, CCR.y, CCR.width, CCR.height, lw, th, CCR.width * cwscale, CCR.height * chscale);


            if (this.smoothSides) {
                (cast context).mozImageSmoothingEnabled = true;
                (cast context).webkitImageSmoothingEnabled = true;
                (cast context).msImageSmoothingEnabled = true;
                context.imageSmoothingEnabled = true;
            } else {
                (cast context).mozImageSmoothingEnabled = false;
                (cast context).webkitImageSmoothingEnabled = false;
                (cast context).msImageSmoothingEnabled = false;
                context.imageSmoothingEnabled = false;
            }
            if (cw > 0) context.drawImage(imageElement, TCR.x, TCR.y, TCR.width, TCR.height, lw, 0, TCR.width * cwscale, TCR.height);
            if (cw > 0) context.drawImage(imageElement, BCR.x, BCR.y, BCR.width, BCR.height, lw, curH - BCR.height, BCR.width * cwscale, BCR.height);
            if (ch > 0) context.drawImage(imageElement, CLR.x, CLR.y, CLR.width, CLR.height, 0, th, CLR.width, CLR.height * chscale);
            if (ch > 0) context.drawImage(imageElement, CRR.x, CRR.y, CRR.width, CRR.height, curW - CRR.width, th, CRR.width, CRR.height * chscale);

            if (this.smoothEdges) {
                (cast context).mozImageSmoothingEnabled = true;
                (cast context).webkitImageSmoothingEnabled = true;
                (cast context).msImageSmoothingEnabled = true;
                context.imageSmoothingEnabled = true;
            } else {
                (cast context).mozImageSmoothingEnabled = false;
                (cast context).webkitImageSmoothingEnabled = false;
                (cast context).msImageSmoothingEnabled = false;
                context.imageSmoothingEnabled = false;
            }
            context.drawImage(imageElement, TLR.x, TLR.y, TLR.width, TLR.height, 0, 0, TLR.width, TLR.height);
            context.drawImage(imageElement, TRR.x, TRR.y, TRR.width, TRR.height, curW - TRR.width, 0, TRR.width, TRR.height);
            context.drawImage(imageElement, BLR.x, BLR.y, BLR.width, BLR.height, 0, curH - BLR.height, BLR.width, BLR.height);
            context.drawImage(imageElement, BRR.x, BRR.y, BRR.width, BRR.height, curW - BRR.width, curH - BRR.height, BRR.width, BRR.height);

        }
    }

    private function updateCanvasWidth():Void {
        var smallerWidth:Float = 0;

        var curW:Float = this.width;
        if (curW < this._smallerWidth) curW = this._smallerWidth;

        this._canvas.width = Math.floor(curW);
    }

    private function updateCanvasHeight():Void {
        var smallerHeight:Float = 0;

        var curH:Float = this.height;
        if (curH < this._smallerHeight) curH = this._smallerHeight;

        this._canvas.height = Math.floor(curH);
    }

    @:noCompletion override private function set_width(value:Float) {
        super.set_width(value);
        this.updateCanvasWidth();
        this.updateSliceDraw();
        return value;
    }

    @:noCompletion override private function set_height(value:Float):Float {
        super.set_height(value);
        this.updateCanvasHeight();
        this.updateSliceDraw();
        return value;
    }
}
