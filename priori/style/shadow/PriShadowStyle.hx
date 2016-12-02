package priori.style.shadow;

import priori.geom.PriColor;

class PriShadowStyle {

    public var horizontalOffset:Float = 0;
    public var verticalOffset:Float = 8;
    public var blur:Float = 30;
    public var spread:Float = -5;
    public var color:Int = 0x000000;
    public var opacity:Float = 0.7;
    public var type:PriShadowType = PriShadowType.OUTLINE;

    public function new() {

    }

    public function setHorizontalOffset(value:Float):PriShadowStyle {
        this.horizontalOffset = value;
        return this;
    }

    public function setVerticalOffset(value:Float):PriShadowStyle {
        this.verticalOffset = value;
        return this;
    }

    public function setBlur(value:Float):PriShadowStyle {
        this.blur = value;
        return this;
    }

    public function setSpread(value:Float):PriShadowStyle {
        this.spread = value;
        return this;
    }

    public function setColor(value:Int):PriShadowStyle {
        this.color = value;
        return this;
    }

    public function setOpacity(value:Float):PriShadowStyle {
        this.opacity = value;
        return this;
    }

    public function setType(value:PriShadowType):PriShadowStyle {
        this.type = value;
        return this;
    }

    public function toString():String {
        // H, V, B, S, RGBA()

        var c:PriColor = new PriColor(this.color);

        return
            (this.horizontalOffset + "px ") +
            (this.verticalOffset + "px ") +
            (this.blur + "px ") +
            (this.spread + "px ") +
            ("rgba(" + c.red + "," + c.green + "," + c.red + "," + this.opacity + ")")
        ;
    }
}
