package priori.view.grid;

import priori.system.PriDeviceBrowser;
import priori.system.PriDevice;
import priori.event.PriEvent;
import priori.event.PriMouseEvent;
import priori.app.PriApp;
import haxe.Timer;
import priori.view.grid.column.PriGridColumnSort;
import priori.style.border.PriBorderStyle;
import priori.event.PriTapEvent;
import priori.view.grid.header.PriGridHeader;
import priori.view.grid.column.PriGridColumnSize;
import priori.view.grid.column.PriGridColumn;
import priori.view.grid.row.PriGridRow;
import priori.view.container.PriContainer;
import priori.view.container.PriScrollableContainer;
import priori.view.container.PriGroup;

class PriDataGrid extends PriGroup {

    @:isVar public var selection(default, set):Array<PriDataGridInterval>;

    @:isVar public var data(default, set):Array<Dynamic>;
    @:isVar public var columns(default, set):Array<PriGridColumn>;
    @:isVar public var rowHeight(default, set):Float;
    @:isVar public var headerHeight(default, set):Float;

    @:isVar public var verticalGridLines(default, set):Bool;
    @:isVar public var verticalGridLineColor(default, set):Int;
    @:isVar public var horizontalGridLines(default, set):Bool;
    @:isVar public var horizontalGridLineColor(default, set):Int;
    @:isVar public var rowPointer(default, set):Bool;
    @:isVar public var rowColorSequence(default, set):Array<Int>;

    public var asyncRow:Bool = true;

    private var header:PriGridHeader;

    private var verticalLinesList:Array<PriDisplay>;
    private var scrollerContainer:PriScrollableContainer;

    private var __timer_insetionFlow:Timer;
    private var __timer_timeToGenerate:Timer;

    private var __data_originalList:Array<Dynamic>;
    private var __data_waitingInsertion:Array<Dynamic>;
    private var __rowContainer:PriContainer;
    private var __usedRows:Array<PriGridRow>;
    private var __pooledRows:Array<PriGridRow>;

    private var __rowAutoSize:Bool;

    private var sort:PriGridColumnSort;

    private var __renderRowIndexStart:Int;
    private var __renderRowIndexEnd:Int;

    @:isVar public var scrollY(get, set):Float;
    @:isVar public var maxScrollY(get, null):Float;

    public function new() {
        super();

        this.rowHeight = 40;
        this.headerHeight = 40;

        this.verticalLinesList = [];
        this.selection = null;

        this.sort = new PriGridColumnSort();

        this.header = new PriGridHeader();
        this.scrollerContainer = new PriScrollableContainer();
        this.scrollerContainer.addEventListener(PriEvent.SCROLL, onScroll);

        this.__renderRowIndexStart = -1;
        this.__renderRowIndexEnd = -1;

        this.__data_originalList = [];
        this.__data_waitingInsertion = [];
        this.__usedRows = [];
        this.__pooledRows = [];
        this.__rowContainer = new PriContainer();
        this.__rowContainer.clipping = false;

        this.horizontalGridLines = true;
        this.verticalGridLines = true;

        this.horizontalGridLineColor = 0xDDDDDD;
        this.verticalGridLineColor = 0xDDDDDD;

        this.border = new PriBorderStyle();
        this.rowPointer = true;

        this.rowColorSequence = [0xFFFFFF];

        this.bgColor = 0xFFFFFF;


        this.addEventListener(PriDataGridEvent.SORT, this.onDataGridSort);
    }

    @:noCompletion private function set_scrollY(value:Float) {
        if (this.scrollerContainer != null) this.scrollerContainer.scrollY = value;
        return value;
    }

    @:noCompletion private function get_scrollY():Float {
        if (this.scrollerContainer != null) return this.scrollerContainer.scrollY;
        return 0;
    }

    @:noCompletion private function get_maxScrollY():Float {
        if (this.scrollerContainer != null) return this.scrollerContainer.maxScrollY;
        return 0;
    }

    private function onDataGridSort(e:PriDataGridEvent):Void {
        e.stopBubble();
        e.stopPropagation();

        var field:String = e.data.field;
        var order:PriGridColumnSortOrder = e.data.order;

        sort.order = order;
        sort.dataField = field;

        this.data = __data_originalList;
    }

    public function resetSort():Void {
        this.header.applySort("", PriGridColumnSortOrder.NONE);
    }

