package priori.view.grid.row;

import helper.pool.PoolGridCell;
import priori.view.grid.cell.PriGridCellRenderer;
import haxe.ds.HashMap;
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
        var lastX:Float = 0;

        if (this.preCalc != null && this.preCalc.widthList.length == this.cellList.length) {
            for (i in 0 ... this.cellList.length) {
                this.cellList[i].width = this.preCalc.widthList[i];
                this.cellList[i].height = h;
                this.cellList[i].x = lastX;
                this.cellList[i].y = 0;

                lastX += this.preCalc.widthList[i];
            }
        }
    }

    public function applyPreCalcColumns(size:PriGridColumnSize):Void {
        this.preCalc = size;
    }

    private function set_selection(value:Array<PriDataGridInterval>):Array<PriDataGridInterval> {
        this.selection = value;
        this.updateSelection();

        return value;
    }

    private function set_data(value:Dynamic):Dynamic {
        this.data = value;
        this.updateData();

        return value;
    }

    private function set_rowIndex(value:Int):Int {
        this.rowIndex = value;
        this.updateSelection();

        return value;
    }

    private function set_rowColor(value:Int):Int {
        if (this.rowColor != value) {
            this.rowColor = value;
            this.bgColor = value;
        }

        return value;
    }

    private function set_columns(value:Array<PriGridColumn>):Array<PriGridColumn> {
        if (this.columns != value) {
            this.columns = value;
            this.generateCells();
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

        var e:PriEvent = new PriEvent(
            PriEvent.CHANGE, false, false,
            {
                data : this.data,
                column : null,
                colIndex : null,
                rowIndex : this.rowIndex
            }
        );

        for (i in 0 ... this.cellList.length) {
            e.data.column = this.columns[i];
            e.data.colIndex = i;
            this.cellList[i].dispatchEvent(e);
        }

        this.updateSelection();
    }


    private function generateCells():Void {
        this.killCells();

        for (i in 0 ... this.columns.length) {
            var cellClass:Class<PriGridCellRenderer> = this.columns[i].cellRenderer;
            var cellParams:Array<Dynamic> = this.columns[i].cellRendererParams;

            var cell:PriGridCellRenderer = PoolGridCell.instance.createCell(cellClass, cellParams);

            this.cellList.push(cell);
        }

        this.addChildList(this.cellList);
        this.updateData();
    }

    private function killCells():Void {
        this.removeChildList(this.cellList);
        for (i in 0 ... this.cellList.length) PoolGridCell.instance.returnCell(this.cellList[i]);
        this.cellList = [];
    }

}