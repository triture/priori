package priori.assets;

import priori.event.PriEventDispatcher;
import js.jquery.JQuery;
import String;

class Asset extends PriEventDispatcher {

    public var id:String;
    public var url:String;

    public function new(id:String, url:String) {
        super();

        this.id = id;
        this.url = url;
    }

    public function load():Void {

    }

    public function getElement():JQuery {
        return new JQuery();
    }

}
