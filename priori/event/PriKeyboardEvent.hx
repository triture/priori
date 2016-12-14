package priori.event;

class PriKeyboardEvent extends PriEvent {

    inline public static var KEY_DOWN:String = "keydown";
    inline public static var KEY_UP:String = "keyup";

    public var keycode:Int;
    public var altKey:Bool;
    public var shiftKey:Bool;
    public var ctrlKey:Bool;

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriKeyboardEvent = new PriKeyboardEvent(this.type, this.propagate, this.bubble);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        clone.keycode = this.keycode;
        clone.altKey = this.altKey;
        clone.ctrlKey = this.ctrlKey;
        clone.shiftKey = this.shiftKey;

        return clone;
    }

    public function toString():String {
        return haxe.Json.stringify({
            keyCode : this.keycode,
            altKey : this.altKey,
            ctrlKey : this.ctrlKey,
            shiftKey : this.shiftKey
        });
    }

}
