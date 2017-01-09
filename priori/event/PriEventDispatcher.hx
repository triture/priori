package priori.event;


import priori.view.container.PriContainer;
import priori.view.PriDisplay;
import priori.event.PriEvent;

class PriEventDispatcher {

    private var ___ed_elist:Array<String> = [];
    private var ___ed_llist:Array<Dynamic> = [];

    private var _isKilled:Bool = false;

    public function new() {

    }

    public function hasEvent(event:String):Bool {
        if (this.___ed_elist.indexOf(event) > -1) return true;
        return false;
    }

    public function addEventListener(event:String, listener:Dynamic->Void):Void {
        this.___ed_elist.push(event);
        this.___ed_llist.push(listener);
    }

    public function removeEventListener(event:String, listener:Dynamic->Void):Void {

        var i:Int = 0;
        var n:Int = this.___ed_elist.length;

        while (i < n) {
            if (this.___ed_elist[i] == event && this.___ed_llist[i] == listener) {
                this.___ed_elist.splice(i, 1);
                this.___ed_llist.splice(i, 1);
                n--;
            }

            i++;
        }
    }

    public function removeAllEventListenersFromType(event:String):Void {
        var i:Int = 0;
        var n:Int = this.___ed_elist.length;

        while (i < n) {
            if (this.___ed_elist[i] == event) {
                this.___ed_elist.splice(i, 1);
                this.___ed_llist.splice(i, 1);
                n--;
            }

            i++;
        }
    }

    public function dispatchEvent(event:PriEvent):Void {
        if (this.isKilled()) return;

        // uma copia eh necessaria para evitar quebrar o loop
        // em situacoes que um evento é removido no momento do seu despacho

        var tempEvent:Array<String> = this.___ed_elist.copy();
        var tempListener:Array<Dynamic> = this.___ed_llist.copy();

        var clone:PriEvent = null;

        // define o primeiro objeto a disparar o evento
        if (event.currentTarget == null) event.currentTarget = this;


        for (i in 0 ... tempEvent.length) {
            if (tempEvent[i] == event.type) {

                clone = event.clone();

                event.target = this;

                tempListener[i](clone);

                if (clone.propagate) {
                    var c:PriEvent = clone.clone();
                    c.bubble = false;

                    this.propagateEvent(c);
                }

                if (clone.bubble) {
                    var c:PriEvent = clone.clone();
                    c.propagate = false;

                    this.bubbleEvent(c);
                }
            }
        }


        if (clone == null && event.propagate) {
            clone = event.clone();
            clone.bubble = false;

            this.propagateEvent(clone);

            clone = null;
        }

        if (clone == null && event.bubble) {
            clone = event.clone();
            clone.propagate = false;

            this.bubbleEvent(clone);

            clone = null;
        }

    }

    private function bubbleEvent(event:PriEvent):Void {
        if (!this.isKilled() && Std.is(this, PriDisplay)) {
            var display:PriDisplay = cast this;
            if (display.parent != null) display.parent.dispatchEvent(event);
        }
    }

    private function propagateEvent(event:PriEvent):Void {
        if (!this.isKilled() && Std.is(this, PriContainer)) {

            var container:PriContainer = cast this;
            var childList:Array<PriDisplay> = container._childList.copy();
            for (i in 0 ... childList.length) childList[i].dispatchEvent(event);

        }
    }

    public function isKilled():Bool {
        return _isKilled;
    }

    public function kill():Void {
        this.___ed_elist = [];
        this.___ed_llist = [];

        this._isKilled = true;
    }

}