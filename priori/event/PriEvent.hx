package priori.event;


class PriEvent {

    inline public static var ADD_ITEM:String = "prievent_base_add_item";
    inline public static var ADDED:String = "prievent_base_addedToContainer";
    inline public static var ADDED_TO_APP:String = "prievent_base_addedToApp";
    inline public static var CANCEL:String = "prievent_base_cancel";
    inline public static var CHANGE:String = "prievent_base_change";
    inline public static var CLOSE:String = "prievent_base_close";
    inline public static var COMPLETE:String = "prievent_base_complete";
    inline public static var DELETE:String = "prievent_base_delete";
    inline public static var DRAG:String = "prievent_base_drag";
    inline public static var ERROR:String = "prievent_base_error";
    inline public static var OK:String = "prievent_base_ok";
    inline public static var OPEN:String = "prievent_base_open";
    inline public static var PRESS_ENTER:String = "prievent_base_pressenter";
    inline public static var RESIZE:String = "prievent_base_resize";
    inline public static var REMOVED:String = "prievent_base_removedFromContainer";
    inline public static var REMOVE_ITEM:String = "prievent_base_remove_item";
    inline public static var REMOVED_FROM_APP:String = "prievent_base_removedFromApp";
    inline public static var SAVE:String = "prievent_base_save";
    inline public static var START:String = "prievent_base_start";
    inline public static var SCROLL:String = "prievent_base_scroll";
    inline public static var STOP:String = "prievent_base_stop";
    inline public static var TICK:String = "prievent_base_tick";
    inline public static var UPDATE:String = "prievent_base_update";
    inline public static var PROGRESS:String = "prievent_base_progress";

    public var type:String;
    public var propagate:Bool;
    public var bubble:Bool;
    public var target:PriEventDispatcher;
    public var currentTarget:PriEventDispatcher;

    public var data:Dynamic;

    public function new(type:String, propagate:Bool = false, bubble:Bool = false, data:Dynamic = null) {
        if (propagate == null) propagate = false;
        if (bubble == null) bubble = false;

        this.type = type;
        this.propagate = propagate;
        this.bubble = bubble;
        this.data = data;
    }

    public function stopBubble():Void {
        this.bubble = false;
    }

    public function stopPropagation():Void {
        this.propagate = false;
    }

    public function clone():PriEvent {
        var clone:PriEvent = new PriEvent(this.type, this.propagate, this.bubble, this.data);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;

        return clone;
    }
}
