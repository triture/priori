package priori.view.grid.header;

import helper.pool.PoolGridHead;
import priori.event.PriTapEvent;
import priori.view.grid.column.PriGridColumnSort;
import priori.view.grid.column.PriGridColumnSort.PriGridColumnSortOrder;
import priori.view.grid.column.PriGridColumnSize;
import priori.view.grid.column.PriGridColumn;
import priori.view.container.PriGroup;

class PriGridHeader extends PriGroup {

    @:isVar public var columns(default, set):Array<PriGridColumn>;

    private var headerList:Array<PriGridHeaderRenderer>;
    private var headerCaret:Array<PriGridHeaderSortCaret>;

    public function new() {
        super();

        this.headerList = [];
        this.headerCaret = [];
    }

    override private function setup():Void {
        this.bgColor = 0xFFFFFF;
    }

    override private function paint():Void {
        var w:Float = this.width;
        var h:Float = this.height;

        var columnSizes:PriGridColumnSize = PriGridColumnSize.calculate(w, this.columns);

        var i:Int = 0;
        var n:Int = this.headerList.length;


        while (i < n) {
            this.headerList[i].width = columnSizes.widthList[i];
            this.headerList[i].height = h;

            if (i == 0) {
                this.headerList[i].x = 0;
            } else {
                this.headerList[i].x = this.headerList[i-1].maxX;
            }

            this.headerList[i].y = 0;

            if (this.headerCaret[i] != null) {
                this.headerCaret[i].maxX = this.headerList[i].maxX - 3;
                this.headerCaret[i].y = 0;
                this.headerCaret[i].height = this.headerList[i].height;
            }

            i++;
        }
    }

    private function set_columns(value:Array<PriGridColumn>):Array<PriGridColumn> {
        this.columns = value;

        this.generateHeaders();

        return value;
    }


//    private function generateHeaders():Void {
//
//        this.removeHeaders();
//
//        if (this.columns != null) {
//            var i:Int = 0;
//            var n:Int = this.columns.length;
//
//            var header:PriGridHeaderRenderer;
//
//            while (i < n) {
//                var params:Array<Dynamic> = this.columns[i].headerRendererParams;
//
//                header = Type.createInstance(this.columns[i].headerRenderer, params == null ? [] : params);
//                header.title = this.columns[i].title;
//
//                this.headerList.push(header);
//                this.addChild(header);
//
//                if (this.columns[i].sortable) {
//                    this.headerCaret.push(Type.createInstance(this.columns[i].headerSortCaret, []));
//                    this.headerCaret[i].addEventListener(PriTapEvent.TAP, onCaretClick);
//                    this.addChild(this.headerCaret[i]);
//                } else {
//                    this.headerCaret.push(null);
//                }
//
//                i++;
//            }
//        }
//
//        this.invalidate();
//        this.validate();
//    }

    public function applySort(field:String, order:PriGridColumnSortOrder):Void {
        var i:Int = 0;
        var n:Int = this.columns == null ? 0 : this.columns.length;

        var caret:PriGridHeaderSortCaret = null;

        while (i < n) {

            if (this.columns[i].dataField == field && this.columns[i].sortable) {
                caret = this.headerCaret[i];
                caret.order = order;
            } else if (this.headerCaret[i] != null) this.headerCaret[i].order = PriGridColumnSortOrder.NONE;

            i++;
        }

        this.dispatchEvent(new PriDataGridEvent(PriDataGridEvent.SORT, false, true, {
            field : field,
            order : order
        }));

        this.invalidate();
        this.validate();
    }

    private function onCaretClick(e:PriTapEvent):Void {
        var caret:PriGridHeaderSortCaret = cast(e.currentTarget, PriGridHeaderSortCaret);
        var index:Int = -1;

        var i:Int = 0;
        var n:Int = this.headerCaret.length;

        while (i < n) {
            if (this.headerCaret[i] != null) {
                if (this.headerCaret[i] == caret) {
                    index = i;
                    this.headerCaret[i].toogle();
                } else {
                    this.headerCaret[i].order = PriGridColumnSortOrder.NONE;
                }
            }

            i++;
        }

        if (index > -1) {
            this.dispatchEvent(new PriDataGridEvent(PriDataGridEvent.SORT, false, true, {
                field : this.columns[index].dataField,
                order : this.headerCaret[index].order

            }));
        }

        this.invalidate();
        this.validate();
    }

//    private function removeHeaders():Void {
//        var i:Int = 0;
//        var n:Int = this.headerList.length;
//
//        while (i < n) {
//            this.removeChild(this.headerList[i]);
//            this.headerList[i].kill();
//
//            if (this.headerCaret[i] != null) {
//                this.removeChild(this.headerCaret[i]);
//                this.headerCaret[i].kill();
//            }
//
//            i++;
//        }
//
//        this.headerList = [];
//        this.headerCaret = [];
//    }


    private function generateHeaders():Void {
        this.killHeaders();

        if (this.columns != null) {
            for (i in 0 ... this.columns.length) {
                var headerRenderer:Class<PriGridHeaderRenderer> = this.columns[i].headerRenderer;
                var headerParams:Array<Dynamic> = this.columns[i].headerRendererParams;

                var header:PriGridHeaderRenderer = PoolGridHead.instance.createCell(headerRenderer, headerParams);
                header.title = this.columns[i].title;

                this.headerList.push(header);

                if (this.columns[i].sortable) {
                    this.headerCaret.push(Type.createInstance(this.columns[i].headerSortCaret, []));
                    this.headerCaret[i].addEventListener(PriTapEvent.TAP, onCaretClick);
                } else {
                    this.headerCaret.push(null);
                }
            }
        }

        this.addChildList(this.headerList);
        this.addChildList(this.headerCaret);

        this.invalidate();
        this.validate();
    }

    private function killHeaders():Void {
        this.removeChildList(this.headerList);
        for (i in 0 ... this.headerList.length) PoolGridHead.instance.returnCell(this.headerList[i]);
        this.headerList = [];

        this.removeChildList(this.headerCaret);
        this.headerCaret = [];
    }
}
