package data;

class PrioriData {

    public static var TOKEN_NAME:String = "{project_name}";
    public static var TOKEN_LANG:String = "{lang}";
    public static var TOKEN_META:String = "{meta}";
    public static var TOKEN_LINK:String = "{link}";
    public static var TOKEN_PRIORI:String = "{priori}";




    public var file:String = "";

    public var name:String = "PRIORI";
    public var lang:String = "en";

    public var meta:Array<String> = [];
    public var link:Array<String> = [];

    public var dependencies:Array<String> = [];
    public var src:Array<String> = [];

    public var output:String = "build";
    public var template:String = "template";
    public var main:String = "Main";

    public function new() {

    }

    public function parse(json:Dynamic):Void {
        var i:Int = 0;
        var n:Int = 0;

        if (validateString(json.project_name)) this.name = json.project_name;
        if (validateString(json.lang)) this.lang = json.lang;
        if (validateString(json.output)) this.output = json.output;
        if (validateString(json.template)) this.template = json.template;
        if (validateString(json.main)) this.main = json.main;

        this.meta = this.meta.concat(this.parseStringArray(json.meta));
        this.link = this.link.concat(this.parseStringArray(json.link));
        this.dependencies = this.dependencies.concat(this.parseStringArray(json.dependencies));
        this.src = this.src.concat(this.parseStringArray(json.src));
    }

    private function validateString(value:Dynamic):Bool {
        if (value != null && Std.is(value, String)) return true;
        return false;
    }

    private function parseStringArray(data:Dynamic):Array<String> {
        if (data != null && Std.is(data, Array)) {

            var i:Int = 0;
            var n:Int = data.length;
            var result:Array<String> = [];

            while (i < n) {
                if (validateString(data[i])) {
                    result.push(data[i]);
                }

                i++;
            }

            return result;
        } else if (validateString(data)) {
            return [data];
        }

        return [];
    }
}
