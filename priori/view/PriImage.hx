package priori.view;

import haxe.io.BytesData;
import haxe.io.Bytes;
import js.html.Image;
import priori.app.PriApp;
import priori.event.PriEvent;
import priori.assets.AssetManager;
import priori.assets.Asset;
import js.jquery.JQuery;
import priori.assets.AssetImage;

class PriImage extends PriDisplay {

    private var _originalImageWidth:Int;
    private var _originalImageHeight:Int;

    private var _imageScaleX:Float = 1;
    private var _imageScaleY:Float = 1;

    public var imageScaleX(get, set):Float;
    public var imageScaleY(get, set):Float;

    private var _imageObject:Image;
    private var _loader:AssetImage;
    private var _imageElement:JQuery;

    public function new(assetId:String = null) {
        super();

        this._originalImageWidth = 0;
        this._originalImageHeight = 0;

        if (assetId != null && assetId != "") {
            var asset:Asset = AssetManager.g().getAsset(assetId);

            if (asset != null) {
                if (Std.is(asset, AssetImage)) {
                    this.loadByAsset(cast(asset, AssetImage));
                } else {
                    throw "Asset is not an AssetImage";
                }
            } else {
                throw "Asset not found or not loaded yet.";
            }
        }
    }

    private function clearCurrentImage():Void {
        if (this._imageObject != null) {
            this._imageObject.onload = null;
            this._imageObject.onerror = null;
            this._imageObject = null;
        }

        if (this._imageElement != null) {
            this._imageElement.remove();
            this._imageElement.off();
        }

        this.killImageLoader();
    }

    private function killImageLoader():Void {
        if (this._loader != null) {
            this._loader.removeEventListener(PriEvent.COMPLETE, this.onAssetComplete);
            this._loader.removeEventListener(PriEvent.ERROR, this.onAssetError);
            this._loader.kill();
            this._loader = null;
        }
    }

    public function loadImageData(base64ImageData:String, type:String = "jpeg"):Void {
        this.clearCurrentImage();

        this._imageObject = new Image();
        this._imageObject.onload = function():Void {
            this._imageObject.onload = null;
            this._imageObject.onerror = null;

            this._originalImageWidth = this._imageObject.naturalWidth;
            this._originalImageHeight = this._imageObject.naturalHeight;
            this._imageElement = new JQuery(this._imageObject);

            this.startImageElement();
            this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
        }
        this._imageObject.onerror = function():Void {
            this._imageObject.onload = null;
            this._imageObject.onerror = null;

            this.dispatchEvent(new PriEvent(PriEvent.ERROR));
        }

        this._imageObject.src = 'data:image/${type};base64,${base64ImageData}';
    }

    public function load(imageURL:String):Void {
        this.clearCurrentImage();

        this._loader = new AssetImage("_internalasset", imageURL);
        this._loader.addEventListener(PriEvent.COMPLETE, this.onAssetComplete);
        this._loader.addEventListener(PriEvent.ERROR, this.onAssetError);
        this._loader.load();
    }

    public function loadURL(url:String):Void {
        this.clearCurrentImage();

        this._imageObject = new Image();
        this._imageObject.onload = function():Void {
            this._imageObject.onload = null;
            this._imageObject.onerror = null;

            this._originalImageWidth = this._imageObject.naturalWidth;
            this._originalImageHeight = this._imageObject.naturalHeight;
            this._imageElement = new JQuery(this._imageObject);

            this.startImageElement();
            this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
        }
        this._imageObject.onerror = function():Void {
            this._imageObject.onload = null;
            this._imageObject.onerror = null;

            this.dispatchEvent(new PriEvent(PriEvent.ERROR));
        }

        this._imageObject.src = url;
    }

    private function onAssetComplete(e:PriEvent):Void {
        this.loadByAsset(this._loader);
        this.killImageLoader();
        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
    }

    private function onAssetError(e:PriEvent):Void {
        this.killImageLoader();
        this.dispatchEvent(new PriEvent(PriEvent.ERROR));
    }

    public function loadByAsset(asset:AssetImage):Void {
        if (asset != null) {
            this.clearCurrentImage();

            this._originalImageWidth = asset.imageWidth;
            this._originalImageHeight = asset.imageHeight;

            this._imageElement = asset.getElement();
            this._imageObject = cast this._imageElement.get(0);

            this.startImageElement();
        }
    }

    private function startImageElement():Void {
        this._imageElement.css("width", "100%");
        this._imageElement.css("height", "100%");
        this._imageElement.attr("onmousedown", "if (event.preventDefault) event.preventDefault()");
        this._imageElement.attr("draggable", "false");

        this.getElement().append(this._imageElement);

        this.width = this._originalImageWidth * this._imageScaleX;
        this.height = this._originalImageHeight * this._imageScaleY;
    }

    private function get_imageScaleX():Float {
        if (this._originalImageWidth == 0) return this._imageScaleX;
        var result:Float = this.width / this._originalImageWidth;
        return result;
    }

    private function set_imageScaleX(value:Float):Float {
        var val:Float = value == null ? 1 : value;

        this._imageScaleX = val;
        this.width = this._originalImageWidth * val;

        return value;
    }

    private function get_imageScaleY():Float {
        if (this._originalImageHeight == 0) return this._imageScaleY;
        var result:Float = this.height / this._originalImageHeight;
        return result;
    }

    private function set_imageScaleY(value:Float):Float {
        var val:Float = value == null ? 1 : value;
        this._imageScaleY = val;
        this.height = this._originalImageHeight * val;
        return value;
    }

    public function resizeToWidth(width:Float):Void {
        this.width = width;
        this.imageScaleY = this.imageScaleX;
    }

    public function resizeToHeight(height:Float):Void {
        this.height = height;
        this.imageScaleX = this.imageScaleY;
    }

    public function resizeToLetterBox(width:Float, height:Float):Void {
        this.resizeToWidth(width);
        if (this.height > height) this.resizeToHeight(height);
    }

    public function resizeToZoom(width:Float, height:Float):Void {
        this.resizeToWidth(width);
        if (this.height < height) this.resizeToHeight(height);
    }
}
