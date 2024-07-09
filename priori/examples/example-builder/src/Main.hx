package ;

import priori.app.PriApp;


class Main extends PriApp {

    public function new() {
        super();
    }

    static public function main():Void new Main();

    override private function setup():Void {
        var builder:BuilderTest = new BuilderTest();
        this.addChildList([
            builder
        ]);
    }

}
