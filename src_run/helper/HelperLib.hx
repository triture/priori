package helper;

import sys.io.File;
import sys.FileSystem;
import data.PrioriData;

class HelperLib {

    public var libList:Array<HaxeLib>;
    public var loadedLibs:Array<String>;

    public function new() {
        this.libList = [];
        this.loadedLibs = [];
    }


    public function processIndex():Void {
        if (this.libList.length > 0) {

            var app:HaxeLib = this.libList[this.libList.length - 1];
            var appData:PrioriData = app.prioriLibData;

            var index:String = Helper.g().path.append(app.libPath, appData.output);
            index = Helper.g().path.append(index, "index.html");

            if (FileSystem.exists(index)) {
                var content:String = File.getContent(index);

                var i:Int = 0;
                var n:Int = this.libList.length;


                var meta:Array<String> = [];
                var link:Array<String> = [];

                while (i < n) {
                    if (this.libList[i].prioriLibData != null) {
                        meta = meta.concat(this.libList[i].prioriLibData.meta);
                        link = link.concat(this.libList[i].prioriLibData.link);
                    }

                    i++;
                }

                content = this.replace(content, PrioriData.TOKEN_NAME, appData.name);
                content = this.replace(content, PrioriData.TOKEN_LANG, appData.lang);
                content = this.replace(content, PrioriData.TOKEN_META, meta.join("\n"));
                content = this.replace(content, PrioriData.TOKEN_LINK, link.join("\n"));

                content = this.replace(content, PrioriData.TOKEN_PRIORI, [
                    "<link href=\"css/priori.css\" rel=\"stylesheet\">",
                    "<script type=\"text/javascript\" src=\"js/priori.js\" ></script>"
                ].join("\n"));


                File.saveContent(index, content);
            }
        }
    }

    private function replace(content:String, token:String, value:String):String {
        return content.split(token).join(value);
    }

    public function processTemplates(clean:Bool):Bool {
        if (this.libList.length > 0) {

            var app:HaxeLib = this.libList[this.libList.length - 1];
            var appData:PrioriData = app.prioriLibData;

            if (appData == null) {
                Helper.g().output.print("");
                Helper.g().output.print("ERROR : " + app.prioriFile + " NOT FOUND ON YOUR CURRENT PATH : " + app.libPath);

                return false;
            }

            var outputFolder:String = Helper.g().path.append(app.libPath, appData.output);

            // CREATE OUTPUT FOLDER
            if (FileSystem.exists(outputFolder)) {
                if (clean) {
                    Helper.g().path.removeDirectory(outputFolder);
                    FileSystem.createDirectory(outputFolder);
                }
            } else {
                FileSystem.createDirectory(outputFolder);
            }

            var i:Int = 0;
            var n:Int = this.libList.length;

            while (i < n) {
                if (this.libList[i].prioriTemplatePath != "") {
                    try {

                        Helper.g().path.copyPath(this.libList[i].prioriTemplatePath, outputFolder);

                    } catch (e:Dynamic) {
                        Helper.g().output.print("");
                        Helper.g().output.print("ERROR : " + this.libList[i].prioriTemplatePath);
                        Helper.g().output.print(e);

                        return false;
                        break;
                    }
                }

                i++;
            }
        }

        return true;
    }

    public function loadLib(libName:String, prioriFile:String = null):Bool {

        if (this.loadedLibs.indexOf(libName) == -1) {
            var lib:HaxeLib = new HaxeLib(libName, prioriFile);

            if (lib.exists) {

                if (lib.prioriLibData != null) {
                    var i:Int = 0;
                    var n:Int = lib.prioriLibData.dependencies.length;

                    while (i < n) {
                        if (!this.loadLib(lib.prioriLibData.dependencies[i])) {
                            return false;
                            break;
                        }

                        i++;
                    }
                }

                this.libList.push(lib);
                this.loadedLibs.push(libName);

                return true;
            }

            return false;
        } else {
            return true;
        }

        return false;
    }

}
