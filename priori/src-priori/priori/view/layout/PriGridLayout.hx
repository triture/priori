package priori.view.layout;

class PriGridLayout extends PriLayout {

    @:isVar public var cols(default, set):Int;
    @:isVar public var rowHeight(default, set):Float;

    public function new() {
        super();

        this.gap = 10;
        this.cols = 0;
        this.rowHeight = 0;
        this.autoSizeElements = false;
    }

    private function set_cols(value:Int):Int {
        this.cols = value;

        this.invalidate();
        this.validate();

        return value;
    }

    private function set_rowHeight(value:Float):Float {
        this.rowHeight = value;

        this.invalidate();
        this.validate();

        return value;
    }


    override private function paint():Void {
        var i:Int = 0;
        var n:Int = this.numChildren;

        var rows:Array<Array<PriDisplay>> = [[]];

        var width:Float = this.width;
        var gap:Float = this.gap;

        var colHeight:Float = gap;
        var rowWidth:Float = gap;
        var rowMaxHeight:Float = 0;

        var maxCols:Int = this.cols;
        if (maxCols == null || maxCols < 0) maxCols = 0;

        var defaultRowHeight:Float = this.rowHeight;
        if (defaultRowHeight == null || defaultRowHeight < 0) defaultRowHeight = 0;

        while (i < n) {

            var item:PriDisplay = this.getChild(i);
            var itemW:Float = item.width;
            var itemH:Float = item.height;

            var curRow:Array<PriDisplay> = rows[rows.length - 1];

            if ((maxCols == 0 && rowWidth + itemW + gap <= width) || (maxCols > 0 && curRow.length < maxCols)) {
                curRow.push(item);
                rowMaxHeight = defaultRowHeight == 0 ? Math.max(rowMaxHeight, itemH) : defaultRowHeight;

                rowWidth += itemW + gap;
            } else {
                if (maxCols == 0 && curRow.length == 0) {
                    curRow.push(item);
                    rowMaxHeight = defaultRowHeight == 0 ? Math.max(rowMaxHeight, itemH) : defaultRowHeight;

                    rowWidth += itemW + gap;
                } else {
                    this.organizeRow(curRow, rowWidth, rowMaxHeight, colHeight);

                    colHeight += rowMaxHeight + gap;

                    rowWidth = gap;
                    rowMaxHeight = 0;
                    curRow = [];

                    rows.push(curRow);

                    curRow.push(item);
                    rowMaxHeight = defaultRowHeight == 0 ? Math.max(rowMaxHeight, itemH) : defaultRowHeight;

                    rowWidth += itemW + gap;
                }
            }

            if (i == n-1) {
                this.organizeRow(curRow, rowWidth, rowMaxHeight, colHeight);
            }

            i++;
        }

        if (this.autoSizeContainer) this.height = colHeight + rowMaxHeight + gap;
    }

    private function organizeRow(row:Array<PriDisplay>, rowWidth:Float, rowHeight:Float, rowYStart:Float):Void {
        var i:Int = 0;
        var n:Int = row.length;

        var gap:Float = this.gap;

        var colWidth:Float = 0;
        var maxCols:Int = this.cols;
        if (maxCols == null || maxCols < 0) maxCols = 0;
        else colWidth = (this.width - gap * (maxCols + 1)) / maxCols;

        var defaultRowHeight:Float = this.rowHeight;
        if (defaultRowHeight == null || defaultRowHeight < 0) defaultRowHeight = 0;

        var rowSpace:Float = (this.width - rowWidth) / (n + 1);
        var lastX:Float = rowSpace + gap;

        while (i < n) {

            if (this.autoSizeElements && defaultRowHeight > 0) {
                row[i].height = rowHeight;
            }

            if (maxCols == 0) {
                row[i].x = lastX;
                row[i].centerY = rowYStart + rowHeight / 2;

                lastX += row[i].width + rowSpace + gap;
            } else {
                if (this.autoSizeElements) {
                    row[i].width = colWidth;
                }

                row[i].centerX = (gap + colWidth) * i + gap + colWidth / 2;
                row[i].centerY = rowYStart + rowHeight / 2;
            }

            i++;
        }
    }

}
