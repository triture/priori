package helper;

class TerminalPrinter {

    private static var TAB:String = "    ";
    private static var ccode = '\033[0m';

    private static var colorCodes:Array<Array<String>> = [
        ['[red]', '[/red]', '\033[0;31m'],
        ['[cyan]', '[/cyan]', '\033[0;36m'],
        ['[green]', '[/green]', '\033[0;32m'],
        ['[yellow]', '[/yellow]', '\033[0;33m']
    ];

    static public function print(value:Any):Void {
        Sys.print(colorize(value));
    }

    static public function printLine(value:Any):Void {
        Sys.println(colorize(value));
    }

    static public function breakLines(n:Int = 1):Void {
        for (i in 0 ... n) Sys.println('');
    }

    static private function string(value:Any):String {
        return Std.string(value);
    }

    static private function tag(value:Any, openTag:String, replaceOpenTag:String, closeTag:String, replaceCloseTag:String):String {
        var str:String = string(value);
        str = str.split(openTag).join(replaceOpenTag);
        str = str.split(closeTag).join(replaceCloseTag);
        return str;   
    }

    static private function colorize(value:Any):String {
        for (color in colorCodes) value = tag(value, color[0], color[2], color[1], ccode);
        return string(value);
    }
}