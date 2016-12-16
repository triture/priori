package priori.event;

class PriTapEvent extends PriEvent {

    inline public static var TAP:String = "click";
    inline public static var TAP_DOWN:String = "mousedown";
    inline public static var TAP_UP:String = "mouseup";


    public static var TAP_START:String = "tapstart";
    public static var TAP_END:String = "tapend";
    public static var TAP_MOVE:String = "mousemove"; //tapmove
    public static var SINGLETAP:String = "singletap";


    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriTapEvent = new PriTapEvent(this.type, this.propagate, this.bubble);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        return clone;
    }
}
