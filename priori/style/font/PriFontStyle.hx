package priori.style.font;

class PriFontStyle {

    public static var DEFAULT_COLOR:Int = 0x000000;
    public static var DEFAULT_FAMILY:String = "Arial, Helvetica, sans-serif";
    public static var DEFAULT_WEIGHT:PriFontStyleWeight = null;
    public static var DEFAULT_ITALIC:PriFontStyleItalic = null;
    public static var DEFAULT_VARIANT:PriFontStyleVariant = null;
    public static var DEFAULT_ALIGN:PriFontStyleAlign = null;
    public static var DEFAULT_DECORATION:PriFontStyleDecoration = null;

    public var color:Int;
    public var family:String;

    public var weight:PriFontStyleWeight;
    public var italic:PriFontStyleItalic;
    public var variant:PriFontStyleVariant;
    public var align:PriFontStyleAlign;
    public var decoration:PriFontStyleDecoration;

    public function new(?color:Int, ?family:String, ?weight:PriFontStyleWeight, ?italic:PriFontStyleItalic, ?variant:PriFontStyleVariant, ?align:PriFontStyleAlign, ?decoration:PriFontStyleDecoration) {
        if (color != null) this.color = color else this.color = PriFontStyle.DEFAULT_COLOR;
        if (family != null) this.family = family else this.family = PriFontStyle.DEFAULT_FAMILY;
        if (weight != null) this.weight = weight else this.weight = PriFontStyle.DEFAULT_WEIGHT;
        if (italic != null) this.italic = italic else this.italic = PriFontStyle.DEFAULT_ITALIC;
        if (variant != null) this.variant = variant else this.variant = PriFontStyle.DEFAULT_VARIANT;
        if (align != null) this.align = align else this.align = PriFontStyle.DEFAULT_ALIGN;
        if (decoration != null) this.decoration = decoration else this.decoration = PriFontStyle.DEFAULT_DECORATION;
    }

    public function setColor(color:Int):PriFontStyle {
        this.color = color;
        return this;
    }

    public function setFamily(family:String):PriFontStyle {
        this.family = family;
        return this;
    }

    public function setWeight(weight:PriFontStyleWeight):PriFontStyle {
        this.weight = weight;
        return this;
    }

    public function setItalic(italic:PriFontStyleItalic):PriFontStyle {
        this.italic = italic;
        return this;
    }

    public function setVariant(variant:PriFontStyleVariant):PriFontStyle {
        this.variant = variant;
        return this;
    }

    public function setAlign(align:PriFontStyleAlign):PriFontStyle {
        this.align = align;
        return this;
    }

    public function setDecoration(decoration:PriFontStyleDecoration):PriFontStyle {
        this.decoration = decoration;
        return this;
    }


    public static function getFontStyleObjectBase():Dynamic {
        return {
            fontFamily : "",
            fontWeight : "",
            fontVariant : "",
            fontStyle : "",
            textAlign : "",
            color : "",
            textDecoration : ""
        }
    }

    public function getFontStyleObject():Dynamic {
        var weight:String = "";
        var italic:String = "";
        var variant:String = "";
        var align:String = "";
        var family:String = this.family == null ? "" : this.family;
        var color:String = this.color == null ? "" : "#" + StringTools.hex(this.color, 6);
        var decoration:String = "";

        if (this.weight != null)
            weight = switch (this.weight) {
                case PriFontStyleWeight.NORMAL : "normal";
                case PriFontStyleWeight.BOLD : "bold";
                case PriFontStyleWeight.BOLDER : "bolder";
                case PriFontStyleWeight.LIGHTER : "lighter";
                case PriFontStyleWeight.THICK100 : "100";
                case PriFontStyleWeight.THICK200 : "200";
                case PriFontStyleWeight.THICK300 : "300";
                case PriFontStyleWeight.THICK400 : "400";
                case PriFontStyleWeight.THICK500 : "500";
                case PriFontStyleWeight.THICK600 : "600";
                case PriFontStyleWeight.THICK700 : "700";
                case PriFontStyleWeight.THICK800 : "800";
                case PriFontStyleWeight.THICK900 : "900";
            }

        if (this.italic != null)
            italic = switch (this.italic) {
                case PriFontStyleItalic.NORMAL : "normal";
                case PriFontStyleItalic.ITALIC : "italic";
                case PriFontStyleItalic.OBLIQUE : "oblique";
            }

        if (this.variant != null)
            variant = switch (this.variant) {
                case PriFontStyleVariant.NORMAL : "normal";
                case PriFontStyleVariant.SMALL_CAPS : "small-caps";
            }

        if (this.align != null)
            align = switch (this.align) {
                case PriFontStyleAlign.LEFT : "left";
                case PriFontStyleAlign.CENTER : "center";
                case PriFontStyleAlign.RIGHT : "right";
            }

        if (this.decoration != null)
            decoration = switch (this.decoration) {
                case PriFontStyleDecoration.NONE : "none";
                case PriFontStyleDecoration.UNDERLINE : "underline";
                case PriFontStyleDecoration.OVERLINE : "overline";
                case PriFontStyleDecoration.LINE_THROUGH : "line-through";
            }

        var styleData:Dynamic = PriFontStyle.getFontStyleObjectBase();
        styleData.fontFamily = family;
        styleData.fontWeight = weight;
        styleData.fontStyle = italic;
        styleData.fontVariant = variant;
        styleData.textAlign = align;
        styleData.color = color;
        styleData.textDecoration = decoration;

        return styleData;
    }

    public function toString():String {
        return haxe.Json.stringify(this.getFontStyleObject());
    }

}
