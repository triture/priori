package priori.style.border;

import String;

class BorderStyle {

    public var width:Int;
    public var type:BorderType;
    public var color:String;

    public function new(width:Int = 1, color:String = "#CCCCCC") {
        this.width = width;
        this.color = color;

        this.type = BorderType.SOLID;
    }

    public function toString():String {
        var styleString:String = "";
        var result:String;

        if (this.type == BorderType.SOLID) {
            styleString = "solid";
        } else if (this.type == BorderType.DOTTED) {
            styleString = "dotted";
        } else if (this.type == BorderType.DASHED) {
            styleString = "dashed";
        }

        result = styleString + " " + this.width + "px " + this.color;

        return result;
    }

}
