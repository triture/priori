package priori.view.grid.header;

import priori.view.text.PriText;
import priori.view.grid.column.PriGridColumnSort;

class PriGridHeaderSortCaretDefault extends PriGridHeaderSortCaret {

    private var down:PriText;
    private var up:PriText;

    public function new() {
        super();

        this.width = null;
        this.height = null;

        this.order = PriGridColumnSortOrder.NONE;
    }

    override private function setup():Void {
        this.down = new PriText();
        this.down.fontSize = 10;
        this.down.text = "▼";
        this.addChild(this.down);

        this.up = new PriText();
        this.up.fontSize = 10;
        this.up.text = "▲";
        this.addChild(this.up);
    }

    override private function paint():Void {
        var curOrder:PriGridColumnSortOrder = this.order;

        if (curOrder == PriGridColumnSortOrder.NONE) {
            this.up.alpha = 1;
            this.down.alpha = 1;

        } else if (curOrder == PriGridColumnSortOrder.ASC) {
            this.up.alpha = 0.3;
            this.down.alpha = 1;

        } else if (curOrder == PriGridColumnSortOrder.DESC) {
            this.up.alpha = 1;
            this.down.alpha = 0.3;
        }

        this.down.x = 0;
        this.down.centerY = this.centerY;

        this.up.x = this.down.maxX - 3;
        this.up.centerY = this.centerY;

        this.width = this.up.maxX;
    }

}