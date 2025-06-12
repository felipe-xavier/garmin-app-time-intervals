import Toybox.Graphics;
import Toybox.WatchUi;

class BisGleichView extends WatchUi.View {
    private var _notificationManager;
    private var _currentTimerElement;
    private var _intervalsLeftElement;

    private var _todElement;
    private var _is24Hour;

    function initialize(notificationManager) {
        _notificationManager = notificationManager;
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        _currentTimerElement = findDrawableById("current_timer");
        _intervalsLeftElement = findDrawableById("intervals_left");
        _todElement = findDrawableById("time_of_the_day");

        updateDynamicData();

        _notificationManager.callEverySecond(method(:updateDynamicData));
         
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        var deviceSettings = System.getDeviceSettings();
        _is24Hour = deviceSettings.is24Hour;

        var extraInterval = 18 % 5 > 0 ? 1 : 0;
        var intervalsCount = (18 / 5) + extraInterval;
        updateIntervalsValue(intervalsCount);
        updateCurrentTimerValue(18);

        updateDynamicData();
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
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


        for (var i = 0; i < angles.size(); i++) {
            var angle = angles[i];
            var rad = angle * Math.PI / 180.0;
            var x = centerX + radius * Math.cos(rad);
            var y = centerY + radius * Math.sin(rad);

            // Draw glow (simulate with a larger, semi-transparent circle)
            dc.setFill(0x40FFFFFF);
            dc.fillCircle(x, y, glowRadius);

            // Draw the dot
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(x, y, dotRadius);
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
        if (_currentTimerElement == null || value < 0) {
            return;
        }
        var seconds = value % 60;
        var minutes = value / 60;

        var secondsFormatted = seconds > 9 ? seconds.toString() : "0" + seconds.toString();
        var current = minutes.toString() + ":" + secondsFormatted;

        _currentTimerElement.setText(current);

        WatchUi.requestUpdate();
    }

    function updateDynamicData() as Void {
        updateDateTime();

        WatchUi.requestUpdate();
    }

    function updateDateTime() {
        var time = System.getClockTime();

        if (_is24Hour) {
        _todElement.setText(time.hour + ":" + time.min.format("%02d") + ":" + time.sec.format("%02d"));
        } else {
        var period = time.hour >= 12 ? "PM" : "AM";
        var hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;

        _todElement.setText(hour12 + ":" + time.min.format("%02d") + ":" + time.sec.format("%02d") + " " + period);
        }
    }

}
