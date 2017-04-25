package model;

typedef ArgsVO = {
    @:optional var command:String;
    @:optional var currPath:String;
    @:optional var prioriFile:String;
    @:optional var port:Int;
    @:optional var dList:Array<String>;
    @:optional var error:Bool;
    @:optional var errorMessage:String;
}
