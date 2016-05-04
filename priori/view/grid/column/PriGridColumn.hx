package priori.view.grid.column;

import priori.view.grid.header.PriGridHeaderSortCaretDefault;
import priori.view.grid.header.PriGridHeaderSortCaret;
import priori.view.grid.column.PriGridColumnSize.PriGridColumnSizeType;
import priori.view.grid.header.PriGridHeaderRenderer;
import priori.view.grid.header.PriGridHeaderRendererDefault;
import priori.view.grid.cell.PriGridCellRendererDefault;
import priori.view.grid.cell.PriGridCellRenderer;

class PriGridColumn {

    public var title:String;
    public var dataField:String;
    public var cellRenderer:Class<PriGridCellRenderer>;
    public var headerRenderer:Class<PriGridHeaderRenderer>;
    public var headerSortCaret:Class<PriGridHeaderSortCaret>;

    public var cellRendererParams:Array<Dynamic>;
    public var headerRendererParams:Array<Dynamic>;

    public var width:Float;
    public var sizeType:PriGridColumnSizeType;

    public var sortable:Bool;

    public function new(
        title:String,
        dataField:String,
        ?cellRenderer:Class<PriGridCellRenderer> = null,
        ?headerRenderer:Class<PriGridHeaderRenderer> = null,
        ?sizeType:PriGridColumnSizeType = null,
        ?width:Float = 100,
        ?cellRendererParams:Array<Dynamic> = null,
        ?headerRendererParams:Array<Dynamic> = null,
        ?sortable:Bool = null
    ) {

        this.title = title;
        this.dataField = dataField;

        this.cellRendererParams = cellRendererParams;
        if (this.cellRendererParams == null) this.cellRendererParams = [];

        this.headerRendererParams = headerRendererParams;
        if (this.headerRendererParams == null) this.headerRendererParams = [];

        if (cellRenderer == null) {
            this.cellRenderer = PriGridCellRendererDefault;
        } else {
            this.cellRenderer = cellRenderer;
        }

        this.headerSortCaret = PriGridHeaderSortCaretDefault;

        if (headerRenderer == null) {
            this.headerRenderer = PriGridHeaderRendererDefault;
        } else {
            this.headerRenderer = headerRenderer;
        }

        if (sizeType == null) {
            this.sizeType = PriGridColumnSizeType.FIT;
        } else {
            this.sizeType = sizeType;
        }

        if (sortable == null) {
            this.sortable = true;
        } else {
            this.sortable = sortable;
        }

        this.width = width;
    }
}
