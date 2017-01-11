package priori.assets;

import priori.system.PriDeviceSystem;
import priori.system.PriDevice;
import jQuery.Event;
import priori.event.PriEvent;
import jQuery.JQuery;

class AssetAudio extends Asset {

    private var _elementId:String;
    private var _isLoading:Bool = false;
    private var _isLoaded:Bool = false;
    private var _element:JQuery;

    public var urlMP3:String;

    public function new(id:String, urlMP3:String, urlOGG:String = null) {
        this.urlMP3 = urlMP3;

        super(id, urlOGG);
    }

    override public function load():Void {
        if (_isLoaded == false && _isLoading == false) {

            this._isLoading = true;

            this._element = new JQuery("<audio>");
            var dom:Dynamic = this._element.get(0);

            var canPlayAny:Bool = false;

            if (dom.canPlayType != null) {

                if (PriDevice.deviceSystem() == PriDeviceSystem.IOS) {
                    this._element.on("progress", this._onLoadAudio);
                } else {
                    this._element.on("loadeddata", this._onLoadAudio);
                }

                if (dom.canPlayType("audio/ogg;")) {
                    if (this.url != null && this.url != "") {
                        this._element.append(new JQuery("<source>", {src : this.url, type : "audio/ogg"}));
                        canPlayAny = true;
                    }
                } else {
                    #if debug
                    trace("This browser cannot play ogg audio files");
                    #end
                }

                if (!canPlayAny) {
                    if (dom.canPlayType("audio/mp3;")) {
                        if (this.urlMP3 != null && this.urlMP3 != "") {
                            this._element.append(new JQuery("<source>", {src : this.urlMP3, type : "audio/mp3"}));
                            canPlayAny = true;
                        }
                    } else {
                        #if debug
                        trace("This browser cannot play mp3 audio files");
                        #end
                    }
                }

                this._element.find("source").on("error", this._onErrorAudio);
            }

            if (!canPlayAny) {
                this.dispatchEvent(new PriEvent(PriEvent.ERROR));
            }

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
        #if debug
        trace("* AssetAudio Loading Error");
        trace(e);
        #end
        this._isLoading = false;
        this._isLoaded = false;

        this._element.off();
        this._element.find("source").off();
        this._element = null;

        this.dispatchEvent(new PriEvent(PriEvent.ERROR));
    }

    private function _onLoadAudio(e:Event):Void {
        #if debug
        trace("* AssetAudio Loaded");
        trace(e);
        #end
        this._isLoading = false;
        this._isLoaded = true;

        this._element.off();
        this._element.find("source").off();

        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
    }
}
