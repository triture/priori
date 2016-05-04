package priori.event;

class PriMouseEvent extends PriEvent {

    public static var MOUSE_OVER:String = "primouseover";
    public static var MOUSE_OUT:String = "primouseout";


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
