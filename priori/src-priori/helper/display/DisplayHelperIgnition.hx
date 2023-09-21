package helper.display;

import haxe.ds.StringMap;
import helper.browser.BrowserEventEngine;
import helper.display.DisplayHelper;

class DisplayHelperIgnition {

    static inline public var INITIAL_FONT_SIZE:Int = 14;

    static inline public function getDisplayTextHelper():DisplayTextHelper {
        return {
            text : "",
            html : "",
            fontSize : INITIAL_FONT_SIZE,
            autoSize : true,
            multiLine : false,
            selectable : false,
            ellipsis : true,
            editable : false,
            lineHeight : null,
            letterSpace : null,

            textColor:null,
            fontFamily:null,
            weight:null,
            italic:null,
            variant:null,
            align:null,
            decoration:null
        }
    }

    static inline public function getDisplayHerlper():DisplayHelper {

        var map:PriMap = new PriMap();

        map.set("left", "0px");             // x
        map.set("top", "0px");              // y
        map.set("width", "100px");          // width
        map.set("height", "100px");         // height
        map.set("overflow", "hidden");      // clipping
        map.set("z-index", "1000");         // depth

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
            visible : true,
            mouseEnabled : true,

            anchorX : 0.5,
            anchorY : 0.5,
            rotation : 0,
            scaleX : 1,
            scaleY : 1,
            alpha : 1,
            disabled : false,

            eventHelper : new BrowserEventEngine(),
            styles : map,
            styleString : "",
            holdStyleUpdate : false
        }
    }

}
