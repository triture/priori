package priori.event;

import js.html.MouseEvent;

class PriMouseEvent extends PriEvent {

    inline public static var MOUSE_OVER:String = "mouseenter";
    inline public static var MOUSE_OUT:String = "mouseleave";
    inline public static var MOUSE_MOVE:String = "mousemove";

    @:allow(helper.browser.BrowserEventEngine)
    private var __real:MouseEvent;

    public var altKey:Bool;
    public var shiftKey:Bool;
    public var ctrlKey:Bool;
    public var metaKey:Bool;

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    public function preventDefault():Void this.__real.preventDefault();

    override public function clone():PriEvent {
        var clone:PriMouseEvent = new PriMouseEvent(this.type, this.propagate, this.bubble);

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
