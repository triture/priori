package priori.audio;

import priori.assets.AssetAudio;
import priori.assets.AssetManager;
import priori.assets.Asset;
import priori.event.PriEvent;
import jQuery.Event;
import jQuery.JQuery;

import priori.event.PriEventDispatcher;

class PriAudio extends PriEventDispatcher {

    @:isVar public var currentTime(get, set):Float;
    @:isVar public var duration(get, null):Float;
    @:isVar public var volume(get, set):Float;
    @:isVar public var loop(get, set):Bool;

    private var _priId:String;
    private var _element:JQuery;

    private var _playing:Bool = false;

    private var _loader:AssetAudio;

    public function new(assetId:String = null) {
        super();

        if (assetId != null && assetId != "") {
            var asset:Asset = AssetManager.g().getAsset(assetId);

            if (asset != null) {
                if (Std.is(asset, AssetAudio)) {
                    this.loadByAsset(cast(asset, AssetAudio));
                } else {
                    throw "Asset is not an AssetAudio";
                }
            } else {
                throw "Asset not found or not loaded yet.";
            }
        }

//        this.audioInit();
    }

    private function resetStatus():Void {
        this.stop();

        this._playing = false;

        this.volume = 1;
        this.loop = false;

        if (this._element != null) {
            this._element.off();
            this._element.find("source").off();
            this._element.find("source").remove();
            this._element.remove();
        }
    }

    public function load(ogg:String, mp3:String = null):Void {
        this.resetStatus();

        if (this._loader != null) {
            _loader.kill();
            _loader = null;
        }

        this._loader = new AssetAudio("_internalasset", ogg, mp3);
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

    public function loadByAsset(asset:AssetAudio):Void {
        this.resetStatus();

        if (asset != null) {
            this._element = asset.getElement();
            this._element.on("ended", this._onEndedAudio);
        }
    }

    public function play():Void {
        if (this._element != null) {
            if (this._playing) {
                this.stop();
            }

            this._playing = true;
            this._element.trigger("play");
        }
    }

    public function stop():Void {
        if (this._element != null) {
            this._element.trigger("pause");
            this.currentTime = 0;
            this._playing = false;
        }
    }

    private function _onEndedAudio(e:Event):Void {
        this._playing = false;
        this.dispatchEvent(new PriEvent(PriEvent.STOP));
    }

    private function getElement():JQuery {
        return this._element;
    }

    @:noCompletion private function get_currentTime():Float {
        var result:Float = 0;

        if (this._element != null) result = this._element.prop("currentTime") + 0.0;

        return result;
    }

    @:noCompletion private function set_currentTime(value:Float):Float {
        if (this._element != null) {
            var cur:Float = value;

            if (cur < 0) cur = 0;
            if (cur > this.duration) cur = this.duration;

            this._element.prop("currentTime", cur);
        }

        return value;
    }

    @:noCompletion private function get_volume():Float {
        var result:Float = 0;

        if (this._element != null) result = this._element.prop("volume") + 0.0;

        return result;
    }

    @:noCompletion private function set_volume(value:Float):Float {
        if (this._element != null) {
            var vol:Float = value;

            if (vol > 1) vol = 1;
            if (vol < 0) vol = 0;

            this._element.prop("volume", vol);
        }

        return value;
    }

    @:noCompletion private function get_duration():Float {
        var result:Float = 0;

        if (this._element != null) result = this.getElement().prop("duration") + 0.0;

        return result;
    }

    @:noCompletion private function get_loop():Bool {
        var result:Bool = false;

        if (this._element != null) result = this.getElement().prop("loop");

        return result;
    }

    @:noCompletion private function set_loop(value:Bool):Bool {
        if (this._element != null) this.getElement().prop("loop", value);

        return value;
    }

    override public function kill():Void {
        this.resetStatus();

        this._element = null;
        super.kill();
    }
}
