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

        var totalTimeLabel = IntervalsManager.getTotalTimeInMinDuration().toString() + " min";
        var intervalTimeLabel = IntervalsManager.getIntervalTimeInMinDuration().toString() + " min";

        // var hotDurationLbl = CyclesManager.getCycleDuration(WaterType.Hot).toString() + "sec";
        // var coldDurationLbl = CyclesManager.getCycleDuration(WaterType.Cold).toString() + "sec";
        // var swtichDurationLbl = CyclesManager.getCycleDuration(WaterType.Switch).toString() + "sec";
        // var cyclesCountLbl = CyclesManager.getCyclesCount().toString();
   
        _menu.addItem(new WatchUi.MenuItem("Total time (min)", totalTimeLabel, "total_time", null));
        _menu.addItem(new WatchUi.MenuItem("Interval time (min)", intervalTimeLabel, "interval_time", null));
        // _menu.addItem(new WatchUi.MenuItem("Cold duration", coldDurationLbl, "cold_duration", null));
        // _menu.addItem(new WatchUi.MenuItem("Switch duration", swtichDurationLbl, "switch_duration", null));
        // _menu.addItem(new WatchUi.MenuItem("Cycles", cyclesCountLbl, "cycles_count", null));
        // _menu.addItem(new WatchUi.ToggleMenuItem(
        //     "Record activity", 
        //     {:enabled=>"Yes", :disabled=>"No"},
        //     "record_activity",
        //     ActivityManager.getRecordActivityFlag(),
        //     null
        // ));
        // _menu.addItem(new WatchUi.ToggleMenuItem(
        //     "Double click", 
        //     {:enabled=>"Yes", :disabled=>"No"},
        //     "use_double_click",
        //     CyclesManager.getUseDoubleClickFlag(),
        //     null
        // ));
    }
}
