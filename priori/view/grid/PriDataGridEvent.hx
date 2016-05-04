package priori.view.grid;

import priori.event.PriEvent;

class PriDataGridEvent extends PriEvent {

    public static var GRID_CLICK:String = "PRI_DATA_GRID_CLICK";
    public static var CELL_OVER:String = "PRI_DATA_GRID_CELL_OVER";
    public static var SORT:String = "PRI_DATA_GRID_SORT";

    public var rowIndex:Int = 0;
    public var colIndex:Int = 0;

    public function new(type:String, propagate:Bool, bubble:Bool, data:Dynamic) {
        super(type, propagate, bubble, data);
    }

    override public function clone():PriEvent {
        var clone:PriDataGridEvent = new PriDataGridEvent(this.type, this.propagate, this.bubble, this.data);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = this.data;

        clone.rowIndex = this.rowIndex;
        clone.colIndex = this.colIndex;

        return clone;
    }
}
