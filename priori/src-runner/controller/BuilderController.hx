package controller;

import helper.TerminalPrinter;
import model.ArgsData;
import sys.io.File;
import sys.FileSystem;
import helper.Helper;
import model.HaxelibData;

class BuilderController {

    static public function build(args:ArgsData, libs:Array<HaxelibData>):Void {
        if (libs.length == 0) return;

        var app:HaxelibData = libs[0];
        var buildPath:String = app.priori.output;
        var prioriHaxelibPath:String = HaxelibController.getHaxelibPath("priori");

        var argsHaxelib:Array<String> = [];
        var argsSourcePath:Array<String> = [];
        var argsFlags:Array<String> = [];

        libs.reverse();
        for (lib in libs) {
            if (lib.isHaxelib) {
                argsHaxelib.push('-L');
                argsHaxelib.push(lib.libName);
            }
            if (lib.priori != null) {
                for (flag in lib.priori.dFlags) {
                    argsFlags.push('-D');
                    argsFlags.push(flag);
                }
            }
        }
        libs.reverse();

        for (source in app.priori.src) {
            argsSourcePath.push('-cp');
            argsSourcePath.push(source);
        }

        for (flag in args.dList) {
            argsFlags.push('-D');
            argsFlags.push(flag);
        }

        // copy main build to temp folder
        var tempCompilerFolder:String = "__temp_compiler";
        var tempCompilerPath:String = Helper.g().path.append(app.pathHaxelib, buildPath);
        tempCompilerPath = Helper.g().path.append(tempCompilerPath, tempCompilerFolder);

        if (!FileSystem.exists(tempCompilerPath)) FileSystem.createDirectory(tempCompilerPath);

        var mainBuildPath:String = Helper.g().path.appendMultiple([prioriHaxelibPath, 'project', 'main', 'MainBuild._hx']);
        var mainBuilderName:String = "Priori_auto_main_builder";

        var content:String = File.getContent(mainBuildPath);
        content = content.split("{APPCLASS}").join(app.priori.main);
        content = content.split("{MAINBUILDCLASS}").join(mainBuilderName);

        File.saveContent(Helper.g().path.append(tempCompilerPath, mainBuilderName + ".hx"), content);

        // set main builder to source paths
        argsSourcePath.push("-cp");
        argsSourcePath.push(Helper.g().path.append(buildPath, tempCompilerFolder));

        var args:Array<String> = [];
        args = args.concat(argsHaxelib);
        args = args.concat(argsSourcePath);
        args = args.concat(argsFlags);

        args.push("-main");
        args.push(mainBuilderName);

        args.push("-js");
        args.push(Helper.g().path.appendMultiple([buildPath, "js", "priori.js"]));

        // go to current folder
        Sys.setCwd(app.pathHaxelib);

        TerminalPrinter.printLine('- Running haxe command...');
        TerminalPrinter.printLine('  > haxe ${args.join(' ')}');
        TerminalPrinter.breakLines();

        var commandResult:Int = Sys.command('haxe', args);

        Helper.g().path.removeDirectory(tempCompilerPath);

        if (commandResult != 0) throw "Error building app";
    }

}
