package priori.view.form;

import priori.event.PriEvent;
import js.jquery.Event;

class PriFormRadioButton extends PriFormElementBase {

    private static var RADIO_BUTTON_GROUP_LIST:Array<PriFormRadioButton> = [];

    public var data:Dynamic;
    public var selected(get, set):Dynamic;

    @:isVar public var groupId(default, set):String;

    public function new(groupId:String) {
        super();

        this.groupId = groupId;
    }

    override private function getComponentCode():String {
        return '<input type="radio" style="padding:0px;margin:0px;vertical-align:middle;" name="">';
    }

    override private function onAddedToApp():Void {
        RADIO_BUTTON_GROUP_LIST.push(this);

        this._baseElement.on("change", this._onCheckChange);
    }

    override private function onRemovedFromApp():Void {
        this._baseElement.off("change", this._onCheckChange);

        RADIO_BUTTON_GROUP_LIST.remove(this);
    }

    @:noCompletion private function _onCheckChange(event:Event):Void {
        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    private function set_groupId(value:String):String {
        this.groupId = value;

        this._baseElement.attr("name", value);

        return value;
    }

    private function get_selected():Dynamic {
        var groupToSearch:String = this.groupId;
        var result:Dynamic = null;

        for (i in 0 ... RADIO_BUTTON_GROUP_LIST.length) {
            if (RADIO_BUTTON_GROUP_LIST[i].groupId == groupToSearch) {
                if (RADIO_BUTTON_GROUP_LIST[i]._baseElement.prop("checked")) {
                    result = RADIO_BUTTON_GROUP_LIST[i].data;
                    break;
                }
            }
        }

        return result;
    }

    private function set_selected(value:Dynamic):Dynamic {
        var groupToSearch:String = this.groupId;

        for (i in 0 ... RADIO_BUTTON_GROUP_LIST.length) {
            if (RADIO_BUTTON_GROUP_LIST[i].groupId == groupToSearch) {
                if (RADIO_BUTTON_GROUP_LIST[i].data == value) {
                    RADIO_BUTTON_GROUP_LIST[i]._baseElement.prop("checked", true);
                } else {
                    RADIO_BUTTON_GROUP_LIST[i]._baseElement.prop("checked", false);
                }
            }
        }

        return value;
    }

}
