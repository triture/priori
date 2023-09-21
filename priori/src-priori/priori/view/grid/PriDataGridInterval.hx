package priori.view.grid;

class PriDataGridInterval {

    public var col:Int; // x
    public var row:Int; // y

    public var colLen:Int;
    public var rowLen:Int;

    public var color:Int;

    public function new(col:Int = 0, row:Int = 0, colLen:Int = 1, rowLen:Int = 1, color:Int = 0x00FF00) {
        this.col = col;
        this.row = row;
        this.colLen = colLen;
        this.rowLen = rowLen;
        this.color = color;
    }

    public function toString():String {
        return "Col : " + this.col + ", Row : " + this.row + ", Color : " + this.color;
    }

    public function contains(col:Int, row:Int):Bool {
        if ((row >= this.row && row < this.row + this.rowLen) && (col >= this.col && col < this.col + this.colLen)) {
            return true;
        }
        return false;
    }
}