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

    function updateSubLabel(id, value) {
        switch(id) {
            case "total_time":
                var totalMinutes = value / 60;
                var totalSeconds = value % 60;
                var totalFormattedTime = totalMinutes.toString() + ":" + (totalSeconds < 10 ? "0" : "") + totalSeconds.toString();
                _menu.getItem(0).setSubLabel(totalFormattedTime);
                break;
            case "interval_time":
                var intervalMinutes = value / 60;
                var intervalSeconds = value % 60;
                var intervalFormattedTime = intervalMinutes.toString() + ":" + (intervalSeconds < 10 ? "0" : "") + intervalSeconds.toString();
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
  
    }
}
