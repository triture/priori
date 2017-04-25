package helper;

class HelperWebserver {

    public function new() {

    }

    public function run():Void {

        var args:Array<String> = ["server", "-p", "4321", "-d", PrioriRunModel.getInstance().args.currPath];

        Helper.g().output.print("");
        Helper.g().output.print("Starting webserver: nekotools " + args.join(" "));
        Helper.g().process.run("nekotools", args, true);
    }
}
