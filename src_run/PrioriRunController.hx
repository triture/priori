package ;

import controller.BuilderController;
import controller.TemplateController;
import controller.HaxelibController;
import controller.DataController;
import controller.ArgsController;

class PrioriRunController {

    private static var instance:PrioriRunController = new PrioriRunController();
    public static function getInstance():PrioriRunController return instance;

    public var args:ArgsController;
    public var data:DataController;
    public var haxelib:HaxelibController;
    public var template:TemplateController;
    public var builder:BuilderController;

    private function new() {
        this.args = new ArgsController();
        this.data = new DataController();
        this.haxelib = new HaxelibController();
        this.template = new TemplateController();
        this.builder = new BuilderController();
    }
}
