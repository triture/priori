package priori.view.builder;

import priori.event.PriEvent;
import priori.view.container.PriContainer;
import priori.view.PriDisplay;

@:autoBuild(priori.view.builder.PriBuilderMacros.build())
class PriBuilder extends PriContainer {

    public function new() {
        super();

        this.__priBuilderSetup();
        this.setup();

        this.__priBuilderPaint();
        this.paint();

        this.addEventListener(PriEvent.RESIZE, this.___onResize);
    }

    @:noCompletion
    private function ___onResize(e:PriEvent):Void {
        this.__priBuilderPaint();
        this.paint();
    }

    @:noCompletion
    private function __priBuilderSetup():Void {}

    @:noCompletion
    private function __priBuilderPaint():Void {}

    private function setup():Void {}

    private function paint():Void {}
}
