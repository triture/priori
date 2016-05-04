package priori.assets;

import priori.event.PriEvent;

class AssetManagerEvent extends PriEvent {

    public static var ASSET_COMPLETE:String = "AssetManagerComplete";
    public static var ASSET_ERROR:String = "AssetManagerError";
    public static var ASSET_PROGRESS:String = "AssetManagerProgress";

    public var percentLoaded:Float;

    public function new(type:String, percentLoaded:Float) {
        super(type);

        this.percentLoaded = percentLoaded;
    }


    override public function clone():PriEvent {
        var clone:AssetManagerEvent = new AssetManagerEvent(this.type, this.percentLoaded);

        clone.target = this.target;
        clone.currentTarget = this.currentTarget;
        clone.data = null;

        return clone;
    }

}
