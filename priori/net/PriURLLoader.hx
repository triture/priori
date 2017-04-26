package priori.net;

import haxe.Json;
import priori.event.PriEvent;
import js.jquery.JqXHR;
import js.jquery.JQuery;
import priori.event.PriEventDispatcher;

class PriURLLoader extends PriEventDispatcher {


    private var _isLoading:Bool;
    private var _isLoaded:Bool;

    private var ajax:JqXHR;

    public var data:Dynamic;

    private var _responseHeaders:String = "";

    public function new(request:PriURLRequest = null) {
        super();

        this._isLoaded = false;
        this._isLoading = false;

        if (request != null) {
            this.load(request);
        }

    }


    public function getResponseHeaders():Array<PriURLHeader> {

        var result:Array<PriURLHeader> = [];
        var lines:Array<String> = this._responseHeaders.split("\n");

        for (line in lines) {

            var data:Array<String> = line.split(":");

            if (data.length > 1) {
                var header:String = StringTools.trim(data.shift());
                var value:String = StringTools.trim(data.join(":"));

                result.push(new PriURLHeader(header, value));
            }
        }

        return result;
    }

    private function getRequestHeaders(request:PriURLRequest):Dynamic {
        var result:Dynamic = {};

        if (request.requestHeader != null) {
            var i:Int = 0;
            var n:Int = request.requestHeader.length;

            while (i < n) {
                Reflect.setField(result, request.requestHeader[i].header, request.requestHeader[i].value);

                i++;
            }
        }

        return result;
    }

    public function load(request:PriURLRequest):Void {
        if (this._isLoaded == false && this._isLoading == false) {

            var contentType:String = request.contentType;
            var value:Dynamic = request.data;

            if (Std.is(request.data, PriRequestURLEncodedValues)) {
                contentType = PriRequestContentType.FORM_URLENCODED;
                value = cast(request.data, PriRequestURLEncodedValues).toString();
            } else if (request.contentType == PriRequestContentType.APPLICATION_JSON && !Std.is(request.data, String)) {
                value = haxe.Json.stringify(request.data);
            }

            var ajaxObject:Dynamic = {
                async : true,

                method : request.method,
                url : request.url,
                cache : request.cache,
                dataType : "text",
                contentType : contentType,

                data : value,

                headers : getRequestHeaders(request),

                error : this.onError,
                success : this.onSuccess
            };

            this.ajax = JQuery.ajax(ajaxObject);

        }
    }

    private function onSuccess(data:Dynamic, status:String, e:JqXHR):Void {
        this._isLoaded = true;
        this._isLoading = false;

        this.data = data;

        this.ajax = null;

        this._responseHeaders = e.getAllResponseHeaders();

        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE, false, false, data));
    }

    private function onError(data):Void {
        this._isLoaded = false;
        this._isLoading = false;

        this.data = data.responseText;
        this.ajax = null;

        this.dispatchEvent(new PriEvent(PriEvent.ERROR, false, false, data.responseText));
    }

    public function close():Void {
        if (this.ajax != null) {
            this.ajax.abort();

            this.ajax = null;

            this._isLoading = false;
            this._isLoaded = false;
        }
    }

    override public function kill():Void {
        this.close();

        super.kill();
    }
}
