package priori.assets;

import priori.event.PriEvent;
import jQuery.Event;
import jQuery.JQuery;

class AssetImage extends Asset {

    private var _elementId:String;
    private var _isLoading:Bool = false;
    private var _isLoaded:Bool = false;
    private var _element:JQuery;

    public var imageWidth:Int = 0;
    public var imageHeight:Int = 0;

    public function new(id:String, url:String) {
        super(id, url);
    }

    override public function load():Void {
        if (_isLoaded == false && _isLoading == false) {

            this._isLoading = true;

            this._element = new JQuery("<img>", {
                src : this.url
            });

            this._element.bind("load", {}, onImageLoad);
            this._element.bind("error", {}, onImageError);


        } else if (_isLoaded) {
            this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
        }
    }

    override public function getElement():JQuery {
        if (_isLoaded == false) {
            throw "Asset not loaded";
        }

        return this._element.clone();
    }

    private function onImageError(e:Event):Void {
        this._isLoading = false;
        this._isLoaded = false;

        this._element.unbind();
        this._element = null;

        //trace("image load error");

        this.dispatchEvent(new PriEvent(PriEvent.ERROR));
    }

    private function onImageLoad(e:Event):Void {
        this._isLoading = false;
        this._isLoaded = true;

        //trace("image load complete");

        this._element.unbind();
        this._element.css("display", "none");

        var body:JQuery = new JQuery("body");
        body.append(this._element);

        this.imageWidth = Std.int(this._element.width());
        this.imageHeight = Std.int(this._element.height());

        this._element.remove();
        this._element.css("display", "");


        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
    }

}
