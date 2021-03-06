package model;

typedef HaxelibVO = {

    var libName:String;

    @:optional var isHaxelib:Bool;
    @:optional var hasPrioriJson:Bool;
    @:optional var hasPrioriTemplate:Bool;

    @:optional var priori:PrioriDataVO;

    @:optional var filenamePrioriJson:String;
    @:optional var pathPrioriJson:String;

    @:optional var pathHaxelib:String;
    @:optional var pathPrioriTemplate:String;

    @:optional var error:Bool;
    @:optional var errorMessage:String;
}
