package unit.builder;

import builder.model.data.BuilderImportData;
import haxe.ds.StringMap;
import builder.model.enums.BuilderKeyValueType;
import utest.Assert;
import builder.model.data.BuilderKeyValueData;
import utest.Test;

class TestBuilderPropertyValue extends Test {
    

    function test_simple_string_value() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "value");
        var expected:String = '"value"';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_empty_string_value() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "");
        var expected:String = '""';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_int_number() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "100");
        var expected:String = '100';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_float_number() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "10.1");
        var expected:String = '10.1';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_int_hexadecimal() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "0xff0000");
        var expected:String = '0xff0000';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_int_negative() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "-5");
        var expected:String = '-5';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_float_negative() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "-5.5");
        var expected:String = '-5.5';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_numbers_and_space_should_be_string() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "10 10");
        var expected:String = '"10 10"';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_numbers_and_letters_should_be_string() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "10abc");
        var expected:String = '"10abc"';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }
    
    function test_numeric_special_case_should_be_string() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "100", BuilderKeyValueType.STRING);
        var expected:String = '"100"';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_literal_false_case() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", ":false");
        var expected:String = 'false';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_literal_true_case() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", ":true");
        var expected:String = 'true';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_literal_typed_value() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "MyClass.value", BuilderKeyValueType.LITERAL);
        var expected:String = 'MyClass.value';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_hex_with_hashtag_should_start_with_0x() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "#FF");
        var expected:String = '0xFF';
        var result:String;
        
        // ACT
        result = value.getMacroValue();

        // ASSERT
        Assert.equals(expected, result);
    }

    function test_class_value_without_imports() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "<MyClass>");
        var valueImports:StringMap<BuilderImportData> = new StringMap<BuilderImportData>();

        var expected:String = "<MyClass>";
        var result:String;

        // ACT
        result = value.getClassValue(valueImports);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_class_value_with_one_class_alias() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "<MyClass>");
        var valueImports:StringMap<BuilderImportData> = [
            "MyClass" => {
                name : "full.MyClass",
                alias : "MyClass"
            }
        ];

        var expected:String = "<full.MyClass>";
        var result:String;

        // ACT
        result = value.getClassValue(valueImports);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_class_value_with_more_classes() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "<MyClass, OtherClass>");
        var valueImports:StringMap<BuilderImportData> = [
            "MyClass" => {
                name : "full.MyClass",
                alias : "MyClass"
            }
        ];

        var expected:String = "<full.MyClass, OtherClass>";
        var result:String;

        // ACT
        result = value.getClassValue(valueImports);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_class_value_with_full_class_with_alias() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "<MyClass, full.MyClass>");
        var valueImports:StringMap<BuilderImportData> = [
            "MyClass" => {
                name : "full.MyClass",
                alias : "MyClass"
            }
        ];

        var expected:String = "<full.MyClass, full.MyClass>";
        var result:String;

        // ACT
        result = value.getClassValue(valueImports);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_class_value_type_with_type() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "<Array<MyClass>>");
        var valueImports:StringMap<BuilderImportData> = [
            "MyClass" => {
                name : "full.MyClass",
                alias : "MyClass"
            }
        ];

        var expected:String = "<Array<full.MyClass>>";
        var result:String;

        // ACT
        result = value.getClassValue(valueImports);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_class_anonymous_type() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "<{x:MyClass}>");
        var valueImports:StringMap<BuilderImportData> = [
            "MyClass" => {
                name : "full.MyClass",
                alias : "MyClass"
            }
        ];

        var expected:String = "<{x:full.MyClass}>";
        var result:String;

        // ACT
        result = value.getClassValue(valueImports);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_class_anonymous_type_inside_other_annonymous() {
        // ARRANGE
        var value = new BuilderKeyValueData("key", "<{x:Array<{y:MyClass, z:other.MyClass}>}>");
        var valueImports:StringMap<BuilderImportData> = [
            "MyClass" => {
                name : "full.MyClass",
                alias : "MyClass"
            }
        ];

        var expected:String = "<{x:Array<{y:full.MyClass, z:other.MyClass}>}>";
        var result:String;

        // ACT
        result = value.getClassValue(valueImports);

        // ASSERT
        Assert.same(expected, result);
    }

    // function test_extract_all_class_names() {
    //     // ARRANGE
        
    //     var value = new BuilderKeyValueData("key", "<MyClass, Other12Class, Array<some.full.Path>, {xx : Int, y:MyClass, "y":Int}>");
        
    //     var valueImports = [
    //         "MyClass" => {
    //             name : "full.MyClass",
    //             alias : "MyClass"
    //         }
    //     ];
        

    //     var expected:Array<String> = ["MyClass", "Other12Class", "Array", "Int", "MyClass"];
    //     var result:Array<String>;

    //     // ACT
    //     result = value.extractClassCandidates();

    //     // ASSERT
    //     Assert.same(expected, result);
    // }
}