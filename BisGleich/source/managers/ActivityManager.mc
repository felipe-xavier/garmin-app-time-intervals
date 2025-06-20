class ActivityManager {
    private static var _instance = null;
    private var _activityStatus = ActivityStatus.stopped;

    /* Get the singleton instance **/
    static function getInstance() {
        if (_instance == null) {
            _instance = new ActivityManager();
        }
        return _instance;
    }

    function startActivity() {
        _activityStatus = ActivityStatus.playing;
    }

    function pauseActivity() {
        _activityStatus = ActivityStatus.paused;
    }

    function stopActivity() {
        _activityStatus = ActivityStatus.stopped;
    }

    function overtimeActivity() {
        _activityStatus = ActivityStatus.overtime;
    }

    function getActivityStatus() {
        return _activityStatus;
    }

    function setActivityStatus(status) {
        _activityStatus = status;
    }
}
