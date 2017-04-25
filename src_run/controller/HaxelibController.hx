package controller;

import sys.io.File;
import helper.HelperPath;
import StringTools;
import helper.ArrayHelper;
import model.HaxelibVO;
import sys.FileSystem;
import helper.Validation;
import helper.Helper;

class HaxelibController {

    public function new() {

    }

    public function load(libName:String, prioriFile:String = null):String {

        var name:String = StringTools.trim(libName.toLowerCase());

        var haxelib:HaxelibVO = ArrayHelper.getItemByFieldValue(
            PrioriRunModel.getInstance().haxelibs,
            "libName",
            name
        );


        if (haxelib == null) {
            haxelib = this.loadHaxelib(libName, prioriFile);

            if (haxelib.error) {
                return haxelib.errorMessage;
            } else {

                if (haxelib.hasPrioriJson) {

                    for (i in 0 ... haxelib.priori.dependencies.length) {

                        var result:String = this.load(haxelib.priori.dependencies[i]);

                        if (result.length > 0) {
                            return result;
                            break;
                        }
                    }

                }

            }

            PrioriRunModel.getInstance().haxelibs.push(haxelib);
        }

        return "";
    }

    private function loadHaxelib(libName:String, filenamePrioriJson:String = null):HaxelibVO {

        var name:String = StringTools.trim(libName.toLowerCase());


        // try to load
        var haxelib:HaxelibVO = {
            libName : name
        };

        // initiate lib data
        haxelib.isHaxelib = false;
        haxelib.error = false;
        haxelib.errorMessage = "";
        haxelib.filenamePrioriJson = filenamePrioriJson == null ? "priori.json" : filenamePrioriJson;
        haxelib.hasPrioriJson = false;
        haxelib.hasPrioriTemplate = false;


        // 1. try to locate lib
        var libPath:String = PrioriRunController.getInstance().haxelib.getHaxelibPath(name);

        if (Validation.isString(libPath) && libPath.length > 0) {
            haxelib.pathHaxelib = libPath;
            haxelib.isHaxelib = true;
        } else {
            // is lib name a local path???
            if (Helper.g().path.exists(libName)) {
                haxelib.pathHaxelib = libName;
                haxelib.isHaxelib = false;
            } else {
                haxelib.error = true;
                haxelib.errorMessage = 'Haxelib ${name.toUpperCase()} not found';

                return haxelib;
            }
        }

        Helper.g().output.print('');
        Helper.g().output.print('- Loading ${haxelib.libName.toUpperCase()}...');


        // 2. try to locate priori.json file
        haxelib.pathPrioriJson = Helper.g().path.append(haxelib.pathHaxelib, haxelib.filenamePrioriJson);

        if (Helper.g().path.exists(haxelib.pathPrioriJson) && !FileSystem.isDirectory(haxelib.pathPrioriJson)) {
            try {

                var data:String = File.getContent(haxelib.pathPrioriJson);
                var json:Dynamic = haxe.Json.parse(data);

                haxelib.hasPrioriJson = true;
                haxelib.priori = PrioriRunController.getInstance().data.parseData(json);

            } catch(e:Dynamic) {
                haxelib.error = true;
                haxelib.errorMessage = 'Error loading ${haxelib.pathPrioriJson} file';

                return haxelib;
            }
        }

        if (haxelib.hasPrioriJson) {
            Helper.g().output.print('> Loading Priori data at ${haxelib.pathPrioriJson}', 2);
        } else {
            Helper.g().output.print('> ${haxelib.libName.toUpperCase()} is not a priori lib... Using as haxelib', 2);
        }


        // 3. try to locate priori template
        if (haxelib.hasPrioriJson && haxelib.priori.template.length > 0) {
            haxelib.pathPrioriTemplate = Helper.g().path.append(haxelib.pathHaxelib, haxelib.priori.template);

            if (Helper.g().path.exists(haxelib.pathPrioriTemplate) && FileSystem.isDirectory(haxelib.pathPrioriTemplate)) {
                haxelib.hasPrioriTemplate = true;
            }
        }

        if (haxelib.hasPrioriTemplate) {
            Helper.g().output.print('> Template Assets found at ${haxelib.pathPrioriTemplate}', 2);
        }



        return haxelib;
    }

    public function getHaxelibPath(libname:String):String {
        var data:String = Helper.g().process.run("haxelib", ["path", libname]);
        if (Validation.isString(data) == false || data == "") return null;


        var result:String = "";
        var lines:Array<String> = data.split("\n");


        for (i in 1...lines.length) {
            var trim:String = StringTools.trim(lines[i]);
            if (StringTools.startsWith(trim, "-D " + libname)) result = StringTools.trim(lines[i - 1]);
        }


        if (result != "") {
            try {
                if (FileSystem.exists(result)) return result;
            } catch (e:Dynamic) {
                result = "";
            }
        }

        if (result == "") {
            for (line in lines) {
                var trim:String = StringTools.trim(line);

                if (trim != "" && StringTools.startsWith(trim, "-") == false) {
                    try {
                        if (FileSystem.exists(trim)) {
                            return trim;
                            break;
                        }
                    } catch (e:Dynamic) {

                    }
                }
            }
        }

        return null;
    }
}
