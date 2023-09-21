package model;

enum abstract ArgsType(String) from String to String {
    var D = "-D";
    var FILE = "-f";
    var PATH = "-p";
    var PORT = "-port";
    var NOHASH = "-nohash";
}
