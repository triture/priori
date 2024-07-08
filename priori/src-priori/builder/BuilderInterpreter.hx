package builder;

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
        
        var root:Xml = xml.firstElement();

        this.data = {
            imports: [],
            views: [],
            properties: []
        };

        this.interpretImports(root);
        this.interpretViews(root);
    }

    private function interpretViews(data:Xml):Void {
        var resultViews:Array<BuilderInstanceData> = [];
        var resultProperties:Array<BuilderKeyValueData> = [];

        for (views in data.elementsNamed("views")) {
            for (element in views.elements()) {
                if (StringTools.startsWith(element.nodeName, "p:")) resultProperties.push(this.extractElementPropertyFromNode(element));
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

        for (element in data.elements()) {
            if (StringTools.startsWith(element.nodeName, "p:")) properties.push(this.extractElementPropertyFromNode(element));
            else children.push(this.interpretViewElement(element));
        }

        return {
            name: cleanName,
            visibility: visibility,
            properties: properties,
            children: children
        };
    }

    private function extractElementPropertyFromNode(data:Xml):BuilderKeyValueData {
        var nodeName:String = data.nodeName;
        var cleanName:String = nodeName.split(":").pop();

        return new BuilderKeyValueData(cleanName, data.get("value"));
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
        var result:Array<BuilderImportData> = [];

        for (imports in data.elementsNamed("imports")) {
            for (element in imports.elements()) {

                var name:String = element.nodeName;
                var alias:String = element.get("alias");

                if (isEmpty(alias)) alias = name.split('.').pop();

                result.push({
                    name: name,
                    alias: alias
                });
            }
        }

        this.data.imports = result;
    }

    private function isEmpty(value:String):Bool {
        if (value == null) return true;
        else if (StringTools.trim(value).length == 0) return true;
        else return false;
    }
}