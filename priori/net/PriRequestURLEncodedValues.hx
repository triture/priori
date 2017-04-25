package priori.net;

import js.jquery.JQuery;

class PriRequestURLEncodedValues implements Dynamic {

    public function new() {

    }

    public function toString():String {
        var object:Dynamic = haxe.Json.parse(haxe.Json.stringify(this));
        return JQuery.param(object);
    }
}