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


        var prioriJSReplacement:String = '<script type="text/javascript" src="js/priori.js';
        if (!PrioriRunModel.getInstance().args.noHash) {
            prioriJSReplacement += (app.priori.gitHash == null ? "" : "?" + app.priori.gitHash);
        }
        prioriJSReplacement += '" ></script>';

        content = this.replace(content, TokenTypes.TOKEN_NAME, app.priori.name);
        content = this.replace(content, TokenTypes.TOKEN_LANG, app.priori.lang);
        content = this.replace(content, TokenTypes.TOKEN_META, meta.join("\n"));
        content = this.replace(content, TokenTypes.TOKEN_LINK, link.join("\n"));
        content = this.replace(content, TokenTypes.TOKEN_PRIORI, [prioriJSReplacement].join("\n"));

        content = this.replaceSEO(content, app);

        try {
            Helper.g().output.print("> Saving index.html... ", 3);
            File.saveContent(indexPath, content);
            Helper.g().output.append("DONE");
        } catch (e:Dynamic) {
            return 'Cannot save ${outputFolder} file';
        }

        return "";
    }

    private function replaceSEO(content:String, app:HaxelibVO):String {
        var token:String = TokenTypes.TOKEN_SEO;
        var seoContent:String = "";

        if (content.indexOf(token) >= 0) {

            if (app.priori.seo != null && app.priori.seo.url != null && app.priori.seo.url.length > 0) {
                // try to load data
                Helper.g().output.print("> Loading SEO DATA from " + app.priori.seo.url + '... ', 3);

                var seoLoaded:Bool = false;
                var loadedContent:String = "";

                try {
                    loadedContent = sys.Http.requestUrl(app.priori.seo.url);
                    seoLoaded = true;

                    Helper.g().output.append("DONE");
                } catch (e:Dynamic) {
                    Helper.g().output.append("ERROR");
                }

                if (seoLoaded && app.priori.seo.ereg != null && app.priori.seo.ereg.length > 0) {

                    Helper.g().output.print("> Extracting loaded data... ", 3);

                    for (item in app.priori.seo.ereg) {

                        Helper.g().output.print('> Running EReg ${item}... ', 4);

                        try {
                            var er:EReg = new EReg(item, 'ms');
                            if (er.match(loadedContent)) loadedContent = er.matched(0);
                            Helper.g().output.append("DONE");
                        } catch (e:Dynamic) {
                            trace(e);
                            seoLoaded = false;
                            Helper.g().output.append("ERROR - " + Std.string(e));
                        }
                    }
                }

                if (seoLoaded) seoContent = '<div id="priori_seo_content" style="width:0px;height:0px;overflow:hidden;">\n${loadedContent}\n</div>';

            }
        }

        return this.replace(content, token, seoContent);
    }

    private function replace(content:String, token:String, value:String):String {
        return content.split(token).join(value);
    }
}
