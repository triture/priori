package priori.style.border;

import String;

class PriBorderStyle {

    public var width:Int;
    public var type:PriBorderType;
    public var color:Int;

    public function new(?width:Int = 1, ?color:Int = 0xCCCCCC, ?type:PriBorderType) {
        this.width = width;
        this.color = color;

        this.type = type == null ? PriBorderType.SOLID : type;
    }

    public function toString():String {
        var styleString:String = "";
        var result:String;

        if (this.type == PriBorderType.SOLID) {
            styleString = "solid";
        } else if (this.type == PriBorderType.DOTTED) {
            styleString = "dotted";
        } else if (this.type == PriBorderType.DASHED) {
            styleString = "dashed";
        }

        result = "#" + StringTools.hex(color, 6) + " " + styleString + " " + this.width + "px ";

        return result;
    }

}
