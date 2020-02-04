package priori.view.builder;

#if macro
import haxe.macro.PositionTools;
import haxe.xml.Parser.XmlParserException;
import haxe.macro.TypeTools;
import haxe.macro.ComplexTypeTools;
import haxe.macro.Type;
import haxe.ds.StringMap;
import haxe.macro.ExprTools;
import haxe.macro.Expr.Catch;
import haxe.macro.Expr.FieldType;
import haxe.macro.Expr.Access;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.macro.Expr;
#end

@:noCompletion
class PriBuilderMacros {

    #if macro

    static public function loadPrioriXML():Xml {
        var val:String = null;
        var xml:Xml = null;

        if (!hasMetaKey('priori')) return null;
        else val = Std.string(getMetaValue('priori'));

        // try to load xml data from file
        var fileName:String = StringTools.trim(val.substr(0, 1024)).split('\n').join('');
        
        if (sys.FileSystem.exists(fileName) && !sys.FileSystem.isDirectory(fileName)) {

            var data:String = sys.io.File.getContent(StringTools.trim(val));

            try {
                xml = Xml.parse(data);
            } catch(e:XmlParserException) {

                var errorPos = Context.makePosition(
                    {
                        file : fileName,
                        min : e.position,
                        max : data.length
                    }
                );
                
                Context.warning(
                    e.message,
                    errorPos
                );

                var metaPos = getMetaPosition('priori');
                errorPos = Context.makePosition(metaPos);

                Context.fatalError(
                    'Error on $fileName: ${e.message}',
                    errorPos
                );

            }

        } else {
            // try to parse xml data from metatag
            try {
                xml = Xml.parse(val);
            } catch(e:XmlParserException) {
                
                var metaPos = getMetaPosition('priori');
                var errorPos = Context.makePosition(
                    {
                        file : metaPos.file,
                        min : metaPos.min + e.position,
                        max : metaPos.min + val.length
                    }
                );
                
                Context.fatalError(
                    e.message,
                    errorPos
                );
            }
        }

        return xml;
    }

