package priori.system;

import js.html.Navigator;
import js.Browser;

class PriDevice {

    private static var _detectedBrowser:PriDeviceBrowser = null;

    public static function browser():PriDeviceBrowser {
        if (_detectedBrowser == null) {

            var navigator:Navigator = Browser.navigator;
            var userAgent:String = navigator.userAgent;

            if(userAgent.indexOf("Chrome") > -1) {
                _detectedBrowser = PriDeviceBrowser.CHROME;
            } else if (userAgent.indexOf("Safari") > -1) {
                _detectedBrowser = PriDeviceBrowser.SAFARI;
            } else if (userAgent.indexOf("Opera") > -1) {
                _detectedBrowser = PriDeviceBrowser.OPERA;
            } else if (userAgent.indexOf("Firefox") > -1) {
                _detectedBrowser = PriDeviceBrowser.MOZILLA;
            } else if (userAgent.indexOf("MSIE") > -1) {
                _detectedBrowser = PriDeviceBrowser.MSIE;
            } else {
                _detectedBrowser = PriDeviceBrowser.UNKNOW;
            }
        }

        return _detectedBrowser;
    }

    public static function deviceSystem():PriDeviceSystem {
        var navigator:Navigator = Browser.navigator;
        var userAgent:String = navigator.userAgent;

        if (userAgent.indexOf("Macintosh") > -1) {
            return PriDeviceSystem.MAC;
        } else if (~/Android/i.match(userAgent)) {
            return PriDeviceSystem.ANDROID;
        } else if (~/BlackBerry/i.match(userAgent)) {
            return PriDeviceSystem.BLACKBERRY;
        } else if (~/iPhone|iPad|iPod/i.match(userAgent)) {
            return PriDeviceSystem.IOS;
        } else if (~/Opera Mini/i.match(userAgent)) {
            return PriDeviceSystem.OPERAMINI;
        } else if (~/IEMobile|WPDesktop/i.match(userAgent)) {
            return PriDeviceSystem.WINDOWSMOBILE;
        } else if (userAgent.indexOf("Linux") > -1) {
            return PriDeviceSystem.LINUX;
        } else if (userAgent.indexOf("Windows") > -1) {
            return PriDeviceSystem.WINDOWS;
        }

        return PriDeviceSystem.UNKNOW;
    }

    public static function isMobileDevice():Bool {
        var system:PriDeviceSystem = deviceSystem();

        if (system == PriDeviceSystem.ANDROID ||
            system == PriDeviceSystem.IOS ||
            system == PriDeviceSystem.BLACKBERRY ||
            system == PriDeviceSystem.OPERAMINI ||
            system == PriDeviceSystem.WINDOWSMOBILE
        ) {
            return true;
        }

        return false;
    }

}
