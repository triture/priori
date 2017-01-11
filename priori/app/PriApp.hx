package priori.app;

import priori.event.PriTapEvent;
import priori.geom.PriGeomPoint;
import priori.system.PriDevice;
import js.Browser;
import priori.assets.AssetManagerEvent;
import priori.view.container.PriGroup;
import priori.assets.AssetManager;
import jQuery.Event;
import priori.event.PriEvent;
import haxe.Timer;
import priori.geom.PriGeomBox;
import jQuery.JQuery;
import priori.app.PriApp;
import priori.view.PriDisplay;

class PriApp extends PriGroup {

    private static var _g:PriApp;

    private var ___xmouse:Float = 0;
    private var ___ymouse:Float = 0;

    private var _body:JQuery;
    private var _window:JQuery;
    private var _document:JQuery;

    private var _fps:Int;
    private var _delta:Float;
    private var _timer:Timer;

    private var _fullSetupCalled:Bool;

    public function new() {

        if (_g != null) throw "Do not create PriApp instance";
        else _g = this;

        this._fps = 60;

        super();

        #if debug
        trace("** PRIORI APP **");
        trace("Device : ", priori.system.PriDevice.deviceSystem());
        trace("Browser : ", priori.system.PriDevice.browser());
        #end


        this._jselement.style.width = "100%";
        this._jselement.style.height = "100%";
        this._jselement.style.position = "fixed";

        Browser.window.document.body.style.border = "0px";
        Browser.window.document.body.style.margin = "0px";
        Browser.window.document.onmousemove = this.___onMouseMove;

        Browser.window.onresize = this.___onWindowResize;
        Browser.window.onmouseup = this.___onWindowMouseUp;

        this.___applyPreventBackspace();

        Browser.window.document.body.appendChild(this._jselement);

        this.dispatchEvent(new PriEvent(PriEvent.ADDED_TO_APP, true));
        this.dispatchEvent(new PriEvent(PriEvent.RESIZE, false));

        this.invalidate();
        this.validate();
    }

    override private function get_mousePoint():PriGeomPoint return new PriGeomPoint(this.___xmouse, this.___ymouse);

    private function ___onMouseMove(e):Void {
        this.___xmouse = e.pageX;
        this.___ymouse = e.pageY;
    }



    private function ___onWindowResize():Void this.dispatchEvent(new PriEvent(PriEvent.RESIZE, false));
    private function ___onWindowMouseUp():Void this.dispatchEvent(new PriTapEvent(PriTapEvent.TAP_UP, false));

    override private function set_width(value:Float) return value;
    override private function get_width():Float return this.getAppSize().width;

    override private function set_height(value:Float):Float return value;
    override private function get_height():Float return this.getAppSize().height;

    override private function set_x(value:Float) return 0;
    override private function get_x():Float return 0;

    override private function set_y(value:Float) return 0;
    override private function get_y():Float return 0;


    public function getMSUptate():Int return Std.int(1000 / this._fps);


    private function ___applyPreventBackspace():Void {
        if (!PriDevice.isMobileDevice()) {
            this.getDocument().keydown(function (e) {
                if (e.which == 8 && !(new JQuery(e.target).is("input:not([readonly]):not([type=radio]):not([type=checkbox]), textarea, [contentEditable], [contentEditable=true]"))) {
                    e.preventDefault();
                }
            });
        }
    }

    public function getAppSize():PriGeomBox {
        var b:PriGeomBox = new PriGeomBox();
        var e:JQuery = this.getWindow();

        b.width = e.width();
        b.height = e.height();
        b.x = 0;
        b.y = 0;

        return b;
    }

    private function getDocument():JQuery {
        if (_document == null) _document = new JQuery(js.Browser.document);
        return _document;
    }

    private function getWindow():JQuery {
        if (_window == null) _window = new JQuery(js.Browser.window);
        return _window;
    }

    public function getBody():JQuery {
        if (_body == null) _body = new JQuery("body");
        return _body;
    }

    public static function g():PriApp {
        if (_g == null) throw "Application not yet created";
        return _g;
    }

}
