package controller;

import model.ArgsCommand;
import model.ArgsType;
import model.ArgsData;

class ArgParser {

    static public function parse(values:Array<String>):ArgsData {
        var result:ArgsData = {
            command : ArgsCommand.RUN,
            currPath : '.',
            prioriFile : 'priori.json',
            port : 7571,
            dList : [],
            noHash : false
        };

        if (values.length == 0) return result;
        result.command = getValidCommand(values);

        return loopWithArgs(result, values);
    }

    static private function getValidCommand(values:Array<String>):ArgsCommand {
        var result:ArgsCommand = values.shift();
        
        switch (result) {
            case BUILD | RUN | CREATE | VSCODE: return result;
            case _ : throw 'Invalid Priori Command: ${result}';
        }
    }

    static private function loopWithArgs(result:ArgsData, values:Array<String>):ArgsData {
        if (values.length % 2 != 0) throw 'Invalid Params Composition. Some value is missing. ${values}';

        while (values.length > 0) {
            var arg:String = values.shift();
            var value:String = values.shift();

            switch (arg) {
                case ArgsType.FILE: result.prioriFile = value;
                case ArgsType.PATH: result.currPath = value;
                case ArgsType.PORT: {
                    var portValue:Int = Std.parseInt(value);
                    if (portValue == null) throw 'Invalid Port value ${value}';
                    result.port = portValue;
                }
                case ArgsType.D: result.dList.push(value);
                case ArgsType.NOHASH: {
                    if (value == "true") result.noHash = true;
                    else if (value == "false") result.noHash = false;
                    else throw 'Invalid NoHash value ${value}';
                }
                case _ : throw 'Invalid Priori Argument: ${arg}';
            }
        }

        return result;
    }

    // public function parseArgs(values:Array<String>):ArgsData {
    //     var clone:Array<String> = values.copy();

    //     var result:ArgsData = {};
    //     result.prioriFile = "priori.json";
    //     result.port = 6000 + Math.floor(Math.random()*1000);
    //     result.error = false;
    //     result.errorMessage = "";
    //     result.currPath = "";
    //     result.dList = [];
    //     result.noHash = false;


    //     if (Validation.isValidCommand(clone[0])) {
    //         result.command = clone.shift();
    //     } else {
    //         result.error = true;
    //         result.errorMessage = "Command Missing: use create, build or vscode";
    //         return result;
    //     }

    //     result.currPath = clone.pop();

    //     while (clone.length > 0) {

    //         var header:String = clone.shift();
    //         var value:String = "";

    //         if (header == ArgsType.ARG_D && clone.length > 0) {
    //             value = clone.shift();
    //             result.dList.push(value);
    //         } else if (header == ArgsType.ARG_FILE  && clone.length > 0) {
    //             value = clone.shift();
    //             result.prioriFile = value;
    //         } else if (header == ArgsType.ARG_PATH  && clone.length > 0) {
    //             value = clone.shift();
    //             result.currPath = value;
    //         } else if (header == ArgsType.ARG_PORT  && clone.length > 0) {
    //             value = clone.shift();
    //             result.port = Std.parseInt(value);

    //             if (result.port == null) {
    //                 result.error = true;
    //                 result.errorMessage = "Invalid Port value";
    //                 return result;
    //             }
    //         } else if (header == ArgsType.ARG_NOHASH) {
    //             result.noHash = true;

    //         } else {
    //             result.error = true;
    //             if (header.charAt(0) == "-") {
    //                 result.errorMessage = 'Param ${header} not recognized';
    //             } else {
    //                 result.errorMessage = 'Wrong param length';
    //             }
    //             return result;
    //         }
    //     }

    //     return result;
    // }
}
