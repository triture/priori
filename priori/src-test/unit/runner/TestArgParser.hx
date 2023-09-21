package unit.runner;

import utest.Assert;
import controller.ArgParser;
import model.ArgsCommand;
import model.ArgsData;
import utest.Test;

class TestArgParser extends Test {
    
    function test_result_basic_object_without_params() {
        // ARRANGE
        var resultObject:ArgsData;
        var expectedObject:ArgsData = {
            command : ArgsCommand.RUN,
            currPath : '.',
            prioriFile : 'priori.json',
            port : 7571,
            dList : [],
            noHash : false
        }
        // ACT
        resultObject = ArgParser.parse([]);

        // ASSERT
        Assert.same(expectedObject, resultObject, true);
    }

    function test_result_basic_object_without_params_with_other_command() {
        // ARRANGE
        var resultObject:ArgsData;
        var expectedObject:ArgsData = {
            command : ArgsCommand.CREATE,
            currPath : '.',
            prioriFile : 'priori.json',
            port : 7571,
            dList : [],
            noHash : false
        }
        // ACT
        resultObject = ArgParser.parse(['create']);

        // ASSERT
        Assert.same(expectedObject, resultObject, true);
    }

    function test_raises_error_on_invalid_command() {
        // ASSERT
        Assert.raises(ArgParser.parse.bind(['no-command']));
    }

    function test_raises_error_on_invalid_param_quantity() {
        // ASSERT
        Assert.raises(ArgParser.parse.bind(['run', '-extra-param']));
    }

    function test_full_set_of_data() {
        // ARRANGE
        var resultObject:ArgsData;
        var expectedObject:ArgsData = {
            command : ArgsCommand.RUN,
            currPath : './new_path',
            prioriFile : 'priori-test.json',
            port : 8080,
            dList : ['el1', 'el2'],
            noHash : true
        }
        
        // ACT
        resultObject = ArgParser.parse([
            'run',
            '-D', 'el1',
            '-D', 'el2',
            '-f', 'priori-test.json',
            '-p', './new_path',
            '-port', '8080',
            '-nohash', 'true'
        ]);

        // ASSERT
        Assert.same(expectedObject, resultObject, true);
    }

}