package priori.view.form;

import jQuery.JQuery;
import jQuery.Event;
import priori.event.PriEvent;

class PriFormSelect extends PriFormElementBase {

    @:isVar public var data(default, set):Array<Dynamic>;
    @:isVar public var labelField(default, set):String;
    @:isVar public var selected(get, set):Dynamic;

    private var _selectedData:Dynamic;
    private var _menuItens:Array<{label:String, id:String, data:Dynamic}>;

    public function new() {
        super();

        this.labelField = "label";
    }

    override public function getComponentCode():String {
        return "<select></select>";
    }

    override private function onAddedToApp():Void {
        this._baseElement.on("change", this._onSelectChange);
    }

    override private function onRemovedFromApp():Void {
        this._baseElement.off("change", this._onSelectChange);
    }

    @:noCompletion private function set_data(value:Array<Dynamic>):Array<Dynamic> {
        this.data = value;

        if (
            (this._selectedData == null && value != null && value.length > 0) ||
            (value != null && value.length > 0 && this.data.indexOf(this._selectedData) == -1)
        ) {
            this._selectedData = this.data[0];
        }

        this.updateDropDownData();

        return value;
    }

    @:noCompletion private function set_labelField(value:String):String {
        this.labelField = value;

        this.updateDropDownData();

        return value;
    }

    @:noCompletion private function get_selected():Dynamic {
        var result:Dynamic = this._selectedData;

        if (this._baseElement != null) {
            var i:Int = 0;
            var n:Int = this._menuItens.length;

            var isDisabled:Bool = this.disabled;
            if (isDisabled) this.disabled = false;

            var selectedId:String = this._baseElement.val();
            if (isDisabled) this.disabled = true;

            while (i < n) {

                if (this._menuItens[i].id == selectedId) {
                    result = this._menuItens[i].data;
                    i = n;
                }

                i++;
            }
        }

        return result;
    }

    @:noCompletion private function set_selected(value:Dynamic):Dynamic {
        this._selectedData = value;

        this.updateDropDownView();

        return value;
    }

    private function updateDropDownView():Void {
        if (this._selectedData != null) {

            var i:Int = 0;
            var n:Int = this._menuItens.length;

            while (i < n) {

                if (this._selectedData == this._menuItens[i].data) {
                    var item:Dynamic = this._menuItens[i];

                    this._baseElement.val(item.id);

                    i = n;
                }

                i++;
            }

        } else {

        }
    }

    private function getLabelForData(data:Dynamic):String {
        var result:String = "";

        if (this.labelField != null && this.labelField != "") {
            var val:Dynamic = Reflect.getProperty(data, this.labelField);

            if (val == null) {
                result = Std.string(data);
            } else {
                result = Std.string(val);
            }
        } else {
            result = Std.string(data);
        }

        return result;
    }

    private function updateDropDownData():Void {
        this.clearDropDown();

        if (this.data != null) {

            var i:Int = 0;
            var n:Int = this.data.length;

            var item_id:String = null;
            var item_label:String = null;
            var item_data:Dynamic = null;
            var item_view:JQuery;

            while (i < n) {

                item_data = this.data[i];

                if (item_data != null) {

                    item_label = this.getLabelForData(item_data);

                    if (item_label == null) item_label = "";

                    item_id = "opt_" + this.getRandomId(4);
                    item_view = new JQuery("<option>", {
                        value : item_id,
                        text : item_label
                    });

                    this._menuItens.push({
                        id : item_id,
                        label : item_label,
                        data : item_data
                    });

                    this._baseElement.append(item_view);

                } else {
                    // divider???
                }

                item_data = null;
                item_id = null;
                item_label = null;

                i++;
            }
        }

        this.updateDropDownView();
    }

    private function clearDropDown():Void {
        if (this._baseElement != null) {
            this._baseElement.find("option").remove();
            this._menuItens = [];
        }
    }

    private function _onSelectChange(e:Event):Void {
        trace("changed");

        this._selectedData = this.selected;

        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    override public function kill():Void {
        this.getElement().off();
        this.clearDropDown();

        super.kill();
    }
}
