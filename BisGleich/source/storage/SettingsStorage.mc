import Toybox.Application;

var useTouchScreenKey = "useTouchScreen";
var isScreenAlwaysOnKey = "isScreenAlwaysOn";

class SettingsStorage {

    static function getUseTouchScreen() {
        return Application.Properties.getValue(useTouchScreenKey);
    }

    static function setUseTouchScreen(value) {
        Application.Properties.setValue(useTouchScreenKey, value);
    }

    static function getIsScreenAlwaysOn() {
        return Application.Properties.getValue(isScreenAlwaysOnKey);
    }

    static function setIsScreenAlwaysOn(value) {
        Application.Properties.setValue(isScreenAlwaysOnKey, value);
    }
}
