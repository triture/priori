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

            var funbody = macro {
                super.__priBuilderSetup();
                $b{generateInitializations(builderFields)}
                $b{generateAddChilds(builderFields)}
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

    private static function createElement(node:haxe.xml.Access, parent:PriBuilderField, fields:Array<Field>, builderFields:Array<PriBuilderField>) {
        
        var result:PriBuilderField = {
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

        for (key in parentingMap.keys()) {
            var itemList:Array<PriBuilderField> = parentingMap.get(key);
            
            for (item in itemList) {
                var itemId = item.name;
                var parentId = key;

                if (parentId == "this") {
                    result.push(
                        macro this.addChild(this.$itemId)
                    );
                } else {
                    result.push(
                        macro this.$parentId.addChild(this.$itemId)
                    );
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
    var name:String;
    var type:String;
    var isPublic:Bool;
    var macroType:haxe.macro.Type;
    var macroComplexType:haxe.macro.ComplexType;

    @:optional var parent:PriBuilderField;
}