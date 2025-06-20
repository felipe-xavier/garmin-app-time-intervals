// Class used to keep track and share the progress of the activity
class ProgressManager {
    private static var _instance = null;
    private var _currentDurationInSec;
    private var _intervalDurationInSec;
    private var _currentIntervalDurationInSec;
    private var _targetTimeInSec;

    private function initValues() {
        _currentDurationInSec = TimeDurationsStorage.getTotalTimeInMinDuration() * 60;
        _intervalDurationInSec = TimeDurationsStorage.getIntervalTimeInMinDuration() * 60;
        _currentIntervalDurationInSec = _intervalDurationInSec;
        _targetTimeInSec = 0;
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

    function setIntervalDurationInSec(value) {
        _intervalDurationInSec = value;
    }

    function getCurrentIntervalDurationInSec() {
        return _currentIntervalDurationInSec;
    }

    function setCurrentIntervalDurationInSec(value) {
        _currentIntervalDurationInSec = value;
    }

    function getTargetTimeInSec() {
        return _targetTimeInSec;
    }

    function setTargetTimeInSec(value) {
        _targetTimeInSec = value;
    }

    function getCurrentIntervalsCount() {
        var extraInterval = _currentDurationInSec % _intervalDurationInSec > 0 ? 1 : 0;
        return (_currentDurationInSec / _intervalDurationInSec) + extraInterval;
    }
}
