package priori.assets;

import jQuery.Event;
import priori.event.PriEvent;
import jQuery.JQuery;

class AssetAudio extends Asset {

    private var _elementId:String;
    private var _isLoading:Bool = false;
    private var _isLoaded:Bool = false;
    private var _element:JQuery;

    public var urlMP3:String;

    public function new(id:String, urlOGG:String, urlMP3:String = null) {
        this.urlMP3 = urlMP3;

        super(id, urlOGG);
    }

    override public function load():Void {
        if (_isLoaded == false && _isLoading == false) {

            this._isLoading = true;

            this._element = new JQuery("<audio>");
            this._element.on("loadeddata", this._onLoadAudio);

            if (this.url != null && this.url != "") {
                this._element.append(new JQuery("<source>", {src : this.url, type : "audio/ogg"}));
            }

            if (this.urlMP3 != null && this.urlMP3 != "") {
                this._element.append(new JQuery("<source>", {src : this.urlMP3, type : "audio/mp3"}));
            }

            this._element.find("source").on("error", this._onErrorAudio);

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

    private function _onErrorAudio(e:Event):Void {
        this._isLoading = false;
        this._isLoaded = false;

        this._element.off();
        this._element.find("source").off();
        this._element = null;

        this.dispatchEvent(new PriEvent(PriEvent.ERROR));
    }

    private function _onLoadAudio(e:Event):Void {
        this._isLoading = false;
        this._isLoaded = true;

        this._element.off();
        this._element.find("source").off();

        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
    }
}
