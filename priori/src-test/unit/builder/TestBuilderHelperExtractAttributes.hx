package unit.builder;

import utest.Assert;
import builder.helper.BuilderMacroHelper;
import utest.Test;

class TestBuilderHelperExtractAttributes extends Test {
    
    function test_extract_one_key() {
        // ARRANGE
        var value:Xml = Xml.parse('<node a="1" />').firstElement();
        var expected = [{att: 'a', value: '1'}];
        var result;

        // ACT
        result = BuilderMacroHelper.extractAttributes(value);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_extract_two_attribute() {
        // ARRANGE
        var value:Xml = Xml.parse('<node a="1" b="2" />').firstElement();
        var expected = [
            {att: 'a', value: '1'},
            {att: 'b', value: '2'}
        ];

        var result;

        // ACT
        result = BuilderMacroHelper.extractAttributes(value);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_extract_two_attribute_in_forced_order() {
        // ARRANGE
        var value:Xml = Xml.parse('<node 2:a="1" 1:b="2" />').firstElement();
        var expected = [
            {att: 'b', value: '2'},
            {att: 'a', value: '1'}
        ];

        var result;

        // ACT
        result = BuilderMacroHelper.extractAttributes(value);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_extract_two_attribute_in_forced_order_only_with_numbers() {
        // ARRANGE
        var value:Xml = Xml.parse('<node a:a="1" b:b="2" />').firstElement();
        var expected = [
            {att: 'a:a', value: '1'},
            {att: 'b:b', value: '2'}
        ];

        var result;

        // ACT
        result = BuilderMacroHelper.extractAttributes(value);

        // ASSERT
        Assert.same(expected, result);
    }
    
}