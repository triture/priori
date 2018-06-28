package priori.view;

import priori.style.line.LineDirection;
import priori.geom.PriColor;
import priori.style.border.PriBorderType;

class PriLine extends PriDisplay {

    @:isVar public var lineWidth(default, set):Float = 1;
    @:isVar public var lineStyle(default, set):PriBorderType = PriBorderType.SOLID;
    @:isVar public var lineColor(default, set):PriColor = 0x000000;

    private var direction:LineDirection;

    public function new(direction:LineDirection) {
        super();
        this.direction = direction;

        switch (this.direction) {
            case LineDirection.HORIZONTAL : super.set_height(0);
            case LineDirection.VERTICAL : super.set_width(0);
        }

        this.__updateLine();
    }

    private function set_lineWidth(value:Float):Float {
        if (value == null) return value;

        this.lineWidth = value;
        this.__updateLine();
        return value;
    }

    private function set_lineStyle(value:PriBorderType):PriBorderType {
        if (value == null) return value;

        this.lineStyle = value;
        this.__updateLine();
        return value;
    }

    private function set_lineColor(value:PriColor):PriColor {
        if (value == null) return value;

        this.lineColor = value;
        this.__updateLine();
        return value;
    }

    private function __updateLine():Void {
        switch (this.direction) {
            case LineDirection.HORIZONTAL : {
                this.dh.jselement.style.borderTopColor = this.lineColor;
                this.dh.jselement.style.borderTopWidth = this.lineWidth + "px";
                this.dh.jselement.style.borderTopStyle = switch(this.lineStyle) {
                    case PriBorderType.SOLID : "solid";
                    case PriBorderType.DASHED : "dashed";
                    case PriBorderType.DOTTED : "dotted";
                };
            }

            case LineDirection.VERTICAL : {
                this.dh.jselement.style.borderLeftColor = this.lineColor;
                this.dh.jselement.style.borderLeftWidth = this.lineWidth + "px";
                this.dh.jselement.style.borderLeftStyle = switch(this.lineStyle) {
                    case PriBorderType.SOLID : "solid";
                    case PriBorderType.DASHED : "dashed";
                    case PriBorderType.DOTTED : "dotted";
                };
            }
        }
    }

    override private function set_width(value:Float):Float {
        if (this.direction == LineDirection.VERTICAL) {
            return value;
        } else return super.set_width(value);
    }

    override private function get_width():Float {
        if (this.direction == LineDirection.VERTICAL) {
            return 0;
        } else return super.get_width();
    }

    override private function set_height(value:Float):Float {
        if (this.direction == LineDirection.HORIZONTAL) {
            return value;
        } else return super.set_height(value);
    }

    override private function get_height():Float {
        if (this.direction == LineDirection.HORIZONTAL) {
            return 0;
        } else return super.get_height();
    }

}
