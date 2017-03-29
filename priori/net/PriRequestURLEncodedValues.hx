package priori.net;

import jQuery.JQueryStatic;

class PriRequestURLEncodedValues implements Dynamic {

    public function new() {

    }

    public function toString():String {
        var object:Dynamic = haxe.Json.parse(haxe.Json.stringify(this));

        return JQueryStatic.param(object);
    }
}