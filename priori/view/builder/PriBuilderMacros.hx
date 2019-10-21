package priori.view.builder;

import haxe.ds.StringMap;
import haxe.macro.ExprTools;
import haxe.macro.Expr.Catch;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.macro.Expr;

@:noCompletion
class PriBuilderMacros {

    #if macro
    static public function build():Array<Field> {
        trace('PRI BUILDER');
        
        var fields:Array<Field> = Context.getBuildFields();
        var val:String = null;

        if (!hasMetaKey('priori')) return fields;
        else val = Std.string(getMetaValue('priori'));
        
        if (val == null) return fields;

        try {
            var xml:Xml = Xml.parse(val);
            var access = new haxe.xml.Access(xml.firstElement());
            var builderFields:Array<PriBuilderField> = [];

            if (access.hasNode.view) {
                for (item in access.node.view.elements) {
                    createElement(item, null, fields, builderFields);
                }
            }

            fields.push(
                {
                    name : '__priBuilderSetup',
                    pos: Context.currentPos(),
                    access: [Access.APrivate, Access.AOverride],
                    kind : FieldType.FFun(
                        {
                            args : [],
                            ret : null,
                            expr: macro {
                                super.__priBuilderSetup();
                                $b{generateInitializations(builderFields)}
                                $b{generateSetupProperties(builderFields)}
                                $b{generateAddChilds(builderFields)}
                            }
                        }
                    )
                }
            );


            fields.push(
                {
                    name : '__priBuilderPaint',
                    pos: Context.currentPos(),
                    access: [Access.APrivate, Access.AOverride],
                    kind : FieldType.FFun(
                        {
                            args : [],
                            ret : null,
                            expr: macro {
                                super.__priBuilderPaint();
                                $b{generatePaintProperties(builderFields)}
                            }
                        }
                    )
                }
            );

            


        } catch(e:Dynamic) {
            trace(e);
            throw "Invalid priori XML";
        }

        return fields;
    }

    private static function createElement(node:haxe.xml.Access, parent:PriBuilderField, fields:Array<Field>, builderFields:Array<PriBuilderField>) {
        
        var result:PriBuilderField = {
            node : node,
            name : '____' + Math.floor(10000000 * Math.random()),
            type : node.name,
            isPublic : false,
            macroType : Context.getType(node.name),
            macroComplexType : haxe.macro.TypeTools.toComplexType(Context.getType(node.name)),

            parent : parent
        }

        if (node.has.id) {
            result.isPublic = true;
            result.name = node.att.id;
        }

        fields.push(
            {
                name : result.name,
                doc : '',
                access: [result.isPublic ? Access.APublic : Access.APrivate],
                kind: FieldType.FVar(result.macroComplexType),
                pos: Context.currentPos()
            }
        );

        builderFields.push(result);

        for (subnode in node.elements) createElement(subnode, result, fields, builderFields);

    }

    private static function generateSetupProperties(fields:Array<PriBuilderField>):Array<Expr> {
        var result:Array<Expr> = [];

        for (field in fields) {
            
            for (att in field.node.x.attributes()) {
                if (att != "id") {

                    var value:Dynamic = field.node.att.resolve(att);
                    
                    if (!PriBuilderMacroHelper.checkIsExpression(value)) {
                        if (PriBuilderMacroHelper.checkIsNumeric(value)) {
                            if (PriBuilderMacroHelper.checkIsNumericFloat(value)) value = PriBuilderMacroHelper.getFloat(value);
                            else value = PriBuilderMacroHelper.getInt(value);
                        }

                        if (value != null) {
                            result.push(
                                macro $i{field.name}.$att = $v{value}
                            );
                        }
                    }
                }
            }
        }

        return result;
    }

    private static function generatePaintProperties(fields:Array<PriBuilderField>):Array<Expr> {
        var result:Array<Expr> = [];

        for (field in fields) {
            
            for (att in field.node.x.attributes()) {
                if (att != "id") {

                    var value:Dynamic = field.node.att.resolve(att);
                    
                    if (PriBuilderMacroHelper.checkIsExpression(value)) {
                        value = PriBuilderMacroHelper.getExpression(value);
                        
                        var macrExpr = Context.parse(value, Context.currentPos());

                        if (value != null) {
                            result.push(
                                macro $i{field.name}.$att = $e{macrExpr}
                            );
                        }
                    }
                }
            }
        }

        return result;
    }

