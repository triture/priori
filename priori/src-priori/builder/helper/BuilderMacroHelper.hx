package builder.helper;

import haxe.ds.StringMap;
import haxe.macro.PositionTools;
import builder.model.data.BuilderErrorData;
import sys.io.File;
import haxe.macro.ExprTools;
import haxe.macro.Context;

class BuilderMacroHelper {
    
    public static function hasMetaKey(metaKey:String):Bool {
        var localClass = Context.getLocalClass();
        var meta = localClass.get().meta;

        return meta.has(metaKey);
    }

    public static function getMetaPosition(metaKey:String) {
        var localClass = Context.getLocalClass();
        var meta = localClass.get().meta;
        
        if (meta.has(metaKey)) {
            var ext = meta.extract(metaKey);
            
            if (ext.length > 0 && ext[0].params.length > 0) {
                return PositionTools.getInfos(ext[0].params[0].pos);
            }
        }

        return null;
    }

    public static function getMetaValue(metaKey:String):Dynamic {
        if (!hasMetaKey(metaKey)) return null;

        var localClass = Context.getLocalClass();
        var meta = localClass.get().meta;
        var ext = meta.extract(metaKey);

        if (ext.length == 0 || ext[0].params.length == 0) return null;

        return ExprTools.getValue(ext[0].params[0]);
    }

    public static function loadDataFromFile(filename:String):String {
        if (filename == null) return null;
        filename = StringTools.trim(filename.substr(0, 1024)).split('\n').join('');

        if (!sys.FileSystem.exists(filename) || sys.FileSystem.isDirectory(filename)) return null;

        var data:String = File.getContent(StringTools.trim(filename));
        return data;
    }

    public static function dispatchError(error:BuilderErrorData):Void {
        var file = PositionTools.getInfos(Context.currentPos()).file;

        var errorPos = Context.makePosition({
            file : file,
            min : error.min,
            max : error.max
        });
        
        Context.fatalError(error.message, errorPos);
    }

    public static function print(message:String):Void {
        if (message == '') Sys.println("");
        else Sys.println("   PriBuilder : " + message);
    }

    public static function generateRandomString():String {
        var chars:String = "ABCDEFGHIJKLMNOPQRSTUVXYWZabcdefghijklmnopqrstuvxywz0123456789";
        var result:String = "";

        for (i in 0 ... 15) result += chars.charAt(
            Math.floor(Math.random() * chars.length)
        );

        return result;
    }

    public static function isEmptyString(value:String):Bool {
        return value == null || StringTools.trim(value) == "";
    }

    public static function extractAttributes(data:Xml):Array<{att:String, value:String}> {
        var result:Array<{att:String, value:String}> = [];

        var atts:Array<String> = [for (att in data.attributes()) att];
        atts.sort((a, b) -> return a < b ? -1 : a > b ? 1 : 0);

        // expressão regular para detectar caracteres numericos seguidos de dois pontos no inicio da string
        var reg = ~/^\d+:/;
        
        for (att in atts) {
            var value:String = data.get(att);

            if (reg.match(att)) att = reg.matchedRight();

            result.push({att: att, value: value});
        }   

        return result;
    }
    
}