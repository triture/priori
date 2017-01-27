package helper.pool;

import priori.view.grid.header.PriGridHeaderRenderer;

class PoolGridHead {

    public static var instance(default, null):PoolGridHead = new PoolGridHead();
    private function new() {}

    private var used:Array<{ref:PriGridHeaderRenderer, cls:Class<PriGridHeaderRenderer>}> = [];
    private var available:Array<{ref:PriGridHeaderRenderer, cls:Class<PriGridHeaderRenderer>}> = [];

    public function createCell(cellClass:Class<PriGridHeaderRenderer>, cellParams:Array<Dynamic>):PriGridHeaderRenderer {
        var cell:PriGridHeaderRenderer = null;

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

    public function returnCell(cell:PriGridHeaderRenderer):Void {
        var item:Dynamic = this.locateByRef(this.used, cell);

        if (item != null) {
            this.used.remove(item);
            this.available.push(item);
        } else {
            cell.kill();
        }
    }

    private function locateByClass(arr:Array<Dynamic>, cellClass:Class<PriGridHeaderRenderer>):Dynamic {
        for (i in 0 ... arr.length) {
            if (arr[i].cls == cellClass) {
                return arr[i];
            }
        }

        return null;
    }

    private function locateByRef(arr:Array<Dynamic>, ref:PriGridHeaderRenderer):Dynamic {
        for (i in 0 ... arr.length) {
            if (arr[i].ref == ref) {
                return arr[i];
            }
        }

        return null;
    }
}