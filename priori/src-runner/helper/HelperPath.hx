package helper;

import sys.io.File;
import sys.FileSystem;
import helper.HelperPlatform.HelperPlatformType;

class HelperPath {

    private var haxelib_path:String;

    public function new() {

    }

    public function exists(path:String):Bool {
        try {
            return FileSystem.exists(path);
        } catch (e:Dynamic) {}

        return false;
    }

    public function copyPath(srcPath:String, dstPath:String):Void {
        var sep:String = this.getSep();

        if (FileSystem.exists(srcPath) && FileSystem.isDirectory(srcPath)) {
            var fileList:Array<String> = FileSystem.readDirectory(srcPath);

            var i:Int = 0;
            var n:Int = fileList.length;

            while (i < n) {
                var fullSrcPath:String = srcPath + sep + fileList[i];
                var fullDstPath:String = dstPath + sep + fileList[i];

                fullDstPath = StringTools.replace(fullDstPath, "._hx", ".hx");

                if (FileSystem.isDirectory(fullSrcPath)) {
                    FileSystem.createDirectory(fullDstPath);
                    this.copyPath(fullSrcPath, fullDstPath);
                } else {
                    if (FileSystem.exists(fullSrcPath)) File.copy(fullSrcPath, fullDstPath);
                }

                i++;
            }
        }
    }

    public function removeDirectory (directory:String):Void {
        var sep:String = this.getSep();

        if (FileSystem.exists(directory)) {

            var files;
            try {
                files = FileSystem.readDirectory (directory);
            } catch (e:Dynamic) {
                return;
            }

            for (file in FileSystem.readDirectory (directory)) {
                var path = directory + sep + file;
                try {
                    if (FileSystem.isDirectory (path)) {
                        removeDirectory (path);
                    } else {
                        FileSystem.deleteFile (path);
                    }
                } catch (e:Dynamic) {}
            }

            try {
                FileSystem.deleteDirectory (directory);
            } catch (e:Dynamic) {}
        }
    }

    public function getSep():String {
        var sep:String = "/";
        if (Helper.g().platform.host == HelperPlatformType.WINDOWS) {
            sep = "\\";
        }

        return sep;
    }

    public function appendMultiple(path:Array<String>):String {
        if (path.length == 0) return '';
        else if (path.length == 1) return path[0];

        var result:String = path.shift();

        for (p in path) result = this.append(result, p);
        
        return result;
    }

    public function append(path:String, extra:String):String {
        var sep:String = this.getSep();
        var result:String = "";

        path = StringTools.trim(path);
        extra = StringTools.trim(extra);

        if (StringTools.endsWith(path, sep) || StringTools.startsWith(extra, sep)) {
            result = path + extra;
        } else {
            result = path + sep + extra;
        }

        return result;
    }

    public function escape (path:String):String {

        if (Helper.g().platform.host != HelperPlatformType.WINDOWS) {
            path = StringTools.replace (path, "\\ ", " ");
            path = StringTools.replace (path, " ", "\\ ");
            path = StringTools.replace (path, "\\'", "'");
            path = StringTools.replace (path, "'", "\\'");

        } else {
            path = StringTools.replace (path, "^,", ",");
            path = StringTools.replace (path, ",", "^,");

        }

        return expand(path);
    }

    public function expand (path:String):String {

        if (path == null) {
            path = "";
        }

        if (Helper.g().platform.host != HelperPlatformType.WINDOWS) {
            if (StringTools.startsWith (path, "~/")) {
                path = Sys.getEnv ("HOME") + "/" + path.substr(2);
            }
        }

        return path;
    }
}
