package controller;

import helper.TerminalPrinter;
import sys.io.File;
import StringTools;
import model.HaxelibData;
import sys.FileSystem;
import helper.Validation;
import helper.Helper;

class HaxelibController {

    static public function load(libName:String, prioriFile:String = null, libs:Array<HaxelibData> = null):Array<HaxelibData> {
        var result:Array<HaxelibData> = libs == null ? [] : libs;

        if (existLib(libName, result)) return result;

        var lib:HaxelibData = loadHaxelib(libName, prioriFile);
        result.push(lib);

        if (lib.hasPrioriJson) {
            for (dependency in lib.priori.dependencies) {
                load(dependency, null, result);
            }
        }
        
        return result;
    }

    static private function existLib(name:String, libs:Array<HaxelibData>):Bool {
        for (lib in libs) if (lib.libName == name) return true;
        return false;
    }

    static private function loadHaxelib(name:String, filenamePrioriJson:String = null):HaxelibData {
        TerminalPrinter.breakLines();
        TerminalPrinter.printLine('- Loading ${name.toUpperCase()}...');

        var result:HaxelibData = {
            libName : name,
            isHaxelib : false,
            filenamePrioriJson : filenamePrioriJson == null ? "priori.json" : filenamePrioriJson,
            hasPrioriJson : false,
            hasPrioriTemplate : false
        };

        var libPath:String = getHaxelibPath(name);

        if (Validation.isString(libPath) && libPath.length > 0) {
            result.pathHaxelib = libPath;
            result.isHaxelib = true;
        } else {
            // is lib name a local path???
            if (!Helper.g().path.exists(name)) throw 'Haxelib ${name.toUpperCase()} not found';
            
            result.pathHaxelib = name;
            result.isHaxelib = false;
        }

        // 2. try to locate priori.json file
        result.pathPrioriJson = Helper.g().path.append(result.pathHaxelib, result.filenamePrioriJson);

        if (Helper.g().path.exists(result.pathPrioriJson) && !FileSystem.isDirectory(result.pathPrioriJson)) {
            try {

                var jsonString:String = File.getContent(result.pathPrioriJson);
                var jsonObject:Dynamic = haxe.Json.parse(jsonString);

                result.hasPrioriJson = true;
                result.priori = DataController.parseData(jsonObject);

            } catch(e:Dynamic) {
                throw 'Error loading ${result.pathPrioriJson} file';
            }
        }

        if (result.hasPrioriJson) {
            TerminalPrinter.printLine('  > Loading PRIORI DATA at ${result.pathPrioriJson}');
        } else {
            TerminalPrinter.printLine('  > ${result.libName.toUpperCase()} is not a priori lib... Using as normal haxelib');
        }

        // 3. try to locate priori template
        if (result.hasPrioriJson && result.priori.template.length > 0) {
            result.pathPrioriTemplate = Helper.g().path.append(result.pathHaxelib, result.priori.template);

            if (Helper.g().path.exists(result.pathPrioriTemplate) && FileSystem.isDirectory(result.pathPrioriTemplate)) {
                result.hasPrioriTemplate = true;
            }
        }

        if (result.hasPrioriTemplate) {
            TerminalPrinter.printLine('  > Template Assets found at ${result.pathPrioriTemplate}');
        }

        return result;
    }

    static public function getHaxelibPath(libname:String):String {
        var data:String = Helper.g().process.run("haxelib", ["path", libname]);

        if (Validation.isEmptyString(data)) return null;

        var result:String = "";
        var lines:Array<String> = data.split("\n");


        for (i in 1...lines.length) {
            var trim:String = StringTools.trim(lines[i]);
            if (StringTools.startsWith(trim, "-D " + libname)) result = StringTools.trim(lines[i - 1]);
        }

        if (result != "") {
            try {
                if (FileSystem.exists(result)) return getRootLibFolder(result);
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
                            return getRootLibFolder(trim);
                            break;
                        }
                    } catch (e:Dynamic) {

                    }
                }
            }
        }

        return null;
    }

    static private function getRootLibFolder(path:String):String {
        var up:String = "";

        var cleanPath:String = StringTools.trim(path);
        if (StringTools.endsWith(cleanPath, '/') == false && StringTools.endsWith(cleanPath, '\\') == false) {
            cleanPath += '/';
        }

        for (i in 0 ... 15) {
            if (FileSystem.exists(cleanPath + up + 'haxelib.json')) {
                return cleanPath + up;
            }
            up += "../";
        }

        return path;
    }
}
