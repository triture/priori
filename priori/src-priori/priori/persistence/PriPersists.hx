package priori.persistence;

import js.Browser;
import haxe.Unserializer;
import haxe.Serializer;
import js.html.Storage;

class PriPersists {

    static public function save(key:String, data:Dynamic):Bool {
        try {
            var serial:Serializer = new Serializer();
            serial.useCache = true;
            serial.useEnumIndex = false;
            serial.serialize(data);

            var dataString:String = serial.toString();

            var s:Storage = Browser.getLocalStorage();

            if (s != null) {
                s.setItem(key, dataString);
            } else {
                return false;
            }

        } catch (e:Dynamic) {
            return false;
        }

        return true;
    }

    static public function load(key:String):Dynamic {
        try {
            var s:Storage = Browser.getLocalStorage();

            if (s != null) {
                var dataString:String = s.getItem(key);

                if (dataString != null && dataString != "") {
                    var unserial:Unserializer = new Unserializer(dataString);
                    var data = unserial.unserialize();

                    return data;
                }
            } else {
                return null;
            }

        } catch (e:Dynamic) {
            return null;
        }

        return null;
    }

    static public function delete(key:String):Bool {
        try {

            var s:Storage = Browser.getLocalStorage();
            if (s != null) {
                s.removeItem(key);
            } else {
                return false;
            }

        } catch (e:Dynamic) {
            return false;
        }

        return true;
    }
}
