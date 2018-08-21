package priori.scene.view;

import priori.view.PriDisplay;

class PriPreloaderViewDefault extends PriPreloaderView {

    private var bar:PriDisplay;

    public function new() {
        super();
    }

    override public function setup():Void {
        this.bar = new PriDisplay();
        this.bar.bgColor = 0xCCCCCC;
        this.addChild(this.bar);
    }

    override public function paint():Void {
        this.bar.height = 20;
        this.bar.x = 0;
        this.bar.centerY = this.height/2;
    }

    override public function updateProgress(percent:Float):Void {
        if (this.bar != null) {
            this.bar.width = this.width * percent;
        }
    }

}
