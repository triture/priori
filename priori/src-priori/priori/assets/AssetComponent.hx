package priori.assets;

import priori.event.PriEvent;
import js.jquery.JQuery;

class AssetComponent extends Asset {


    private var _content:String;

    private var _isLoading:Bool = false;
    private var _isLoaded:Bool = false;



    public function new(id:String, url:String) {
        super(id, url);
    }

    override public function load() {
        if (_isLoaded == false && _isLoading == false) {

            this._isLoading = true;

            JQuery.ajax({

                method : "GET",

                url : this.url,

                async : true,
                cache : true,

                error : function(e):Void {
                    this._isLoading = false;
                    this._isLoaded = false;

                    this.dispatchEvent(new PriEvent(PriEvent.ERROR));
                },

                success : function(data):Void {
                    this._content = data;

                    this._isLoading = false;
                    this._isLoaded = true;

                    //trace(this._content);

                    this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
                }

            });
        } else if (_isLoaded) {
            this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
        }
    }

    public function getContent():String {
        if (_isLoaded == false) throw "Asset not loaded";
        return this._content;
    }

    override public function getElement():JQuery {
        if (_isLoaded == false) {
            throw "Asset not loaded";
        }

        var result:JQuery = new JQuery(this._content);

        return result;
    }

}
