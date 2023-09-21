package priori.view.grid.column;

import priori.view.grid.column.PriGridColumn;

enum PriGridColumnSizeType {
    FIXED;
    FIT;
}

class PriGridColumnSize {

    public var widthList:Array<Float>;
    public var fitWidth:Float;


    public function new() {
        this.fitWidth = 0;
        this.widthList = [];
    }

    public static function calculate(width:Float, columnData:Array<PriGridColumn>):PriGridColumnSize {
        var result:PriGridColumnSize = new PriGridColumnSize();

        if (columnData != null) {

            var fixedColumnsWidth:Float = 0;
            var totalFitColumns:Int = 0;

            var i:Int = 0;
            var n:Int = columnData.length;


            while (i < n) {
                if (columnData[i].sizeType == PriGridColumnSizeType.FIT) {
                    totalFitColumns++;

                    result.widthList.push(null);

                } else if (columnData[i].sizeType == PriGridColumnSizeType.FIXED) {
                    fixedColumnsWidth += Math.ffloor(columnData[i].width);

                    result.widthList.push(Math.ffloor(columnData[i].width));
                }

                i++;
            }

            if (totalFitColumns > 0) {
                result.fitWidth = Math.ffloor((width - fixedColumnsWidth) / totalFitColumns);

                if (result.fitWidth < 0) result.fitWidth = 0;
            }

            i = 0;

            while (i < n) {
                if (result.widthList[i] == null) {
                    result.widthList[i] = result.fitWidth;
                }

                i++;
            }

            // valida o tamanho final
            i = 0;
            var validateFinalSize:Float = 0;

            while (i < n) {
                validateFinalSize += result.widthList[i];

                i++;
            }

            if (validateFinalSize < width) {
                result.widthList[n-1] += (width - validateFinalSize);
            }
        }

        return result;
    }

}
