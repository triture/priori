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
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [],
            properties: [],
            root: "this"
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
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                }
            ],
            properties: [],
            root : "this"
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
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PRIVATE,
                    properties: [],
                    children: []
                }
            ],
            properties: [],
            root : "this"
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
                "PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "PriDisplay"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: [
                        {
                            name: "priori.view.PriDisplay",
                            visibility: BuilderElementVisibilityType.PUBLIC,
                            properties: [],
                            children: []
                        }
                    ]
                }
            ],
            properties: [],
            root : "this"
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_views_without_import_should_add_import_elements_using_full_name() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "
            <priori>
                <views>
                    <priori.view.PriDisplay />
                </views>
            </priori>
        ";

        var expecteData:BuilderData = {
            imports: [
                "priori.view.PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "priori.view.PriDisplay"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                }
            ],
            properties: [],
            root : "this"
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_alias_and_full_name_should_be_allowed() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <imports>
                    <priori.view.PriDisplay alias="Display" />
                </imports>
                <views>
                    <priori.view.PriDisplay />
                    <Display />
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: [
                "priori.view.PriDisplay" => {
                    name: "priori.view.PriDisplay",
                    alias: "priori.view.PriDisplay"
                },
                "Display" => {
                    name: "priori.view.PriDisplay",
                    alias: "Display"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                },
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                }
            ],
            properties: [],
            root : "this"
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_multiple_alias_should_be_allowed() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <imports>
                    <priori.view.PriDisplay alias="DisplayA" />
                    <priori.view.PriDisplay alias="DisplayB" />
                </imports>
                <views>
                    <DisplayA />
                    <DisplayB />
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: [
                "DisplayA" => {
                    name: "priori.view.PriDisplay",
                    alias: "DisplayA"
                },
                "DisplayB" => {
                    name: "priori.view.PriDisplay",
                    alias: "DisplayB"
                }
            ],
            views: [
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                },
                {
                    name: "priori.view.PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                }
            ],
            properties: [],
            root : "this"
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_same_class_name_from_other_modules_should_be_allowed() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <imports>
                    <pack.a.Name alias="NameA" />
                    <pack.b.Name alias="NameB" />
                </imports>
                <views>
                    <NameA />
                    <NameB />
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: [
                "NameA" => {
                    name: "pack.a.Name",
                    alias: "NameA"
                },
                "NameB" => {
                    name: "pack.b.Name",
                    alias: "NameB"
                }
            ],
            views: [
                {
                    name: "pack.a.Name",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                },
                {
                    name: "pack.b.Name",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: []
                }
            ],
            properties: [],
            root : "this"
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_test_typed_view() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <views>
                    <some.TypedClass type="<Bool>" />
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: [
                "some.TypedClass" => {
                    name: "some.TypedClass",
                    alias: "some.TypedClass"
                }
            ],
            views: [
                {
                    name: "some.TypedClass",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [],
                    children: [],
                    typed: "<Bool>"
                }
            ],
            properties: [],
            root : "this"
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }
}