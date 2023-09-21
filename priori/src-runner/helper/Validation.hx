package helper;

class Validation {

    public static function isString(value:Dynamic):Bool {
        if (value != null && Std.isOfType(value, String)) return true;
        return false;
    }
    
    public static function isEmptyString(value:Dynamic):Bool {
        if (value == null) return true;
        else if (Std.isOfType(value, String) && value == "") return true;
        else return false;
    }

    public static function parseStringArray(data:Dynamic):Array<String> {
        if (data != null && Std.isOfType(data, Array)) {

            var result:Array<String> = [];
            for (i in 0 ... data.length) if (isString(data[i])) result.push(data[i]);

            return result;
        } else if (isString(data)) {
            return [data];
        }

        return [];
    }

}
