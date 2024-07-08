package builder;

import haxe.macro.Type;
import haxe.macro.TypeTools;
import haxe.macro.Expr.ImportMode;
import builder.model.data.BuilderMacroImportData;
import haxe.ds.StringMap;
import builder.helper.BuilderMacroHelper;
import haxe.macro.Expr.Field;
import haxe.macro.Context;

class BuilderMacro {

    private static var PRIORI_BUILDER_TAG:String = 'priori';

    private var fileName:String = Context.getClassPath().join('.');
    private var className:String = Context.getLocalClass().toString();
    private var fields:Array<Field> = Context.getBuildFields();
    private var types:StringMap<BuilderMacroImportData> = new StringMap<BuilderMacroImportData>();

    private var interpreter:BuilderInterpreter;
    
    public function new() {
        BuilderMacroHelper.print('Building ${this.className}');

        this.interpreter = new BuilderInterpreter(this.className);
        this.interpreter.loadXML(this.recoverXmlData());

        this.constructImportTypes();
        for (item in this.types.iterator()) trace(item);
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
            var className:String = t.getName();
            
            var item:BuilderMacroImportData = {
                className: className,
                type : t,
                complexType: TypeTools.toComplexType(t)
            }
            
            this.types.set(className, item);
        }
    }

}