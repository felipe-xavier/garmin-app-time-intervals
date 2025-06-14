class ProgressManager {
    private static var _instance = null;
    private var _activityStatus = ActivityStatus.stopped;
    private var _currentTotalDuration;
    private var _currentNumberOfIntervals;

    /* Get the singleton instance **/
    static function getInstance() {
        if (_instance == null) {
            _instance = new ProgressManager();
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

    function getActivityStatus() {
        return _activityStatus;
    }
}
