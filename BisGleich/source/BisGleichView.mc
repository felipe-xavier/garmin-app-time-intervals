import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Lang;

class BisGleichView extends WatchUi.View {
    private var _currentTimerElement;
    private var _intervalsLeftElement;
    private var _timeOfTheDayElement;
    private var _targetTimeElement;
    private var _targetTimeLabelElement;
    private var _heartRateElement;
    private var _heartRateIcon;

    private var _deviceSettings as DeviceSettings;

    private var _activityManager as ActivityManager;
    private var _progressManager as ProgressManager;
    private var _notificationManager as NotificationManager;

    function initialize() {
        _activityManager = ActivityManager.getInstance();
        _notificationManager = NotificationManager.getInstance();
        _progressManager = ProgressManager.getInstance();
        _deviceSettings = System.getDeviceSettings();

        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(createLayout(dc));
            
        updateTargetTimeElement();
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
        drawDotsLeftMenu(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    function drawDotsLeftMenu(dc as Dc) as Void {
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;
        var radius = dc.getWidth() / 2 - 8; // 8px margin from edge
        var dotRadius = 3;
        var glowRadius = 5;
        var angles = [185, 180, 175]; // degrees, adjust for your device
        var color = Graphics.COLOR_WHITE;

        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus != ActivityStatus.stopped) {
            color = Graphics.COLOR_DK_GRAY;
        }

        for (var i = 0; i < angles.size(); i++) {
            var angle = angles[i];
            var rad = angle * Math.PI / 180.0;
            var x = centerX + radius * Math.cos(rad);
            var y = centerY + radius * Math.sin(rad);

            // Draw glow (simulate with a larger, semi-transparent circle)
            if (dc has :setFill) {
                dc.setFill(0x40FFFFFF);
                dc.fillCircle(x, y, glowRadius);
            } else {
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(x, y, dotRadius);
            }
        }
    }

    function updateIntervalsValue(cycles) as Void {
        if (_intervalsLeftElement == null || cycles < 0) {
            return;
        }

        var multipleSign = cycles == 1 ? "" : "s";
        var formattedValue = cycles.toString() + " alert" + multipleSign + " left";
        _intervalsLeftElement.setText(formattedValue);

        WatchUi.requestUpdate();
    }

    function updateCurrentTimerValue(value) as Void {
        if (_currentTimerElement == null) {
            return;
        }

        var formattedTime = formatTimeMMSS(value);
        _currentTimerElement.setText(formattedTime);

        WatchUi.requestUpdate();
    }

    function updateDynamicData() as Void {
        updateSensorsData();
        updateTimeOfTheDayElement();

        var activityStatus = _activityManager.getActivityStatus();
        if (activityStatus == ActivityStatus.paused || activityStatus == ActivityStatus.stopped) {
            updateTargetTimeElement();
        }

        WatchUi.requestUpdate();
    }

    function updateSensorsData() {
        var heartRate = Activity.getActivityInfo().currentHeartRate;
        if (heartRate == null) {
            heartRate = "000";
            _heartRateElement.setColor(Graphics.COLOR_WHITE);
        } else {
            heartRate = heartRate.format("%i");
            _heartRateElement.setColor(Graphics.COLOR_RED);
        }

        _heartRateElement.setText(heartRate);
    }

    function updateTimeOfTheDayElement() {
        var time = System.getClockTime();

        if (_deviceSettings.is24Hour) {
            _timeOfTheDayElement.setText(time.hour + ":" + time.min.format("%02d") + ":" + time.sec.format("%02d"));
        } else {
            var period = time.hour >= 12 ? "PM" : "AM";
            var hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
            _timeOfTheDayElement.setText(hour12 + ":" + time.min.format("%02d") + ":" + time.sec.format("%02d") + " " + period);
        }
    }

    function updateTargetTimeElement() {
        var time = System.getClockTime();

        var extraDurationTimeInSec = _progressManager.getCurrentDurationInSec();

        var currentTimeInSec = getTimeInSec(time);

        // Calculate target time by adding extra duration to current time
        var totalSeconds = currentTimeInSec + extraDurationTimeInSec;
        _progressManager.setTargetTimeInSec(totalSeconds);

        var targetHour = (totalSeconds / 3600) % 24;
        var targetMin = (totalSeconds % 3600) / 60;
        var targetSec = totalSeconds % 60;

        if (_deviceSettings.is24Hour) {
            _targetTimeElement.setText(targetHour.format("%02d") + ":" + targetMin.format("%02d") + ":" + targetSec.format("%02d"));
        } else {
            var period = targetHour >= 12 ? "PM" : "AM";
            var hour12 = targetHour % 12 == 0 ? 12 : targetHour % 12;

            _targetTimeElement.setText(hour12 + ":" + targetMin.format("%02d") + ":" + targetSec.format("%02d") + " " + period);
        }
    }

    // Helper function to format time in MM:SS
    private function formatTimeMMSS(totalSeconds) {
        var minutes = totalSeconds / 60;
        var seconds = totalSeconds % 60;
        return minutes.toString() + ":" + (seconds < 10 ? "0" : "") + seconds.toString();
    }

    private function createLayout(dc as Dc) as Lang.Array<Drawable> {
        var height = dc.getHeight();
        var width = dc.getWidth();

        // Calculate centered positions for the heart rate icon and text to keep them close
        var heartRateIconDrawable = WatchUi.loadResource(Rez.Drawables.heart_rate_icon);
        var iconWidth = heartRateIconDrawable.getWidth();
        var iconHeight = heartRateIconDrawable.getHeight();
        
        var heartRateText = "---"; // Use placeholder for width calculation
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
