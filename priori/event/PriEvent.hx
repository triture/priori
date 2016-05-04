package priori.event;


class PriEvent {

    public static var COMPLETE:String = "prievent_base_complete";
    public static var START:String = "prievent_base_start";
    public static var STOP:String = "prievent_base_stop";
    public static var CANCEL:String = "prievent_base_cancel";
    public static var OK:String = "prievent_base_ok";
    public static var SAVE:String = "prievent_base_save";
    public static var DELETE:String = "prievent_base_delete";
    public static var ERROR:String = "prievent_base_error";
    public static var CHANGE:String = "prievent_base_change";
    public static var RESIZE:String = "prievent_base_resize";
    public static var TICK:String = "prievent_base_tick";
    public static var SCROLL:String = "prievent_base_scroll";
    public static var ADD_ITEM:String = "prievent_base_add_item";
    public static var REMOVE_ITEM:String = "prievent_base_remove_item";

    public static var ADDED_TO_APP:String = "prievent_base_addedToApp";
    public static var REMOVED_FROM_APP:String = "prievent_base_removedFromApp";
    public static var ADDED:String = "prievent_base_addedToContainer";
    public static var REMOVED:String = "prievent_base_removedFromContainer";


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
        var clone:PriEvent = new PriEvent(this.type, this.propagate, this.bubble);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        return clone;
    }
}
