import Toybox.System;
import Toybox.WatchUi;

class MainMenu {
    private static var _menu;

    function initialize() {
        if(_menu == null) {
            setMenu();
        }
    }

    function getView() {
        return _menu;
    }

    function updateSubLabel(id, valueInMin) {
        switch(id) {
            case "total_time":
                var totalFormattedTime = valueInMin.toString() + " min";
                _menu.getItem(0).setSubLabel(totalFormattedTime);
                break;
            case "interval_time":
                var intervalFormattedTime = valueInMin.toString() + " min";
                _menu.getItem(1).setSubLabel(intervalFormattedTime);
                break;
        }
    }

    private function setMenu() {
        _menu = new WatchUi.Menu2(null);

        var totalTimeLabel = TimeDurationsStorage.getTotalTimeInMinDuration().toString() + " min";
        var intervalTimeLabel = TimeDurationsStorage.getIntervalTimeInMinDuration().toString() + " min";

        _menu.addItem(new WatchUi.MenuItem("Total time", totalTimeLabel, "total_time", null));
        _menu.addItem(new WatchUi.MenuItem("Interval time", intervalTimeLabel, "interval_time", null));
        if (GlobalVariables.deviceSettings has :hasTouchscreen && GlobalVariables.deviceSettings.hasTouchscreen) {
            _menu.addItem(new WatchUi.ToggleMenuItem(
                "Touch screen", 
                {:enabled=>"enabled", :disabled=>"disabled"},
                "use_touch_screen",
                    SettingsStorage.getUseTouchScreen(),
                    null
            ));
        }
        _menu.addItem(new WatchUi.ToggleMenuItem(
            "Screen backlight", 
            {:enabled=>"always", :disabled=>"alerts only"},
            "is_screen_always_on",
            SettingsStorage.getIsScreenAlwaysOn(),
            null
        ));
    }
}
