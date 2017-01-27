package helper.pool;

import priori.view.grid.cell.PriGridCellRenderer;

class PoolGridCell {

    public static var instance(default, null):PoolGridCell = new PoolGridCell();
    private function new() {}

    private var used:Array<{ref:PriGridCellRenderer, cls:Class<PriGridCellRenderer>}> = [];
    private var available:Array<{ref:PriGridCellRenderer, cls:Class<PriGridCellRenderer>}> = [];

    public function createCell(cellClass:Class<PriGridCellRenderer>, cellParams:Array<Dynamic>):PriGridCellRenderer {
        var cell:PriGridCellRenderer = null;

        if (cellParams == null || cellParams.length == 0) {
            var item:Dynamic = this.locateByClass(this.available, cellClass);

            if (item != null) {
                cell = item.ref;

                this.available.remove(item);
                this.used.push(item);
            }
        }

        if (cell == null) {
            cell = Type.createInstance(cellClass, cellParams == null ? [] : cellParams);

            if (cellParams == null || cellParams.length == 0) {
                this.used.push({
                    ref : cell,
                    cls : cellClass
                });
            }
        }

        return cell;
    }

    public function returnCell(cell:PriGridCellRenderer):Void {
        var item:Dynamic = this.locateByRef(this.used, cell);

        if (item != null) {
            this.used.remove(item);
            this.available.push(item);
        } else {
            cell.kill();
        }
    }

    private function locateByClass(arr:Array<Dynamic>, cellClass:Class<PriGridCellRenderer>):Dynamic {
        for (i in 0 ... arr.length) {
            if (arr[i].cls == cellClass) {
                return arr[i];
            }
        }

        return null;
    }

    private function locateByRef(arr:Array<Dynamic>, ref:PriGridCellRenderer):Dynamic {
        for (i in 0 ... arr.length) {
            if (arr[i].ref == ref) {
                return arr[i];
            }
        }

        return null;
    }
}