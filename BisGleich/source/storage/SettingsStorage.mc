import Toybox.Application;

var useTouchScreenKey = "useTouchScreen";

class SettingsStorage {

    static function getUseTouchScreen() {
        return Application.Properties.getValue(useTouchScreenKey);
    }

    static function setUseTouchScreen(value) {
        Application.Properties.setValue(useTouchScreenKey, value);
    }
}
