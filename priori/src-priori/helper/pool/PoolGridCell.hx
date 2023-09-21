package helper.pool;

import priori.view.grid.cell.PriGridCellRenderer;

class PoolGridCell {

    public static var instance(default, null):PoolGridCell = new PoolGridCell();

    private function new() {}

    private var poolUsed:PoolMap<Class<PriGridCellRenderer>, PriGridCellRenderer> = new PoolMap();
    private var poolAvailable:PoolMap<Class<PriGridCellRenderer>, PriGridCellRenderer> = new PoolMap();

    public function createCell(cellClass:Class<PriGridCellRenderer>, cellParams:Array<Dynamic>):PriGridCellRenderer {
        var cell:PriGridCellRenderer = null;

        if (cellParams == null || cellParams.length == 0) {
            cell = this.poolAvailable.get(cellClass);
            this.poolUsed.add(cellClass, cell);
        }

        if (cell == null) {
            cell = Type.createInstance(cellClass, cellParams == null ? [] : cellParams);

            if (cellParams == null || cellParams.length == 0) {
                this.poolUsed.add(cellClass, cell);
            }
        }

        return cell;
    }

    public function returnCell(cell:PriGridCellRenderer):Void {
        var cellClass:Class<PriGridCellRenderer> = this.poolUsed.getKeyOff(cell);

        if (cellClass != null) {
            this.poolUsed.remove(cellClass, cell);
            this.poolAvailable.add(cellClass, cell);
        } else {
            cell.kill();
        }
    }
}