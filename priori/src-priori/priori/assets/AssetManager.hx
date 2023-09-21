package priori.assets;

import priori.event.PriEvent;
import priori.event.PriEventDispatcher;

class AssetManager extends PriEventDispatcher {

    private var queueList:Array<Asset> = [];
    private var loadedList:Array<Asset> = [];

    private var _isLoading:Bool;
    private var _isLoaded:Bool;

    public var maxError:Int = 10;
    private var _totalErrors:Int = 0;

    public function new() {
        super();

        if (_g != null) {
            throw "Use static g()";
        }

        this._isLoading = false;
        this._isLoaded = false;
    }

    public function getAsset(id:String):Asset {
        var i:Int = 0;
        var n:Int = this.loadedList.length;
        var result:Asset = null;

        while (i < n) {
            if (this.loadedList[i].id == id) {
                result = this.loadedList[i];
            }

            i++;
        }

        return result;
    }

    public function addToQueue(asset:Asset):Void {
        if (this.queueList.indexOf(asset) == -1 && this.loadedList.indexOf(asset) == -1) {
            asset.addEventListener(PriEvent.COMPLETE, onAssetComplete);
            asset.addEventListener(PriEvent.ERROR, onAssetError);

            this.queueList.push(asset);
        }
    }

    public function load():Void {
        if (this._isLoaded == false && this._isLoading == false) {

            this._totalErrors = 0;

            this.tryLoadNextAsset();
        }
    }

    private function tryLoadNextAsset():Void {
        if (this.queueList.length == 0) {

            this._isLoading = false;
            this._isLoaded = true;

            this.dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSET_COMPLETE, getPercentCompleted()));
        } else {
            this.queueList[0].load();
        }
    }

    public function getPercentCompleted():Float {
        var total = this.queueList.length + this.loadedList.length;
        var loaded = this.loadedList.length;
        var percent:Float;

        if (total == 0) {
            percent = 1;
        } else {
            percent = loaded/total;
        }

        return percent;
    }

    private function onAssetComplete(e:PriEvent):Void {
        var asset:Asset = cast(e.currentTarget, Asset);

        this.queueList.remove(asset);
        this.loadedList.push(asset);

        asset.removeEventListener(PriEvent.COMPLETE, onAssetComplete);
        asset.removeEventListener(PriEvent.ERROR, onAssetError);

        #if debug
        trace(" * ASSET MANAGER : Loaded " + (Std.int(this.getPercentCompleted()*100)) + "%");
        #end

        this.dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSET_PROGRESS, getPercentCompleted()));

        this.tryLoadNextAsset();
    }

    private function onAssetError(e:PriEvent):Void {
        var asset:Asset = cast(e.currentTarget, Asset);

        #if debug
        trace(" > Erro loading " + asset.id);
        #end

        this._totalErrors ++;

        if (this._totalErrors < this.maxError) {

            // no caso de erro, transfere o asset para o fim da lista
            this.queueList.remove(asset);
            this.queueList.push(asset);

            this.tryLoadNextAsset();
        } else {
            this._isLoaded = false;
            this._isLoading = false;

            this.dispatchEvent(new AssetManagerEvent(AssetManagerEvent.ASSET_ERROR, getPercentCompleted()));
        }
    }


    private static var _g:AssetManager;
    public static function g():AssetManager {
        if (_g == null) _g = new AssetManager();
        return _g;
    }
}
