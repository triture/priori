package priori.view.grid.column;

enum PriGridColumnSortOrder {
    ASC;
    DESC;
    NONE;
}

class PriGridColumnSort {

    public var dataField:String;
    public var order:PriGridColumnSortOrder;

    public function new() {
        this.dataField = "";
        this.order = ASC;
    }

    public function sort(data:Array<Dynamic>):Array<Dynamic> {

        if (this.dataField == "" || this.order == PriGridColumnSortOrder.NONE) {
            return data;
        }

        data.sort(function(x:Dynamic, y:Dynamic):Int {
            var vx:Dynamic;
            var vy:Dynamic;

            var direction:Int = this.order == PriGridColumnSortOrder.ASC ? 1 : -1;

            vx = Reflect.getProperty(x, this.dataField);
            vy = Reflect.getProperty(y, this.dataField);


            if (!Std.is(vx, Float) && !Std.is(vx, Int)) {
                vx = Std.string(vx).toLowerCase();
                vy = Std.string(vy).toLowerCase();
            }

            if (vx > vy) return 1*direction;
            if (vy > vx) return -1*direction;

            return 0;
        });

        return data;
    }

}