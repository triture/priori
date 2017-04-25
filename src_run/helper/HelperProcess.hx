package helper;

import sys.io.Process;
import haxe.io.Eof;
import haxe.io.BytesOutput;

class HelperProcess {

    public function new() {

    }

    public function command(command:String, args:Array<String>):Int {

        Helper.g().output.print("");
        Helper.g().output.print('- Running ${command} command...');

        if (command == "haxe") {
            Helper.g().output.print("- haxe args: " + args.join(" "));
        }

        Helper.g().output.print("", 0);
        Helper.g().output.print("", 0);

        return Sys.command(command, args);
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

                Helper.g().output.print("");
                Helper.g().output.print(" * * * ERROR: " + error);
                Helper.g().output.print("       > Exit code : " + result);
                Helper.g().output.print("       > Message : " + output);
                Helper.g().output.print("");
            }

            return null;
        }

        return output;
    }
}
