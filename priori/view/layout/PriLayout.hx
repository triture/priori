package priori.view.layout;

import priori.view.layout.PriLayoutAlignType;
import priori.view.layout.PriLayoutDistributionType;

import priori.view.container.PriGroup;

class PriLayout extends PriGroup {

    @:isVar public var gap(default, set):Float;
    @:isVar public var alignType(default, set):PriLayoutAlignType;
    @:isVar public var distributionType(default, set):PriLayoutDistributionType;
    @:isVar public var autoSizeElements(default, set):Bool;
    @:isVar public var autoSizeContainer(default, set):Bool;

    public function new() {
        super();

        this.gap = 10;
        this.alignType = PriLayoutAlignType.MIN;
        this.distributionType = PriLayoutDistributionType.NONE;
        this.autoSizeElements = false;
        this.autoSizeContainer = true;
    }

    @:noCompletion private function set_gap(value:Float) {
        if (value != this.gap) {
            this.invalidate();
        }

        return this.gap = value;
    }

    @:noCompletion private function set_distributionType(value:PriLayoutDistributionType) {
        if (value != this.distributionType) {
            this.invalidate();
            this.validate();
        }

        return this.distributionType = value;
    }

    @:noCompletion private function set_alignType(value:PriLayoutAlignType) {
        if (value != this.alignType) {
            this.invalidate();
            this.validate();
        }

        return this.alignType = value;
    }

    @:noCompletion private function set_autoSizeElements(value:Bool):Bool {
        if (value != this.autoSizeElements) {
            this.invalidate();
            this.validate();
        }

        return this.autoSizeElements = value;
    }

    @:noCompletion private function set_autoSizeContainer(value:Bool):Bool {
        if (value != this.autoSizeContainer) {
            this.invalidate();
            this.validate();
        }

        return this.autoSizeContainer = value;
    }


}
