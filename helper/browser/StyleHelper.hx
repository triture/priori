package helper.browser;

import js.html.Element;
import priori.style.font.PriFontStyle;
import js.html.Element;

class StyleHelper {


    public static function applyFontStyle(element:Element, fontStyle:PriFontStyle):Void runApplyFontStyle(element, fontStyle.getFontStyleObject());
    public static function applyCleanFontStyle(element:Element):Void runApplyFontStyle(element, PriFontStyle.getFontStyleObjectBase());

    private static function runApplyFontStyle(element:Element, values:Dynamic):Void {
        element.style.fontFamily = values.fontFamily;
        element.style.fontWeight = values.fontWeight;
        element.style.fontVariant = values.fontVariant;
        element.style.fontStyle = values.fontStyle;
        element.style.textAlign = values.textAlign;
        element.style.color = values.color;
    }

}