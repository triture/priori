package priori.view.builder;

import priori.event.PriEvent;
import priori.view.container.PriContainer;
import priori.view.PriDisplay;

@:autoBuild(priori.view.builder.PriBuilderMacros.build())
class PriBuilder extends PriContainer {

    public var left(get, set):Float;
    public var right(get, set):Float;
    public var top(get, set):Float;
    public var bottom(get, set):Float;
    
    private var __left_value:Float;
    private var __right_value:Float;
    private var __top_value:Float;
    private var __bottom_value:Float;

    public function new() {
        super();

        this.__priBuilderSetup();
        this.setup();

        this.__priBuilderPaint();
        this.paint();

        this.addEventListener(PriEvent.RESIZE, this.___onResize);
        this.addEventListener(PriEvent.ADDED, this.___onAdded);
    }

    private function get_left():Float return this.__left_value;
    private function get_right():Float return this.__right_value;
    private function get_top():Float return this.__top_value;
    private function get_bottom():Float return this.__bottom_value;

    private function set_left(value:Float):Float {
        this.__left_value = value;
        this.___onParentResize(null);
        return value;
    }

    private function set_right(value:Float):Float {
        this.__right_value = value;
        this.___onParentResize(null);
        return value;
    }

    private function set_top(value:Float):Float {
        this.__top_value = value;
        this.___onParentResize(null);
        return value;
    }

    private function set_bottom(value:Float):Float {
        this.__bottom_value = value;
        this.___onParentResize(null);
        return value;
    }

    @:noCompletion
    private function ___onResize(e:PriEvent):Void {
        this.__priBuilderPaint();
        this.paint();
    }

    private function ___onAdded(e:PriEvent):Void {
        this.removeEventListener(PriEvent.ADDED, this.___onAdded);
        this.addEventListener(PriEvent.REMOVED, this.___onRemoved);
        this.parent.addEventListener(PriEvent.RESIZE, this.___onParentResize);
        this.___onParentResize(null);
    }

    private function ___onRemoved(e:PriEvent):Void {
        this.parent.removeEventListener(PriEvent.RESIZE, this.___onParentResize);
        this.removeEventListener(PriEvent.REMOVED, this.___onRemoved);
        this.addEventListener(PriEvent.ADDED, this.___onAdded);
    }

    private function ___onParentResize(e:PriEvent):Void {
        var p:PriDisplay = this.parent;
        
        if (p != null) {
            this.startBatchUpdate();
            if (this.left != null && this.right != null) {
                this.x = this.left;
                this.width = p.width - this.left - this.right;
            } else if (this.left != null && this.right == null) {
                this.x = this.left;
            } else if (this.left == null && this.right != null) {
                this.maxX = p.width - this.right;
            }

            if (this.top != null && this.bottom != null) {
                this.y = this.top;
                this.height = p.height - this.top - this.bottom;
            } else if (this.top != null && this.bottom == null) {
                this.y = this.top;
            } else if (this.top == null && this.bottom != null) {
                this.maxY = p.height - this.height;
            }
            this.endBathUpdate();
        }
    }

    @:noCompletion
    private function __priBuilderSetup():Void {

    }

    @:noCompletion
    private function __priBuilderPaint():Void {}

    private function setup():Void {}

    private function paint():Void {}
}
