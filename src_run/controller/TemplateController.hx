package controller;

import model.TokenTypes;
import sys.io.File;
import sys.FileSystem;
import helper.Helper;
import model.HaxelibVO;

class TemplateController {

    public function new() {

    }

    public function build():String {
        if (PrioriRunModel.getInstance().haxelibs.length > 0) {

            var app:HaxelibVO = PrioriRunModel.getInstance().app;


            Helper.g().output.print("");
            Helper.g().output.print("- Creating build folder...");

            if (!app.hasPrioriJson) {
                return '${app.filenamePrioriJson} not found at ${app.pathHaxelib}';
            }

            var outputFolder:String = Helper.g().path.append(app.pathHaxelib, app.priori.output);

            if (FileSystem.exists(outputFolder)) {
                Helper.g().output.print("> Removing old data... ", 2);

                try {
                    Helper.g().path.removeDirectory(outputFolder);
                    Helper.g().output.append("DONE");
                } catch (e:Dynamic) {
                    return 'Cannot remove ${outputFolder.toUpperCase()} folder';
                }
            }

            Helper.g().output.print("> Creating new output folder... ", 2);

            try {
                FileSystem.createDirectory(outputFolder);
                Helper.g().output.append("DONE");
            } catch (e:Dynamic) {
                return 'Cannot create ${outputFolder.toUpperCase()} folder';
            }


            for (lib in PrioriRunModel.getInstance().haxelibs) {
                if (lib.hasPrioriTemplate) {

                    Helper.g().output.print('> Copying assets from ${lib.pathPrioriTemplate}... ', 2);

                    try {
                        Helper.g().path.copyPath(lib.pathPrioriTemplate, outputFolder);
                        Helper.g().output.append("DONE");
                    } catch (e:Dynamic) {

                        return "Cannot copy assets";

                    }
                }
            }


            return this.processIndex();

        }

        return "None haxelib found";
    }

    private function processIndex():String {

        var app:HaxelibVO = PrioriRunModel.getInstance().app;
        var outputFolder:String = Helper.g().path.append(app.pathHaxelib, app.priori.output);
        var indexPath:String = Helper.g().path.append(outputFolder, "index.html");


        Helper.g().output.print("> Creating index file... ", 2);

        if (!FileSystem.exists(indexPath)) {
            return 'Index file not found at ${indexPath}';
        }


        var content:String = "";

        try {
            content = File.getContent(indexPath);
        } catch (e:Dynamic) {
            return 'Cannot read ${indexPath} data';
        }


        var meta:Array<String> = [];
        var link:Array<String> = [];

        for (lib in PrioriRunModel.getInstance().haxelibs) {
            if (lib.hasPrioriJson) {
                meta = meta.concat(lib.priori.meta);
                link = link.concat(lib.priori.link);
            }
        }

        content = this.replace(content, TokenTypes.TOKEN_NAME, app.priori.name);
        content = this.replace(content, TokenTypes.TOKEN_LANG, app.priori.lang);
        content = this.replace(content, TokenTypes.TOKEN_META, meta.join("\n"));
        content = this.replace(content, TokenTypes.TOKEN_LINK, link.join("\n"));

        content = this.replace(content, TokenTypes.TOKEN_PRIORI, [
            '<script type="text/javascript" src="js/priori.js" ></script>'
        ].join("\n"));


        try {
            File.saveContent(indexPath, content);
            Helper.g().output.append("DONE");
        } catch (e:Dynamic) {
            return 'Cannot save ${outputFolder} file';
        }

        return "";
    }

    private function replace(content:String, token:String, value:String):String {
        return content.split(token).join(value);
    }
}