    static public function build():Array<Field> {

        Sys.println("   PriBuilder : Building " + Context.getLocalClass().toString());
        
        var fields:Array<Field> = Context.getBuildFields();
        var propertiesElementsForSetup:Array<Expr> = [];
        var propertiesElementsForPaint:Array<Expr> = [];
        var imports:Array<Type> = [];
        var importAlias:StringMap<String> = new StringMap<String>();
        
        var xml:Xml = loadPrioriXML();
        
        if (xml != null) {
            try {
                
                var xmlBase:Xml = xml.firstElement();
                var access = new XmlAccessHelper(xmlBase);
                var builderFields:Array<PriBuilderField> = [];
                
                for (item in Context.getLocalImports()) {
                    if (item.mode == ImportMode.INormal) {
                        var impList:Array<String> = [];
                        for (item_ in item.path) impList.push(item_.name);

                        for (item_ in Context.getModule(impList.join('.'))) imports.push(item_);
                    }
                }

                if (access.hasNode("imports")) {
                    for (item in access.getElementsFromNode("imports")) {
                        createImport(item, imports, importAlias);
                    }
                }
                
                if (access.hasNode("view")) {
                    
                    for (el in xmlBase.elementsNamed("view")) {
                        for (att in el.attributes()) {
                            var propertie:String = att;
                            var value:String = el.get(att);

                            if (PriBuilderMacroHelper.checkIsExpression(value)) {
                                propertiesElementsForPaint.push(generatePropertieExpression('this', propertie, value));
                            } else {
                                propertiesElementsForSetup.push(generatePropertieExpression('this', propertie, value));
                            }
                        }
                    }

                    for (item in access.getElementsFromNode("view")) {
                        createElement(item, null, fields, builderFields, imports, importAlias, propertiesElementsForSetup, propertiesElementsForPaint);
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
                                    $b{propertiesElementsForSetup}
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
                                    $b{propertiesElementsForPaint}
                                }
                            }
                        )
                    }
                );

            } catch(e:Dynamic) {
                Sys.println("       ERROR - " + e);
                Context.fatalError(Std.string(e), Context.currentPos());
            }
        }

        return fields;
    }

    private static function getTypeFromClassName(typeName:String, imports:Array<Type>, importAlias:StringMap<String>):Type {
        if (importAlias.exists(typeName)) typeName = importAlias.get(typeName);
        
        for (item in imports) {
            
            var typeString:String = TypeTools.toString(item);
            
            if (typeName == typeString) return item;
            else if (StringTools.endsWith(typeString, '.' + typeName)) return item;

        }

        return null;
    }

    private static function createImport(node:Xml, imports:Array<Type>, importAlias:StringMap<String>):Void {
        var module:String = node.nodeName;
        var types = Context.getModule(module);
        
        if (node.exists('alias') && StringTools.trim(node.get('alias')).length > 0) {
            importAlias.set(node.get('alias'), node.nodeName);
        }
        
        for (item in types) imports.push(item);
    }

    private static function createElement(
        node:Xml,
        parent:PriBuilderField, 
        fields:Array<Field>, 
        builderFields:Array<PriBuilderField>, 
        imports:Array<Type>,
        importAlias:StringMap<String>,
        propertiesElementsForSetup:Array<Expr>,
        propertiesElementsForPaint:Array<Expr>
    ) {
        var access:XmlAccessHelper = new XmlAccessHelper(node);

        if (StringTools.startsWith(node.nodeName, 'p:')) {

            if (node.exists("value")) {
                var propertie:String = node.nodeName.split(":")[1];
                var value:String = node.get("value");

                if (PriBuilderMacroHelper.checkIsExpression(value)) {
                    propertiesElementsForPaint.push(generatePropertieExpression(parent == null ? 'this' : parent.name, propertie, value));
                } else {
                    propertiesElementsForSetup.push(generatePropertieExpression(parent == null ? 'this' : parent.name, propertie, value));
                }
            }

        } else {

            var nodeName:String = node.nodeName;
            var isPrivate:Bool = false;

            if (StringTools.startsWith(nodeName, 'private:')) {
                nodeName = nodeName.split('private:').join('');
                isPrivate = true;
            }

            var type:Type = getTypeFromClassName(nodeName, imports, importAlias);
            if (type == null) {
                try {
                    type = Context.getType(nodeName);
                } catch (e:Dynamic) {}
            }
            if (type == null) throw "Type not found : " + nodeName;
            
            var result:PriBuilderField = {
                node : node,
                name : '____' + Math.floor(10000000 * Math.random()),
                type : TypeTools.toString(type),
                isPublic : false,
                macroType : type,
                macroComplexType : haxe.macro.TypeTools.toComplexType(type),

                parent : parent
            }

            if (node.exists("id")) {
                if (!isPrivate) result.isPublic = true;
                result.name = node.get("id");
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

            for (subnode in node.elements()) createElement(subnode, result, fields, builderFields, imports, importAlias, propertiesElementsForSetup, propertiesElementsForPaint);
        }
    }

    private static function generatePropertieExpression(objectOwner:String, propertieName:String, value:String):Null<Expr> {
        
        if (objectOwner == null || propertieName == null || value == null) return null;

        if (PriBuilderMacroHelper.checkIsExpression(value)) {

            var val:String = PriBuilderMacroHelper.getExpression(value);
            
            var macrExpr = Context.parse(val, Context.currentPos());
            
            if (val != null) return macro $i{objectOwner}.$propertieName = $e{macrExpr}

        } else {

            var val:Dynamic = null;
            
            if (PriBuilderMacroHelper.checkIsNumeric(value)) {
                if (PriBuilderMacroHelper.checkIsNumericFloat(value)) val = PriBuilderMacroHelper.getFloat(value);
                else val = PriBuilderMacroHelper.getInt(value);
            } else {
                val = Std.string(value);
            }

            if (val != null) {
                return macro $i{objectOwner}.$propertieName = $v{val};
            }
        }

        return null;
    }

    private static function generateSetupProperties(fields:Array<PriBuilderField>):Array<Expr> {
        var result:Array<Expr> = [];

        for (field in fields) {
            
            for (att in field.node.attributes()) {
                if (att != "id") {

                    var value:String = field.node.get(att);
                    
                    if (!PriBuilderMacroHelper.checkIsExpression(value)) {
                        var expr:Expr = generatePropertieExpression(field.name, att, value);
                        if (expr != null) result.push(expr);
                    }
                }
            }
        }

        return result;
    }

    private static function generatePaintProperties(fields:Array<PriBuilderField>):Array<Expr> {
        var result:Array<Expr> = [];

        for (field in fields) {
            
            for (att in field.node.attributes()) {
                if (att != "id") {

                    var value:String = field.node.get(att);
                    
                    if (PriBuilderMacroHelper.checkIsExpression(value)) {
                        var expr:Expr = generatePropertieExpression(field.name, att, value);
                        if (expr != null) result.push(expr);
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

                    result.push(macro var _ac:Array<Dynamic> = []);
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

    private static function getMetaPosition(metaKey:String) {
        var localClass = Context.getLocalClass();
        var meta = localClass.get().meta;
        
        if (meta.has(metaKey)) {
            var ext = meta.extract(metaKey);
            
            if (ext.length > 0 && ext[0].params.length > 0) {
                return PositionTools.getInfos(ext[0].params[0].pos);
            }
        }

        return null;
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

#if macro
private typedef PriBuilderField = {
    var node:Xml;
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
            // ^-?[0-9]*.?[0-9]+$ hexa, negatives, positives, floats or integers
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

private class XmlAccessHelper {

    private var node:Xml;

    public function new(node:Xml) {
        this.node = node;
    }

    public function hasNode(nodeName:String):Bool {
        for (el in this.node.elements()) if (el.nodeName == nodeName) return true;
        return false;
    }

    public function getElementsFromNode(nodeName:String):Array<Xml> {
        var result:Array<Xml> = [];

        for (el in this.node.elementsNamed(nodeName)) {
            for (cel in el.elements()) {
                result.push(cel);
            }
        }

        return result;
    }
}

#end