import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Timer;

// Picker that allows the user to choose a number
class NumberPicker extends WatchUi.Picker {
    private var _factory;
    private var _hasTitle;
    private var _titleColor;

    // Constructor
    public function initialize(
        titleText as String?,
        titleColor as Number,
        lowerLimitNumber as Number,
        upperLimitNumber as Number,
        increment as Number,
        initialValue as Number
    ) {
        _hasTitle = titleText != null;
        _titleColor = titleColor;
        _factory = new NumberPickerFactory(lowerLimitNumber, upperLimitNumber, increment);

        var targetTimeText = getTargetTimeText(initialValue);

        var title = new WatchUi.Text({
            :text=>_hasTitle ? titleText : targetTimeText,
            :color=>titleColor,
            :font=>Graphics.FONT_TINY,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        
        Picker.initialize({
            :title=>title,
            :pattern=>[_factory],
            :defaults=>[NumberPickerFactory.getIndex(initialValue, increment, lowerLimitNumber)],
        });
    }

    // Update the view
    // @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        if (!_hasTitle) {
            var targetTimeText = getTargetTimeText(_factory.currentValue);
            var title = new WatchUi.Text({
                :text=>targetTimeText,
                :color=>_titleColor,
                :font=>Graphics.FONT_TINY,
                :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
                :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
            });
            Picker.setOptions({
                :title=>title,
                :pattern=>[_factory],
            });
        }
        Picker.onUpdate(dc);
    }

    private function getTargetTimeText(currentValue as Number) as String {
        // Calculate target time based on current picker value
        var time = System.getClockTime();
        var currentTimeInSec = time.hour * 3600 + time.min * 60 + time.sec;
        var totalSeconds = currentTimeInSec + (currentValue * 60); // Convert minutes to seconds

        var targetHour = (totalSeconds / 3600) % 24;
        var targetMin = (totalSeconds % 3600) / 60;
        var targetSec = totalSeconds % 60;

        var targetTimeText = FormatManager.formatTime(targetHour, targetMin, targetSec);

        return targetTimeText;
    }
}

// Responds to a time picker selection or cancellation
class NumberPickerDelegate extends WatchUi.PickerDelegate {
    private var _callback;

    // Constructor
    public function initialize(callback as Method) {
        _callback = callback;
        PickerDelegate.initialize();
    }

    // Handle a cancel event from the picker
    //  @return true if handled, false otherwise
    public function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    // Handle a confirm event from the picker
    // @param values The values chosen in the picker
    // @return true if handled, false otherwise
    public function onAccept(values as Array) as Boolean {
        _callback.invoke(values[0]);
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }
}
