package priori.view.grid.cell;

import priori.view.text.PriText;

class PriGridCellRendererDefault extends PriGridCellRenderer {

    private var label:PriText;


    public function new() {
        super();
        this.clipping = true;
    }

    override public function update():Void {
        if (this.canPaint()) {
            this.label.text = this.value;
        }
    }

    override private function setup():Void {
        this.label = new PriText();
        this.label.text = this.value;

        this.addChild(this.label);
    }

    override private function paint():Void {
        var space:Float = 10;

        this.label.x = space;
        this.label.centerY = this.height/2;
    }
}
