package priori.style.font;

import priori.geom.PriColor;

class PriFontStyle {

    public static var DEFAULT_COLOR:PriColor = 0x000000;
    public static var DEFAULT_FAMILY:String = "Arial, Helvetica, sans-serif";
    public static var DEFAULT_WEIGHT:PriFontStyleWeight = null;
    public static var DEFAULT_ITALIC:PriFontStyleItalic = null;
    public static var DEFAULT_VARIANT:PriFontStyleVariant = null;
    public static var DEFAULT_ALIGN:PriFontStyleAlign = null;
    public static var DEFAULT_DECORATION:PriFontStyleDecoration = null;

    public var color:PriColor;
    public var family:String;

    public var weight:PriFontStyleWeight;
    public var italic:PriFontStyleItalic;
    public var variant:PriFontStyleVariant;
    public var align:PriFontStyleAlign;
    public var decoration:PriFontStyleDecoration;

    public function new(?color:PriColor, ?family:String, ?weight:PriFontStyleWeight, ?italic:PriFontStyleItalic, ?variant:PriFontStyleVariant, ?align:PriFontStyleAlign, ?decoration:PriFontStyleDecoration) {
        if (color != null) this.color = color else this.color = PriFontStyle.DEFAULT_COLOR;
        if (family != null) this.family = family else this.family = PriFontStyle.DEFAULT_FAMILY;
        if (weight != null) this.weight = weight else this.weight = PriFontStyle.DEFAULT_WEIGHT;
        if (italic != null) this.italic = italic else this.italic = PriFontStyle.DEFAULT_ITALIC;
        if (variant != null) this.variant = variant else this.variant = PriFontStyle.DEFAULT_VARIANT;
        if (align != null) this.align = align else this.align = PriFontStyle.DEFAULT_ALIGN;
        if (decoration != null) this.decoration = decoration else this.decoration = PriFontStyle.DEFAULT_DECORATION;
    }

    public function clone():PriFontStyle return new PriFontStyle(this.color, this.family, this.weight, this.italic, this.variant, this.align, this.decoration);

    public function setColor(color:PriColor):PriFontStyle {
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
        var color:String = this.color == null ? "" : this.color.toString();
        var decoration:String = "";

        if (this.weight != null) weight = this.weight.toString();
        if (this.italic != null) italic = this.italic.toString();
        if (this.variant != null) variant = this.variant.toString();
        if (this.align != null) align = this.align.toString();
        if (this.decoration != null) decoration = this.decoration.toString();

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
    
    public function toString():String return haxe.Json.stringify(this.getFontStyleObject());

}
