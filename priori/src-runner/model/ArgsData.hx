package model;

import model.ArgsCommand;

typedef ArgsData = {
    @:optional var command:ArgsCommand;
    @:optional var currPath:String;
    @:optional var prioriFile:String;
    @:optional var port:Int;
    @:optional var dList:Array<String>;
    @:optional var noHash:Bool;
}
