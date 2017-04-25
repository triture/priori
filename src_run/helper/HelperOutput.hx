package helper;

class HelperOutput {

    public function new() {

    }

    public function printLines(value:Array<String>, tabs:Int = 1):Void {
        var stringTabs:String = this.getTabs(tabs);
        this.append("\n" + stringTabs + value.join("\n" + stringTabs));
    }

    public function printError(message:String, title:String = "Error..."):Void {

        var errorMessage:String = "   " + message + "   ";
        var errorLine:String = this.getTabs(errorMessage.length+2, "-");
        var errorSpace:String = "|" + this.getTabs(errorMessage.length, " ") + "|";

        this.printLines(
            [
                "",
                "",
                "",
                "",
                "",
                title,
                errorLine,
                errorSpace,
                "|" + errorMessage + "|",
                errorSpace,
                errorLine
            ]
        );
    }

    public function print(value:Dynamic, tabs:Int = 1):Void {
        var stringTabs:String = this.getTabs(tabs);
        Sys.print("\n" + stringTabs + Std.string(value));
    }

    public function append(value:Dynamic):Void {
        Sys.print(value);
    }

    public function getTabs(tabs:Int, char:String = "     "):String {
        var result:String = "";

        for (i in 0 ... tabs) {
            result += char;
        }

        return result;
    }

    public function printWithUnderline(value:String, tabs:Int = 1):Void {
        var under:String = this.getTabs(value.length, "-");

        this.printLines([value, under], tabs);
    }

}
