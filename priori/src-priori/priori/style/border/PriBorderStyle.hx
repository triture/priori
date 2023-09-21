package priori.style.border;

import priori.geom.PriColor;

class PriBorderStyle {

    public var width:Float;
    public var type:PriBorderType;
    public var color:PriColor;

    public function new(?width:Float = 1, ?color:PriColor = 0xCCCCCC, ?type:PriBorderType) {
        this.width = width;
        this.color = color;

        this.type = type == null ? PriBorderType.SOLID : type;
    }

    public function setColor(color:PriColor):PriBorderStyle {
        this.color = color;
        return this;
    }

    public function setType(type:PriBorderType):PriBorderStyle {
        this.type = type;
        return this;
    }

    public function setWidth(width:Float):PriBorderStyle {
        this.width = width;
        return this;
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

        result = this.color.toString() + " " + styleString + " " + this.width + "px ";

        return result;
    }

}
