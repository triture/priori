package helper.display;

import priori.geom.PriColor;
import priori.style.font.PriFontStyleWeight;
import priori.style.font.PriFontStyleItalic;
import priori.style.font.PriFontStyleVariant;
import priori.style.font.PriFontStyleAlign;
import priori.style.font.PriFontStyleDecoration;

typedef DisplayTextHelper = {
    var text:String;
    var html:String;
    var fontSize:Float;
    var autoSize:Bool;
    var multiLine:Bool;
    var selectable:Bool;
    var ellipsis:Bool;
    var editable:Bool;
    var lineHeight:Float;
    var letterSpace:Float;

    var textColor:PriColor;
    var fontFamily:String;
    var weight:PriFontStyleWeight;
    var italic:PriFontStyleItalic;
    var variant:PriFontStyleVariant;
    var align:PriFontStyleAlign;
    var decoration:PriFontStyleDecoration;
}