    public function applySort(field:String, order:PriGridColumnSortOrder):Void {
        this.header.applySort(field, order);
    }

    override private function setup():Void {
        this.addChild(this.header);
        this.addChild(this.scrollerContainer);
        this.scrollerContainer.addChild(this.__rowContainer);
    }

    override private function paint():Void {

        this.header.width = this.width;
        this.header.height = this.headerHeight;


        this.scrollerContainer.x = 0;
        this.scrollerContainer.y = this.headerHeight;
        this.scrollerContainer.width = this.width;
        this.scrollerContainer.height = this.height - this.headerHeight;

        this.generateRows();
        this.organizeRowPosition();

        var i:Int = 0;
        var n:Int = this.__usedRows.length;
        var rowSizes:PriGridColumnSize = PriGridColumnSize.calculate(this.width, this.columns);

        while (i < n) {
            this.__usedRows[i].x = 0;
            this.__usedRows[i].applyPreCalcColumns(rowSizes);

            this.__usedRows[i].width = this.width;
            this.__usedRows[i].validate();

            i++;
        }

        this.__rowContainer.x = 0;
        this.__rowContainer.y = 0;
        this.__rowContainer.width = this.scrollerContainer.width;

        this.updateVerticalLines();
    }

    private function updateRowContainerHeight():Void {
        var rowHeightCalculated = this.calculateRowHeight();
        var n:Int = this.data == null ? 0 : this.data.length;

        if (this.horizontalGridLines) {
            this.__rowContainer.height = n*(rowHeightCalculated.all + 1) - 1;
        } else {
            this.__rowContainer.height = n*rowHeightCalculated.all;
        }
    }

    private function organizeRowPosition():Void {
        var i:Int = 0;
        var n:Int = this.__usedRows.length;

        var rowHeightCalculated = this.calculateRowHeight();

        while (i < n) {

            var index:Int = this.__usedRows[i].rowIndex;

            if (this.horizontalGridLines) {
                this.__usedRows[i].y = (rowHeightCalculated.all + 1) * index;
            } else {
                this.__usedRows[i].y = rowHeightCalculated.all * index;
            }

            this.__usedRows[i].height = index == n-1 ? rowHeightCalculated.last : rowHeightCalculated.all;
            this.__usedRows[i].rowColor = this.rowColorSequence[index % this.rowColorSequence.length];

            i++;
        }

        this.updateRowContainerHeight();
    }

    private function updateVerticalLines():Void {
        var columnSize = PriGridColumnSize.calculate(this.width, this.columns);

        var oldVerticalLines:Array<PriDisplay> = this.verticalLinesList;

        this.verticalLinesList = [];

        if (this.verticalGridLines) {

            var lastX:Float = 0;
            var h:Float = this.height;

            for (i in 0 ... columnSize.widthList.length - 1) {

                this.verticalLinesList.push(
                    oldVerticalLines.length > 0 ?
                    oldVerticalLines.shift() :
                    new PriDisplay()
                );

                this.verticalLinesList[i].width = 1;
                this.verticalLinesList[i].height = h;

                lastX = lastX + columnSize.widthList[i];
                this.verticalLinesList[i].x = lastX;
                this.verticalLinesList[i].bgColor = this.verticalGridLineColor;
            }
        }

        this.addChildList(this.verticalLinesList);
        this.removeChildList(oldVerticalLines);
    }

    public function getTotalRows():Int {
        return this.data.length;
    }

    public function getTotalCols():Int {
        return this.columns.length;
    }

    public function selectRow(rowIndex:Int, color:Int = 0x00FF00):Void {
        this.selection = [
            new PriDataGridInterval(
                0,          // col
                rowIndex,   // row
                999999999,  // col len
                1,          // row len
                color
            )
        ];
    }

    public function selectCol(colIndex:Int, color:Int = 0x00FF00):Void {
        this.selection = [
            new PriDataGridInterval(
                colIndex,   // col
                0,          // row
                1,          // col len
                999999999,   // row len
                color
            )
        ];
    }

    @:noCompletion private function set_selection(value:Array<PriDataGridInterval>):Array<PriDataGridInterval> {
        this.selection = value;

        var i:Int = 0;
        var n:Int = this.__usedRows == null ? 0 : this.__usedRows.length;

        while (i < n) {
            this.__usedRows[i].selection = value;
            i++;
        }

        return value;
    }

