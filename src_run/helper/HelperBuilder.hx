package helper;

import sys.FileSystem;
import sys.io.File;
import data.PrioriData;
import String;
class HelperBuilder {

    public function new() {

    }

    public function build():Void {

        var args:Array<String> = [];

        var libs:Array<HaxeLib> = Helper.g().lib.libList;

        var app:HaxeLib = libs[libs.length - 1];
        var appData:PrioriData = app.prioriLibData;


        var i:Int = 0;
        var n:Int = libs.length;

        var argsLibs:Array<String> = [];

        while (i < n){
            if (libs[i].isLib) {
                argsLibs.push("-lib");
                argsLibs.push(libs[i].libName);
            }

            i++;
        }

        var argsSourcePath:Array<String> = [];

        i = 0;
        n = appData.src.length;

        while (i < n) {
            argsSourcePath.push("-cp");
            argsSourcePath.push(appData.src[i]);

            i++;
        }

        // copy main build to temp folder
        var tempCompilerPath:String = Helper.g().path.append(app.libPath, appData.output);
        tempCompilerPath = Helper.g().path.append(tempCompilerPath, "__temp_compiler");

        if (!FileSystem.exists(tempCompilerPath)) FileSystem.createDirectory(tempCompilerPath);


        var mainBuildPath:String = Helper.g().path.getLibPath("priori");
        mainBuildPath = Helper.g().path.append(mainBuildPath, "project");
        mainBuildPath = Helper.g().path.append(mainBuildPath, "main");
        mainBuildPath = Helper.g().path.append(mainBuildPath, "MainBuild._hx");

        var mainBuilderName:String = "MainBuild" + Math.floor(Math.random()*1000);

        var content:String = File.getContent(mainBuildPath);
        content = content.split("{APPCLASS}").join(appData.main);
        content = content.split("{MAINBUILDCLASS}").join(mainBuilderName);

        File.saveContent(Helper.g().path.append(tempCompilerPath, mainBuilderName + ".hx"), content);

        // set main builder to source paths
        argsSourcePath.push("-cp");
        argsSourcePath.push(Helper.g().path.append(appData.output, "__temp_compiler"));



        var argsFlags:Array<String> = [];
        i = 0;
        n = PrioriRun.args.dList.length;

        while (i < n) {
            argsFlags.push("-D");
            argsFlags.push(PrioriRun.args.dList[i]);
            i++;
        }



        args = args.concat(argsLibs);
        args = args.concat(argsSourcePath);
        args = args.concat(argsFlags);

        args.push("-main");
        args.push(mainBuilderName);

        args.push("-js");
        args.push(
            Helper.g().path.append(
                Helper.g().path.append(
                    appData.output,
                    "js"
                ),
                "priori.js"
            )
        );


        // go to current folder
        Sys.setCwd(app.libPath);

        var result:Int = Helper.g().process.command("haxe", args);


        Helper.g().path.removeDirectory(tempCompilerPath);

        if (result != 0) {
            Helper.g().output.print("");
            Helper.g().output.print("");
            Helper.g().output.print("* * * Error");
        } else {
            Helper.g().output.print("");
            Helper.g().output.print("Build Success");
        }
    }

}