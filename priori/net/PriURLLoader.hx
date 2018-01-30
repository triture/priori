package priori.net;

import js.html.ProgressEvent;
import priori.event.PriEvent;
import priori.event.PriEventDispatcher;
import haxe.Json;
import js.jquery.JqXHR;
import js.jquery.JQuery;
import js.html.XMLHttpRequest;

class PriURLLoader extends PriEventDispatcher {

    private var _isLoading:Bool;
    private var _isLoaded:Bool;
    private var ajax:JqXHR;

    public var data:Dynamic;

    private var _responseHeaders:String = "";
    @:isVar public var status(default, null):Int = -1;
    @:isVar public var statusText(default, null):String = "";

    public function new(request:PriURLRequest = null) {
        super();

        this._isLoaded = false;
        this._isLoading = false;

        if (request != null) {
            this.load(request);
        }

    }


    public function getResponseHeaders():Array<PriURLHeader> {

        if (this._responseHeaders == null) return [];

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

    // If this is a CORS request, you may see all headers in debug tools (such as Chrome->Inspect Element->Network),
    // but the xHR object will only retrieve the header (via xhr.getResponseHeader('Header')) if such a header is a
    // simple response header
    // reference: http://stackoverflow.com/questions/1557602/jquery-and-ajax-response-header
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

            // reset old request data
            this.status = -1;
            this.statusText = "";
            this._responseHeaders = "";
            this.data = null;

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

            ajaxObject.xhr = function() {
                var xhr = new XMLHttpRequest();

                xhr.upload.addEventListener("progress", this.onProgress, false);
                xhr.addEventListener("progress", this.onProgress, false);

                return xhr;
            }

            JQuery.support.cors = true;

            this.ajax = JQuery.ajax(ajaxObject);
        }
    }

    private function onProgress(e:ProgressEvent):Void {
        if (e.lengthComputable) {
            var percentComplete = e.loaded / e.total;
            this.dispatchEvent(new PriEvent(PriEvent.PROGRESS, false, false, percentComplete));
        }
    }

    private function onSuccess(data:Dynamic, status:String, e:JqXHR):Void {
        this._isLoaded = true;
        this._isLoading = false;

        if (this.ajax == null) {
            this._responseHeaders = "";
            this.status = 200;
            this.statusText = "success";
        } else {
            this._responseHeaders = this.ajax.getAllResponseHeaders();
            this.status = this.ajax.status;
            this.statusText = this.ajax.statusText;
        }

        this.data = data;
        this.ajax = null;

        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE, false, false, data));
    }

    private function onError(data):Void {
        this._isLoaded = false;
        this._isLoading = false;

        if (this.ajax == null) {
            this._responseHeaders = "";
            this.status = -1;
            this.statusText = "undefined";
        } else {
            this._responseHeaders = this.ajax.getAllResponseHeaders();
            this.status = this.ajax.status;
            this.statusText = this.ajax.statusText;
        }

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
