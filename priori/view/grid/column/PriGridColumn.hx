package priori.view.grid.column;

import priori.view.grid.row.PriGridRow;
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
        this.setCellRenderer(cellRenderer);
        this.setHeadRenderer(headerRenderer);
        this.setSizeType(sizeType);
        this.setSortable(sortable);

        this.setCellRendererParams(cellRendererParams);
        this.setHeadRendererParams(headerRendererParams);

        this.setHeaderSortCaret(null);

        this.setWidth(width);
        this.setTitle(title);
        this.setDatafield(dataField);
    }

    public function setTitle(value:String):PriGridColumn {
        this.title = value;
        return this;
    }

    public function setDatafield(value:String):PriGridColumn {
        this.dataField = value;
        return this;
    }

    public function setCellRenderer(value:Class<PriGridCellRenderer>):PriGridColumn {
        if (value == null) this.cellRenderer = PriGridCellRendererDefault;
        else this.cellRenderer = value;

        return this;
    }

    public function setCellRendererParams(value:Array<Dynamic>):PriGridColumn {
        this.cellRendererParams = value;
        return this;
    }

    public function setHeadRenderer(value:Class<PriGridHeaderRenderer>):PriGridColumn {
        if (value == null) this.headerRenderer = PriGridHeaderRendererDefault;
        else this.headerRenderer = value;

        return this;
    }

    public function setHeadRendererParams(value:Array<Dynamic>):PriGridColumn {
        this.headerRendererParams = value;
        return this;
    }

    public function setWidth(value:Float):PriGridColumn {
        this.width = value;
        return this;
    }

    inline public function setFixedWidth(value:Float):PriGridColumn {
        return this.setSizeType(PriGridColumnSizeType.FIXED).setWidth(value);
    }

    public function setSizeType(value:PriGridColumnSizeType):PriGridColumn {
        if (value == null) this.sizeType = PriGridColumnSizeType.FIT;
        else this.sizeType = value;

        return this;
    }

    public function setSortable(value:Bool):PriGridColumn {
        if (value == null) this.sortable = true;
        else this.sortable = value;

        return this;
    }

    public function setHeaderSortCaret(value:Class<PriGridHeaderSortCaret>):PriGridColumn {
        if (value == null) this.headerSortCaret = PriGridHeaderSortCaretDefault;
        else this.headerSortCaret = value;

        return this;
    }

}
