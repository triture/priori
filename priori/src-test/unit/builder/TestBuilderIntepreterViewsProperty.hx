package unit.builder;

import builder.model.data.BuilderImportData;
import haxe.ds.StringMap;
import builder.model.data.BuilderKeyValueData;
import builder.model.enums.BuilderElementVisibilityType;
import utest.Assert;
import builder.model.data.BuilderData;
import builder.BuilderInterpreter;
import utest.Test;

class TestBuilderIntepreterViewsProperty extends Test {

    function test_load_xml_views_has_views_with_one_property() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "
            <priori>
                <imports>
                    <priori.view.PriDisplay />
                </imports>
                <views>
                    <PriDisplay width=\"100\" />
                </views>
            </priori>
        ";

        var expecteData:BuilderData = {
            imports: [
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [
                        new BuilderKeyValueData("width", "100")
                    ],
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

    function test_load_xml_views_has_views_with_property_node() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "
            <priori>
                <imports>
                    <priori.view.PriDisplay />
                </imports>
                <views>
                    <PriDisplay >
                        <p:width value=\"100\" />
                    </PriDisplay>
                </views>
            </priori>
        ";

        var expecteData:BuilderData = {
            imports: [
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [
                        new BuilderKeyValueData("width", "100")
                    ],
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

    function test_load_xml_views_has_property_on_view_root() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "
            <priori>
                <imports>
                    <priori.view.PriDisplay />
                </imports>
                <views>
                    <p:width value=\"100\" />
                </views>
            </priori>
        ";

        var expecteData:BuilderData = {
            imports: [
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [],
            properties: [
                new BuilderKeyValueData("width", "100")
            ]
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_property_withou_value_cannot_be_processed() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "
            <priori>
                <views>
                    <PriDisplay >
                        <p:width />
                    </PriDisplay>
                </views>
            </priori>
        ";

        var expecteData:BuilderData = {
            imports: ["PriDisplay" => {
                name: "PriDisplay",
                alias: "PriDisplay"
            }],
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

}