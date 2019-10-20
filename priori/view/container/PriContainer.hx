package priori.view.container;

import js.Browser;
import js.html.DocumentFragment;
import helper.browser.DomHelper;
import priori.geom.PriGeomBox;
import priori.event.PriEvent;

class PriContainer extends PriDisplay {

    @:noCompletion
    @:allow(priori.event.PriEventDispatcher)
    private var _childList:Array<PriDisplay> = [];
    
    @:noCompletion
    private var _migratingView:Bool = false;

    public var numChildren(get, null):Int;

    public function new() {
        super();
    }

    private function get_numChildren():Int return this._childList.length;

    public function getChild(index:Int):PriDisplay {
        var result:PriDisplay = null;

        if (index < this._childList.length) {
            result = this._childList[index];
        }

        return result;
    }

    /**
    * Adds all objects of the Array to this PriContainer instance.
    *
    * Itens that not inherit from PriDisplay class are ignored.
    **/
    public function addChildList(childList:Array<Dynamic>):Void {
        var realItens:Array<PriDisplay> = [];
        #if (haxe_ver >= 4.0)
        for (item in childList) if (Std.downcast(item, PriDisplay) != null) realItens.push(item);
        #else
        for (item in childList) if (Std.instance(item, PriDisplay) != null) realItens.push(item);
        #end

        var thisHasApp:Bool = this.hasApp();
        var thisDisabled:Bool = this.disabled;
        var thisHasDisabledParent:Bool = this.hasDisabledParent();

        var docFrag:DocumentFragment = Browser.document.createDocumentFragment();

        for (child in realItens) {
            child.removeFromParent();

            this._childList.push(child);
            child.dh.parent = this;


            if (thisHasApp) {
                if (thisDisabled) DomHelper.disableAll(child.getJSElement());
                else if (!thisHasDisabledParent) DomHelper.enableAllUpPrioriDisabled(child.getJSElement());
            }

            docFrag.appendChild(child.getJSElement());
        }

        this.dh.jselement.appendChild(docFrag);

        for (i in 0 ... realItens.length) {
            var child:PriDisplay = realItens[i];
            if (thisHasApp) child.dispatchEvent(new PriEvent(PriEvent.ADDED_TO_APP, true));
            child.dispatchEvent(new PriEvent(PriEvent.ADDED, true));
        }
    }

    /**
    * Removes all children PriDisplay instance from the child list of the PriContainer instance.
    *
    * Itens that not inherit from PriDisplay class are ignored.
    **/
    public function removeChildList(childList:Array<Dynamic>):Void {
        var realItens:Array<PriDisplay> = [];
        #if (haxe_ver >= 4.0)
        for (item in childList) if (Std.downcast(item, PriDisplay) != null) realItens.push(item);
        #else
        for (item in childList) if (Std.instance(item, PriDisplay) != null) realItens.push(item);
        #end

        var hasAppBefore:Bool = this.hasApp();

        for (child in realItens) {
            if (child.parent == this) {
                this._childList.remove(child);
                this.dh.jselement.removeChild(child.getJSElement());

                child.dh.parent = null;

                if (hasAppBefore) child.dispatchEvent(new PriEvent(PriEvent.REMOVED_FROM_APP, true));
                child.dispatchEvent(new PriEvent(PriEvent.REMOVED, true));
            }
        }
    }

    /**
    * Adds a child PriDisplay instance to this PriContainer instance.
    * The child is added to the front (top) of all other children in this PriContainer instance.
    *
    * If you add a child object that already has a different container as a parent, the object is removed
    * from the child list of the other display object container.
    *
    * If you add the child object to the same parent container, the object is removed and added
    * to the front of all other children.
    **/
    public function addChild(child:PriDisplay):Void this.addChildList([child]);

    /**
    * Removes the specified child PriDisplay instance from the child list of the PriContainer instance.
    *
    * The parent property of the removed child is set to null.
    *
    * The index positions of any display objects above the child in the PriDisplay are decreased by 1.
    **/
    public function removeChild(child:PriDisplay):Void this.removeChildList([child]);

    override public function kill():Void {

        for (i in 0 ... this._childList.length) {
            this._childList[i].kill();
        }

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

    override private function set_width(value:Float):Float {
        if (value != this.width) {
            super.set_width(value);
            this.dispatchEvent(new PriEvent(PriEvent.RESIZE, false));
        }

        return value;
    }

    override private function set_height(value:Float):Float {
        if (value != this.height) {
            super.set_height(value);
            this.dispatchEvent(new PriEvent(PriEvent.RESIZE, false));
        }

        return value;
    }
}
