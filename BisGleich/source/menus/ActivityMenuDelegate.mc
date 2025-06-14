import Toybox.Lang;
import Toybox.WatchUi;

class ActivityMenuViewDelegate extends WatchUi.Menu2InputDelegate {
    private var _progressManager as ProgressManager;
    private var _activityManager as ActivityManager;
    private var _notificationManager as NotificationManager;

    // Constructor
    function initialize() {
        _progressManager = ProgressManager.getInstance();
        _activityManager = ActivityManager.getInstance();
        _notificationManager = NotificationManager.getInstance();
        Menu2InputDelegate.initialize();
    }

    // On Select button clicked
    function onSelect(item as MenuItem) as Void {
        var id = item.getId().toString();

        if (id.equals("play_pause_resume")) {
            handleOnPauseResume();
        } else if (id.equals("stop")) {
            handleOnStop();
        }
    }

    function handleOnPauseResume() as Void {
        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus == ActivityStatus.playing) {
            _activityManager.pauseActivity();
            _notificationManager.removeCallback(NotificationManager.startActivityKey);
        } else if (activityStatus == ActivityStatus.paused) {
            _activityManager.startActivity();
        } else if (activityStatus == ActivityStatus.stopped) {
            _activityManager.startActivity();
        }

        _progressManager.reset();
    }

    function handleOnStop() as Void {
        _progressManager.reset();
    }

}
