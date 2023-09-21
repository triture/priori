package helper;

enum HelperPlatformType {
    WINDOWS;
    MAC;
    LINUX;
    UNKNOW;
}

class HelperPlatform {

    public function new() {

    }

    @:isVar public var host(get, null):HelperPlatformType;
    private var _host:HelperPlatformType;

    function get_host():HelperPlatformType {

        if (_host == null) {
            if (new EReg("window", "i").match(Sys.systemName())) {
                _host = HelperPlatformType.WINDOWS;

            } else if (new EReg ("linux", "i").match(Sys.systemName())) {
                _host = HelperPlatformType.LINUX;

            } else if (new EReg ("mac", "i").match(Sys.systemName())) {
                _host = HelperPlatformType.MAC;

            } else {
                _host = HelperPlatformType.UNKNOW;

            }
        }

        return _host;
    }



}
