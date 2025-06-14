import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class BisGleichDelegate extends WatchUi.BehaviorDelegate {

    private var _activityManager as ActivityManager;
    private var _notificationManager;
    private var _view;
    private var _currentTotalDuration;
    private var _currentIntervalDuration;
    private var _currentNumberOfIntervals;
    private var _timer;

    private var _progressManager as ProgressManager;

    function initialize(notificationManager, view) {
        _timer = new Timer.Timer();
        _activityManager = ActivityManager.getInstance();
        _notificationManager = notificationManager;
        _view = view;
        _progressManager = ProgressManager.getInstance();
        BehaviorDelegate.initialize();
    }

    function openMenu() as Boolean {
        WatchUi.pushView((new MainMenu()).getView(), new MainMenuViewDelegate(), WatchUi.SLIDE_UP);
        // WatchUi.pushView(new Rez.Menus.MainMenu(), new BisGleichMenuDelegate(), WatchUi.SLIDE_UP);
        System.println("BisGleichDelegate onMenu called");
        return true;
    }

   
    
    function onKeyPressed(keyEvent as KeyEvent) as Boolean {
        System.println("BisGleichDelegate onKeyPressed called with key: " + keyEvent.getKey() + ", type: " + keyEvent.getType() + ", string: " + keyEvent.toString());

        if (keyEvent.getKey() == WatchUi.KEY_UP) {
            return openMenu();
        }


        return false; // Indicate that the key event was not handled
    }

    function onSelect() as Boolean {
        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus == ActivityStatus.playing) {
            _activityManager.pauseActivity();
            _timer.stop();
            return true; 
        }

        if (activityStatus == ActivityStatus.stopped) {
            _activityManager.startActivity();
            startActivity();
            return true; 
        }
        
         if (activityStatus == ActivityStatus.paused) {
            _activityManager.startActivity();
            startTimer();
            return true; 
        }
        
        return true; // Indicate that the select action was handled
    }

    function startTimer() {
        _timer.start(method(:updateCountdownValue), 1000, true);
    }

    function startActivity() {
       
        _currentTotalDuration = _progressManager.getCurrentDurationInSec();
        _currentIntervalDuration = _progressManager.getIntervalDurationInSec();
        _currentNumberOfIntervals = _progressManager.getCurrentIntervalsCount();

        _view.updateIntervalsValue(_currentNumberOfIntervals);
        _view.updateCurrentTimerValue(_currentTotalDuration);

        startTimer();
    }

    function updateCountdownValue() as Void {
        if (_currentTotalDuration <= 0) {
            System.println("Countdown finished");
            _timer.stop();
            _activityManager.stopActivity(); // Reset the flag when countdown is finished
            _notificationManager.callAttention(AttentionLevel.High, true);
            _view.updateIntervalsValue(0);

            return;
        }

        if (_currentIntervalDuration <= 0) {
            _currentNumberOfIntervals--;
            System.println("Interval finished, intervals left: " + _currentNumberOfIntervals);
            _currentIntervalDuration = _progressManager.getIntervalDurationInSec(); // Reset interval duration for the next interval
            _notificationManager.callAttention(AttentionLevel.Low, true);
            _view.updateIntervalsValue(_currentNumberOfIntervals);
        }


        _currentTotalDuration--;
        _currentIntervalDuration--;
        _view.updateCurrentTimerValue(_currentTotalDuration);
        _progressManager.setCurrentDurationInSec(_currentTotalDuration);

    }

    function onBack() as Boolean {
        System.println("BisGleichDelegate onBack called");
        // Handle back action if needed
        // For example, you might want to pop the current view or perform a specific action
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true; // Indicate that the back action was handled
    }
}
