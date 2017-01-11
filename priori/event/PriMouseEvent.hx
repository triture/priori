package priori.event;

class PriMouseEvent extends PriEvent {

    inline public static var MOUSE_OVER:String = "mouseenter";
    inline public static var MOUSE_OUT:String = "mouseleave";
    inline public static var MOUSE_MOVE:String = "mousemove";


    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriMouseEvent = new PriMouseEvent(this.type, this.propagate, this.bubble);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        return clone;
    }
}
