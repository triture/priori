package data;

class PrioriArgs {

    public static var ARG_D:String = "-D";
    public static var ARG_FILE:String = "-f";
    public static var ARG_PATH:String = "-p";

    public static var COMMAND_BUILD:String = "build";
    public static var COMMAND_CREATE:String = "create";

    public var command:String;
    public var currPath:String;
    public var prioriFile:String;

    public var dList:Array<String>;

    public var error:String = "";

    public function new() {
        this.prioriFile = "priori.json";

    }

    public function parse(params:Array<String>):Bool {
        var clone:Array<String> = params.copy();

        var result:Bool = true;

        if (this.isValidCommand(clone[0])) this.command = clone.shift();
        else {
            this.error = "* * * ERROR - COMMAND MISSING : use 'build'";
            return false;
        }

        this.currPath = clone.pop();

        this.dList = [];

        var i:Int = 0;
        var n:Int = clone.length;

        if (n % 2 != 0) {
            this.error = "* * * ERROR - WRONG LENGTH OF PARAMS";
            return false;
        }

        n = Math.round(n/2);

        while (i < n) {
            var header:String = clone.shift();
            var value:String = clone.shift();

            if (header == ARG_D) {
                this.dList.push(value);
            } else if (header == ARG_FILE) {
                this.prioriFile = value;
            } else if (header == ARG_PATH) {
                this.currPath = value;
            } else {
                this.error = "* * * ERROR - ARGUMENT TYPE UNEXPECTED : " + header;
                return false;
            }

            i++;
        }




        return result;
    }

    private function isValidCommand(value:String):Bool {
        if (value == COMMAND_BUILD ||
            value == COMMAND_CREATE) return true;


        return false;
    }
}
