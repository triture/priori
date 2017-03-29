package priori.view.container;

import priori.app.PriApp;
import haxe.Timer;
import priori.geom.PriGeomBox;
import priori.event.PriEvent;

class PriGroup extends PriContainer {

    private var _setupCalled:Bool;
    private var _invalid:Bool;
    private var _invalidateTimer:Timer;

    public function new() {
        super();

        this._setupCalled = false;
        this._invalid = false;

        this.addEventListener(PriEvent.ADDED_TO_APP, this._onAddedToApp);
        this.addEventListener(PriEvent.RESIZE, this._onPriResizeGroup);

    }

    private function _onPriResizeGroup(e:PriEvent):Void {
        this.invalidate();
    }

    override public function kill():Void {
        if (this._invalidateTimer != null) {
            this._invalidateTimer.stop();
            this._invalidateTimer = null;
        }

        super.kill();
    }

    override public function addChildList(childList:Array<Dynamic>):Void {
        super.addChildList(childList);
//        for (i in 0 ... childList.length) if (Std.instance(childList[i], PriDisplay) != null) super.addChild(childList[i]);
        this.invalidate();
    }

    override public function removeChildList(childList:Array<Dynamic>):Void {
//        for (i in 0 ... childList.length) if (Std.instance(childList[i], PriDisplay) != null) super.removeChild(childList[i]);
        super.removeChildList(childList);
        this.invalidate();
    }

    override public function addChild(view:PriDisplay):Void {
        super.addChild(view);
        this.invalidate();
    }

    override public function removeChild(view:PriDisplay):Void {
        super.removeChild(view);
        this.invalidate();
    }

    private function _onAddedToApp(e:PriEvent):Void {
        this.removeEventListener(PriEvent.ADDED_TO_APP, this._onAddedToApp);

        if (this._setupCalled == false) {
            this._setupCalled = true;
            this.setup();
        }

        this.validate();
    }

    private function setup():Void {

    }

    private function paint():Void {

    }

    public function isInvalid():Bool return _invalid;
    public function canPaint():Bool return this._setupCalled;

    public function validate():Void {
        if (this._invalidateTimer != null) {
            this._invalidateTimer.stop();
            this._invalidateTimer = null;
        }

        if (!this._isKilled && this._invalid && this.canPaint()) {

            var child:PriGroup;

            this.paint();

            for (i in 0 ... this.numChildren) {
                child = cast this.getChild(i);
                if (child.validate != null) child.validate();
            }

            this._invalid = false;
        }
    }


    public function invalidate():Void {
        this._invalid = true;

        if (this._invalidateTimer != null) {
            this._invalidateTimer.stop();
            this._invalidateTimer = null;
        }

        this._invalidateTimer = Timer.delay(this.validate, 33);
    }

    public function invalidateChildren():Void {
        for (i in 0 ... this._childList.length) {
            if (Std.is(this._childList[i], PriGroup)) {
                cast(this._childList[i], PriGroup).invalidateChildren();
            }
        }

        this.invalidate();
    }

    override public function getContentBox():PriGeomBox {
        this.validate();
        return super.getContentBox();
    }


}
