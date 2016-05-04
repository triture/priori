package priori.event;


import priori.view.container.PriContainer;
import priori.view.PriDisplay;
import priori.event.PriEvent;

class PriEventDispatcher {

    private var _eventList:Array<{eventType:String, eventListener:PriEvent->Void}> = [];
    private var _eventTypeList:Array<String> = [];
    private var _isKilled:Bool = false;

    public function new() {

    }

    public function hasEvent(event:String):Bool {
        var result:Bool = false;

        if (this._eventTypeList.indexOf(event) > -1) {
            result = true;
        }

        return result;
    }

    public function addEventListener(event:String, listener:Dynamic->Void):Void {
        this._eventList.push({
            eventType : event,
            eventListener : listener
        });

        if (this._eventTypeList.indexOf(event) == -1) {
            this._eventTypeList.push(event);
        }
    }

    public function removeEventListener(event:String, listener:Dynamic->Void):Void {
        var i:Int = 0;
        var n:Int = this._eventList.length;

        var itensToRemove:Array<Dynamic> = [];
        var alreadyHasSameEvent:Bool = false;

        while (i < n) {
            if (this._eventList[i].eventType == event && this._eventList[i].eventListener == listener) {
                itensToRemove.push(this._eventList[i]);
            } else if(!alreadyHasSameEvent) {
                if (this._eventList[i].eventType == event) {
                    alreadyHasSameEvent = true;
                }
            }

            i++;
        }

        i = 0;
        n = itensToRemove.length;

        while (i < n) {
            this._eventList.remove(itensToRemove[i]);
            i++;
        }

        if (!alreadyHasSameEvent) {
            this._eventTypeList.remove(event);
        }
    }

    public function removeAllEventListenersFromType(event:String):Void {
        var i:Int = 0;
        var n:Int = this._eventList.length;

        var itensToRemove:Array<Dynamic> = [];

        while (i < n) {
            if (this._eventList[i].eventType == event) {
                itensToRemove.push(this._eventList[i]);
            }

            i++;
        }

        i = 0;
        n = itensToRemove.length;

        while (i < n) {
            this._eventList.remove(itensToRemove[i]);
            i++;
        }

        this._eventTypeList.remove(event);
    }

    public function dispatchEvent(event:PriEvent):Void {
        if (this.isKilled()) return;

        // uma copia eh necessaria para evitar quebrar o loop
        // em situacoes que um evento é removido no momento do seu despacho
        var temporaryEventList:Array<Dynamic> = _eventList.copy();

        var i:Int = 0;
        var n:Int = temporaryEventList.length;

        var clone:PriEvent = null;

        // define o primeiro objeto a disparar o evento
        if (event.currentTarget == null) event.currentTarget = this;

        while (i < n) {
            if (temporaryEventList[i].eventType == event.type) {
                clone = event.clone();

                event.target = this;

                temporaryEventList[i].eventListener(clone);

                if (clone.propagate) {
                    var cloneForPropagate:PriEvent = clone.clone();
                    cloneForPropagate.bubble = false;

                    this.propagateEvent(cloneForPropagate);
                }

                if (clone.bubble) {
                    var cloneForBubble:PriEvent = clone.clone();
                    cloneForBubble.propagate = false;

                    this.bubbleEvent(cloneForBubble);
                }
            }

            i++;
        }


        if (clone == null) {
            clone = event.clone();
            clone.bubble = false;

            if (clone.propagate) {
                this.propagateEvent(clone);
            }

            clone = null;
        }

        if (clone == null) {
            clone = event.clone();
            clone.propagate = false;

            if (clone.bubble) {
                this.bubbleEvent(clone);
            }

            clone = null;
        }

    }

    private function bubbleEvent(event:PriEvent):Void {
        if (!this.isKilled() && Std.is(this, PriDisplay)) {
            var display:PriDisplay = cast(this, PriDisplay);
            var itemParent:PriDisplay = display.parent;

            if (itemParent != null) {
                itemParent.dispatchEvent(event);
            }
        }
    }

    private function propagateEvent(event:PriEvent):Void {
        if (!this.isKilled() && Std.is(this, PriContainer)) {
            var container:PriContainer = cast(this, PriContainer);
            var item:PriDisplay;

            var i:Int = 0;
            var n:Int = container.numChildren;

            while (i < n) {
                item = container.getChild(i);

                if (item != null) {
                    item.dispatchEvent(event);
                }

                i++;
            }
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
