package priori.view.grid.header;

import priori.style.font.PriFontStyle;
import priori.view.text.PriText;

class PriGridHeaderRendererDefault extends PriGridHeaderRenderer {

    private var label:PriText;


    public function new() {
        super();
    }

    override public function update():Void {
        if (this.canPaint()) {
            this.label.text = this.title;
        }
    }

    override private function setup():Void {
        this.bgColor = 0xCCCCCC;

        this.label = new PriText();
        this.label.autoSize = false;
        this.label.fontStyle = new PriFontStyle();
        this.label.text = this.title;
        this.label.height = null;

        this.addChild(this.label);
    }

    override private function paint():Void {
        var space:Float = 10;

        this.label.x = space;
        this.label.centerY = this.height/2;
        this.label.width = this.width - space*2;
    }

}
