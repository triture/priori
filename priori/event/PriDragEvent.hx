package priori.event;

class PriDragEvent extends PriEvent {

    inline public static var DROP:String = "drop";
    inline public static var DRAG_ENTER:String = "dragenter";
    inline public static var DRAG_LEAVE:String = "dragleave";

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriDragEvent = new PriDragEvent(this.type, this.propagate, this.bubble);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        return clone;
    }
}
