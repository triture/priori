package priori.view.grid.header;

import priori.view.grid.column.PriGridColumnSort;
import priori.view.container.PriGroup;

class PriGridHeaderSortCaret extends PriGroup {

    @:isVar public var order(default, set):PriGridColumnSortOrder;

    public function new() {
        super();

        this.width = null;
        this.height = null;

        this.order = PriGridColumnSortOrder.NONE;
    }

    public function toogle():Void {
        if (this.order == PriGridColumnSortOrder.NONE) {
            this.order = PriGridColumnSortOrder.ASC;
        } else if (this.order == PriGridColumnSortOrder.ASC) {
            this.order = PriGridColumnSortOrder.DESC;
        } else if (this.order == PriGridColumnSortOrder.DESC) {
            this.order = PriGridColumnSortOrder.NONE;
        }
    }

    function set_order(value:PriGridColumnSortOrder):PriGridColumnSortOrder {
        this.order = value;

        this.invalidate();
        this.validate();

        return value;
    }


}