package controller;

import String;
import helper.HelperProcess;
import sys.io.File;
import sys.FileSystem;
import helper.Helper;
import model.HaxelibVO;

class BuilderController {

    public function new() {

    }

    public function build():Bool {

        var app:HaxelibVO = PrioriRunModel.getInstance().app;

        var argsHaxelib:Array<String> = [];
        var argsSourcePath:Array<String> = [];
        var argsFlags:Array<String> = [];

        for (lib in PrioriRunModel.getInstance().haxelibs) {
            if (lib.isHaxelib) {
                argsHaxelib.push("-lib");
                argsHaxelib.push(lib.libName);
            }
        }

        for (source in app.priori.src) {
            argsSourcePath.push("-cp");
            argsSourcePath.push(source);
        }

        for (flag in PrioriRunModel.getInstance().args.dList) {
            argsFlags.push("-D");
            argsFlags.push(flag);
        }


        // copy main build to temp folder
        var tempCompilerFolder:String = "__temp_compiler";
        var tempCompilerPath:String = Helper.g().path.append(app.pathHaxelib, app.priori.output);
        tempCompilerPath = Helper.g().path.append(tempCompilerPath, tempCompilerFolder);

        if (!FileSystem.exists(tempCompilerPath)) FileSystem.createDirectory(tempCompilerPath);


        var mainBuildPath:String = PrioriRunController.getInstance().haxelib.getHaxelibPath("priori");
        mainBuildPath = Helper.g().path.append(mainBuildPath, "project");
        mainBuildPath = Helper.g().path.append(mainBuildPath, "main");
        mainBuildPath = Helper.g().path.append(mainBuildPath, "MainBuild._hx");

        var mainBuilderName:String = "Priori_auto_main_builder";

        var content:String = File.getContent(mainBuildPath);
        content = content.split("{APPCLASS}").join(app.priori.main);
        content = content.split("{MAINBUILDCLASS}").join(mainBuilderName);

        File.saveContent(Helper.g().path.append(tempCompilerPath, mainBuilderName + ".hx"), content);

        // set main builder to source paths
        argsSourcePath.push("-cp");
        argsSourcePath.push(Helper.g().path.append(app.priori.output, tempCompilerFolder));


        var args:Array<String> = [];
        args = args.concat(argsHaxelib);
        args = args.concat(argsSourcePath);
        args = args.concat(argsFlags);

        args.push("-main");
        args.push(mainBuilderName);

        args.push("-js");
        args.push(
            Helper.g().path.append(
                Helper.g().path.append(
                    app.priori.output,
                    "js"
                ),
                "priori.js"
            )
        );


        // go to current folder
        Sys.setCwd(app.pathHaxelib);

        var result:Int = Helper.g().process.command("haxe", args);

        Helper.g().path.removeDirectory(tempCompilerPath);

        if (result != 0) return false;
        return true;
    }

}
