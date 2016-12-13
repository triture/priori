package priori.view;

import priori.event.PriEvent;
import priori.assets.AssetManager;
import priori.assets.Asset;
import jQuery.JQuery;
import priori.assets.AssetImage;

class PriImage extends PriDisplay {

    private var _originalImageWidth:Int;
    private var _originalImageHeight:Int;

    private var _imageScaleX:Float = 1;
    private var _imageScaleY:Float = 1;

    public var imageScaleX(get, set):Float;
    public var imageScaleY(get, set):Float;

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

    public function load(imageURL:String):Void {
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
        this.loadByAsset(this._loader);

        this._loader.kill();
        this._loader = null;

        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
    }

    private function onAssetError(e:PriEvent):Void {
        this._loader.kill();
        this._loader = null;

        this.dispatchEvent(new PriEvent(PriEvent.ERROR));
    }

    public function loadByAsset(asset:AssetImage):Void {
        if (asset != null) {
            this._originalImageWidth = asset.imageWidth;
            this._originalImageHeight = asset.imageHeight;

            this._imageElement = asset.getElement();
            this._imageElement.css("width", "100%");
            this._imageElement.css("height", "100%");
            this._imageElement.attr("onmousedown", "if (event.preventDefault) event.preventDefault()");
            this._imageElement.attr("draggable", "false");

            this.getElement().append(this._imageElement);

            this.width = this._originalImageWidth * this._imageScaleX;
            this.height = this._originalImageHeight * this._imageScaleY;
        }
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
}
