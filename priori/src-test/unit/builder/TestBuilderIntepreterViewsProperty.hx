package unit.builder;

import builder.model.enums.BuilderKeyValueType;
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

    function test_load_xml_id_property_shoud_be_converted_to_id() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <views>
                    <PriDisplay id="id" />
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: ["PriDisplay" => {
                name: "PriDisplay",
                alias: "PriDisplay"
            }],
            views: [
                {
                    id : "id",
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

    function test_load_xml_empry_id_property_shoud_be_ignored() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <views>
                    <PriDisplay id="" />
                </views>
            </priori>
        ';

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

    function test_load_xml_numeric_property_should_be_interpreted_as_string() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <views>
                    <PriDisplay label:String="100" />
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: ["PriDisplay" => {
                name: "PriDisplay",
                alias: "PriDisplay"
            }],
            views: [
                {
                    name: "PriDisplay",
                    visibility: BuilderElementVisibilityType.PUBLIC,
                    properties: [
                        new BuilderKeyValueData("label", "100", BuilderKeyValueType.STRING)
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

    function test_load_xml_forced_typed_property_on_prop_nodes_should_works() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <views>
                    <p:label value:String="100" />
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: new StringMap<BuilderImportData>(),
            views: [],
            properties: [
                new BuilderKeyValueData("label", "100", BuilderKeyValueType.STRING)
            ]
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_extract_property_from_view_root_node() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = '
            <priori>
                <views width="100" label:String="100">
                </views>
            </priori>
        ';

        var expecteData:BuilderData = {
            imports: new StringMap<BuilderImportData>(),
            views: [],
            properties: [
                new BuilderKeyValueData("width", "100", BuilderKeyValueType.DYNAMIC),
                new BuilderKeyValueData("label", "100", BuilderKeyValueType.STRING)
            ]
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    function test_load_xml_detect_paint_expression() {
        // ARRANGE
        var builderInterpreter = new BuilderInterpreter();
        var valueXml:String = "
            <priori>
                <views>
                    <p:width value:Paint=\"100\" />
                    <p:height value=\"${this.getSize()}\" />
                </views>
            </priori>
        ";

        var expecteData:BuilderData = {
            imports: new StringMap<BuilderImportData>(),
            views: [],
            properties: [
                new BuilderKeyValueData("width", "100", BuilderKeyValueType.PAINT),
                new BuilderKeyValueData("height", "this.getSize()", BuilderKeyValueType.PAINT)
            ]
        };

        var resultData:BuilderData;
        
        // ACT
        builderInterpreter.loadXML(valueXml);
        resultData = builderInterpreter.data;

        // ASSERT
        Assert.same(expecteData, resultData);
    }

    // function test_load_xml_property_order_matter_following_att_order() {
    //     // ARRANGE
    //     var builderInterpreter = new BuilderInterpreter();
    //     var valueXml:String = '
    //         <priori>
    //             <views>
    //                 <PriDisplay x="10" label:String="100" width="90" other="abc" />
    //                 <PriDisplay other="abc" x="10" width="90" label:String="100" />
    //             </views>
    //         </priori>
    //     ';

    //     var expecteData:BuilderData = {
    //         imports: ["PriDisplay" => {
    //             name: "PriDisplay",
    //             alias: "PriDisplay"
    //         }],
    //         views: [
    //             {
    //                 name: "PriDisplay",
    //                 visibility: BuilderElementVisibilityType.PUBLIC,
    //                 properties: [
    //                     new BuilderKeyValueData("x", "100", BuilderKeyValueType.DYNAMIC),
    //                     new BuilderKeyValueData("label", "100", BuilderKeyValueType.STRING),
    //                     new BuilderKeyValueData("width", "90", BuilderKeyValueType.DYNAMIC),
    //                     new BuilderKeyValueData("other", "abc", BuilderKeyValueType.DYNAMIC)
    //                 ],
    //                 children: []
    //             },
    //             {
    //                 name: "PriDisplay",
    //                 visibility: BuilderElementVisibilityType.PUBLIC,
    //                 properties: [
    //                     new BuilderKeyValueData("other", "abc", BuilderKeyValueType.DYNAMIC),
    //                     new BuilderKeyValueData("x", "100", BuilderKeyValueType.DYNAMIC),
    //                     new BuilderKeyValueData("width", "90", BuilderKeyValueType.DYNAMIC),
    //                     new BuilderKeyValueData("label", "100", BuilderKeyValueType.STRING)
    //                 ],
    //                 children: []
    //             }
    //         ],
    //         properties: []
    //     };

    //     var resultData:BuilderData;
        
    //     // ACT
    //     builderInterpreter.loadXML(valueXml);
    //     resultData = builderInterpreter.data;

    //     // ASSERT
    //     Assert.same(expecteData, resultData);
    // }
}