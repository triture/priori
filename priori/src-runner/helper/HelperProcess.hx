package helper;

import helper.TerminalPrinter;
import sys.io.Process;
import haxe.io.Eof;
import haxe.io.BytesOutput;

class HelperProcess {

    public function new() {

    }

    public function run(command:String, args:Array<String>, printErrors:Bool = false):String {
        var process = new Process(command, args);
        var buffer = new BytesOutput();

        var waiting = true;
        var result:Int = 0;
        var output:String = "";

        while (waiting) {
            try  {
                var current = process.stdout.readAll(1024);
                buffer.write(current);

                if (current.length == 0) {
                    waiting = false;
                }

            } catch (e:Eof) {
                waiting = false;
            }
        }

        result = process.exitCode();
        process.close();

        output = buffer.getBytes().toString();


        if (result != 0) {

            if (printErrors) {
                var error = process.stderr.readAll().toString();

                TerminalPrinter.printLine("");
                TerminalPrinter.printLine(" * * * ERROR: " + error);
                TerminalPrinter.printLine("       > Exit code : " + result);
                TerminalPrinter.printLine("       > Message : " + output);
                TerminalPrinter.printLine("");
            }

            return null;
        }

        return output;
    }
}
