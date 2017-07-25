package model;

typedef PrioriDataVO = {
    @:optional var file:String;
    @:optional var name:String;
    @:optional var lang:String;
    @:optional var meta:Array<String>;
    @:optional var link:Array<String>;
    @:optional var dependencies:Array<String>;
    @:optional var src:Array<String>;
    @:optional var output:String;
    @:optional var template:String;
    @:optional var main:String;
    @:optional var gitHash:String;
    @:optional var dFlags:Array<String>;
}
