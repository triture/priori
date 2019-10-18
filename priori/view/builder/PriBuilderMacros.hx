package priori.view.builder;

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
        
        var fields = Context.getBuildFields();
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

                    var builderField:PriBuilderField = {
                        name : '____' + Math.floor(10000000 * Math.random()),
                        type : item.name,
                        isPublic : false,
                        macroType : Context.getType(item.name),
                        macroComplexType : haxe.macro.TypeTools.toComplexType(Context.getType(item.name))
                    }

                    builderFields.push(builderField);

                    if (item.has.id) {
                        builderField.isPublic = true;
                        builderField.name = item.att.id;
                    }
                    
                    fields.push(
                        {
                            name : builderField.name,
                            doc : '',
                            access: [builderField.isPublic ? Access.APublic : Access.APrivate],
                            // kind: FieldType.FVar(macro:String, macro $v{''}),
                            // kind: FieldType.FVar(complexType, Context.parse('new ${builderField.type}()', Context.currentPos())),
                            kind: FieldType.FVar(builderField.macroComplexType),
                            pos: Context.currentPos()
                        }
                    );
                }
            }

            var funbody = macro {
                super.__priBuilderSetup();
                $b{generateInitializations(builderFields)}
                trace(1);
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
                            expr: funbody
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
    var name:String;
    var type:String;
    var isPublic:Bool;
    var macroType:haxe.macro.Type;
    var macroComplexType:haxe.macro.ComplexType;
}