package priori.event;

class PriSwipeEvent extends PriEvent {

    public static var SWIPE:String = "swipe";
    public static var SWIPE_UP:String = "swipeup";
    public static var SWIPE_RIGHT:String = "swiperight";
    public static var SWIPE_DOWN:String = "swipedown";
    public static var SWIPE_LEFT:String = "swipeleft";
    public static var SWIPE_END:String = "swipeend";


    public function new(type:String, propagate:Bool = false) {
        super(type, propagate);

    }
}
