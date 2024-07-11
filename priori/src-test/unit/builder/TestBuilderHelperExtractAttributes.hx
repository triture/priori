package unit.builder;

import utest.Assert;
import builder.helper.BuilderMacroHelper;
import utest.Test;

class TestBuilderHelperExtractAttributes extends Test {
    
    function test_extract_one_attribute() {
        // ARRANGE
        var value:Xml = Xml.parse('<node a="1" />').firstElement();
        var expected = [
            {key: 'a', value: '1'}
        ];

        var result;

        // ACT
        result = BuilderMacroHelper.extractAttributesInOrder(value);

        // ASSERT
        Assert.same(expected, result);
    }

    function test_extract_two_attribute() {
        // ARRANGE
        var value:Xml = Xml.parse('<node a="1" b = "2" />').firstElement();
        var expected = [
            {key: 'a', value: '1'},
            {key: 'b', value: '2'}
        ];

        var result;

        // ACT
        result = BuilderMacroHelper.extractAttributesInOrder(value);

        // ASSERT
        Assert.same(expected, result);
    }

    // function test_extract_two_attribute_in_other_order() {
    //     // ARRANGE
    //     var value:Xml = Xml.parse('<node b = "2" a="1" />').firstElement();
    //     var expected = [
    //         {key: 'b', value: '2'},
    //         {key: 'a', value: '1'}
    //     ];

    //     var result;

    //     // ACT
    //     result = BuilderMacroHelper.extractAttributesInOrder(value);

    //     // ASSERT
    //     Assert.same(expected, result);
    // }
}