package helper.browser;

import haxe.ds.StringMap;
import js.html.Element;
import priori.style.font.PriFontStyle;
import js.html.Element;

class StyleHelper {


    public static function applyFontStyleDirect(element:Element, ?fontStyle:PriFontStyle, ?valuesDirect:Dynamic = null):Void {
        var values:Dynamic = fontStyle == null ? valuesDirect : fontStyle.getFontStyleObject();

        element.style.fontFamily = values.fontFamily;
        element.style.fontWeight = values.fontWeight;
        element.style.fontVariant = values.fontVariant;
        element.style.fontStyle = values.fontStyle;
        element.style.textAlign = values.textAlign;
        element.style.color = values.color;
        element.style.textDecoration = values.textDecoration;
    }
    public static function applyCleanFontStyleDirect(element:Element):Void applyFontStyleDirect(element, PriFontStyle.getFontStyleObjectBase());

    public static function applyFontStyle(styleMap:StringMap<String>, fontStyle:PriFontStyle):Void runApplyFontStyle(styleMap, fontStyle.getFontStyleObject());
    public static function applyCleanFontStyle(styleMap:StringMap<String>):Void runApplyFontStyle(styleMap, PriFontStyle.getFontStyleObjectBase());

    private static function runApplyFontStyle(styleMap:StringMap<String>, values:Dynamic):Void {

        values.fontFamily == null ? styleMap.remove("font-family") : styleMap.set("font-family", values.fontFamily);
        values.fontWeight == null ? styleMap.remove("font-weight") : styleMap.set("font-weight", values.fontWeight);
        values.fontVariant == null ? styleMap.remove("font-variant") : styleMap.set("font-variant", values.fontVariant);
        values.fontStyle == null ? styleMap.remove("font-style") : styleMap.set("font-style", values.fontStyle);
        values.textAlign == null ? styleMap.remove("text-align") : styleMap.set("text-align", values.textAlign);
        values.color == null ? styleMap.remove("color") : styleMap.set("color", values.color);
        values.textDecoration == null ? styleMap.remove("text-decoration") : styleMap.set("text-decoration", values.textDecoration);

    }

}