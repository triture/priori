package priori.net;

class PriURLRequest {


    public var data:Dynamic;
    public var contentType:String;
    public var method:String;
    public var requestHeader:Array<PriURLHeader>;
    public var url:String;
    public var userAgent:String;
    public var cache:Bool;

    public function new(url:String) {
        this.url = url;

        this.method = PriRequestMethod.POST;
        this.contentType = PriRequestContentType.MULTIPART_FORM_DATA;
        this.cache = true;
    }
}
