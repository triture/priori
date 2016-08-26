package priori.view.grid.cell;

import priori.event.PriTapEvent;
import priori.event.PriMouseEvent;
import haxe.Json;
import priori.event.PriEvent;
import priori.view.grid.column.PriGridColumn;
import priori.view.container.PriGroup;

class PriGridCellRenderer extends PriGroup {

    public static var SPECIAL_COLUMN_INDEX:String = "#COL_INDEX";
    public static var SPECIAL_ROW_LINE:String = "#ROW_LINE";

    private var __data:Dynamic;
    private var __column:PriGridColumn;
    private var __rowIndex:Int;
    private var __colIndex:Int;

    @:isVar public var data(get, null):Dynamic;
    @:isVar public var value(get, null):Dynamic;
    @:isVar public var dataField(get, null):String;
    @:isVar public var rowIndex(get, null):Int;
    @:isVar public var colIndex(get, null):Int;

    public function new() {
        super();

        this.addEventListener(PriEvent.CHANGE, this.__onCellDataChange);
        this.addEventListener(PriTapEvent.TAP, this.__onTap);
        this.addEventListener(PriMouseEvent.MOUSE_OVER, this.__onMouse);
        this.pointer = false;
        this.clipping = false;
    }

//    public function activateCellOver():Void {
//        this.addEventListener(PriMouseEvent.MOUSE_OVER, this.__onMouse);
//    }
//
//    public function removeCellOver():Void {
//        this.removeEventListener(PriMouseEvent.MOUSE_OVER, this.__onMouse);
//    }


    private function __onTap(e:PriTapEvent):Void {
        var event:PriDataGridEvent = new PriDataGridEvent(PriDataGridEvent.GRID_CLICK, false, true, this.data);
        event.colIndex = this.colIndex;
        event.rowIndex = this.rowIndex;

        this.dispatchEvent(event);
    }

    private function __onMouse(e:PriMouseEvent):Void {
        var event:PriDataGridEvent = new PriDataGridEvent(PriDataGridEvent.CELL_OVER, false, true, this.data);
        event.colIndex = this.colIndex;
        event.rowIndex = this.rowIndex;

//        trace(this.colIndex, this.rowIndex);

        this.dispatchEvent(event);
    }

    public function update():Void {

    }

    private function __onCellDataChange(e:PriEvent):Void {
        this.__data = e.data.data;
        this.__column = e.data.column;
        this.__rowIndex = e.data.rowIndex;
        this.__colIndex = e.data.colIndex;

        this.invalidate();
        this.update();
    }

    @:noCompletion private function get_data():Dynamic {
        return this.__data;
    }

    @:noCompletion private function get_rowIndex():Int {
        return this.__rowIndex;
    }

    @:noCompletion private function get_colIndex():Int {
        return this.__colIndex;
    }

    @:noCompletion private function get_dataField():String {
        var result:String = "";

        if (this.__column != null && this.__column.dataField != null) {
            result = this.__column.dataField;
        }

        return result;
    }

    @:noCompletion private function get_value():Dynamic {
        var result:Dynamic = null;

        if (this.__column == null) return null;

        if (this.__column.dataField == PriGridCellRenderer.SPECIAL_COLUMN_INDEX) {
            result = this.rowIndex;
        } else if (this.__column.dataField == PriGridCellRenderer.SPECIAL_ROW_LINE) {
            result = this.rowIndex + 1;
        } else {
            if (__data != null) {
                result = Reflect.getProperty(this.__data, this.__column.dataField);
            }
        }

        return result;
    }

    override public function kill():Void {

        this.removeEventListener(PriEvent.CHANGE, this.__onCellDataChange);
        this.removeEventListener(PriMouseEvent.MOUSE_OVER, this.__onMouse);

        super.kill();
    }
}
