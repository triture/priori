package priori.event;

class PriMouseEvent extends PriEvent {

    inline public static var MOUSE_OVER:String = "mouseenter";
    inline public static var MOUSE_OUT:String = "mouseleave";
    inline public static var MOUSE_MOVE:String = "mousemove";

    public var x:Float;
    public var y:Float;

    public var xGlobal:Float;
    public var yGlobal:Float;

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriMouseEvent = new PriMouseEvent(this.type, this.propagate, this.bubble);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        clone.x = this.x;
        clone.y = this.y;
        clone.xGlobal = this.xGlobal;
        clone.yGlobal = this.yGlobal;

        return clone;
    }
}
