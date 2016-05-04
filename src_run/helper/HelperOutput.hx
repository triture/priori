package helper;

class HelperOutput {

    public function new() {

    }

    public function print(value:Dynamic):Void {
        Sys.print("\n" + Std.string(value));
    }

    public function append(value:Dynamic):Void {
        Sys.print(value);
    }

}
