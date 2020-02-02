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
    
    @:noCompletion private var __left_value:Float;
    @:noCompletion private var __right_value:Float;
    @:noCompletion private var __top_value:Float;
    @:noCompletion private var __bottom_value:Float;

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
    private function set_left(value:Float):Float {
        if (this.__left_value == value) return value;
        this.__left_value = value;
        this.updateRelativePositions();
        return value;
    }

    private function get_right():Float return this.__right_value;
    private function set_right(value:Float):Float {
        if (this.__right_value == value) return value;
        this.__right_value = value;
        this.updateRelativePositions();
        return value;
    }

    private function get_top():Float return this.__top_value;
    private function set_top(value:Float):Float {
        if (this.__top_value == value) return value;
        this.__top_value = value;
        this.updateRelativePositions();
        return value;
    }

    private function get_bottom():Float return this.__bottom_value;
    private function set_bottom(value:Float):Float {
        if (this.__bottom_value == value) return value;
        this.__bottom_value = value;
        this.updateRelativePositions();
        return value;
    }

    public function updateDisplay():Void {
        this.__priBuilderPaint();
        this.paint();
        this.updateRelativePositions();
        
        for (i in 0 ... this.numChildren) {
            var item:Dynamic = this.getChild(i);
            if (item.updateDisplay != null) item.updateDisplay();
        }
    }

    override private function set_x(value:Float):Float {
        this.__left_value = null;
        this.__right_value = null;
        
        return super.set_x(value);
    }

    override private function set_y(value:Float):Float {
        this.__top_value = null;
        this.__bottom_value = null;
        
        return super.set_y(value);
    }

    override private function set_maxX(value:Float):Float {
        this.__left_value = null;
        this.__right_value = null;
        
        return super.set_maxX(value);
    }

    override private function set_maxY(value:Float):Float {
        this.__top_value = null;
        this.__bottom_value = null;
        
        return super.set_maxY(value);
    }

    override private function set_centerX(value:Float):Float {
        this.__left_value = null;
        this.__right_value = null;
        
        return super.set_centerX(value);
    }

    override private function set_centerY(value:Float):Float {
        this.__top_value = null;
        this.__bottom_value = null;
        
        return super.set_centerY(value);
    }

    override private function set_width(value:Float):Float {
        if (this.__right_value != null && this.__left_value != null) {
            this.__right_value = null;
            this.__left_value = null;
        }

        return super.set_width(value);
    }

    override private function set_height(value:Float):Float {
        if (this.__top_value != null && this.__bottom_value != null) {
            this.__top_value = null;
            this.__bottom_value = null;
        }

        return super.set_height(value);
    }

    @:noCompletion
    private function ___onResize(e:PriEvent):Void this.updateDisplay();

    @:noCompletion
    private function ___onAdded(e:PriEvent):Void {
        this.removeEventListener(PriEvent.ADDED, this.___onAdded);
        this.addEventListener(PriEvent.REMOVED, this.___onRemoved);
        if (this.parent != null) this.parent.addEventListener(PriEvent.RESIZE, this.___onParentResize);
        this.updateRelativePositions();
    }

    @:noCompletion
    private function ___onRemoved(e:PriEvent):Void {
        if (e != null && e.data != null) {
            var oldParent:PriDisplay = e.data;
            oldParent.removeEventListener(PriEvent.RESIZE, this.___onParentResize);
        }
        this.removeEventListener(PriEvent.REMOVED, this.___onRemoved);
        this.addEventListener(PriEvent.ADDED, this.___onAdded);
    }

    @:noCompletion
    private function ___onParentResize(e:PriEvent):Void this.updateRelativePositions();

    private function updateRelativePositions():Void {
        var p:PriDisplay = this.parent;
        
        if (p != null) {

            var pWidth:Float = p.width;
            var pHeight:Float = p.height;

            this.startBatchUpdate();
            if (this.__left_value != null && this.__right_value != null) {
                super.set_x(this.__left_value);
                super.set_width(pWidth - this.__left_value - this.__right_value);
            } else if (this.__left_value != null && this.__right_value == null) {
                super.set_x(this.__left_value);
            } else if (this.__left_value == null && this.__right_value != null) {
                super.set_maxX(pWidth - this.__right_value);
            }

            if (this.top != null && this.bottom != null) {
                super.set_y(this.top);
                super.set_height(p.height - this.top - this.bottom);
            } else if (this.top != null && this.bottom == null) {
                super.set_y(this.top);
            } else if (this.top == null && this.bottom != null) {
                super.set_maxY(pHeight - this.bottom);
            }
            this.endBatchUpdate();
        }
    }

    @:noCompletion
    private function __priBuilderSetup():Void {}

    @:noCompletion
    private function __priBuilderPaint():Void {}

    private function setup():Void {}

    private function paint():Void {}
}
