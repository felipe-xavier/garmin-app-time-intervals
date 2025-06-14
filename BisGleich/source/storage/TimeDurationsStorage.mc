import Toybox.Application;

var totalTimeKey = "totalTimeInMinKey";
var intervalTimeKey = "intervalTimeInMinKey";

class TimeDurationsStorage {

    static function getTotalTimeInMinDuration() {
        return Application.Properties.getValue(totalTimeKey);
    }

    static function setTotalTimeInMinDuration(value) {
        Application.Properties.setValue(totalTimeKey, value);
    }

    static function getIntervalTimeInMinDuration() {
        return Application.Properties.getValue(intervalTimeKey);
    }

    static function setIntervalTimeInMinDuration(value) {
        Application.Properties.setValue(intervalTimeKey, value);
    }
}
