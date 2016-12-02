package priori.view;


import priori.event.PriEvent;
import priori.assets.AssetManager;
import priori.assets.Asset;
import jQuery.JQuery;
import priori.assets.AssetImage;

class PriImage extends PriDisplay {

    private var _originalImageWidth:Int;
    private var _originalImageHeight:Int;

//    @:isVar public var scaleX(get, set):Float;
//    @:isVar public var scaleY(get, set):Float;

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

            this.width = this._originalImageWidth * this.scaleX;
            this.height = this._originalImageHeight * this.scaleY;
        }
    }

//    private function get_scaleX():Float {
//        var currWidth:Float = this.width;
//        var result:Float = currWidth / this._originalImageWidth;
//
//        return result;
//    }

    override private function set_scaleX(value:Float):Float {
        var val:Float = value == null ? 1 : value;

        this._scaleX = val;
        this.width = this._originalImageWidth * val;

        return value;
    }

    override private function set_scaleY(value:Float):Float {
        var val:Float = value == null ? 1 : value;

        this._scaleY = val;
        this.height = this._originalImageHeight * val;

        return value;
    }

//    private function get_scaleY():Float {
//        var currHeight = this.height;
//        var result:Float = currHeight / this._originalImageHeight;
//
//        return result;
//    }

    override private function __applyMatrixTransformation():Void {

    }

}
