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

        var content = Context.getLocalClass();
        var meta = content.get().meta;
        var val:String = null;

        if (meta.has("priori")) {
            var ext = meta.extract("priori");
            if (ext.length > 0 && ext[0].params.length > 0) {
                val = ExprTools.getValue(ext[0].params[0]);                
            }
        }

        var fields = Context.getBuildFields();
        
        if (val == null) return fields;

        try {
            var xml:Xml = Xml.parse(val);
            var access = new haxe.xml.Access(xml.firstElement());

            if (access.hasNode.view) {
                for (item in access.node.view.elements) {
                    var className:String = item.name;
                    var fieldName:String = '____' + Math.floor(10000000 * Math.random());
                    var isPublic:Bool = false;

                    if (item.has.id) {
                        isPublic = true;
                        fieldName = item.att.id;
                    }

                    var type = Context.getType(className);
                    var complexType = haxe.macro.TypeTools.toComplexType(type);
                    //var typeClass = haxe.macro.TypeTools.getClass(type);
                    
                    fields.push(
                        {
                            name : fieldName,
                            doc : '',
                            access: [isPublic ? Access.APublic : Access.APrivate],
                            // kind: FieldType.FVar(macro:String, macro $v{''}),
                            kind: FieldType.FVar(complexType, Context.parse('new ${className}()', Context.currentPos())),
                            pos: Context.currentPos()
                        }
                    );
                }
            }
        } catch(e:Dynamic) {
            throw "Invalid priori XML";
        }

		var clsType = Context.getLocalClass().get();
        
        // fields.push({
        //     name: 'fieldname',
        //     doc: 'meu a',
        //     access: [Access.APublic],
        //     kind: FieldType.FVar(macro:String, macro $v{"aqui"}),
        //     pos: Context.currentPos()
        // });

        // for (ii in fields) {
        //     if (ii.name == 'aqui') {
        //         trace(ii.kind);
        //     }
        // }

        return fields;
    }
    #end
}