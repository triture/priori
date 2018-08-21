package priori.types;


abstract PriRoutePathType(String) to String {

    inline function new(value:String) {
        this = validateRoute(value);
    }

    public function getSignature():String {
        var signature:String = "";

        var routes:Array<String> = this.split("/");

        for (route in routes) {

            signature += "/";

            if (StringTools.startsWith(route, "?")) signature += "?" + route.split(":")[1];
            else signature += StringTools.trim(route);

        }

        return signature.substr(1);
    }

    public function match(path:String):Bool {
        path = StringTools.trim(path);

        while (path.length > 0 && StringTools.startsWith(path, "/")) path = path.substr(1);
        while (path.length > 0 && StringTools.endsWith(path, "/")) path = path.substr(0, path.length - 1);

        return matchValidation(this, path);
    }

    public function extractData(path:String):Dynamic {

        path = StringTools.trim(path);

        while (path.length > 0 && StringTools.startsWith(path, "/")) path = path.substr(1);
        while (path.length > 0 && StringTools.endsWith(path, "/")) path = path.substr(0, path.length - 1);

        var routes:Array<String> = this.split("/");
        var paths:Array<String> = path.split("/");

        if (routes.length != paths.length) return null;

        var data:Dynamic = {};

        for (i in 0 ... routes.length) {

            var route:String = routes[i];
            var value:String = paths[i];

            if (StringTools.startsWith(route, "?")) {

                var keyName:String = route.split("?")[1].split(":")[0];
                var keyType:String = route.split("?")[1].split(":")[1];

                if (keyType == "Number") Reflect.setField(data, keyName, Std.parseFloat(value));
                else if (keyType == "String") Reflect.setField(data, keyName, value);
            }
        }

        return data;
    }

    private function matchValidation(route:String, path:String):Bool {
        var routes:Array<String> = route.split("/");
        var paths:Array<String> = path.split("/");

        if (routes.length == paths.length) {

            var routePiece:String = routes.shift();
            var pathPiece:String = paths.shift();

            if (StringTools.startsWith(routePiece, "?")) {

                var type:String = routePiece.split("?")[1].split(":")[1];

                if (type == "Number") {
                    var valueRaw:String = pathPiece;
                    var valueNumber:Float = Std.parseFloat(valueRaw);

                    if (Math.isNaN(valueNumber)) return false;
                    else if (
                        (StringTools.lpad(Std.string(valueNumber), "0", pathPiece.length) == pathPiece) ||
                        ("-" + StringTools.lpad(Std.string(valueNumber * -1), "0", pathPiece.length - 1) == pathPiece)
                    ) {

                        if (routes.length == 0 && paths.length == 0) return true;
                        else return matchValidation(routes.join("/"), paths.join("/"));

                    } else return false;

                } else if (type == "String") {

                    if (routes.length == 0 && paths.length == 0) return true;
                    else return matchValidation(routes.join("/"), paths.join("/"));

                } else return false;

            } else {
                if (routePiece == pathPiece) {

                    if (routes.length == 0 && paths.length == 0) return true;
                    else return matchValidation(routes.join("/"), paths.join("/"));

                } else return false;
            }
        } else {
            return false;
        }
    }

    @:from static public function fromString(value:String):PriRoutePathType {
        return new PriRoutePathType(value);
    }

    static private function validateRoute(value:String):String {

        value = StringTools.trim(value);

        while (value.length > 0 && StringTools.startsWith(value, "/")) value = value.substr(1);
        while (value.length > 0 && StringTools.endsWith(value, "/")) value = value.substr(0, value.length - 1);

        if (value.length == 0) throw "Invalid route: Empty path";

        var routes:Array<String> = value.split("/");

        var routeFinal:String = "";

        for (route in routes) {

            route = StringTools.trim(route);

            if (route.length == 0) throw "Route in path cannot be empty";
            else if (StringTools.startsWith(route, "?")) {
                var parts:Array<String> = StringTools.trim(route).split(":");

                if (parts.length != 2) throw '"${route}" is an invalid rout variable: use ?var_name:var_type';
                if (parts[1] != "Number" && parts[1] != "String") throw '${parts[1]} is an invalid variable type: must be Number or String';
                else {
                    route = StringTools.trim(parts[0]) + ":" + StringTools.trim(parts[1]);
                }
            }

            routeFinal += "/" + route;
        }

        return routeFinal.substr(1);
    }

}
