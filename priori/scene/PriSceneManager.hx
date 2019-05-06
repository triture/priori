package priori.scene;

import priori.types.PriRoutePathType;
import priori.scene.route.RouteManager;
import priori.scene.view.PriPreloaderViewDefault;
import priori.scene.view.PriPreloaderView;
import priori.scene.view.PriSceneView;
import priori.view.container.PriContainer;
import priori.event.PriEvent;
import priori.assets.AssetManager;
import priori.assets.AssetManagerEvent;
import priori.app.PriApp;

class PriSceneManager {

    private static var _singleton:PriSceneManager;

    public static function use():PriSceneManager {
        if (_singleton == null) _singleton = new PriSceneManager();
        return _singleton;
    }

    private var currentScene:PriSceneView;
    private var sceneHistory:Array<{scene:Class<PriSceneView>, args:Array<Dynamic>}>;
    private var isPreloading:Bool;

    @:isVar public var holder(get, set):PriContainer;
    @:isVar public var container(get, null):PriContainer;

    private var router:RouteManager;
    private var historyIndexPosition:Int;

    private function new() {

        this.holder = PriApp.g();

        PriApp.g().addEventListener(PriEvent.RESIZE, this.onAppResize);

        this.isPreloading = false;
        this.sceneHistory = [];

        this.container = new PriContainer();
        this.container.clipping = true;

        this.router = new RouteManager();
    }

    public function clearHistoryAndNavigate(path:String):Void {
        try {
            js.Browser.window.history.go(js.Browser.window.history.length * -1);
            this.replaceAndNavigate(path);
        } catch (e:Dynamic) {}
    }

    public function hasScope(scope:String) return this.router.hasScope(scope);
    public function addScope(scope:String):Void this.router.addScope(scope);
    public function removeScope(scope:String):Void this.router.removeScope(scope);

    private function get_router():RouteManager return this.router;
    private function get_container():PriContainer return this.container;
    private function get_holder():PriContainer return this.holder;

    private function set_holder(value:PriContainer):PriContainer {
        if (value != null && value != this.holder) {
            if (this.holder != null) this.holder.removeEventListener(PriEvent.RESIZE, this.onAppResize);
            value.addEventListener(PriEvent.RESIZE, this.onAppResize);
            this.holder = value;
        }
        return value;
    }

    public function historyBack():Void {
        try {
            js.Browser.window.history.back();
        } catch(e:Dynamic) {}
    }
    public function hitoryForward():Void {
        try {
            js.Browser.window.history.forward();
        } catch(e:Dynamic) {}
    }

    public function addRoute(path:PriRoutePathType, scene:Class<PriSceneView>, ?scope:String):Void this.router.addRoute(path, scene, scope);
    public function navigateToCurrent():Void this.router.navigateToCurrent();
    public function reload():Void this.navigateToCurrent();

    public function preload(?preloadScene:Class<PriPreloaderView>, ?onError:Void->Void, ?onComplete:Void->Void):Void {
        if (preloadScene == null) preloadScene = PriPreloaderViewDefault;

        AssetManager.g().addEventListener(AssetManagerEvent.ASSET_COMPLETE, function(e:AssetManagerEvent):Void {
            this.isPreloading = false;

            AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_COMPLETE);
            AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_ERROR);
            AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_PROGRESS);

            if (onComplete != null) onComplete();
        });

        AssetManager.g().addEventListener(AssetManagerEvent.ASSET_ERROR, function(e:AssetManagerEvent):Void {
            this.isPreloading = false;

            AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_COMPLETE);
            AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_ERROR);
            AssetManager.g().removeAllEventListenersFromType(AssetManagerEvent.ASSET_PROGRESS);

            if (onError != null) onError();
        });

        AssetManager.g().addEventListener(AssetManagerEvent.ASSET_PROGRESS, function(e:AssetManagerEvent):Void {
            cast(this.currentScene, PriPreloaderView).updateProgress(e.percentLoaded);
        });

        this.open(cast preloadScene, []);
        cast(this.currentScene, PriPreloaderView).updateProgress(0);

        this.isPreloading = true;

        AssetManager.g().load();
    }

    public function updatePath(path:String):Void {

        if (StringTools.startsWith(path,"/")) path = "#" + path;
        else path = "#/" + path;

        js.Browser.window.history.replaceState({}, "", path);

    }

    public function navigate(path:String):Void {
        if (StringTools.startsWith(path,"/")) path = "#" + path;
        else path = "#/" + path;

        if (js.Browser.location.hash == path) {
            this.navigateToCurrent();
        } else {
            js.Browser.location.hash = path;
        }
    }

    public function replaceAndNavigate(path:String):Void {
        this.updatePath(path);
        this.navigateToCurrent();
    }

    @:allow(priori.scene.route.RouteManager)
    private function changeScene(newScene:PriSceneView):Void {
        if (this.currentScene != null) {
            this.currentScene.removeFromParent();
            this.currentScene.kill();

            this.currentScene = null;
        }

        if (newScene != null) {

            this.currentScene = newScene;

            var w:Float = this.holder.width;
            var h:Float = this.holder.height;

            this.container.width = w;
            this.container.height = h;

            newScene.width = w;
            newScene.height = h;

            this.container.addChild(newScene);

            if (this.container.parent != this.holder) this.holder.addChild(this.container);

//            if (keepInHistory == true) {
//                this.sceneHistory.push({
//                    scene : scene,
//                    args : args
//                });
//            }
        }

        this.onAppResize(null);
    }

    private function open(scene:Class<PriSceneView>, ?args:Array<Dynamic> = null):Void {
        if (scene != null) {
            if (args == null) args = [];

            var newScene:PriSceneView = Type.createInstance(scene, args);

            this.changeScene(newScene);
        }
    }

    private function onAppResize(e:PriEvent):Void {
        var w:Float = this.holder.width;
        var h:Float = this.holder.height;

        this.container.width = w;
        this.container.height = h;

        if (this.currentScene != null) {
            this.currentScene.width = w;
            this.currentScene.height = h;

            this.currentScene.validate();
        }
    }
}
