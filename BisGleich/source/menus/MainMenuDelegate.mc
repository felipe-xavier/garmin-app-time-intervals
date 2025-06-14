import Toybox.Lang;
import Toybox.WatchUi;

class MainMenuViewDelegate extends WatchUi.Menu2InputDelegate {
    private var _mainMenuView;

    // Constructor
    function initialize() {
        _mainMenuView = new MainMenu();
        Menu2InputDelegate.initialize();
    }

    // On Select button clicked
    function onSelect(item as MenuItem) as Void {
        var id = item.getId().toString();

        var label = null;
        var initialValue = null;
        var callback = null;
        var color = Graphics.COLOR_WHITE;

        if (id.equals("total_time")) {
            label = "GOAL TIME";
            initialValue = IntervalsManager.getTotalTimeInMinDuration();
            callback = method(:updateTotalTime);
        } else if (id.equals("interval_time")) {
            label = "INTERVAL TIME";
            initialValue = IntervalsManager.getIntervalTimeInMinDuration();
            callback = method(:updateIntervalTime);
        }

        var picker = new NumberPicker(label, color, true, initialValue);
        var delegate = new NumberPickerDelegate(callback);

         WatchUi.pushView(picker, delegate, WatchUi.SLIDE_LEFT);
    }


    function updateTotalTime(value as Number) as Void {
        _mainMenuView.updateSubLabel("total_time", value);
        IntervalsManager.setTotalTimeInMinDuration(value);
    }

    function updateIntervalTime(value as Number) as Void {
        _mainMenuView.updateSubLabel("interval_time", value);
        IntervalsManager.setIntervalTimeInMinDuration(value);

    }
}
