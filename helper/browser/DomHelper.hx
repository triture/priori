package helper.browser;

import js.html.Element;

class DomHelper {

    public static function disableAll(el:Element):Void {

        el.setAttribute("disabled", "disabled");

        for (i in 0 ... el.children.length) {
            disableAll(el.children.item(i));
        }
    }

    public static function enableAllUpPrioriDisabled(el:Element):Void {
        if (!el.hasAttribute("priori-disabled")) {
            el.removeAttribute("disabled");

            for (i in 0 ... el.children.length) {
                enableAllUpPrioriDisabled(el.children.item(i));
            }
        }
    }
}