package priori.geom;

class PriColor {

    public var color:Int;

    public var red(get, set):Int;
    public var green(get, set):Int;
    public var blue(get, set):Int;

    public function new(color:Int = 0x000000) {
        this.color = color;
    }

    private function get_red():Int {
        return (this.color >> 16) & 0xff;
    }

    private function set_red(value:Int):Int {
        var g:Int = this.green;
        var b:Int = this.blue;

        this.updateColor(value, g, b);

        return value;
    }

    private function get_green():Int {
        return (this.color >> 8) & 0xff;
    }

    private function set_green(value:Int):Int {
        var r:Int = this.red;
        var b:Int = this.blue;

        this.updateColor(r, value, b);

        return value;
    }

    private function get_blue():Int {
        return this.color & 0xff;
    }

    private function set_blue(value:Int):Int {
        var r:Int = this.red;
        var g:Int = this.green;

        this.updateColor(r, g, value);

        return value;
    }

    public function updateColor(r:Int, g:Int, b:Int):Void {
        var R:Int = (r << 16);
        var G:Int = (g << 8);
        var B:Int = b;

        this.color = R | G | B;
    }

    public function toString():String {
        return "#" + StringTools.hex(this.color, 6);
    }

}
