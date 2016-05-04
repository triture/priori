package priori.assets;

import priori.event.PriEvent;
import jQuery.JQuery;

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

            JQuery._static.ajax({

                method : "GET",

                url : this.url,

                async : true,
                cache : true,
                dataType : "font",

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

    override public function getElement():JQuery {
        if (_isLoaded == false) {
            throw "Asset not loaded";
        }

        var result:JQuery = new JQuery(this._content);

        return result;
    }

}
