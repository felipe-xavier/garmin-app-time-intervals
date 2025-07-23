import Toybox.Lang;
import Toybox.WatchUi;

class BisGleichDelegate extends WatchUi.BehaviorDelegate {

    private var _progressManager as ProgressManager;
    private var _activityManager as ActivityManager;
    private var _notificationManager as NotificationManager;
    private var _view;
    private var _currentTotalDuration;
    private var _currentIntervalDuration;
    private var _currentNumberOfIntervals;

    function initialize(view as BisGleichView) {
        _activityManager = ActivityManager.getInstance();
        _notificationManager = NotificationManager.getInstance();
        _view = view;
        _progressManager = ProgressManager.getInstance();
        BehaviorDelegate.initialize();
        var savedStatus = ActivityStateStorage.getActivityStatus();
        var savedDurationInSec = ActivityStateStorage.getCurrentDurationInSec();
        var savedTargetTimeInSec = ActivityStateStorage.getTargetTimeInSec();
        var savedCurrentTimeInSec = ActivityStateStorage.getCurrentTimeInSec();
        System.println("BisGleichDelegate initialize, savedStatus: " + savedStatus + ", savedDurationInSec: " + savedDurationInSec + ", savedTargetTimeInSec: " + savedTargetTimeInSec);
        if (savedDurationInSec == -1 || savedTargetTimeInSec == -1) {
            return;
        }
        //  activityState: 0, targetTime: 2949, currentDuration: 115
        ActivityStateStorage.clearState();
        var currentTimeInSec = getTimeInSec(System.getClockTime());
        if (savedCurrentTimeInSec > currentTimeInSec) {
            return;
        }
        System.println("BisGleichDelegate initialize, currentTimeInSec: " + currentTimeInSec);
        var newDurationTimeInSec = savedTargetTimeInSec - currentTimeInSec;
        var originalIntervalDurationInSec = _progressManager.getIntervalDurationInSec();
        var newIntervalDurationInSec = newDurationTimeInSec % originalIntervalDurationInSec;

        if (savedStatus == ActivityStatus.playing) {
            if (currentTimeInSec < savedTargetTimeInSec) {
                _activityManager.setActivityStatus(ActivityStatus.playing);
                _progressManager.setCurrentDurationInSec(newDurationTimeInSec);
                _progressManager.setCurrentIntervalDurationInSec(newIntervalDurationInSec);
                _progressManager.setTargetTimeInSec(savedTargetTimeInSec);
                _view.updateCurrentTimerValue(newDurationTimeInSec);
                startActivity();
                return;
            }
        }
    }

    function openMenu() as Boolean {
        WatchUi.pushView((new MainMenu()).getView(), new MainMenuViewDelegate(), WatchUi.SLIDE_UP);
        System.println("BisGleichDelegate onMenu called");
        return true;
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) {
        var direction = swipeEvent.getDirection();

        if (direction == WatchUi.SWIPE_LEFT) {
            var activityStatus = _activityManager.getActivityStatus();
            if (activityStatus == ActivityStatus.stopped) {
                return openMenu();
            } else {
                onReset();
                return true;
            }
        }
        return false;
    }
    
    function onKeyPressed(keyEvent as KeyEvent) as Boolean {
        System.println("BisGleichDelegate onKeyPressed with key: " + keyEvent.getKey());

        if (keyEvent.getKey() == WatchUi.KEY_UP) {
            var activityStatus = _activityManager.getActivityStatus();
            if (activityStatus == ActivityStatus.stopped) {
                return openMenu();
            } else {
                onReset();
                return true;
            }

        }

        if (keyEvent.getKey() == WatchUi.KEY_ENTER) {
            if (SettingsStorage.getUseTouchScreen() == false) {
                handleSelect();
                return true;
            }
        }

        return false; // Indicate that the key event was not handled
    }

    function onSelect() as Boolean {
        if (SettingsStorage.getUseTouchScreen() == true) {
            handleSelect();
            return true;
        }
        
        return false; // Indicate that the select action was handled
    }

    function handleSelect() {
        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus == ActivityStatus.playing) {
            _activityManager.pauseActivity();
            _notificationManager.removeCallback(NotificationManager.startActivityKey);
        } else if (activityStatus == ActivityStatus.stopped) {
            _activityManager.startActivity();
            startActivity();
        } else if (activityStatus == ActivityStatus.paused) {
            _activityManager.startActivity();
            startTimer();
        } else if (activityStatus == ActivityStatus.overtime) {
            onReset();
        }
    }

    function onReset() {
        _activityManager.stopActivity();
        _notificationManager.removeCallback(NotificationManager.startPostActivityKey);
        _notificationManager.removeCallback(NotificationManager.startActivityKey);

        _progressManager.reset();
        
        _view.onReset();
    }

    function startActivity() {
       
        _currentTotalDuration = _progressManager.getCurrentDurationInSec();
        _currentIntervalDuration = _progressManager.getCurrentIntervalDurationInSec();
        _currentNumberOfIntervals = _progressManager.getCurrentIntervalsCount();

        _view.updateIntervalsValue(_currentNumberOfIntervals);
        _view.updateCurrentTimerValue(_currentTotalDuration);

        startTimer();
    }

    function startTimer() {
        _notificationManager.callEverySecond(NotificationManager.startActivityKey, method(:updateCountdownValue));
    }

    function updateCountdownValue() as Void {
        _currentTotalDuration--;
        _currentIntervalDuration--;

        if (_currentTotalDuration <= 0) {
            System.println("Countdown finished");
            _notificationManager.removeCallback(NotificationManager.startActivityKey);
            _activityManager.overtimeActivity(); // Reset the flag when countdown is finished
            _notificationManager.callAttention(AttentionLevel.High, true);
            _view.updateIntervalsValue(0);
            startOvertime();
            return;
        }

        if (_currentIntervalDuration <= 0) {
            _currentNumberOfIntervals--;
            System.println("Interval finished, intervals left: " + _currentNumberOfIntervals);
            _currentIntervalDuration = _progressManager.getIntervalDurationInSec(); // Reset interval duration for the next interval
            _notificationManager.callAttention(AttentionLevel.Low, true);
            _view.updateIntervalsValue(_currentNumberOfIntervals);
        }
       
        _view.updateCurrentTimerValue(_currentTotalDuration);
        _progressManager.setCurrentDurationInSec(_currentTotalDuration);

    }

    function startPostActivity() {
        _currentTotalDuration++;
        _view.updateCurrentTimerValue(_currentTotalDuration);
    }

    function startOvertime() {
        _notificationManager.callEverySecond(NotificationManager.startPostActivityKey, method(:startPostActivity));
    }

    function onBack() as Boolean {
        System.println("BisGleichDelegate onBack called");
        
        // Save state if activity is playing
        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus == ActivityStatus.playing) {
            ActivityStateStorage.setActivityStatus(activityStatus);
            ActivityStateStorage.setCurrentDurationInSec(_progressManager.getCurrentDurationInSec());
            ActivityStateStorage.setTargetTimeInSec(_progressManager.getTargetTimeInSec());
            ActivityStateStorage.setCurrentTimeInSec(getTimeInSec(System.getClockTime()));
            System.println("BisGleichDelegate onBack called, activityState: " + activityStatus + ", targetTime: " + _progressManager.getTargetTimeInSec() + ", currentDuration: " + _progressManager.getCurrentDurationInSec());
        } else {
            ActivityStateStorage.clearState();
        }
        
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
