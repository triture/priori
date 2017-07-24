package controller;

import model.ArgsType;
import model.ArgsVO;
import helper.Validation;

class ArgsController {

    public function new() {

    }

    public function parseArgs(values:Array<String>):ArgsVO {
        var clone:Array<String> = values.copy();

        var result:ArgsVO = {};
        result.prioriFile = "priori.json";
        result.port = 6000 + Math.floor(Math.random()*1000);
        result.error = false;
        result.errorMessage = "";
        result.currPath = "";
        result.dList = [];
        result.noHash = false;


        if (Validation.isValidCommand(clone[0])) {
            result.command = clone.shift();
        } else {
            result.error = true;
            result.errorMessage = "Command Missing: use create, build or run";
            return result;
        }

        result.currPath = clone.pop();

        // validate nohash


//        var n:Int = clone.length;
//
//        if (n % 2 != 0) {
//            result.error = true;
//            result.errorMessage = "Wrong param length";
//            return result;
//        }
//
//        n = Math.floor(n/2);

        while (clone.length > 0) {

            var header:String = clone.shift();
            var value:String = "";

            if (header == ArgsType.ARG_D && clone.length > 0) {
                value = clone.shift();
                result.dList.push(value);
            } else if (header == ArgsType.ARG_FILE  && clone.length > 0) {
                value = clone.shift();
                result.prioriFile = value;
            } else if (header == ArgsType.ARG_PATH  && clone.length > 0) {
                value = clone.shift();
                result.currPath = value;
            } else if (header == ArgsType.ARG_PORT  && clone.length > 0) {
                value = clone.shift();
                result.port = Std.parseInt(value);

                if (result.port == null) {
                    result.error = true;
                    result.errorMessage = "Invalid Port value";
                    return result;
                }
            } else if (header == ArgsType.ARG_NOHASH) {
                result.noHash = true;

            } else {
                result.error = true;
                if (header.charAt(0) == "-") {
                    result.errorMessage = 'Param ${header} not recognized';
                } else {
                    result.errorMessage = 'Wrong param length';
                }
                return result;
            }
        }

        return result;
    }
}
