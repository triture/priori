package priori.view.container;

import priori.style.border.PriBorderStyle;
import jQuery.JQuery;
import priori.geom.PriGeomBox;
import priori.event.PriEvent;

class PriContainer extends PriDisplay {

    private var _childList:Array<PriDisplay> = [];
    private var _migratingView:Bool = false;

    @:isVar public var numChildren(get, null):Int;

    public function new() {
        super();
    }

    @:noCompletion private function get_numChildren():Int {
        return this._childList.length;
    }

    public function getChild(index:Int):PriDisplay {
        var result:PriDisplay = null;

        if (index < this._childList.length) {
            result = this._childList[index];
        }

        return result;
    }

    public function addChildList(childList:Array<Dynamic>):Void {
        var i:Int = 0;
        var n:Int = childList.length;

        while (i < n) {
            if (Std.is(childList[i], PriDisplay)) this.addChild(childList[i]);
            i++;
        }
    }

    public function addChild(child:PriDisplay):Void {

        // remove o objeto de algum parent, caso ja tenha algum
        var parent:PriContainer = child.parent;

        if (parent != null) {
            parent.removeChild(child);
        }

        this._childList.push(child);
        this._jselement.appendChild(child.getJSElement());

        if (this.disabled) {
            child.getElement().attr("disabled", "disabled");
            child.getElement().find("*").attr("disabled", "disabled");
        } else {
            this.disabled = false;
        }

        if (child.hasApp()) {
            child.dispatchEvent(new PriEvent(PriEvent.ADDED_TO_APP, true));
        }

        child.dispatchEvent(new PriEvent(PriEvent.ADDED, true));
    }

    public function removeChild(child:PriDisplay):Void {
        // verifica se a view é filha deste container
        if (this == child.parent) {

            // verifica se a view ja esta no app
            var viewHasAppBefore:Bool = child.hasApp();

            this._childList.remove(child);
            this._jselement.removeChild(child.getJSElement());
            //child.getElement().remove();

            if (viewHasAppBefore) {
                child.dispatchEvent(new PriEvent(PriEvent.REMOVED_FROM_APP, true));
            }

            child.dispatchEvent(new PriEvent(PriEvent.REMOVED, true));
        }
    }

    override public function kill():Void {
        var i:Int;
        var n:Int;

        var childListCopy:Array<PriDisplay> = this._childList.copy();

        i = 0;
        n = childListCopy.length;

        while (i < n) {
            childListCopy[i].kill();
            i++;
        }

        childListCopy = null;

        this._childList = [];

        super.kill();
    }

    public function getContentBox():PriGeomBox {
        var result:PriGeomBox = new PriGeomBox();

        var i:Int = 0;
        var n:Int = this.numChildren;

        while (i < n) {

            result.x = Math.min(result.x, this.getChild(i).x);
            result.y = Math.min(result.y, this.getChild(i).y);

            result.width = Math.max(result.width, this.getChild(i).maxX);
            result.height = Math.max(result.height, this.getChild(i).maxY);

            i++;
        }

        return result;
    }

    @:noCompletion override private function set_width(value:Float):Float {
        var result:Float = super.set_width(value);

        this.updateBorderDisplay();

        return result;
    }

    @:noCompletion override private function set_height(value:Float):Float {
        var result:Float = super.set_height(value);

        this.updateBorderDisplay();

        return result;
    }
}
