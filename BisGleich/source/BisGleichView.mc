import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;
import Toybox.Activity;

class BisGleichView extends WatchUi.View {
    private var _currentTimerElement;
    private var _intervalsLeftElement;
    private var _timeOfTheDayElement;
    private var _targetTimeElement;
    private var _targetTimeLabelElement;
    private var _heartRateElement;
    private var _heartRateIcon;

    private var _activityManager as ActivityManager;
    private var _progressManager as ProgressManager;
    private var _notificationManager as NotificationManager;

    function initialize() {
        _activityManager = ActivityManager.getInstance();
        _notificationManager = NotificationManager.getInstance();
        _progressManager = ProgressManager.getInstance();

        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(createLayout(dc));
            
        updateTargetTime();
        updateDynamicData();

        _notificationManager.callEverySecond(NotificationManager.updateDynamicDataKey, method(:updateDynamicData));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        _targetTimeElement.setColor(Graphics.COLOR_RED);
        _targetTimeLabelElement.setColor(Graphics.COLOR_RED);

        // Calculate number of intervals using ProgressManager
        var intervalsCount = _progressManager.getCurrentIntervalsCount();
        updateIntervalsValue(intervalsCount);

        // Format and display the current timer value in MM:SS
        var currentTimeInSec = _progressManager.getCurrentDurationInSec();
        updateCurrentTimerValue(currentTimeInSec);

        updateDynamicData();
    }


    function onReset() as Void {
        _currentTimerElement.setColor(Graphics.COLOR_WHITE);
        updateIntervalsValue(_progressManager.getCurrentIntervalsCount());
        updateCurrentTimerValue(_progressManager.getCurrentDurationInSec());
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        var activityStatus = _activityManager.getActivityStatus();

        if (activityStatus == ActivityStatus.playing) {
            _targetTimeElement.setColor(Graphics.COLOR_GREEN);
            _currentTimerElement.setColor(Graphics.COLOR_WHITE);
        } else if (activityStatus == ActivityStatus.stopped) {
            _targetTimeElement.setColor(Graphics.COLOR_ORANGE);
        } else if (activityStatus == ActivityStatus.paused) {
            _targetTimeElement.setColor(Graphics.COLOR_ORANGE);
            _currentTimerElement.setColor(Graphics.COLOR_ORANGE);
        } else if (activityStatus == ActivityStatus.overtime) {
            _targetTimeElement.setColor(Graphics.COLOR_RED);
            _currentTimerElement.setColor(Graphics.COLOR_RED);
            _intervalsLeftElement.setText("overtime");
        }
        View.onUpdate(dc);
    }

    

    function drawScreenDots(dc as Dc) as Void {
        var activityStatus = _activityManager.getActivityStatus();
        var color = activityStatus == ActivityStatus.stopped ? Graphics.COLOR_WHITE : Graphics.COLOR_DK_GRAY;
        drawDots(dc, 180, color); // UP
        // drawDots(dc, 330, Graphics.COLOR_WHITE); // START
        // drawDots(dc, 30, Graphics.COLOR_WHITE); // BACK
        // drawDots(dc, 150, Graphics.COLOR_WHITE); // DOWN
        // drawDots(dc, 210, Graphics.COLOR_WHITE); // LIGHT
    }

    function updateIntervalsValue(cycles) as Void {
        if (_intervalsLeftElement == null) {
            return;
        }
        _intervalsLeftElement.setText(FormatManager.formatIntervals(cycles));
        WatchUi.requestUpdate();
    }

    function updateCurrentTimerValue(value) as Void {
        if (_currentTimerElement == null) {
            return;
        }
        _currentTimerElement.setText(FormatManager.formatTimeMMSS(value));
        WatchUi.requestUpdate();
    }

    function updateDynamicData() as Void {
        updateSensorsData();

        var time = System.getClockTime();
        _timeOfTheDayElement.setText(FormatManager.formatTime(time.hour, time.min, time.sec));

        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus == ActivityStatus.paused || activityStatus == ActivityStatus.stopped) {
            updateTargetTime();
        }

