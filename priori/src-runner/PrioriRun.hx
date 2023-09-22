package ;

import controller.CommandVSCode;
import controller.CommandCreate;
import controller.CommandBuild;
import helper.TerminalPrinter;
import model.ArgsData;
import controller.ArgParser;

class PrioriRun {

    static public function main():Void new PrioriRun(Sys.args());

    public function new(argList:Array<String>) {

        TerminalPrinter.breakLines();
        TerminalPrinter.printLine('  [cyan] __   __  .  __   __  . [/cyan]');
        TerminalPrinter.printLine('  [cyan]|__| |__| | /  \\ |__| | [/cyan]');
        TerminalPrinter.printLine('  [cyan]|    |  \\ | \\__/ |  \\ | [/cyan]');
        TerminalPrinter.breakLines();

        try  {
            var args:ArgsData = ArgParser.parse(argList);

            switch (args.command) {
                case BUILD | RUN: CommandBuild.run(args);
                case CREATE: CommandCreate.run(args);
                case VSCODE: CommandVSCode.run(args);
            }

            TerminalPrinter.breakLines(2);
            TerminalPrinter.printLine('[green]PRIORI ${args.command} SUCCESS[/green]');
            TerminalPrinter.breakLines();
            
            Sys.exit(0);
        } catch (e:Dynamic) {

            TerminalPrinter.breakLines(2);
            TerminalPrinter.printLine('[red]PRIORI ERROR:[/red]');
            TerminalPrinter.printLine('[red]${Std.string(e)}[/red]');
            TerminalPrinter.breakLines();
            Sys.exit(1);
        }

        return;


        // if (args.error) {

        //     Helper.g().output.print("");
        //     Helper.g().output.printError(args.errorMessage);
        //     return;

        // } else {

        //     Helper.g().output.print("");
        //     Helper.g().output.print("");
        //     Helper.g().output.print("");
        //     Helper.g().output.print("");
        //     Helper.g().output.print("   >>> Running " + args.command.toUpperCase() + " command", 0);

        //     if (args.command == ArgsType.COMMAND_VSCODE) {
                
        //         var error:Bool = false;

        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.printWithUnderline("1. Loading Libs...");

        //         // try to load priori lib
        //         var prioriLibResult:String = PrioriRunController.getInstance().haxelib.load("priori");
        //         if (prioriLibResult.length > 0) {
        //             Helper.g().output.print("");
        //             Helper.g().output.printError(prioriLibResult, "Lib error");
        //             return;
        //         }

        //         // try to load project lib
        //         var projectLibResult:String = PrioriRunController.getInstance().haxelib.load(args.currPath, args.prioriFile);
        //         if (projectLibResult.length > 0) {
        //             Helper.g().output.print("");
        //             Helper.g().output.printError(projectLibResult, "Lib error");
        //             return;
        //         }

        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.printWithUnderline("3. Generating vscode files from Haxe code...");


        //     } else if (args.command == ArgsType.COMMAND_BUILD || args.command == ArgsType.COMMAND_RUN) {

        //         var error:Bool = false;

        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.printWithUnderline("1. Loading Libs...");

        //         // try to load priori lib
        //         var prioriLibResult:String = PrioriRunController.getInstance().haxelib.load("priori");
        //         if (prioriLibResult.length > 0) {
        //             Helper.g().output.print("");
        //             Helper.g().output.printError(prioriLibResult, "Lib error");
        //             return;
        //         }

        //         // try to load project lib
        //         var projectLibResult:String = PrioriRunController.getInstance().haxelib.load(args.currPath, args.prioriFile);
        //         if (projectLibResult.length > 0) {
        //             Helper.g().output.print("");
        //             Helper.g().output.printError(projectLibResult, "Lib error");
        //             return;
        //         }


        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.printWithUnderline("2. Copying template Files...");


        //         var templateBuildResult:String = PrioriRunController.getInstance().template.build();

        //         if (templateBuildResult.length > 0) {
        //             Helper.g().output.print("");
        //             Helper.g().output.printError(templateBuildResult    );
        //             return;
        //         }


        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.printWithUnderline("3. Generating javascript file from Haxe code...");


        //         var buildResult:Bool = PrioriRunController.getInstance().builder.build();

        //         if (buildResult) {
        //             Helper.g().output.print("");
        //             Helper.g().output.print("- Build Success");

        //             if (args.command == ArgsType.COMMAND_RUN) {
        //                 //Helper.g().webserver.run();
        //             }

        //         } else {
        //             Helper.g().output.print("");
        //             Helper.g().output.print("");
        //             Helper.g().output.printError("Compilation Error");
        //         }

        //     } else if (args.command == ArgsType.COMMAND_CREATE) {

        //         var error:Bool = false;

        //         Helper.g().output.print("");
        //         Helper.g().output.print("");
        //         Helper.g().output.print("Creating new Project...");
        //         Helper.g().output.print("");

        //         var prioriPath:String = PrioriRunController.getInstance().haxelib.getHaxelibPath("priori");

        //         if (prioriPath != null && prioriPath != "") {

        //             prioriPath = Helper.g().path.append(prioriPath, "project");
        //             prioriPath = Helper.g().path.append(prioriPath, "cleanbase");

        //             if (Helper.g().path.exists(prioriPath)) {

        //                 try {
        //                     Helper.g().path.copyPath(prioriPath, args.currPath);
        //                 } catch (e:Dynamic) {
        //                     error = true;

        //                     Helper.g().output.print("Error: CANNOT CREATE PROJECT");
        //                     Helper.g().output.print(e);
        //                     Helper.g().output.print("");
        //                 }

        //                 if (!error) {
        //                     Helper.g().output.print("Project created on " + args.currPath);
        //                 }

        //             } else {
        //                 error = true;
        //                 Helper.g().output.print("Error: PROJECT BASE NOT FOUND");
        //             }

        //         } else {
        //             error = true;
        //             Helper.g().output.print("Error: PRIORI LIB NOT FOUND ");
        //         }

        //     }
        // }
    }
}
