package priori.geom;

abstract PriColor(Int) from Int to Int {

    public var red(get, set):Int;
    public var green(get, set):Int;
    public var blue(get, set):Int;

    inline public function new(color:Int = 0x000000) {
        this = color;
    }

    inline public function mixWith(color:PriColor, percent:Float = 0.5):Void {
        if (percent == null || percent < 0) percent = 0;
        if (percent > 1) percent = 1;

        var nr:Int = red + Math.round((color.red - red)*percent);
        var ng:Int = green + Math.round((color.green - green)*percent);
        var nb:Int = blue + Math.round((color.blue - blue)*percent);

        updateColor(nr, ng, nb);
    }

    public function mix(withColor:PriColor, percent:Float = 0.5):PriColor {
        if (percent == null || percent < 0) percent = 0;
        if (percent > 1) percent = 1;

        var nr:Int = red + Math.round((withColor.red - red)*percent);
        var ng:Int = green + Math.round((withColor.green - green)*percent);
        var nb:Int = blue + Math.round((withColor.blue - blue)*percent);
        
        return new PriColor((nr << 16) | (ng << 8) | nb);
    }

    inline private function get_red():Int {
        return (this >> 16) & 0xff;
    }

    inline private function set_red(value:Int):Int {
        var g:Int = green;
        var b:Int = blue;

        updateColor(value, g, b);

        return value;
    }

    inline private function get_green():Int {
        return (this >> 8) & 0xff;
    }

    inline private function set_green(value:Int):Int {
        var r:Int = red;
        var b:Int = blue;

        updateColor(r, value, b);

        return value;
    }

    inline private function get_blue():Int {
        return this & 0xff;
    }

    inline private function set_blue(value:Int):Int {
        var r:Int = red;
        var g:Int = green;

        updateColor(r, g, value);

        return value;
    }

    inline public function updateColor(r:Int, g:Int, b:Int):PriColor {
        var R:Int = (r << 16);
        var G:Int = (g << 8);
        var B:Int = b;

        this = R | G | B;

        return this;
    }

    @:to inline public function toString():String {
        return "#" + StringTools.hex(this, 6);
    }

    @:from inline static public function fromString(rgb:String):PriColor {
        if (rgb.charAt(0) == "#") rgb = "0x" + rgb.substring(1);
        var colorInt:Int = Std.parseInt(rgb);
        if (colorInt == null) colorInt = 0;
        return new PriColor(colorInt);
    }

}
