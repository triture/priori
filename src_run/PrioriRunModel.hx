package ;

import model.HaxelibVO;
import model.ArgsVO;

class PrioriRunModel {

    private static var instance:PrioriRunModel = new PrioriRunModel();
    public static function getInstance():PrioriRunModel return instance;

    public var args:ArgsVO;
    public var haxelibs:Array<HaxelibVO>;

    public var app(get, null):HaxelibVO;

    private function new() {

        this.haxelibs = [];

    }

    private function get_app():HaxelibVO {
        if (this.haxelibs.length > 1) return this.haxelibs[this.haxelibs.length-1];
        return null;
    }
}
