package priori.geom;

class PriGeomPoint {

    public var x:Float;
    public var y:Float;

    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }

    public function clone():PriGeomPoint {
        return new PriGeomPoint(this.x, this.y);
    }
}
