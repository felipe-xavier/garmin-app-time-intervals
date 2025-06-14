import Toybox.System;
import Toybox.WatchUi;

class ActivityMenu {
    private static var _menu;
    private var _activityManager;


    function initialize() {
        if(_menu == null) {
            _activityManager = ActivityManager.getInstance();

            setMenu();
        }
    }

    function getView() {
        return _menu;
    }

    private function setMenu() {
        _menu = new WatchUi.Menu2(null);
        var firstMenu = null;
        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus == ActivityStatus.playing) {
            firstMenu = "Pause";
        } else if (activityStatus == ActivityStatus.paused) {
            firstMenu = "Resume";
        } else if (activityStatus == ActivityStatus.stopped) {
            firstMenu = "Start";
        }

        if (firstMenu != null) {
            _menu.addItem(new WatchUi.MenuItem(firstMenu, null, "play_pause_resume", null));
        }
        _menu.addItem(new WatchUi.MenuItem("Stop", null, "stop", null));
  
    }
}
