package unit.builder;

import builder.model.data.BuilderKeyValueData;
import builder.model.enums.BuilderElementVisibilityType;
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
            imports: [],
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
                {
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
                {
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

}