    @:noCompletion private function set_rowColorSequence(value:Array<Int>) {
        if (value.length > 0) {
            this.rowColorSequence = value;
        } else {
            this.rowColorSequence = [0xFFFFFF];
        }

        this.organizeRowPosition();
        return value;
    }

    @:noCompletion private function set_rowPointer(value:Bool):Bool {
        this.rowPointer = value;

        var i:Int = 0;
        var n:Int = this.__usedRows.length;

        while (i < n) {
            this.__usedRows[i].pointer = value;
            i++;
        }

        return value;
    }

    @:noCompletion private function set_verticalGridLines(value:Bool) {
        this.verticalGridLines = value;
        this.invalidate();
        return value;
    }

    @:noCompletion private function set_verticalGridLineColor(value:Int):Int {
        this.verticalGridLineColor = value;
        this.invalidate();
        return value;
    }

    @:noCompletion private function set_horizontalGridLines(value:Bool) {
        this.horizontalGridLines = value;
        this.invalidate();
        return value;
    }

    @:noCompletion private function set_horizontalGridLineColor(value:Int):Int {
        this.horizontalGridLineColor = value;
        this.__rowContainer.bgColor = value;
        return value;
    }

    @:noCompletion private function set_rowHeight(value:Float):Float {
        this.rowHeight = value;

        if (value == null || value < 0) {
            this.__rowAutoSize = true;
        } else {
            this.__rowAutoSize = false;
        }

        this.invalidate();
        return value;
    }

    @:noCompletion private function set_headerHeight(value:Float):Float {
        if (value == null || value < 0) {
            this.headerHeight = 40;
        } else {
            this.headerHeight = value;
        }

        this.invalidate();
        return value;
    }


    @:noCompletion private function set_data(value:Array<Dynamic>):Array<Dynamic> {
        this.__renderRowIndexStart = -1;
        this.__renderRowIndexEnd = -1;

        this.__data_originalList = value;

        var sortedList:Array<Dynamic> = this.sort.sort(value.copy());

        this.data = sortedList.copy();

        if (this.canPaint()) this.generateRows();
        return value;
    }



    @:noCompletion private function set_columns(value:Array<PriGridColumn>):Array<PriGridColumn> {
        this.columns = value;

        this.sort.dataField = "";
        this.sort.order = PriGridColumnSortOrder.NONE;

        this.applyColumnToRows();
        this.applyColumnToHeader();
        this.updateVerticalLines();

        // update data to new columns
        this.data = __data_originalList;

        return value;
    }


    private function applyColumnToHeader():Void {
        this.header.columns = this.columns;
    }

    private function applyColumnToRows():Void {
        var i:Int = 0;
        var n:Int = this.__usedRows.length;

        while (i < n) {
            this.__usedRows[i].columns = this.columns;

            i++;
        }
    }

    private function calculateRowHeight():{all:Float, last:Float} {
        if (this.__rowAutoSize) {
            if (this.data == null) return {all : 0, last : 0};

            var freeSpace:Float = this.scrollerContainer.height - (this.horizontalGridLines ? (this.data.length - 1) : 0);

            var all:Float = Math.ffloor(freeSpace / this.data.length);
            var last:Float = Math.ffloor(freeSpace - all * (this.data.length - 1));

            return {all : all, last : last};
        }

        return {all : this.rowHeight, last : this.rowHeight};
    }

    private var timeStart:Float;

    private function onScroll(e:PriEvent):Void {
        this.generateRows();
    }

    private var lastRenderTime:Float = 0;

    private function generateRows():Void {
        if (this.__timer_timeToGenerate != null) {
            this.__timer_timeToGenerate.stop();
            this.__timer_timeToGenerate = null;
        }

        // todo : another way to better performance on firefox ???
        // https://developer.mozilla.org/en-US/docs/Mozilla/Performance/Scroll-linked_effects
        if (PriDevice.browser() == PriDeviceBrowser.MOZILLA) {

            this.updateRowContainerHeight();

            if (Date.now().getTime() - this.lastRenderTime > 300) {
                this.generateRowsRun();
            } else {
                this.__timer_timeToGenerate = haxe.Timer.delay(this.generateRowsRun, 30);
            }
        } else {
            this.generateRowsRun();
        }
    }

