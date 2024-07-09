package builder;

import builder.model.enums.BuilderKeyValueType;
import builder.model.data.BuilderKeyValueData;
import haxe.macro.Expr;
import haxe.macro.Expr.Access;
import builder.model.data.BuilderInstanceData;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import haxe.macro.Expr.ImportMode;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.ds.StringMap;
import builder.model.data.BuilderMacroImportData;
import builder.helper.BuilderMacroHelper;


class BuilderMacro {

    private static var PRIORI_BUILDER_TAG:String = 'priori';

    private var fileName:String = Context.getClassPath().join('.');
    private var className:String = Context.getLocalClass().toString();
    
    private var fields:Array<Field>;
    private var types:StringMap<BuilderMacroImportData>;

    private var interpreter:BuilderInterpreter;
    
    public function new() {
        BuilderMacroHelper.print('Building ${this.className}');

        this.interpreter = new BuilderInterpreter(this.className);
        this.interpreter.loadXML(this.recoverXmlData());

        this.constructImportTypes();
        this.constructFields();
        this.constructCode();
    }

    public function getFields():Array<Field> return this.fields;

    public function recoverXmlData():String {
        var result:String;
        var dataFromTag:String = BuilderMacroHelper.getMetaValue(PRIORI_BUILDER_TAG);
        var dataFromFile:String = BuilderMacroHelper.loadDataFromFile(dataFromTag);

        if (dataFromFile != null) result = dataFromFile;
        else if (dataFromTag != null) result = dataFromTag;

        if (result == null) return null;
        
        return result;
    }

    private function constructImportTypes():Void {
        this.types = new StringMap<BuilderMacroImportData>();

        // building from current code imports
        for (importItem in Context.getLocalImports()) {
            if (importItem.mode == ImportMode.INormal) {
                var path:String = [for (path in importItem.path) path.name].join('.');
                var module:Array<Type> = Context.getModule(path);
                this.importTypesFromModule(module);
            }
        }

        // building from import data
        for (importItem in this.interpreter.data.imports) {
            var module:Array<Type> = Context.getModule(importItem.name);
            this.importTypesFromModule(module);
        }
    }

    private function importTypesFromModule(module:Array<Type>):Void {
        for (t in module) {
            var className:String = TypeTools.toString(t);
            
            var item:BuilderMacroImportData = {
                className: className,
                type : t,
                complexType: TypeTools.toComplexType(t)
            }
            
            this.types.set(className, item);
        }
    }

    private function constructFields():Void {
        this.fields = Context.getBuildFields();
        for (view in this.interpreter.data.views) this.createField(view, this.fields);
    }

    private function createField(element:BuilderInstanceData, ?result:Array<Field>):Array<Field> {
        if (result == null) result = [];

        var importData:BuilderMacroImportData = this.types.get(element.name);
        if (element.id == null) element.id = '___${BuilderMacroHelper.generateRandomString()}';

        var field:Field = {
            meta : StringTools.startsWith(element.id, '___') 
                ? [{
                    pos : Context.currentPos(), 
                    name : ':noCompletion',
                    params:[]
                  }] 
                : null,
            name : element.id,
            doc : '',
            access: [element.visibility],
            kind: FieldType.FVar(importData.complexType),
            pos: Context.currentPos()
        }

        result.push(field);

        for (child in element.children) this.createField(child, result);
        return result;
    }

    private function constructCode():Void {
        this.fields.push({
            name : '__priBuilderSetup',
            pos: Context.currentPos(),
            access: [Access.APrivate, Access.AOverride],
            kind : FieldType.FFun({
                args : [],
                ret : null,
                expr: macro {
                    super.__priBuilderSetup();
                    $b{generateSetupCode()}
                }
            })
        });

        fields.push({
            name : '__priBuilderPaint',
            pos: Context.currentPos(),
            access: [Access.APrivate, Access.AOverride],
            kind : FieldType.FFun({
                args : [],
                ret : null,
                expr: macro {
                    super.__priBuilderPaint();
                    $b{generatePaintCode()}
                }
            })
        });
    }

    private function generateSetupCode():Array<Expr> {
        var codes:Array<String> = [];
        var result:Array<Expr> = [];
        var allowed:Array<BuilderKeyValueType> = [
            BuilderKeyValueType.DYNAMIC, 
            BuilderKeyValueType.LITERAL, 
            BuilderKeyValueType.STRING
        ];

        this.createProperty('this', this.interpreter.data.properties, codes, allowed);

        for (item in this.interpreter.data.views) this.createNewCode(item, codes);
        for (item in this.interpreter.data.views) this.createPropertyCode(item, codes, allowed);
        for (item in this.interpreter.data.views) this.createAddCode('this', item, codes);
        
        for (code in codes) {
            #if prioridebug
            BuilderMacroHelper.print(' > SETUP: ${code}');
            #end
            result.push(Context.parse(code, Context.currentPos()));
        }

        return result;
    }

    private function generatePaintCode():Array<Expr> {
        var codes:Array<String> = [];
        var result:Array<Expr> = [];
        var allowed:Array<BuilderKeyValueType> = [BuilderKeyValueType.PAINT];

        this.createProperty('this', this.interpreter.data.properties, codes, allowed);
        for (item in this.interpreter.data.views) this.createPropertyCode(item, codes, allowed);

        for (code in codes) {
            #if prioridebug
            BuilderMacroHelper.print(' > PAINT: ${code}');
            #end
            result.push(Context.parse(code, Context.currentPos()));
        }

        return result;
    }

    private function createAddCode(parent:String, item:BuilderInstanceData, result:Array<String>):Void {
        for (child in item.children) {
            this.createAddCode('this.${item.id}', child, result);
        }

        var code:String = '${parent}.addChild(this.${item.id});';
        result.push(code);
    }

    private function createProperty(parent:String, properties:Array<BuilderKeyValueData>, result:Array<String>, allowed:Array<BuilderKeyValueType>):Void {
        for (property in properties) {
            if (allowed.indexOf(property.getType()) == -1) continue;
            
            var code:String = '${parent}.${property.getKey()} = ${property.getMacroValue()};';
            result.push(code);
        }
    }

    private function createPropertyCode(item:BuilderInstanceData, result:Array<String>, allowed:Array<BuilderKeyValueType>):Void {        
        this.createProperty('this.${item.id}', item.properties, result, allowed);
        for (child in item.children) this.createPropertyCode(child, result, allowed);
    }

    private function createNewCode(item:BuilderInstanceData, result:Array<String>):Void {
        var code:String = 'this.${item.id} = new ${item.name}();';
        result.push(code);

        for (child in item.children) this.createNewCode(child, result);
    }

}