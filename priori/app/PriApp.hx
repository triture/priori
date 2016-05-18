package priori.app;

import haxe.ds.StringMap;
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

    public static var PRIORI_MAP:StringMap<Dynamic> = new StringMap<Dynamic>();

    private static var _g:PriApp;

    private var _body:JQuery;
    private var _window:JQuery;
    private var _document:JQuery;

    private var _fps:Int;
    private var _delta:Float;
    private var _timer:Timer;

    private var _fullSetupCalled:Bool;

    public function new() {

        if (_g != null) {
            throw "Do not create PriApp instance";
        } else {
            _g = this;
        }


        this._fps = 60;

        super();

        #if debug
        trace("** PRIORI APP **");
        trace("Device : ", priori.system.PriDevice.g().deviceSystem());
        trace("Browser : ", priori.system.PriDevice.g().browser());
        #end

        this.setupApp();
    }

    @noCompletion override private function set_width(value:Float) {
        return value;
    }

    @noCompletion override private function get_width():Float {
        return this.getAppSize().width;
    }

    @noCompletion override private function set_height(value:Float):Float {
        return value;
    }

    @noCompletion override private function get_height():Float {
        return this.getAppSize().height;
    }

    @noCompletion override private function set_x(value:Float) {
        return 0;
    }

    @noCompletion override private function get_x():Float {
        return 0;
    }

    @noCompletion override private function set_y(value:Float) {
        return 0;
    }

    @noCompletion override private function get_y():Float {
        return 0;
    }

    public function getMSUptate():Int {
        return Std.int(1000 / this._fps);
    }

    private function setupApp():Void {

        var box:PriGeomBox = this.getAppSize();

        this.getElement().css("width", "100%");
        this.getElement().css("height", "100%");
        this.getElement().css("position", "fixed");

        this.getWindow().resize(
            function(e:Event):Void {
                this.dispatchEvent(new PriEvent(PriEvent.RESIZE, false));
            }
        );


        // prevent backspace
        this.getDocument().keydown(function (e) {
            if (e.which == 8 && !(new JQuery(e.target).is("input:not([readonly]):not([type=radio]):not([type=checkbox]), textarea, [contentEditable], [contentEditable=true]"))) {
                e.preventDefault();
            }
        });


        var body:JQuery = this.getBody();
        body.css("border", "0px");
        body.css("margin", "0px");

        body.append(this.getElement());

        this.dispatchEvent(new PriEvent(PriEvent.ADDED_TO_APP, true));
        this.dispatchEvent(new PriEvent(PriEvent.RESIZE, false));


        this.invalidate();
        this.validate();
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
        return new JQuery(js.Browser.document);
    }

    private function getWindow():JQuery {
        if (_window == null) {
            _window = new JQuery(js.Browser.window);
        }

        return _window;
    }

    public function getBody():JQuery {
        if (_body == null) {
            _body = new JQuery("body");
        }

        return _body;
    }

    public static function g():PriApp {
        if (_g == null) {
            throw "Application not yet created";
        }

        return _g;
    }

}
