package unit.runner;

import utest.Assert;
import helper.TerminalPrinter;
import utest.Test;

@:access(helper.TerminalPrinter)
class TestTerminalPrinter extends Test {

    function test_output_same_string_as_inserted() {
        // ARRANGE
        var result:String;
        var expectedResult:String = 'Hello World';

        // ACT
        result = TerminalPrinter.string('Hello World');

        // ASSERT
        Assert.equals(expectedResult, result);
    }

    function test_output_string_between_indicated_tags() {
        // ARRANGE
        var result:String;
        var expectedResult:String = '<b>Hello World</b>';

        // ACT
        result = TerminalPrinter.tag('[Hello World]', '[', '<b>', ']', '</b>');

        // ASSERT
        Assert.equals(expectedResult, result);
    }

    function test_output_terminal_red_text_formating() {
        // ARRANGE
        
        var result:String;
        var expectedResult:String = '\033[0;31mHello World\033[0m';

        // ACT
        result = TerminalPrinter.colorize('[red]Hello World[/red]');

        // ASSERT
        Assert.equals(expectedResult, result);
    }

}