        WatchUi.requestUpdate();
    }

    function updateTargetTime() as Void {
        var currentTimeInSec = getTimeInSec(System.getClockTime());

        var extraDurationTimeInSec = _progressManager.getCurrentDurationInSec();

        var totalSeconds = currentTimeInSec + extraDurationTimeInSec;
        _progressManager.setTargetTimeInSec(totalSeconds);

        var targetHour = (totalSeconds / 3600) % 24;
        var targetMin = (totalSeconds % 3600) / 60;
        var targetSec = totalSeconds % 60;

        _targetTimeElement.setText(FormatManager.formatTime(targetHour, targetMin, targetSec));
    }

    function updateSensorsData() {
        var heartRate = Activity.getActivityInfo().currentHeartRate;
        _heartRateElement.setText(FormatManager.formatHeartRate(heartRate));

        if (heartRate == null) {
            _heartRateElement.setColor(Graphics.COLOR_WHITE);
        } else {
            _heartRateElement.setColor(Graphics.COLOR_RED);
        }
    }

    private function createLayout(dc as Dc) as Lang.Array<Drawable> {
        var height = dc.getHeight();
        var width = dc.getWidth();

        // Calculate centered positions for the heart rate icon and text to keep them close
        var heartRateIconDrawable = WatchUi.loadResource(Rez.Drawables.heart_rate_icon);
        var iconWidth = heartRateIconDrawable.getWidth();
        var iconHeight = heartRateIconDrawable.getHeight();
        
        var heartRateText = "--"; // Use placeholder for width calculation
        var heartRateFont = Graphics.FONT_TINY;
        var textWidth = dc.getTextWidthInPixels(heartRateText, heartRateFont);
        
        var groupGap = 5; // 5px gap between icon and text
        var totalGroupWidth = iconWidth + groupGap + textWidth;
        var groupStartX = (width - totalGroupWidth) / 2;
        var groupY = height * 0.10;

        _heartRateIcon = new WatchUi.Bitmap({
            :rezId => Rez.Drawables.heart_rate_icon,
            :locX => groupStartX,
            :locY => groupY,
            :color => Graphics.COLOR_RED,
        });

        _heartRateElement = new WatchUi.Text({
            :text => heartRateText,
            :color => Graphics.COLOR_WHITE,
            :font => heartRateFont,
            :locX => groupStartX + iconWidth + groupGap,
            :locY => groupY + (iconHeight / 2) - (dc.getFontHeight(heartRateFont) / 2) + 1
        });

        _timeOfTheDayElement = new WatchUi.Text({
            :text => "00:00",
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_XTINY,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => height * 0.22,
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });

        _currentTimerElement = new WatchUi.Text({
            :text => "0:00",
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_NUMBER_THAI_HOT,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER,
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });

        _intervalsLeftElement = new WatchUi.Text({
            :text => " ",
            :color => Graphics.COLOR_WHITE,
            :font => Graphics.FONT_SMALL,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => height * 0.65,
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });

        _targetTimeElement = new WatchUi.Text({
            :text => "00:00:00",
            :color => Graphics.COLOR_RED,
            :font => Graphics.FONT_XTINY,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => height * 0.82,
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });

        _targetTimeLabelElement = new WatchUi.Text({
            :text => "target",
            :color => Graphics.COLOR_RED,
            :font => Graphics.FONT_XTINY,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => height * 0.90,
            :justification => Graphics.TEXT_JUSTIFY_CENTER
        });

        return [
            _heartRateIcon,
            _heartRateElement,
            _timeOfTheDayElement,
            _currentTimerElement,
            _intervalsLeftElement,
            _targetTimeElement,
            _targetTimeLabelElement
        ] as Lang.Array<Drawable>;
    }

}
