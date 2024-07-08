package unit.builder;

import builder.model.data.BuilderImportData;
import haxe.ds.StringMap;
import utest.Assert;
import builder.model.data.BuilderData;
import builder.BuilderInterpreter;
import utest.Test;

class TestBuilderIntepreterImports extends Test {
    
    function test_load_xml_without_elements() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "<priori></priori>";

        var expecteData:BuilderData = {
            imports: new StringMap<BuilderImportData>(),
            views: [],
            properties: []
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_with_imports_with_alias() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "<priori><imports><priori.view.PriDisplay alias=\"Display\" /></imports></priori>";

        var expecteData:BuilderData = {
            imports: [
                "Display" => {
                    name: "priori.view.PriDisplay",
                    alias: "Display"
                }
            ],
            views: [],
            properties: []
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_import_without_alias() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "<priori><imports><priori.view.PriDisplay /></imports></priori>";

        var expecteData:BuilderData = {
            imports: [
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [],
            properties: []
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_invalid_xml() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "<priori><imports><priori.view.PriDisplay priori>";

        var expectedHasError:Bool = true;
        var expecteData:BuilderData = null;
        var expectedErrorPos:Int = 47;

        var resultHasError:Bool;
        var resultData:BuilderData;
        var resultErrorPos:Int;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;
        resultHasError = builderInterpreter.hasError;
        resultErrorPos = builderInterpreter.error.min;

        // ASSERT
        Assert.same(expecteData, resultData);
        Assert.equals(expectedHasError, resultHasError);
        Assert.equals(expectedErrorPos, resultErrorPos);
    }

    function test_load_xml_import_without_alias_for_same_class_name_should_input_full_class_name_as_alias() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <imports>
                    <pack.a.Display />
                    <pack.b.Display />
                </imports>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: [
                "Display" => {
                    name: "pack.a.Display",
                    alias: "Display"
                },
                "pack.b.Display" => {
                    name: "pack.b.Display",
                    alias: "pack.b.Display"
                }
            ],
            views: [],
            properties: []
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

}