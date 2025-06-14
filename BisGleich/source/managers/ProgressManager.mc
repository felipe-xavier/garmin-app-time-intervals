class ProgressManager {
    private static var _instance = null;
    private var _totalDurationInSec;
    private var _currentDurationInSec;

    private var _intervalDurationInSec;

    private function initValues() {
        _totalDurationInSec = TimeDurationsStorage.getTotalTimeInMinDuration() * 60;
        _currentDurationInSec = _totalDurationInSec;
        _intervalDurationInSec = TimeDurationsStorage.getIntervalTimeInMinDuration() * 60;
    }

    function initialize() {
        initValues();
    }

    function reset() {
        initValues();
    }

    /* Get the singleton instance **/
    static function getInstance() {
        if (_instance == null) {
            _instance = new ProgressManager();
        }
        return _instance;
    }

    function setCurrentDurationInSec(value) {
        _currentDurationInSec = value;
    }

    function getCurrentDurationInSec() {
        return _currentDurationInSec;
    }

    function getIntervalDurationInSec() {
        return _intervalDurationInSec;
    }

    function getCurrentIntervalsCount() {
        var extraInterval = _currentDurationInSec % _intervalDurationInSec > 0 ? 1 : 0;
        return (_currentDurationInSec / _intervalDurationInSec) + extraInterval;
    }
}
