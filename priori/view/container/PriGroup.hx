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
        this.addEventListener(PriEvent.REMOVED_FROM_APP, this._onRemovedFromApp);

        if (this._setupCalled == false) {
            this._setupCalled = true;
            this.setup();
        }

        this.validate();
    }

    private function _onRemovedFromApp(e:PriEvent):Void {
        this.removeEventListener(PriEvent.REMOVED_FROM_APP, this._onRemovedFromApp);
        this.addEventListener(PriEvent.ADDED_TO_APP, this._onAddedToApp);
    }

    public function _updateScheduled():Void {
        if (this._invalid && !this._isKilled) {
            this.validate();
        }
    }

    private function setup():Void {

    }

    private function paint():Void {

    }

    public function isInvalid():Bool {
        return _invalid;
    }

    public function canPaint():Bool {
        return this._setupCalled;
    }

    public function validate():Void {

        if (this._invalidateTimer != null) {
            this._invalidateTimer.stop();
            this._invalidateTimer = null;
        }

        if (!this._isKilled && this._invalid && this.canPaint()) {

            var i:Int = 0;
            var n:Int = this.numChildren;
            var object:Dynamic;

            this.paint();

            i = 0;
            while (i < n) {
                if (Std.is(this.getChild(i), PriGroup)) {
                    object = this.getChild(i);
                    object.validate();
                }

                i++;
            }

            this._invalid = false;
        }
    }


    public function invalidate():Void {
        if (this._invalid == false) {
            this._invalid = true;

            if (this._invalidateTimer != null) {
                this._invalidateTimer.stop();
                this._invalidateTimer = null;
            }

//            var i:Int = 0;
//            var n:Int = this.numChildren;
//            var object:Dynamic;
//
//            i = 0;
//            while (i < n) {
//                if (Std.is(this.getChild(i), PriGroup)) {
//                    object = this.getChild(i);
//                    object.invalidate();
//                }
//
//                i++;
//            }

            this._invalidateTimer = Timer.delay(this._updateScheduled, PriApp.g().getMSUptate());
        }
    }

    override public function getContentBox():PriGeomBox {
        this.validate();
        return super.getContentBox();
    }


}
