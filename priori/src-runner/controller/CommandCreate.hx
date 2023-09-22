package controller;

import sys.FileSystem;
import helper.Helper;
import helper.Validation;
import helper.TerminalPrinter;
import model.ArgsData;

class CommandCreate {
    
    static public function run(args:ArgsData):Void {
        TerminalPrinter.print("[yellow]CREATING NEW PROJECT:[/yellow]");

        var prioriPath:String = HaxelibController.getHaxelibPath("priori");

        if (Validation.isEmptyString(prioriPath)) throw 'Priori path not found.';

        prioriPath = Helper.g().path.appendMultiple([prioriPath, 'project', 'cleanbase']);
        
        if (!Helper.g().path.exists(prioriPath)) throw 'Priori base project not found.';

        var destPath:String = args.currPath;

        if (FileSystem.exists(destPath)) {
            if (!FileSystem.isDirectory(destPath)) throw 'Destination path is not a directory.';
            else if (FileSystem.readDirectory(destPath).length > 0) throw 'Destination path is not empty.';
        } else FileSystem.createDirectory(destPath);
        
        try {
            TerminalPrinter.breakLines();
            TerminalPrinter.print('  > Copying files project at [yellow]${args.currPath}[/yellow]... ');
            Helper.g().path.copyPath(prioriPath, args.currPath);
            TerminalPrinter.printLine('[cyan]DONE[/cyan]');
        } catch (e:Dynamic) {
            throw 'Error while copying cleanbase project.';
        }
    }
    
}