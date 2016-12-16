package priori.event;

class PriFocusEvent extends PriEvent {

    inline public static var FOCUS_IN:String = "focusin";
    inline public static var FOCUS_OUT:String = "focusout";

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriFocusEvent = new PriFocusEvent(this.type, this.propagate, this.bubble);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        return clone;
    }

}
