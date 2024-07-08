package builder.model.data;

import haxe.macro.Type;
import haxe.macro.Expr.ComplexType;

typedef BuilderMacroImportData = {
    var className:String;
    var type:Type;
    var complexType:ComplexType;
}