package priori.view.grid.row;

import priori.event.PriEvent;
import priori.view.grid.column.PriGridColumnSize;
import priori.view.grid.column.PriGridColumn;
import priori.view.grid.cell.PriGridCellRenderer;
import priori.view.container.PriGroup;

class PriGridRow extends PriGroup {

    @:isVar public var columns(default, set):Array<PriGridColumn>;
    @:isVar public var selection(default, set):Array<PriDataGridInterval>;
    @:isVar public var data(default, set):Dynamic;
    @:isVar public var rowIndex(default, set):Int;
    @:isVar public var rowColor(default, set):Int;

    private var cellList:Array<PriGridCellRenderer>;
    private var preCalc:PriGridColumnSize;

    public function new() {
        super();

        this.selection = null;
        this.cellList = [];
        this.clipping = false;
        this.rowColor = 0xFFFFFF;
    }

    override private function setup():Void {

    }

    override private function paint():Void {
        var h:Float = this.height;

        var i:Int = 0;
        var n:Int = this.cellList.length;
        var lastX:Float = 0;

        while (i < n) {
            this.cellList[i].width = this.preCalc.widthList[i];
            this.cellList[i].height = h;
            this.cellList[i].x = lastX;
            this.cellList[i].y = 0;

            lastX += this.preCalc.widthList[i];

            i++;
        }
    }

    public function applyPreCalcColumns(size:PriGridColumnSize):Void {
        this.preCalc = size;
    }

    @:noCompletion private function set_selection(value:Array<PriDataGridInterval>):Array<PriDataGridInterval> {
        this.selection = value;
        this.updateSelection();

        return value;
    }

    @:noCompletion private function set_data(value:Dynamic):Dynamic {
        this.data = value;
        this.updateData();

        return value;
    }

    @:noCompletion private function set_rowIndex(value:Int):Int {
        this.rowIndex = value;
        this.updateSelection();

        return value;
    }

    @:noCompletion private function set_rowColor(value:Int):Int {
        if (this.rowColor != value) {
            this.rowColor = value;
            this.bgColor = value;
        }

        return value;
    }

    @:noCompletion private function set_columns(value:Array<PriGridColumn>):Array<PriGridColumn> {
        if (this.columns != value) {
            var oldColumns:Array<PriGridColumn> = this.columns;

            this.columns = value;
            this.generateCells(oldColumns);
        }

        return value;
    }

    private function updateSelection():Void {
        if (this.cellList != null) {
            var i:Int = 0;
            var n:Int = this.cellList.length;

            while (i < n) {
                this.cellList[i].bgColor = null;
                i++;
            }

            if (this.selection != null && this.selection.length > 0) {
                i = 0;

                while (i < n) {
                    var cell:PriGridCellRenderer = this.cellList[i];

                    var j:Int = 0;
                    var m:Int = this.selection.length;

                    while (j < m) {
                        if (this.selection[j].contains(cell.colIndex, cell.rowIndex)) cell.bgColor = this.selection[j].color;
                        j++;
                    }

                    i++;
                }
            }
        }
    }

    private function updateData():Void {
        var i:Int = 0;
        var n:Int = this.cellList.length;

        while (i < n) {
            this.cellList[i].dispatchEvent(
                new PriEvent(PriEvent.CHANGE, false, false, {
                    data : this.data,
                    column : this.columns[i],
                    colIndex : i,
                    rowIndex : this.rowIndex
                })
            );

            i++;
        }

        this.updateSelection();
    }

    private function createCell(cellClass:Class<PriGridCellRenderer>, cellParams:Array<Dynamic>):PriGridCellRenderer {
        return Type.createInstance(cellClass, cellParams);
    }

    private function generateCells(oldColumns:Array<PriGridColumn>):Void {
        var u:Int = 0;
        var c:Int = 0;
        var log:String = "";

        if (oldColumns == null) oldColumns = [];

        log += oldColumns.length + ";";

        var oldCellList:Array<PriGridCellRenderer> = this.cellList;
        var newCellList:Array<PriGridCellRenderer> = [];

        if (this.columns == null) {
            log += "killcels;";
            this.killCells();
        } else {

            this.removeChildList(this.cellList);

            for (i in 0 ... this.columns.length) {

                var cell:PriGridCellRenderer = null;

                var cellClass:Class<PriGridCellRenderer> = this.columns[i].cellRenderer;
                var cellParams:Array<Dynamic> = this.columns[i].cellRendererParams;

//                log += cellClass + " " + cellParams + "; ";

                if (cellParams == null || cellParams.length == 0) {
                    for (j in 0 ... oldColumns.length) {
                        if (oldColumns[j].cellRenderer == cellClass && (oldColumns[j].cellRendererParams == null || oldColumns[j].cellRendererParams.length == 0)) {
                            cell = oldCellList[j];

                            oldColumns.splice(j, 1);
                            oldCellList.splice(j, 1);

                            u++;
                            break;
                        }
                    }
                }

                if (cell == null) {
                    c++;
                    cell = this.createCell(cellClass, cellParams);
                }

                newCellList.push(cell);
            }
        }

//        trace('$log - create $c used $u');

        this.cellList = newCellList;
        this.addChildList(newCellList);
        this.updateData();
    }


    private function killCells():Void {
        this.removeChildList(this.cellList);
        for (i in 0 ... this.cellList.length) this.cellList[i].kill();
        this.cellList = [];
    }

}
