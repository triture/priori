package priori.geom;

class PriColor {

    private var color:Int;

    public var red(get, null):Int;
    public var green(get, null):Int;
    public var blue(get, null):Int;

    public function new(color:Int = 0x000000) {
        this.color = color;
    }

    private function get_red():Int {
        return (this.color >> 16) & 0xff;
    }

    private function get_green():Int {
        return (this.color >> 8) & 0xff;
    }

    private function get_blue():Int {
        return this.color & 0xff;
    }

    public function toString():String {
        return "#" + StringTools.hex(this.color, 6);
    }

}
