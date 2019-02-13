package priori.event;

class PriTapEvent extends PriMouseEvent {

    inline public static var TAP:String = "click";
    inline public static var TAP_DOWN:String = "mousedown";
    inline public static var TAP_UP:String = "mouseup";

    inline public static var TOUCH_DOWN:String = "touchdown";
    inline public static var TOUCH_UP:String = "touchup";
    inline public static var TOUCH_MOVE:String = "touchmove";

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriTapEvent = new PriTapEvent(this.type, this.propagate, this.bubble);

        clone.__real = this.__real;

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        clone.altKey = this.altKey;
        clone.shiftKey = this.shiftKey;
        clone.ctrlKey = this.ctrlKey;
        clone.metaKey = this.metaKey;

        return clone;
    }
}
