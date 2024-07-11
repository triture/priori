package unit;

import unit.builder.TestBuilderHelperExtractAttributes;
import unit.builder.TestBuilderPropertyValue;
import unit.builder.TestBuilderIntepreterViewsProperty;
import unit.builder.TestBuilderIntepreterViews;
import unit.builder.TestBuilderIntepreterImports;
import unit.runner.TestArgParser;
import unit.runner.TestTerminalPrinter;
import utest.ui.Report;
import utest.Runner;

class PrioriUnitTest {

    static public function main() new PrioriUnitTest();

    public function new() {
        var runner = new Runner();

        runner.addCase(new TestTerminalPrinter());
        runner.addCase(new TestArgParser());

        runner.addCase(new TestBuilderIntepreterImports());
        runner.addCase(new TestBuilderIntepreterViews());
        runner.addCase(new TestBuilderIntepreterViewsProperty());
        runner.addCase(new TestBuilderPropertyValue());
        runner.addCase(new TestBuilderHelperExtractAttributes());
        

        Report.create(runner);
        runner.run();
    }
}