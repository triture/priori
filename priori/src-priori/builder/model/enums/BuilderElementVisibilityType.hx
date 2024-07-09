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
    #if macro
    @:to
    public function toMacroAccess():haxe.macro.Expr.Access {
        return switch (fromString(this)) {
            case PRIVATE : haxe.macro.Expr.Access.APrivate;
            case PUBLIC : haxe.macro.Expr.Access.APublic;
        }
    }
    #end
    
}