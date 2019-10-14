package priori.net;

import js.jquery.JQuery;

#if (haxe_ver >= 4.0)
class PriRequestURLEncodedValues {
#else
class PriRequestURLEncodedValues implements Dynamic {
#end

    public function new() {

    }

    public function toString():String {
        var object:Dynamic = haxe.Json.parse(haxe.Json.stringify(this));
        return JQuery.param(object);
    }
}