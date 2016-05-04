package priori.style.font;

class PriFontStyle {

    public static var DEFAULT_COLOR:Int = 0x000000;
    public static var DEFAULT_FAMILY:String = "Arial, Helvetica, sans-serif";
    public static var DEFAULT_WEIGHT:PriFontStyleWeight = null;
    public static var DEFAULT_ITALIC:PriFontStyleItalic = null;
    public static var DEFAULT_VARIANT:PriFontStyleVariant = null;
    public static var DEFAULT_ALIGN:PriFontStyleAlign = null;

    public var color:Int;
    public var family:String;

    public var weight:PriFontStyleWeight;
    public var italic:PriFontStyleItalic;
    public var variant:PriFontStyleVariant;
    public var align:PriFontStyleAlign;

    public function new(?color:Int, ?family:String, ?weight:PriFontStyleWeight, ?italic:PriFontStyleItalic, ?variant:PriFontStyleVariant, ?align:PriFontStyleAlign) {
        if (color != null) this.color = color else this.color = PriFontStyle.DEFAULT_COLOR;
        if (family != null) this.family = family else this.family = PriFontStyle.DEFAULT_FAMILY;
        if (weight != null) this.weight = weight else this.weight = PriFontStyle.DEFAULT_WEIGHT;
        if (italic != null) this.italic = italic else this.italic = PriFontStyle.DEFAULT_ITALIC;
        if (variant != null) this.variant = variant else this.variant = PriFontStyle.DEFAULT_VARIANT;
        if (align != null) this.align = align else this.align = PriFontStyle.DEFAULT_ALIGN;
    }

    public static function getFontStyleObjectBase():Dynamic {
        return {
            fontFamily : "",
            fontWeight : "",
            fontVariant : "",
            fontStyle : "",
            textAlign : "",
            color : ""
        }
    }

    public function getFontStyleObject():Dynamic {
        var weight:String = "";
        var italic:String = "";
        var variant:String = "";
        var align:String = "";
        var family:String = this.family == null ? "" : this.family;
        var color:String = this.color == null ? "" : "#" + StringTools.hex(this.color, 6);

        if (this.weight != null)
        switch (this.weight) {
            case PriFontStyleWeight.NORMAL : weight = "normal";
            case PriFontStyleWeight.BOLD : weight = "bold";
            case PriFontStyleWeight.BOLDER : weight = "bolder";
            case PriFontStyleWeight.LIGHTER : weight = "lighter";
            case PriFontStyleWeight.THICK100 : weight = "100";
            case PriFontStyleWeight.THICK200 : weight = "200";
            case PriFontStyleWeight.THICK300 : weight = "300";
            case PriFontStyleWeight.THICK400 : weight = "400";
            case PriFontStyleWeight.THICK500 : weight = "500";
            case PriFontStyleWeight.THICK600 : weight = "600";
            case PriFontStyleWeight.THICK700 : weight = "700";
            case PriFontStyleWeight.THICK800 : weight = "800";
            case PriFontStyleWeight.THICK900 : weight = "900";
        }

        if (this.italic != null)
        switch (this.italic) {
            case PriFontStyleItalic.NORMAL : italic = "normal";
            case PriFontStyleItalic.ITALIC : italic = "italic";
            case PriFontStyleItalic.OBLIQUE : italic = "oblique";
        }

        if (this.variant != null)
        switch (this.variant) {
            case PriFontStyleVariant.NORMAL : variant = "normal";
            case PriFontStyleVariant.SMALL_CAPS : variant = "small-caps";
        }

        if (this.align != null)
        switch (this.align) {
            case PriFontStyleAlign.LEFT : align = "left";
            case PriFontStyleAlign.CENTER : align = "center";
            case PriFontStyleAlign.RIGHT : align = "right";
        }

        var styleData:Dynamic = PriFontStyle.getFontStyleObjectBase();
        styleData.fontFamily = family;
        styleData.fontWeight = weight;
        styleData.fontStyle = italic;
        styleData.fontVariant = variant;
        styleData.textAlign = align;
        styleData.color = color;

        return styleData;
    }

    public function toString():String {
        return haxe.Json.stringify(this.getFontStyleObject());
    }

}
