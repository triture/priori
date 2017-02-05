package priori.view.grid.header;

import priori.view.container.PriGroup;

class PriGridHeaderRenderer extends PriGroup {

    @:isVar public var title(default, set):String;

    public function new() {
        super();
    }

    public function update():Void {

    }

    @noCompletion private function set_title(value:String):String {
        this.title = value;

        this.update();

        return value;
    }

    override public function kill():Void {}

}
