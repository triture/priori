package helper.display;

import helper.browser.BrowserEventEngine;
import helper.display.DisplayHelper;

class DisplayHelperIgnition {

    static inline public var INITIAL_FONT_SIZE:Int = 14;

    static inline public function getDisplayTextHelper():DisplayTextHelper {
        return {
            text : "",
            fontSize : INITIAL_FONT_SIZE,
            autoSize : true,
            multiLine : false,
            selectable : false,
            ellipsis : true,
            editable : false,
            lineHeight : null
        }
    }

    static inline public function getDisplayHerlper():DisplayHelper {
        return {
            bgColor : null,

            x : 0,
            y : 0,
            width : 100,
            height : 100,
            clipping : true,
            depth : 1000,
            pointer : false,
            focusable : false,

            dragdata : null,

            anchorX : 0.5,
            anchorY : 0.5,
            rotation : 0,
            scaleX : 1,
            scaleY : 1,
            alpha : 1,
            disabled : false,

            element : null,
            elementBorder : null,
            jselement : null,

            parent : null,

            eventHelper : new BrowserEventEngine()
        }
    }

}
