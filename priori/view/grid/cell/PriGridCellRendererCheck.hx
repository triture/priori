package priori.view.grid.cell;

import priori.view.form.PriFormCheckBox;
import priori.event.PriTapEvent;
import priori.event.PriEvent;

class PriGridCellRendererCheck extends PriGridCellRenderer {

    private var field:PriFormCheckBox;


    public function new() {
        super();
    }

    override public function update():Void {
        if (this.canPaint()) {
            this.field.value = this.value;
        }
    }

    override private function setup():Void {
        this.field = new PriFormCheckBox();
        this.field.addEventListener(PriEvent.CHANGE, onFieldChange);
        this.field.value = this.value;

        this.addChild(this.field);
    }

    override private function paint():Void {
        this.field.centerX = this.width/2;
        this.field.centerY = this.height/2;
    }

    private function onFieldChange(e:PriEvent):Void {
        Reflect.setProperty(this.data, this.dataField, this.field.value);
    }

    private function _onCellTap(e:PriTapEvent):Void {
        this.field.value = !this.field.value;
        onFieldChange(null);
    }
}
