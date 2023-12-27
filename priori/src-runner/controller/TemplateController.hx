package controller;

import helper.TerminalPrinter;
import model.ArgsData;
import model.TokenTypes;
import sys.io.File;
import sys.FileSystem;
import helper.Helper;
import model.HaxelibData;

class TemplateController {

    static public function build(args:ArgsData, libs:Array<HaxelibData>):Void {
        if (libs.length == 0) return;
        var app:HaxelibData = libs[0];

        TerminalPrinter.breakLines();
        TerminalPrinter.printLine("- Creating build folder...");

        if (!app.hasPrioriJson) throw '${app.filenamePrioriJson} not found at ${app.pathHaxelib}';

        var outputFolder:String = Helper.g().path.append(app.pathHaxelib, app.priori.output);
        cleanOldTemplateData(outputFolder);
        createNewTemplateData(outputFolder);
        copyAllTemplates(libs, outputFolder);

        processIndex(args, libs);
    }

    static private function copyAllTemplates(libs:Array<HaxelibData>, path:String) {
        libs.reverse();
        for (lib in libs) {
            if (lib.hasPrioriTemplate) {
                TerminalPrinter.print('  > Copying assets from ${lib.pathPrioriTemplate}... ');

                try {
                    Helper.g().path.copyPath(lib.pathPrioriTemplate, path);
                    TerminalPrinter.printLine("[cyan]DONE[/cyan]");
                } catch (e:Dynamic) {
                    throw 'Cannot copy assets from ${lib.pathPrioriTemplate}';
                }
            }
        }
        libs.reverse();
    }

    static private function cleanOldTemplateData(path:String) {
        if (FileSystem.exists(path)) {
            TerminalPrinter.print("  > Removing old data... ");

            try {
                Helper.g().path.removeDirectory(path);
                TerminalPrinter.printLine("[cyan]DONE[/cyan]");
            } catch (e:Dynamic) {
                throw 'Cannot remove ${path.toUpperCase()} folder';
            }
        }
    }

    static private function createNewTemplateData(path:String) {
        TerminalPrinter.print("  > Creating new output folder... ");

        try {
            FileSystem.createDirectory(path);
            TerminalPrinter.printLine("[cyan]DONE[/cyan]");
        } catch (e:Dynamic) {
            throw 'Cannot create ${path.toUpperCase()} folder';
        }
    }

    static private function processIndex(args:ArgsData, libs:Array<HaxelibData>):Void {
        if (libs.length == 0) return;
        var app:HaxelibData = libs[0];

        var outputFolder:String = Helper.g().path.append(app.pathHaxelib, app.priori.output);
        var indexPath:String = Helper.g().path.append(outputFolder, "index.html");

        TerminalPrinter.printLine("  > Creating index file... ");

        if (!FileSystem.exists(indexPath)) throw 'Index file not found at ${indexPath}';

        var content:String = "";

        try {
            content = File.getContent(indexPath);
        } catch (e:Dynamic) throw 'Cannot read ${indexPath} data';

        var meta:Array<String> = [];
        var link:Array<String> = [];

        libs.reverse();
        for (lib in libs) {
            if (lib.hasPrioriJson) {
                meta = meta.concat(lib.priori.meta);
                link = link.concat(lib.priori.link);
            }
        }
        libs.reverse();

        var prioriJSReplacement:String = '<script type="text/javascript" src="js/priori.js';
        if (!args.noHash) {
            prioriJSReplacement += (app.priori.gitHash == null ? "" : "?" + app.priori.gitHash);
        }
        prioriJSReplacement += '" ></script>';

        content = replace(content, TokenTypes.NAME, app.priori.name);
        content = replace(content, TokenTypes.LANG, app.priori.lang);
        content = replace(content, TokenTypes.META, meta.join("\n"));
        content = replace(content, TokenTypes.LINK, link.join("\n"));
        content = replace(content, TokenTypes.PRIORI, [prioriJSReplacement].join("\n"));

        content = replaceSEO(content, app);

        try {
            TerminalPrinter.print("   > Saving index.html... ");
            File.saveContent(indexPath, content);
            TerminalPrinter.printLine("[cyan]DONE[/cyan]");
        } catch (e:Dynamic) {
            throw 'Cannot save ${outputFolder} file';
        }
    }

    static private function replaceSEO(content:String, app:HaxelibData):String {
        return replace(content, TokenTypes.SEO, '');


        // var token:String = TokenTypes.SEO;
        // var seoContent:String = "";

        // if (content.indexOf(token) >= 0) {

        //     if (app.priori.seo != null && app.priori.seo.url != null && app.priori.seo.url.length > 0) {
        //         // try to load data
        //         Helper.g().output.print("> Loading SEO DATA from " + app.priori.seo.url + '... ', 3);

        //         var seoLoaded:Bool = false;
        //         var loadedContent:String = "";

        //         try {
        //             loadedContent = sys.Http.requestUrl(app.priori.seo.url);
        //             seoLoaded = true;

        //             Helper.g().output.append("DONE");
        //         } catch (e:Dynamic) {
        //             Helper.g().output.append("ERROR");
        //         }

        //         if (seoLoaded && app.priori.seo.ereg != null && app.priori.seo.ereg.length > 0) {

        //             Helper.g().output.print("> Extracting loaded data... ", 3);

        //             for (item in app.priori.seo.ereg) {

        //                 Helper.g().output.print('> Running EReg ${item}... ', 4);

        //                 try {
        //                     var er:EReg = new EReg(item, 'ms');
        //                     if (er.match(loadedContent)) loadedContent = er.matched(0);
        //                     Helper.g().output.append("DONE");
        //                 } catch (e:Dynamic) {
        //                     trace(e);
        //                     seoLoaded = false;
        //                     Helper.g().output.append("ERROR - " + Std.string(e));
        //                 }
        //             }
        //         }

        //         if (seoLoaded) seoContent = '<div id="priori_seo_content" style="width:0px;height:0px;overflow:hidden;">\n${loadedContent}\n</div>';

        //     }
        // }

        // return this.replace(content, token, seoContent);
    }

    static inline private function replace(content:String, token:String, value:String):String {
        return content.split(token).join(value);
    }
}
