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
        showSecondsLbl as Boolean,
        initialValue as Number
    ) {
        var title = new WatchUi.Text({
            :text=>titleText,
            :color=>titleColor,
            :font=>Graphics.FONT_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM
        });
        
        var factories = [new NumberPickerFactory(0, 59, 1)];
    
        var text = new WatchUi.Text({
            :text=> showSecondsLbl ? "sec" : "",
            :color=> Graphics.COLOR_WHITE,
            :locY=> WatchUi.LAYOUT_VALIGN_CENTER
        });

        Picker.initialize({
            :title=>title,
            :pattern=>factories,
            :defaults=>[initialValue],
            :confirm=>text
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
        // _callbackParams = callbackParams;

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
