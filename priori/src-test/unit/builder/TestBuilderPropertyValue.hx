package unit.builder;

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
}