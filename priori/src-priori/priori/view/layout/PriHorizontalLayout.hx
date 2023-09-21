package priori.view.layout;

import priori.view.container.PriGroup;
import priori.view.layout.PriLayoutAlignType;

class PriHorizontalLayout extends PriLayout {

    public function new() {
        super();
    }

    override private function paint():Void {
        var i:Int = 0;
        var n:Int = this.numChildren;

        var gap:Float = this.gap;
        var lastX:Float = gap;

        var totalSpace:Float = this.width;
        var availableSpace:Float = totalSpace - this.gap * (n - 1);
        var spacePerItem:Float = availableSpace / n;
        var lastItemSize:Float = totalSpace - (spacePerItem * (n - 1) + this.gap * (n - 1));

        while (i < n) {

            this.getChild(i).x = lastX;

            if (autoSizeElements) {
                this.getChild(i).height = this.height - gap*2;
                if (Std.is(this.getChild(i), PriGroup)) (cast(this.getChild(i), PriGroup).validate());
            }

            if (this.distributionType == PriLayoutDistributionType.FIT) {
                this.getChild(i).width = i == n - 1 ? totalSpace : spacePerItem;
            }

            if (this.alignType == PriLayoutAlignType.MIN) {
                this.getChild(i).y = gap;
            } else if (this.alignType == PriLayoutAlignType.CENTER) {
                this.getChild(i).centerY = this.height/2;
            } else if (this.alignType == PriLayoutAlignType.MAX) {
                this.getChild(i).maxY = this.height - gap;
            }

            lastX = this.getChild(i).maxX + gap;

            i++;
        }

        if (this.autoSizeContainer) this.width = lastX;
    }
}
