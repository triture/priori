package builder;

import haxe.macro.CompilationServer.ContextOptions;
import haxe.ValueException;
import haxe.macro.MacroStringTools;
import haxe.macro.PositionTools;
import haxe.macro.ComplexTypeTools;
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
    private var privateTypes:Array<String>;

    private var interpreter:BuilderInterpreter;
    
    public function new() {
        try {
            BuilderMacroHelper.print('');
            BuilderMacroHelper.print('Building ${this.className}');

            this.types = new StringMap<BuilderMacroImportData>();
            this.privateTypes = [];

            this.interpreter = new BuilderInterpreter(this.className);
            this.interpreter.loadXML(this.recoverXmlData(), this.getPreImportList());
            
            if (this.interpreter.hasError) {
                var tagPos = BuilderMacroHelper.getMetaPosition(PRIORI_BUILDER_TAG);
                
                var pos = Context.makePosition({
                    min: tagPos.min + this.interpreter.error.min,
                    max: this.interpreter.error.max,
                    file: PositionTools.getInfos(Context.currentPos()).file
                });
                
                Context.fatalError(
                    this.interpreter.error.message, 
                    pos
                );
            }
            
            this.constructImportTypes();
            this.constructFields();
            this.constructCode();
        } catch (e) {

            var tagPos = BuilderMacroHelper.getMetaPosition(PRIORI_BUILDER_TAG);
                
            var pos = Context.makePosition({
                min: tagPos.min,
                max: tagPos.max,
                file: PositionTools.getInfos(Context.currentPos()).file
            });
            
            Context.fatalError(
                'Building Error: ${e}', 
                pos
            );
            
        }
    }

    private function getPreImportList():Array<String> {
        var result:Array<String> = [];

        this.importTypesFromModule(Context.getModule(Context.getLocalModule()));
        for (m in Context.getModule(Context.getLocalModule())) {
            var pack:String = TypeTools.toString(m);
            if (pack.indexOf('._') != -1) this.privateTypes.push(pack.split('.').pop());
            else result.push(TypeTools.toString(m));
        }

        for (importItem in Context.getLocalImports()) {
            if (importItem.mode == ImportMode.INormal) {
                var path:String = [for (path in importItem.path) path.name].join('.');
                result.push(path);
            }
        }

        return result;
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
        BuilderMacroHelper.print('- Building Imports');
        
        // building from import data
        for (importItem in this.interpreter.data.imports) this.importTypesFromClassName(importItem.name);
    }

    private function importTypesFromClassName(className:String):Void {
        if (this.types.exists(className)) return;
        else if (this.privateTypes.indexOf(className) != -1) return;

        try {
            var module:Array<Type> = Context.getModule(className);
            this.importTypesFromModule(module);
        } catch(e1) {
            
            try {
                var currPack:Array<String> = Context.getLocalClass().get().pack;
                var module:Array<Type> = Context.getModule(currPack.join('.') + '.' + className);
                this.importTypesFromModule(module);

            } catch (e2) {

                var tagPos = BuilderMacroHelper.getMetaPosition(PRIORI_BUILDER_TAG);
            
                var pos = Context.makePosition({
                    min: tagPos.min,
                    max: tagPos.max,
                    file: PositionTools.getInfos(Context.currentPos()).file
                });
                
                Context.fatalError(
                    'Building Error: ${e1}', 
                    pos
                );
            
            }
        }
    }

    private function importTypesFromModule(module:Array<Type>):Void {
        for (t in module) {
            var className:String = TypeTools.toString(t);

            if (this.types.exists(className)) continue;

            BuilderMacroHelper.print('  Importing ${className}');

            var item:BuilderMacroImportData = {
                className: className,
                type : t,
                complexType: TypeTools.toComplexType(t)
            }

            this.types.set(className, item);
        }
    }

    private function constructFields():Void {
        BuilderMacroHelper.print('- Building Fields');

        this.fields = Context.getBuildFields();
        for (view in this.interpreter.data.views) this.createField(view, this.fields);
    }

    private function createField(element:BuilderInstanceData, ?result:Array<Field>):Array<Field> {
        if (result == null) result = [];
        
        var debug_fieldRepresentation:String = '${element.id == null ? 'class:${element.name}' : 'id:${element.id}'}';
        var importData:BuilderMacroImportData = this.types.get(element.name);
        
        BuilderMacroHelper.print('  Creating ${debug_fieldRepresentation}');
        
        if (element.id == null) element.id = '___${BuilderMacroHelper.generateRandomString()}';
        
        try {
            var complex:ComplexType;
            var complexCode:String;

            if (element.typed == null) complexCode = 'var ${element.id}:${element.name}';
            else if (importData == null) complexCode = 'var ${element.id}:${element.name}${element.typed}';
            else complex = importData.complexType;

            if (complexCode != null) {
                var f = Context.parse(complexCode, Context.currentPos());
                complex = f.expr.getParameters()[0][0].type;
            }
            
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
                kind: FieldType.FVar(complex),
                pos: Context.currentPos()
            }

            result.push(field);

        } catch (e:Dynamic) {
            var tagPos = BuilderMacroHelper.getMetaPosition(PRIORI_BUILDER_TAG);
                
            var pos = Context.makePosition({
                min: tagPos.min,
                max: tagPos.max,
                file: PositionTools.getInfos(Context.currentPos()).file
            });
            
            Context.fatalError(
                'Building Error: ${e}', 
                pos
            );
        }
        
        for (child in element.children) this.createField(child, result);
        return result;
    }

    private function constructCode():Void {
        BuilderMacroHelper.print('- Building Code');

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
            BuilderMacroHelper.print('  SETUP: ${code}');
            #end
            result.push(Context.parse(code, Context.currentPos()));
        }

        if (this.interpreter.data.root != 'this') {
            BuilderMacroHelper.print('  CHANGING ROOT TO ${this.interpreter.data.root}');
            var code:String = 'this.root = this.${this.interpreter.data.root}';
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
            BuilderMacroHelper.print('  PAINT: ${code}');
            #end
            result.push(Context.parse(code, Context.currentPos()));
        }

        return result;
    }

    private function createAddCode(parent:String, item:BuilderInstanceData, result:Array<String>):Void {
        for (child in item.children) {
            this.createAddCode('this.${item.id}', child, result);
        }

        var code:String = 'if ((cast ${parent}).addRootChild == null) ${parent}.addChild(this.${item.id}) else (cast ${parent}).addRootChild(this.${item.id})';
        result.push(code);
    }

    private function createProperty(parent:String, properties:Array<BuilderKeyValueData>, result:Array<String>, allowed:Array<BuilderKeyValueType>):Void {
        for (property in properties) {
            if (allowed.indexOf(property.getType()) == -1) continue;
            
            var code:String = '${parent}.${property.getKey()} = ${property.getMacroValue()}';
            result.push(code);
        }
    }

    private function createPropertyCode(item:BuilderInstanceData, result:Array<String>, allowed:Array<BuilderKeyValueType>):Void {        
        this.createProperty('this.${item.id}', item.properties, result, allowed);
        for (child in item.children) this.createPropertyCode(child, result, allowed);
    }

    private function createNewCode(item:BuilderInstanceData, result:Array<String>):Void {
        var code:String = 'this.${item.id} = new ${item.name}${item.typed == null ? '' : item.typed}()';
        result.push(code);

        for (child in item.children) this.createNewCode(child, result);
    }

}