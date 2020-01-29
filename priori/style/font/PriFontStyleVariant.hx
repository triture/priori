package priori.style.font;

@:enum
abstract PriFontStyleVariant(String) {
    var NORMAL = "normal";
    var SMALL_CAPS = "small-caps";

    inline public function toString():String return this;
}
