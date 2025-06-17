import Toybox.Application;

var useTouchScreenKey = "useTouchScreen";
var resetOnBackKey = "resetOnBack";

class SettingsStorage {

    static function getUseTouchScreen() {
        return Application.Properties.getValue(useTouchScreenKey);
    }

    static function setUseTouchScreen(value) {
        Application.Properties.setValue(useTouchScreenKey, value);
    }

    static function getResetOnBack() {
        return Application.Properties.getValue(resetOnBackKey);
    }

    static function setResetOnBack(value) {
        Application.Properties.setValue(resetOnBackKey, value);
    }
}
