package ;

import helper.HelperPath;
import data.PrioriArgs;
import helper.HelperLib;
import helper.Helper;

class PrioriRun {

    public static var args:PrioriArgs;

    private var argList:Array<String>;


    public function new(argList:Array<String>) {
        this.argList = argList;

        var args:PrioriArgs = new PrioriArgs();

        if (!args.parse(argList)) {
            Helper.g().output.print("");
            Helper.g().output.print(args.error);

        } else {

            PrioriRun.args = args;

            if (args.command == PrioriArgs.COMMAND_BUILD) {

                var error:Bool = false;

                Helper.g().output.print("");
                Helper.g().output.print("");
                Helper.g().output.print("Loading Libs...");

                if (!Helper.g().lib.loadLib("priori")) error = true;
                if (!Helper.g().lib.loadLib(args.currPath, args.prioriFile)) error = true;

                if (error) {
                    Helper.g().output.print("");
                    Helper.g().output.print("ERROR LOADING LIBS");
                } else {

                    Helper.g().output.print("");
                    Helper.g().output.print("Copying template Files...");
                    if (!Helper.g().lib.processTemplates(true)) {
                        error = true;
                    } else {
                        Helper.g().output.append(" OK");
                    }

                    if (!error) {
                        Helper.g().output.print("");
                        Helper.g().output.print("Make Index File...");

                        Helper.g().lib.processIndex();

                        Helper.g().output.append(" OK");

                        Helper.g().build.build();
                    }

                }
            } else if (args.command == PrioriArgs.COMMAND_CREATE) {

                var error:Bool = false;

                Helper.g().output.print("");
                Helper.g().output.print("");
                Helper.g().output.print("Creating new Project...");
                Helper.g().output.print("");

                var prioriPath:String = Helper.g().path.getLibPath("priori");

                if (prioriPath != null && prioriPath != "") {

                    prioriPath = Helper.g().path.append(prioriPath, "project");
                    prioriPath = Helper.g().path.append(prioriPath, "cleanbase");

                    if (Helper.g().path.exists(prioriPath)) {

                        try {
                            Helper.g().path.copyPath(prioriPath, args.currPath);
                        } catch (e:Dynamic) {
                            error = true;

                            Helper.g().output.print("Error: CANNOT CREATE PROJECT");
                            Helper.g().output.print(e);
                            Helper.g().output.print("");
                        }

                        if (!error) {
                            Helper.g().output.print("Project created on " + args.currPath);
                        }

                    } else {
                        error = true;
                        Helper.g().output.print("Error: PROJECT BASE NOT FOUND");
                    }

                } else {
                    error = true;
                    Helper.g().output.print("Error: PRIORI LIB NOT FOUND ");
                }


                //Helper.g().path.copyPath(srcPath:String, dstPath:String);
            }
        }
    }
}
