package priori.style.font;

enum abstract PriFontStyleDecoration(String) {
    var NONE = "none";
    var UNDERLINE = "underline";
    var OVERLINE = "overline";
    var LINE_THROUGH = "line-through";

    inline public function toString():String return this;
}
