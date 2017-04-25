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


        if (Validation.isValidCommand(clone[0])) {
            result.command = clone.shift();
        } else {
            result.error = true;
            result.errorMessage = "Command Missing: use create, build or run";
            return result;
        }

        result.currPath = clone.pop();

        var n:Int = clone.length;

        if (n % 2 != 0) {
            result.error = true;
            result.errorMessage = "Wrong param length";

            return result;
        }

        n = Math.floor(n/2);

        for (i in 0 ... n) {
            var header:String = clone.shift();
            var value:String = clone.shift();

            if (header == ArgsType.ARG_D) {
                result.dList.push(value);
            } else if (header == ArgsType.ARG_FILE) {
                result.prioriFile = value;
            } else if (header == ArgsType.ARG_PATH) {
                result.currPath = value;
            } else if (header == ArgsType.ARG_PORT) {
                result.port = Std.parseInt(value);

                if (result.port == null) {
                    result.error = true;
                    result.errorMessage = "Invalid Port value";
                    return result;
                }
            } else {
                result.error = true;
                result.errorMessage = 'Argument ${header.toUpperCase()} not expected';
                return result;
            }
        }


        return result;
    }
}
