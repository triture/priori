package priori.style.font;

enum abstract PriFontStyleWeight(String) {
    inline var NORMAL = "normal";
    inline var BOLD = "bold";
    inline var BOLDER = "bolder";
    inline var LIGHTER = "lighter";
    inline var THICK100 = "100";
    inline var THICK200 = "200";
    inline var THICK300 = "300";
    inline var THICK400 = "400";
    inline var THICK500 = "500";
    inline var THICK600 = "600";
    inline var THICK700 = "700";
    inline var THICK800 = "800";
    inline var THICK900 = "900";

    inline public function toString():String return this;
}
