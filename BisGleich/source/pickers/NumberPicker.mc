import Toybox.Application.Storage;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

// Picker that allows the user to choose a number
class NumberPicker extends WatchUi.Picker {
    // Constructor
    public function initialize(
        titleText as String,
        titleColor as Number,
        lowerLimitNumber as Number,
        upperLimitNumber as Number,
        increment as Number,
        initialValue as Number
    ) {
        var title = new WatchUi.Text({
            :text=>titleText,
            :color=>titleColor,
            :font=>Graphics.FONT_SMALL,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        
        var factories = [new NumberPickerFactory(lowerLimitNumber, upperLimitNumber, increment)];
    
        Picker.initialize({
            :title=>title,
            :pattern=>factories,
            :defaults=>[NumberPickerFactory.getIndex(initialValue, increment, lowerLimitNumber)],
        });
    }

    // Update the view
    // @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
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
