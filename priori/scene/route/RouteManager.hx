package priori.scene.route;

import priori.app.PriApp;
import priori.scene.view.PriSceneView;
import haxe.ds.StringMap;
import priori.types.PriRoutePathType;

class RouteManager {

    private var routes:StringMap<RouteItem>;
    private var initialized:Bool = false;

    @:allow(priori.scene.PriSceneManager)
    private function new() {
        this.routes = new StringMap<RouteItem>();
    }

    public function addRoute(path:PriRoutePathType, scene:Class<PriSceneView>):Void {
        if (path == null) throw "Route values cannot be NULL";

        var signature:String = path.getSignature();

        if (this.routes.exists(signature)) throw 'Route Signature "${signature}" already exists';

        this.routes.set(
            signature,
            {
                signature : signature,
                path : path,
                scene : scene
            }
        );

        this.registerEvent();
    }

    private function registerEvent():Void {
        if (this.initialized) return;

        if (js.Browser.window.addEventListener != null) {
            js.Browser.window.addEventListener("hashchange", this.onHashChange);
        }

        this.initialized = true;
    }

    private function openScene(path:String):Void {
        var item:RouteItem = this.locatePath(path);

        if (item != null) {
            var data:Dynamic = item.path.extractData(path);

            var scene:PriSceneView = Type.createInstance(item.scene, [data]);

            PriSceneManager.use().changeScene(scene);
        } else if (this.routes.exists("**")) {
            js.Browser.location.hash = "#/";
        }

        return null;
    }

    private function locatePath(path:String):RouteItem {

        // clean hash
        if (StringTools.startsWith(path, "#")) path = path.substr(1);

        while (path.length > 0 && StringTools.startsWith(path, "/")) path = path.substr(1);
        while (path.length > 0 && StringTools.endsWith(path, "/")) path = path.substr(0, path.length - 1);

        if (path.length == 0) return this.routes.get("**");

        path = "/" + path;

        for (signature in this.routes.keys()) {

            var item:RouteItem = this.routes.get(signature);

            if (signature != "**" && item.path.match(path)) {
                return this.routes.get(signature);
                break;
            }
        }

        return null;
    }

    private function onHashChange():Void {
        var hash:String = js.Browser.location.hash;

        if (StringTools.startsWith(hash, "/#/")) hash = hash.substr(3);
        else if (StringTools.startsWith(hash, "#/")) hash = hash.substr(2);
        else if (StringTools.startsWith(hash, "#")) hash = hash.substr(1);

        this.openScene(hash);
    }

    public function navigateToCurrent():Void {
        this.onHashChange();
    }
}

private typedef RouteItem = {
    var signature:String;
    var path:PriRoutePathType;
    var scene:Class<PriSceneView>;
}