package controller;

import helper.TerminalPrinter;
import model.HaxelibData;
import model.ArgsData;

class CommandBuild {
    
    static public function run(args:ArgsData):Void {
        var libs:Array<HaxelibData> = [];

        loadLibs(args, libs);
        generateTemplate(args, libs);
        build(args, libs);
    }

    static private function loadLibs(args:ArgsData, libs:Array<HaxelibData>) {
        TerminalPrinter.breakLines(2);
        TerminalPrinter.printLine("[yellow]LOADING DEPENDENCIES:[/yellow]");

        HaxelibController.load(args.currPath, args.prioriFile, libs);
        HaxelibController.load('priori', null, libs);
    }

    static private function generateTemplate(args:ArgsData, libs:Array<HaxelibData>):Void {
        TerminalPrinter.breakLines(2);
        TerminalPrinter.printLine("[yellow]CREATING TEMPLATE:[/yellow]");

        TemplateController.build(args, libs);
    }

    static private function build(args:ArgsData, libs:Array<HaxelibData>):Void {
        TerminalPrinter.breakLines(2);
        TerminalPrinter.printLine("[yellow]BUILDING APPLICATION:[/yellow]");

        BuilderController.build(args, libs);
    }

}