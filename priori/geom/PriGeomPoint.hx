package priori.geom;

class PriGeomPoint {

    public var x:Float;
    public var y:Float;

    public function new(x:Float = 0, y:Float = 0) {
        this.x = x;
        this.y = y;
    }

    public function distanceFrom(point:PriGeomPoint):Float {
        return Math.sqrt(Math.pow(point.x - this.x, 2) + Math.pow(point.y - this.y, 2));
    }

    public function clone():PriGeomPoint {
        return new PriGeomPoint(this.x, this.y);
    }
}
