import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Timer;

class BisGleichDelegate extends WatchUi.BehaviorDelegate {

    private var alertIntervalInSec as Integer = 5; 
    private var totalDurationInSec as Integer = 18; 

    private var _notificationManager;
    private var _view;
    private var _isInProgress as Boolean = false;
    private var _currentTotalDuration;
    private var _currentIntervalDuration;
    private var _currentNumberOfIntervals;
    private var _timer;

    function initialize(notificationManager, view) {
        _notificationManager = notificationManager;
        _view = view;
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
        if (_isInProgress) {
            System.println("BisGleichDelegate onSelect called but already in progress");
            return false; // Prevent multiple selections if already in progress
        }
        _isInProgress = true; // Set the flag to indicate that an action is in progress
        System.println("BisGleichDelegate onSelect called");
        
        startCountdown(); 
        
        return true; // Indicate that the select action was handled
    }

    function startCountdown() {
        _currentTotalDuration = totalDurationInSec;
        _currentIntervalDuration = alertIntervalInSec;
        var extraInterval = 18 % 5 > 0 ? 1 : 0;
        _currentNumberOfIntervals = (totalDurationInSec / alertIntervalInSec) + extraInterval;
        System.println("Starting countdown with total duration: " + _currentTotalDuration + " seconds, interval: " + _currentIntervalDuration + " seconds, intervals left: " + _currentNumberOfIntervals);

        _view.updateIntervalsValue(_currentNumberOfIntervals);
        _view.updateCurrentTimerValue(_currentTotalDuration);

        _timer = new Timer.Timer();
        _timer.start(method(:updateCountdownValue), 1000, true);
    }

    function updateCountdownValue() as Void {

        
        if (_currentTotalDuration <= 0) {
            System.println("Countdown finished");
            _timer.stop();
            _isInProgress = false; // Reset the flag when countdown is finished
            _notificationManager.callAttention(AttentionLevel.High, true);
            _view.updateIntervalsValue(0);

            return;
        }

        if (_currentIntervalDuration <= 0) {
            _currentNumberOfIntervals--;
            System.println("Interval finished, intervals left: " + _currentNumberOfIntervals);
            _currentIntervalDuration = alertIntervalInSec; // Reset interval duration for the next interval
            _notificationManager.callAttention(AttentionLevel.Low, true);
            _view.updateIntervalsValue(_currentNumberOfIntervals);
        }


        _currentTotalDuration--;
        _currentIntervalDuration--;
        _view.updateCurrentTimerValue(_currentTotalDuration);

    }

    function onBack() as Boolean {
        System.println("BisGleichDelegate onBack called");
        // Handle back action if needed
        // For example, you might want to pop the current view or perform a specific action
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true; // Indicate that the back action was handled
    }
}
