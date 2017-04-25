package helper;

class Helper {

    public var output:HelperOutput;
    public var path:HelperPath;
    public var platform:HelperPlatform;
    public var process:HelperProcess;
    public var webserver:HelperWebserver;

    public function new() {
        if (_g != null) throw "use static .g()";
        else _g = this;


        this.output = new HelperOutput();
        this.path = new HelperPath();
        this.platform = new HelperPlatform();
        this.process = new HelperProcess();
        this.webserver = new HelperWebserver();
    }

    private static var _g:Helper;
    public static function g():Helper {
        if (_g == null) _g = new Helper();
        return _g;
    }
}
