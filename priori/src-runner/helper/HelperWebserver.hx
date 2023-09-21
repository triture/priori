package helper;

import helper.TerminalPrinter;
import model.ArgsData;

class HelperWebserver {

    public function new() {

    }

    public function run(args:ArgsData):Void {

        var serverArgs:Array<String> = ["server", "-p", Std.string(args.port), "-d", args.currPath];

        TerminalPrinter.breakLines();
        TerminalPrinter.print("Starting webserver: nekotools " + serverArgs.join(" "));
        
        Helper.g().process.run("nekotools", serverArgs, true);
    }
}
