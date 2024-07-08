package builder;

import haxe.ds.StringMap;
import builder.model.data.BuilderKeyValueData;
import builder.model.enums.BuilderElementVisibilityType;
import builder.model.data.BuilderInstanceData;
import builder.model.data.BuilderErrorData;
import haxe.xml.Parser.XmlParserException;
import builder.model.data.BuilderImportData;
import builder.model.data.BuilderData;

class BuilderInterpreter {

    public var className:String;
    public var data:BuilderData;

    public var hasError:Bool;
    public var error:BuilderErrorData;
    
    public function new(className:String = "") {
        this.className = className;
        this.hasError = false;
    }
    
    public function loadXML(data:String):Void {
        var xml:Xml;

        try {
            xml = Xml.parse(data);
        } catch (e:XmlParserException) {
            this.hasError = true;
            this.error = {
                message: e.toString(),
                filename: null,
                min: e.position,
                max: e.position
            };
            return;
        }
        
        this.data = {
            imports: new StringMap<BuilderImportData>(),
            views: [],
            properties: []
        };

        var root:Xml = xml.firstElement();
        this.interpretImports(root);
        this.interpretViews(root);
    }

    private function interpretViews(data:Xml):Void {
        var resultViews:Array<BuilderInstanceData> = [];
        var resultProperties:Array<BuilderKeyValueData> = [];

        for (views in data.elementsNamed("views")) {
            for (element in views.elements()) {
                if (StringTools.startsWith(element.nodeName, "p:")) this.extractElementPropertyFromNode(element, resultProperties);
                else resultViews.push(this.interpretViewElement(element));
            }
        }

        this.data.views = resultViews;
        this.data.properties = resultProperties;
    }

    private function interpretViewElement(data:Xml):BuilderInstanceData {
        var nodeName:Array<String> = data.nodeName.split(":");
        var cleanName:String = nodeName.length == 1 ? nodeName[0] : nodeName[1];
        var visibility:BuilderElementVisibilityType = nodeName.length == 1 ? BuilderElementVisibilityType.PUBLIC : nodeName[0];
        var properties:Array<BuilderKeyValueData> = this.extractElementProperties(data);
        var children:Array<BuilderInstanceData> = [];

        // var className:String = cleanName.split('.').pop();
        if (!this.data.imports.exists(cleanName)) this.addImportDirectFromNode(cleanName);

        var classPath:String = this.data.imports.exists(cleanName) 
            ? this.data.imports.get(cleanName).name 
            : cleanName;

        for (element in data.elements()) {
            if (StringTools.startsWith(element.nodeName, "p:")) this.extractElementPropertyFromNode(element, properties);
            else children.push(this.interpretViewElement(element));
        }

        return {
            name: classPath,
            visibility: visibility,
            properties: properties,
            children: children
        };
    }

    private function extractElementPropertyFromNode(data:Xml, deposit:Array<BuilderKeyValueData>):Void {
        var nodeName:String = data.nodeName;
        var cleanName:String = nodeName.split(":").pop();
        var value:String = data.get("value");

        if (value != null) deposit.push(new BuilderKeyValueData(cleanName, value));
    }

    private function extractElementProperties(data:Xml):Array<BuilderKeyValueData> {
        var result:Array<BuilderKeyValueData> = [];

        for (property in data.attributes()) {
            result.push(
                new BuilderKeyValueData(property, data.get(property))
            );
        }

        return result;
    }

    private function interpretImports(data:Xml):Void {
        var result:StringMap<BuilderImportData> = this.data.imports;

        for (imports in data.elementsNamed("imports")) {
            for (element in imports.elements()) {

                var name:String = element.nodeName;
                var alias:String = element.get("alias");

                var autoAlias:String = name.split('.').pop();

                if (isEmpty(alias)) {
                    if (result.exists(autoAlias)) alias = name;
                    else alias = autoAlias;
                }

                result.set(alias, {
                    name: name,
                    alias: alias
                });
            }
        }
    }

    private function addImportDirectFromNode(name:String):Void {
        this.data.imports.set(name, {
            name: name,
            alias: name
        });
    }

    private function isEmpty(value:String):Bool {
        if (value == null) return true;
        else if (StringTools.trim(value).length == 0) return true;
        else return false;
    }
}