import Toybox.Application;

var activityStatusKey = "activityStatus";
var currentDurationInSecKey = "currentDurationInSec";
var targetTimeInSecKey = "targetTimeInSec";
var currentTimeInSecKey = "currentTimeInSec";

class ActivityStateStorage {

    static function getActivityStatus() {
        var stateValue = Application.Properties.getValue(activityStatusKey);
        if (stateValue == null) {
            return null;
        }
        // Convert number back to enum
        switch(stateValue) {
            case 0:
                return ActivityStatus.stopped;
            case 1:
                return ActivityStatus.playing;
            case 2:
                return ActivityStatus.paused;
            case 3:
                return ActivityStatus.overtime;
            default:
                return ActivityStatus.stopped;
        }
    }

    static function setActivityStatus(value) {
        if (value == null) {
            Application.Properties.setValue(activityStatusKey, null);
            return;
        }
        // Convert enum to number
        var stateValue;
        switch(value) {
            case ActivityStatus.stopped:
                stateValue = 0;
                break;
            case ActivityStatus.playing:
                stateValue = 1;
                break;
            case ActivityStatus.paused:
                stateValue = 2;
                break;
            case ActivityStatus.overtime:
                stateValue = 3;
                break;
            default:
                stateValue = 0;
        }
        Application.Properties.setValue(activityStatusKey, stateValue);
    }

    static function getCurrentDurationInSec() {
        return Application.Properties.getValue(currentDurationInSecKey);
    }

    static function setCurrentDurationInSec(value) {
        Application.Properties.setValue(currentDurationInSecKey, value);
    }

    static function getTargetTimeInSec() {
        return Application.Properties.getValue(targetTimeInSecKey);
    }

    static function setTargetTimeInSec(value) {
        Application.Properties.setValue(targetTimeInSecKey, value);
    }

    static function getCurrentTimeInSec() {
        return Application.Properties.getValue(currentTimeInSecKey);
    }

    static function setCurrentTimeInSec(value) {
        Application.Properties.setValue(currentTimeInSecKey, value);
    }

    static function clearState() {
        Application.Properties.setValue(activityStatusKey, 2);
        Application.Properties.setValue(currentDurationInSecKey, -1);
        Application.Properties.setValue(targetTimeInSecKey, -1);
        Application.Properties.setValue(currentTimeInSecKey, -1);
    }
}
