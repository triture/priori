package unit.builder;

import builder.model.data.BuilderKeyValueData;
import builder.model.enums.BuilderElementVisibilityType;
import utest.Assert;
import builder.model.data.BuilderData;
import builder.BuilderInterpreter;
import utest.Test;

class TestBuilderIntepreterViews extends Test {
    
    function test_load_xml_views_has_views_without_elements() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "<priori><imports><priori.view.PriDisplay /></imports><views></views></priori>";

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

    function test_load_xml_views_has_views_with_one_element() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "<priori><imports><priori.view.PriDisplay /></imports><views><PriDisplay /></views></priori>";

        var expecteData:BuilderData = {
            imports: [
                {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                }
            ],
            properties: []
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_views_has_views_with_private_element() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "<priori><imports><priori.view.PriDisplay /></imports><views><private:PriDisplay /></views></priori>";

        var expecteData:BuilderData = {
            imports: [
                {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "PriDisplay",
                    visibility: BuilderElementVisibilityType.PRIVATE,
                    properties: [],
                    children: []
                }
            ],
            properties: []
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_views_has_views_with_display_and_children() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "
            <priori>
                <imports>
                    <priori.view.PriDisplay />
                </imports>
                <views>
                    <PriDisplay >
                        <PriDisplay />
                    </PriDisplay>
                </views>
            </priori>
        ";

        var expecteData:BuilderData = {
            imports: [
                {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: [
                        {
                            name: "PriDisplay",
                            visibility: BuilderElementVisibilityType.PUBLIC,
                            properties: [],
                            children: []
                        }
                    ]
                }
            ],
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