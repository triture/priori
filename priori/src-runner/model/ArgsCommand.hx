package model;

enum abstract ArgsCommand(String) from String to String {
    var BUILD = "build";
    var RUN = "run";
    var CREATE = "create";
    var VSCODE = "vscode";
}