    private static function generateAddChilds(fields:Array<PriBuilderField>):Array<Expr> {
        var result:Array<Expr> = [];

        var parentingMap:StringMap<Array<PriBuilderField>> = new StringMap<Array<PriBuilderField>>();
        
        for (field in fields) {
            
            var parentKey:String = field.parent == null
                ? "this"
                : field.parent.name
            ;

            var itemList:Array<PriBuilderField> = parentingMap.get(parentKey);

            if (itemList == null) {
                itemList = [];
                parentingMap.set(parentKey, itemList);
            }
            
            itemList.push(field);
        }

        // first we add non root objects
        for (rootKey in [0, 1]) {
            for (key in parentingMap.keys()) {
                if ((rootKey == 0 && key != 'this') || rootKey == 1 && key == 'this') {
                    var itemList:Array<PriBuilderField> = parentingMap.get(key);

                    result.push(macro var _ac = []);
                    for (item in itemList) result.push(macro _ac.push($i{item.name}));
                    result.push(macro $i{key}.addChildList(_ac));
                }
            }
        }

        return result;
    }

    private static function generateInitializations(fields:Array<PriBuilderField>):Array<Expr> {
        
        var result:Array<Expr> = [];

        for (item in fields) {
            
            result.push(
                Context.parse(
                    "this." + item.name + " = new " + item.type + "()",
                    Context.currentPos()
                )
            );
        }
        
        return result;
    }

    private static function hasMetaKey(metaKey:String):Bool {
        var localClass = Context.getLocalClass();
        var meta = localClass.get().meta;
        return meta.has(metaKey);
    }

    private static function getMetaValue(metaKey:String):Dynamic {
        var localClass = Context.getLocalClass();
        var meta = localClass.get().meta;
        
        if (meta.has(metaKey)) {
            var ext = meta.extract(metaKey);
            if (ext.length > 0 && ext[0].params.length > 0) {
                return ExprTools.getValue(ext[0].params[0]);                
            }
        }

        return null;
    }
    #end
}

private typedef PriBuilderField = {
    var node:haxe.xml.Access;
    var name:String;
    var type:String;
    var isPublic:Bool;
    var macroType:haxe.macro.Type;
    var macroComplexType:haxe.macro.ComplexType;

    @:optional var parent:PriBuilderField;
}

private class PriBuilderMacroHelper {
    
    public static function getFloat(value:Dynamic):Null<Float> {
        var f = Std.parseFloat(Std.string(value));
        return Math.isNaN(f) ? null : f;
    }

    public static function getInt(value:Dynamic):Null<Int> {
        return Std.parseInt(Std.string(value));
    }

    public static function getExpression(value:Dynamic):String {
        var result:String = StringTools.trim(Std.string(value));
        result = result.substr(2, -1);
        return result;
    }

    public static function checkIsExpression(value:Null<String>):Bool {
        if (value == null) return false;
        else {
            var r = new EReg("^\\${.+}$", "");
            return r.match(StringTools.trim(value));
        }
    }

    public static function checkIsNumeric(value:Null<String>):Bool {
        if (value == null) return false;
        else {

            // ^0x[0-9a-fA-F]+$ : match hexadecimal numbers 
            // | or
            // ^-?[0-9]*.?[0-9]+$ negatives, positives, floats or integers
            var r = new EReg("^0x[0-9a-fA-F]+$|^-?[0-9]*.?[0-9]+$", "");

            return r.match(StringTools.trim(value));
        }
    }

    public static function checkIsNumericFloat(value:Null<String>):Bool {
        if (value == null) return false;
        else {
            // ^-?[0-9]*[.][0-9]+$ negatives, positives, floats (must be a point somewhere)
            var r = new EReg("^-?[0-9]*[.][0-9]+$", "");
            return r.match(StringTools.trim(value));
        }
    }

}
