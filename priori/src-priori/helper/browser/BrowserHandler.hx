package helper.browser;

import priori.system.PriDevice;
import priori.system.PriDeviceBrowser;

class BrowserHandler {

    public static var MIN_FLOAT_POINT:Float = getMinFloat();

    private static function getMinFloat():Float {
        return switch(PriDevice.browser()) {
            case PriDeviceBrowser.CHROME | PriDeviceBrowser.WEBKIT | PriDeviceBrowser.OPERA | PriDeviceBrowser.SAFARI : 0.0001;
            case _: 0.01;
        }
    }

}