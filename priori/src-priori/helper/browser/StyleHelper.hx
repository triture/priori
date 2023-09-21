package helper.browser;

import priori.style.font.PriFontStyleVariant;
import helper.display.DisplayHelper.PriMap;
import haxe.ds.StringMap;
import js.html.Element;
import priori.style.font.PriFontStyle;
import js.html.Element;

class StyleHelper {


    public static function applyFontStyleDirect(element:Element, ?style:PriFontStyle):Void {

        if (style == null) {
            element.style.fontFamily = null;
            element.style.fontWeight = null;
            element.style.fontStyle = null;
            element.style.textAlign = null;
            element.style.color = null;
            element.style.textDecoration = null;
            element.style.fontVariant = null;
            element.style.textTransform = null;    
        } else {
            element.style.fontFamily = style.family;
            element.style.fontWeight = style.weight.toString();
            element.style.fontStyle = style.italic.toString();
            element.style.textAlign = style.align.toString();
            element.style.color = style.color.toString();
            element.style.textDecoration = style.decoration.toString();

            if (style.variant == null) {
                element.style.fontVariant = null;
                element.style.textTransform = null;
            } else {
                if (style.variant == PriFontStyleVariant.ALL_CAPS) {
                    element.style.textTransform = 'uppercase';
                    element.style.fontVariant = null;
                } else {
                    element.style.textTransform = null;
                    element.style.fontVariant = style.variant.toString();
                }
            }
        }
    }
    public static function applyCleanFontStyleDirect(element:Element):Void applyFontStyleDirect(element, PriFontStyle.getFontStyleObjectBase());

    //public static function applyFontStyle(styleMap:PriMap, fontStyle:PriFontStyle):Void runApplyFontStyle(styleMap, fontStyle);
    //public static function applyCleanFontStyle(styleMap:PriMap):Void applyFontStyle(styleMap, null);

    public static function applyFontStyle(styles:PriMap, value:PriFontStyle):Void {
        if (value == null) {

            styles.remove('color');
            styles.remove('font-family');
            styles.remove('font-weight');
            styles.remove('font-style');
            styles.remove('text-align');
            styles.remove('text-decoration');

            styles.remove('font-variant');
            styles.remove('text-transform');

        } else {

            styles.set('font-family', value.family);
            styles.set('font-weight', value.weight == null ? null : value.weight.toString());
            styles.set('font-style', value.italic == null ? null : value.italic.toString());
            styles.set('text-align', value.align == null ? null : value.align.toString());
            styles.set('color', value.color == null ? null : value.color.toString());
            styles.set('text-decoration', value.decoration == null ? null : value.decoration.toString());
            
            if (value.variant == null) {
                styles.remove('font-variant');
                styles.remove('text-transform');
            } else {
                if (value.variant == PriFontStyleVariant.ALL_CAPS) {
                    styles.set('text-transform', 'uppercase');
                    styles.remove('font-variant');
                } else {
                    styles.remove('text-transform');
                    styles.set('font-variant', value.variant.toString());
                }
            }
        }
    }

}