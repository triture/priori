package helper;

import model.ArgsType;

class Validation {

    public static function isString(value:Dynamic):Bool {
        if (value != null && Std.is(value, String)) return true;
        return false;
    }

    public static function parseStringArray(data:Dynamic):Array<String> {
        if (data != null && Std.is(data, Array)) {

            var result:Array<String> = [];
            for (i in 0 ... data.length) if (isString(data[i])) result.push(data[i]);

            return result;
        } else if (isString(data)) {
            return [data];
        }

        return [];
    }

    public static function isValidCommand(value:String):Bool {

        if (!isString(value)) return false;

        value = value.toLowerCase();

        if (value == ArgsType.COMMAND_BUILD ||
            value == ArgsType.COMMAND_CREATE ||
            value == ArgsType.COMMAND_RUN

        ) return true;


        return false;
    }

}
