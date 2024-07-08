package builder.model.enums;

enum abstract BuilderElementVisibilityType(String) {
    
    var PRIVATE;
    var PUBLIC;

    @:from 
    static public function fromString(value:String):BuilderElementVisibilityType {
        return switch (value.toLowerCase()) {
            case "private" : PRIVATE;
            case "public" : PUBLIC;
            default : PUBLIC;
        }
    }
}