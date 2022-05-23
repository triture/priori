package priori.event;

import js.html.KeyboardEvent;

class PriKeyboardEvent extends PriEvent {

    inline public static var KEY_DOWN:String = "keydown";
    inline public static var KEY_UP:String = "keyup";

    @:allow(helper.browser.BrowserEventEngine)
    private var __real:KeyboardEvent;

    public var key:String;
    public var keycode:Int;
    public var altKey:Bool;
    public var shiftKey:Bool;
    public var ctrlKey:Bool;
    public var metaKey:Bool;

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        super(type, propagate, bubble, data);
    }

    public function preventDefault():Void this.__real.preventDefault();

    override public function clone():PriEvent {
        var clone:PriKeyboardEvent = new PriKeyboardEvent(this.type, this.propagate, this.bubble);

        clone.__real = this.__real;
        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        clone.key = this.key;
        clone.keycode = this.keycode;
        clone.altKey = this.altKey;
        clone.ctrlKey = this.ctrlKey;
        clone.shiftKey = this.shiftKey;
        clone.metaKey = this.metaKey;

        return clone;
    }

    public function toString():String {
        return haxe.Json.stringify({
            key : this.key,
            keyCode : this.keycode,
            altKey : this.altKey,
            ctrlKey : this.ctrlKey,
            shiftKey : this.shiftKey
        });
    }

}
