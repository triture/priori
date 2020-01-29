package priori.style.font;

@:enum
abstract PriFontStyleItalic(String) {
    var NORMAL = "normal";
    var ITALIC = "italic";
    var OBLIQUE = "oblique";

    inline public function toString():String return this;
}
