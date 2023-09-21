package unit;

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
        

        Report.create(runner);
        runner.run();
    }
}