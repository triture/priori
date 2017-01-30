package helper.pool;

import priori.view.grid.header.PriGridHeaderRenderer;

class PoolGridHead {

    public static var instance(default, null):PoolGridHead = new PoolGridHead();
    private function new() {}

    private var poolUsed:PoolMap<Class<PriGridHeaderRenderer>, PriGridHeaderRenderer> = new PoolMap();
    private var poolAvailable:PoolMap<Class<PriGridHeaderRenderer>, PriGridHeaderRenderer> = new PoolMap();

    public function createCell(cellClass:Class<PriGridHeaderRenderer>, cellParams:Array<Dynamic>):PriGridHeaderRenderer {
        var cell:PriGridHeaderRenderer = null;

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

    public function returnCell(cell:PriGridHeaderRenderer):Void {
        var cellClass:Class<PriGridHeaderRenderer> = this.poolUsed.getKeyOff(cell);

        if (cellClass != null) {
            this.poolUsed.remove(cellClass, cell);
            this.poolAvailable.add(cellClass, cell);
        } else {
            cell.kill();
        }
    }
}