    private function generateRowsRun():Void {
        this.lastRenderTime = Date.now().getTime();

        var scrollPos:Float = this.scrollerContainer.scrollY;
        var viewHeight:Float = this.scrollerContainer.height;

        var itemHeight:Float = this.calculateRowHeight().all + (this.horizontalGridLines ? 1 : 0);
        var totalItens:Int = this.data == null ? 0 : this.data.length;

        var offsetItens:Int = 4;
        var itensPerView:Int = Math.floor(viewHeight / itemHeight) + offsetItens;

        var i:Int = 0;
        var n:Int = 0;

        i = Math.floor((scrollPos / itemHeight) - offsetItens/2);
        n = i + itensPerView;

        if (i < 0) i = 0;
        if (n > totalItens) n = totalItens;

        if (i != this.__renderRowIndexStart || n != this.__renderRowIndexEnd) {
            this.__renderRowIndexStart = i;
            this.__renderRowIndexEnd = n;

            this.__data_waitingInsertion = [];

            while (i < n) {
                this.__data_waitingInsertion.push(this.data[i]);

                i++;
            }

            // set all rows to pool
            for (j in 0...this.__usedRows.length) {
                this.__pooledRows.unshift(this.__usedRows[j]);
            }

            this.__usedRows = [];

            this.generateRowsBatch(this.__renderRowIndexStart);
        }
    }

    private function generateRowsBatch(indexStart:Int):Void {
        this.killInsertionTimer();

        var maxTime:Float = 150;
        var startTime:Float = Date.now().getTime();

        var i:Int = 0;
        var n:Int = this.__data_waitingInsertion.length;

        var gridRow:PriGridRow = null;
        var rowSizes:PriGridColumnSize = PriGridColumnSize.calculate(this.width, this.columns);
        var rowHeightCalculated = this.calculateRowHeight();

        while (i < n) {
            var item:Dynamic = this.__data_waitingInsertion.shift();

            if (this.__pooledRows.length > 0) {
                gridRow = this.__pooledRows.shift();
            } else {
                gridRow = new PriGridRow();
            }

            this.__usedRows.push(gridRow);

            gridRow.applyPreCalcColumns(rowSizes);
            gridRow.rowIndex = indexStart;
            gridRow.columns = this.columns;
            gridRow.data = item;
            gridRow.width = this.width;
            gridRow.height = indexStart == this.data.length-1 ? rowHeightCalculated.last : rowHeightCalculated.all;
            gridRow.selection = this.selection;
            gridRow.pointer = this.rowPointer;

            if (gridRow.parent == null) this.__rowContainer.addChild(gridRow);

            gridRow.validate();

            i++;
            indexStart++;

            if (this.asyncRow == true && (Date.now().getTime() - startTime) > maxTime) {
                i = n;
            }
        }

        // REMOVE UNUSED ROWS
        this.organizeRowPosition();

        if (this.__data_waitingInsertion.length > 0) {
            this.__timer_insetionFlow = Timer.delay(function():Void {
                this.generateRowsBatch(indexStart);
            }, PriApp.g().getMSUptate());
        } else {
            this.removeRows(this.__pooledRows);

            #if debug
            trace("Grid Rendering Time : " + (Date.now().getTime() - this.timeStart));
            #end
        }
    }

    private function killInsertionTimer():Void {
        if (this.__timer_insetionFlow != null) {
            this.__timer_insetionFlow.stop();
            this.__timer_insetionFlow = null;
        }
    }

    private function removeRows(rowListToRemove:Array<PriGridRow> = null):Void {
        this.killInsertionTimer();

        var rowList:Array<PriGridRow> = rowListToRemove == null ? this.__usedRows : rowListToRemove;

        var i:Int = 0;
        var n:Int = rowList.length;

        while (i < n) {

            var item:PriGridRow = rowList.shift();
            this.__pooledRows.push(item);
            this.__rowContainer.removeChild(item);

            i++;
        }
    }

    override public function kill():Void {
        removeRows();

        if (this.__timer_timeToGenerate != null) {
            this.__timer_timeToGenerate.stop();
            this.__timer_timeToGenerate = null;
        }

        var i:Int = 0;
        var n:Int = this.__pooledRows.length;

        while (i < n) {

            this.__pooledRows[i].kill();

            i++;
        }

        this.__pooledRows = [];

        super.kill();
    }
}