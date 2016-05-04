package ;

import data.PrioriData;
import sys.io.File;
import sys.FileSystem;
import helper.Helper;

class HaxeLib {

    public var isLib:Bool;
    public var exists:Bool;

    public var libName:String;
    public var libPath:String;

    public var prioriLibData:PrioriData;
    public var prioriTemplatePath:String;

    public var prioriFile:String;


    public function new(name:String, prioriFile:String = null) {

        this.prioriFile = prioriFile == null ? "priori.json" : prioriFile;

        this.libName = name;

        this.isLib = false;
        this.exists = false;

        this.prioriLibData = null;
        this.prioriTemplatePath = "";


        Helper.g().output.print(" > " + this.libName + "...");

        this.locateLibPath();
        if (!this.exists) this.locateLocalPath();


        if (this.exists) {
            Helper.g().output.append(" OK");

            this.locatePrioriFile();
            if (this.prioriLibData != null) Helper.g().output.print("   - Priori Data Found at " + this.prioriLibData.file);

            this.locatePrioriTemplate();
            if (this.prioriTemplatePath != "") Helper.g().output.print("   - Priori Template Found at " + this.prioriTemplatePath);

        } else {
            Helper.g().output.append(" ERROR : LIB NOT FOUND");
        }
    }

    private function locatePrioriFile():Void {
        try {
            var prioriPath:String = Helper.g().path.append(this.libPath, this.prioriFile);

            if (FileSystem.exists(prioriPath) && !FileSystem.isDirectory(prioriPath)) {

                var data:String = File.getContent(prioriPath);
                var json:Dynamic = haxe.Json.parse(data);

                this.prioriLibData = new PrioriData();
                this.prioriLibData.file = prioriPath;
                this.prioriLibData.parse(json);

            }
        } catch (e:Dynamic) {}
    }

    private function locatePrioriTemplate():Void {
        if (this.prioriLibData != null) {

            var templatePath:String = Helper.g().path.append(this.libPath, this.prioriLibData.template);

            if (FileSystem.exists(templatePath)) {
                this.prioriTemplatePath = templatePath;
            }
        }
    }

    private function locateLocalPath():Void {
        var result:String = "";

        try {
            if (FileSystem.exists(this.libName)) {
                result = this.libName;
            }
        } catch (e:Dynamic) {}

        if (result == "") {
            this.exists = false;
        } else {
            this.isLib = false;
            this.exists = true;
            this.libPath = result;
        }
    }

    private function locateLibPath():Void {
        var path:String = Helper.g().path.getLibPath(this.libName);

        if (path == null || path == "") {
            this.exists = false;
        } else {
            this.isLib = true;
            this.exists = true;
            this.libPath = path;
        }
    }
}
