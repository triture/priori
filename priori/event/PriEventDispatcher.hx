package priori.event;


import priori.view.container.PriContainer;
import priori.view.PriDisplay;
import priori.event.PriEvent;

class PriEventDispatcher {

    private var _eventList:Array<{type : String, listener : Dynamic->Void}> = [];
    private var _eventTypeList:Array<String> = [];
    private var _isKilled:Bool = false;

    public function new() {

    }

    public function hasEvent(event:String):Bool {
        if (this._eventTypeList.indexOf(event) > -1) return true;
        return false;
    }

    public function addEventListener(event:String, listener:Dynamic->Void):Void {
        this._eventList.push({type : event, listener : listener});
        if (this._eventTypeList.indexOf(event) == -1) this._eventTypeList.push(event);
    }

    public function removeEventListener(event:String, listener:Dynamic->Void):Void {

        var itensToRemove:Array<{type : String, listener : Dynamic->Void}> = [];
        var stillHasEvent:Bool = false;

        for (i in 0 ... this._eventList.length) {
            if (this._eventList[i].type == event && this._eventList[i].listener == listener) {

                itensToRemove.push(this._eventList[i]);

            } else if(!stillHasEvent) {

                if (this._eventList[i].type == event) stillHasEvent = true;

            }
        }

        for (i in 0 ... itensToRemove.length) this._eventList.remove(itensToRemove[i]);
        if (!stillHasEvent) this._eventTypeList.remove(event);

    }

    public function removeAllEventListenersFromType(event:String):Void {
        var itensToRemove:Array<{type : String, listener : Dynamic->Void}> = [];

        for (i in 0 ... this._eventList.length) {

            if (this._eventList[i].type == event) itensToRemove.push(this._eventList[i]);

        }

        for (i in 0 ... itensToRemove.length) this._eventList.remove(itensToRemove[i]);
        this._eventTypeList.remove(event);

    }

    public function dispatchEvent(event:PriEvent):Void {
        if (this.isKilled()) return;

        // uma copia eh necessaria para evitar quebrar o loop
        // em situacoes que um evento é removido no momento do seu despacho
        var temporaryEventList:Array<{type : String, listener : Dynamic->Void}> = this._eventList.copy();

        var clone:PriEvent = null;

        // define o primeiro objeto a disparar o evento
        if (event.currentTarget == null) event.currentTarget = this;


        for (i in 0 ... temporaryEventList.length) {
            if (temporaryEventList[i].type == event.type) {

                clone = event.clone();

                event.target = this;

                temporaryEventList[i].listener(clone);

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
            var itemParent:PriDisplay = display.parent;

            if (itemParent != null) itemParent.dispatchEvent(event);
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
        this._eventList = [];
        this._eventTypeList = [];

        this._isKilled = true;
    }

}