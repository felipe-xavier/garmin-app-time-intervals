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
        System.println("Progress Manager - reset - _totalDurationInSec: " + _totalDurationInSec.toString() + " _intervalDurationInSec: " + _intervalDurationInSec.toString());

    }

    /* Get the singleton instance **/
    static function getInstance() {
        if (_instance == null) {
            _instance = new ProgressManager();
        }
        return _instance;
    }

    function setCurrentDurationInSec(value) {
        System.println("Progress Manager - setCurrentDurationInSec: " + value.toString());
        _currentDurationInSec = value;
    }

    function getCurrentDurationInSec() {
        return _currentDurationInSec;
    }

    function getIntervalDurationInSec() {
        return _intervalDurationInSec;
    }

    function getCurrentIntervalsCount() {
        System.println("Progress Manager - getCurrentIntervalsCount - _intervalDurationInSec: " + _intervalDurationInSec.toString());

        var extraInterval = _totalDurationInSec % _intervalDurationInSec > 0 ? 1 : 0;
        return (_totalDurationInSec / _intervalDurationInSec) + extraInterval;
    }

    function getFinishTime() {

    }
}
