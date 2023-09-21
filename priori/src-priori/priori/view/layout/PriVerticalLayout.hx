package priori.view.layout;

import priori.view.container.PriGroup;
import priori.view.layout.PriLayoutAlignType;
import priori.view.layout.PriLayoutDistributionType;

class PriVerticalLayout extends PriLayout {

    public function new() {
        super();
    }

    override private function paint():Void {
        var i:Int = 0;
        var n:Int = this.numChildren;

        var gap:Float = this.gap;
        var lastY:Float = gap;

        var totalSpace:Float = this.height;
        var availableSpace:Float = totalSpace - this.gap * (n - 1);
        var spacePerItem:Float = availableSpace / n;
        var lastItemSize:Float = totalSpace - (spacePerItem * (n - 1) + this.gap * (n - 1));

        while (i < n) {

            this.getChild(i).y = lastY;

            if (autoSizeElements) {
                this.getChild(i).width = this.width - gap*2;
                if (Std.is(this.getChild(i), PriGroup)) (cast(this.getChild(i), PriGroup).validate());
            }

            if (this.distributionType == PriLayoutDistributionType.FIT) {
                this.getChild(i).height = i == n - 1 ? totalSpace : spacePerItem;
            }

            if (this.alignType == PriLayoutAlignType.MIN) {
                this.getChild(i).x = gap;
            } else if (this.alignType == PriLayoutAlignType.CENTER) {
                this.getChild(i).centerX = this.width/2;
            } else if (this.alignType == PriLayoutAlignType.MAX) {
                this.getChild(i).maxX = this.width - gap;
            }

            lastY = this.getChild(i).maxY + gap;

            i++;
        }

        if (this.autoSizeContainer) this.height = lastY;
    }
}
