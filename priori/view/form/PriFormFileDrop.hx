package priori.view.form;

import haxe.io.BytesData;
import haxe.io.Bytes;
import js.html.compat.ArrayBuffer;
import haxe.crypto.Base64;
import js.html.FileReader;
import priori.system.PriDevice;
import priori.system.PriDeviceBrowser;
import priori.event.PriDragEvent;
import js.html.DragEvent;
import js.html.FileList;
import priori.types.PriFormInputFileType;
import js.jquery.Event;
import priori.app.PriApp;
import priori.event.PriEvent;

class PriFormFileDrop extends PriFormElementBase {

    @:isVar public var acceptFileType(default, set):PriFormInputFileType;
//    @:isVar public var multiFiles(default, set):Bool;

    private var __fileNames:Array<String>;
    private var __fileList:FileList;

    public var length(get, null):Int;

    public function new() {
        super();

        this.clipping = false;
        this.width = 200;
        this.height = 200;

        this.acceptFileType = PriFormInputFileType.IMAGES;
        this.__fileNames = [];
    }

    public function releaseFiles():Void {

        this.__fileNames = [];
        this.__fileList = null;

    }

    override private function set_pointer(value:Bool) {
        super.set_pointer(value);

        if (value) this._baseElement[0].style.cursor = "pointer";
        else this._baseElement[0].style.cursor = "";

        return value;
    }

    private function get_length():Int return this.__fileNames.length;

    // return file data in base64
    public function getDataAsBase64(fileIndex:Int, callback:String->Void):Void {
        this.getDataAsBytes(
            fileIndex,
            function(data:BytesData):Void {
                if (data == null) callback(null);
                else callback(Base64.encode(Bytes.ofData(data)));
            }
        );
    }

    public function getDataAsBytes(fileIndex:Int, callback:BytesData->Void):Void {

        if (this.length > fileIndex) {

            var reader:FileReader = new FileReader();
            reader.onload = function(e):Void {
                // bytes data is an ArrayBuffer
                var bytesData:BytesData = reader.result;

                callback(bytesData);
            }

            reader.onerror = function(e):Void {
                callback(null);
            }

            reader.readAsArrayBuffer(this.__fileList.item(fileIndex));

        } else {
            callback(null);
        }

    }

    public function getFiles():Array<String> return this.__fileNames.copy();

    private function set_acceptFileType(value:PriFormInputFileType):PriFormInputFileType {
        this.acceptFileType = value;
        this._baseElement.attr("accept", Std.string(value));
        return value;
    }

//    private function set_multiFiles(value:Bool):Bool {
//        this.multiFiles = value;
        //this._baseElement.attr("multiple", value ? "multiple" : "");
//        return value;
//    }

    override public function getComponentCode():String {
        return '<input type="file" style="height:100%;width:100%;padding:0px;opacity:0;filter: alpha(opacity=0);" />';
    }

    override private function onAddedToApp():Void {
        super.onAddedToApp();

        if (PriDevice.browser() != PriDeviceBrowser.MSIE) {
            PriApp.g().getBody().on("dragenter", "[id=" + this.fieldId + "]", this._onDragEnter);
            PriApp.g().getBody().on("dragover", "[id=" + this.fieldId + "]", this._onDragOver);
            PriApp.g().getBody().on("dragleave", "[id=" + this.fieldId + "]", this._onDragOut);
            PriApp.g().getBody().on("drop", "[id=" + this.fieldId + "]", this._ondrop);
        }
        PriApp.g().getBody().on("change", "[id=" + this.fieldId + "]", this._onChange);
    }

    override private function onRemovedFromApp():Void {
        super.onRemovedFromApp();

        if (PriDevice.browser() != PriDeviceBrowser.MSIE) {
            PriApp.g().getBody().off("dragenter", "[id=" + this.fieldId + "]", this._onDragEnter);
            PriApp.g().getBody().off("dragover", "[id=" + this.fieldId + "]", this._onDragOver);
            PriApp.g().getBody().off("dragleave", "[id=" + this.fieldId + "]", this._onDragOut);
            PriApp.g().getBody().off("drop", "[id=" + this.fieldId + "]", this._ondrop);
        }

        PriApp.g().getBody().off("change", "[id=" + this.fieldId + "]", this._onChange);
    }

    private function _onDragEnter(event:Event):Void this.dispatchEvent(new PriDragEvent(PriDragEvent.DRAG_ENTER));
    private function _onDragOut(event:Event):Void this.dispatchEvent(new PriDragEvent(PriDragEvent.DRAG_LEAVE));

    private function _onDragOver(event:Event):Void {

    }

    private function _onChange(event:Event):Void {
        this.updateFiles(this._baseElement.prop("files"));
        this.dispatchEvent(new PriEvent(PriEvent.CHANGE));
    }

    private function _ondrop(event:Event):Void {
        var dragEvent:DragEvent = (cast event).originalEvent;
        this.updateFiles(dragEvent.dataTransfer.files);
        this.dispatchEvent(new PriDragEvent(PriDragEvent.DROP));
    }

    private function updateFiles(fl:FileList):Void {
        this.__fileList = fl;
        this.__fileNames = [];

        for (i in 0 ... this.__fileList.length) this.__fileNames.push(this.__fileList.item(i).name);
    }

}
