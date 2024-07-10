package builder.model.data;

import haxe.ds.StringMap;
import builder.model.enums.BuilderKeyValueType;

abstract BuilderKeyValueData({key:String, value:String, typed:BuilderKeyValueType}) {
 
    public function new(key:String, value:String, ?typed:BuilderKeyValueType) {
        if (typed == null) typed = BuilderKeyValueType.DYNAMIC;

        this = {key: key, value: value, typed: typed};
    }

    inline public function getKey():String return this.key;
    inline public function getValue():String return this.value;
    inline public function getType():BuilderKeyValueType return this.typed;
    
    public function getMacroValue():String {
        if (this.typed == BuilderKeyValueType.STRING) return '"${this.value}"';
        else if (this.typed == BuilderKeyValueType.LITERAL) return '${this.value}';
        else if (this.typed == BuilderKeyValueType.PAINT) return '${this.value}';
        else if (this.value == ':true') return 'true';
        else if (this.value == ':false') return 'false';
        else if (isNumeric() || isNumericFloat()) return this.value;
        else if (isNumericHashtagHex()) return this.value.split('#').join('0x');
        else return '"${this.value}"';
    }

    private function isNumericHashtagHex():Bool {
        var r = new EReg("^#[0-9a-fA-F]+$", "");
        return r.match(StringTools.trim(this.value));
    }

    private function isNumeric():Bool {
        // ^0x[0-9a-fA-F]+$ : match hexadecimal numbers 
        // | or
        // ^-?[0-9]*.?[0-9]+$ hexa, negatives, positives, floats or integers
        var r = new EReg("^0x[0-9a-fA-F]+$|^-?[0-9]*\\.?[0-9]+$", "");
        return r.match(StringTools.trim(this.value));
    }

    private function isNumericFloat():Bool {
        // ^-?[0-9]*[.][0-9]+$ negatives, positives, floats (must be a point somewhere)
        var r = new EReg("^-?[0-9]*[\\.][0-9]+$", "");
        return r.match(StringTools.trim(this.value));
    }

    public function getClassValue(imports:StringMap<BuilderImportData>):String {
        var toMatch:String = this.value;
        var result:String = "";
        
        var reg = new EReg("[\\w\"]+ *:|[\\w.]+", "");
        
        while (reg.match(toMatch)) { 
            result += reg.matchedLeft();

            var match:String = reg.matched(0);

            if (match.indexOf('.') > -1) result += match;
            else if (match.charAt(match.length-1) == ':') result += match;
            else if (imports.exists(match)) result += imports.get(match).name;
            else result += match;

            toMatch = reg.matchedRight();
        }

        result += toMatch;

        return result;
    }

}