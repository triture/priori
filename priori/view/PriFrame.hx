package priori.view;

import js.html.HTMLDocument;
import js.html.IFrameElement;
import priori.view.PriDisplay;
import priori.event.PriEvent;

class PriFrame extends PriDisplay {

    private var _iframe:IFrameElement;

    public var url(get, set):String;

    public function new() {
        super();

        this.bgColor = 0xFFFFFF;

        this._iframe = js.Browser.document.createIFrameElement();
        this._iframe.onload = this.__onFrameLoad;
        this._iframe.onerror = this.__onError;
        this._iframe.style.width = "100%";
        this._iframe.style.height = "100%";
        this._iframe.style.border = "0px";

        this.dh.jselement.appendChild(this._iframe);
    }

    public function setHtml(value:String):Void {
        this._iframe.srcdoc = value;
    }

    public function frameDoc():HTMLDocument {
        return this._iframe.contentDocument;
    }

    private function get_url():String {
        return this._iframe.src;
    }

    private function set_url(value:String):String {
        this._iframe.src = value;
        return value;
    }

    private function __onFrameLoad():Void {
        this.dispatchEvent(new PriEvent(PriEvent.COMPLETE));
    }

    private function __onError():Void {
        this.dispatchEvent(new PriEvent(PriEvent.ERROR));
    }

    override public function kill():Void {

        this._iframe.onload = null;
        this._iframe.onerror = null;

        super.kill();
    }
}
