import Toybox.Lang;
import Toybox.WatchUi;

class MainMenuViewDelegate extends WatchUi.Menu2InputDelegate {
    private var _mainMenuView;
    private var _progressManager as ProgressManager;

    // Constructor
    function initialize() {
        _progressManager = ProgressManager.getInstance();
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
        var lowerLimitNumber = 1;
        var upperLimitNumber = 59;
        var increment = 1;

        if (id.equals("total_time")) {
            label = "GOAL TIME";
            initialValue = TimeDurationsStorage.getTotalTimeInMinDuration();
            callback = method(:updateTotalTimeInMin);
        } else if (id.equals("interval_time")) {
            label = "INTERVAL TIME";
            initialValue = TimeDurationsStorage.getIntervalTimeInMinDuration();
            callback = method(:updateIntervalTimeInMin);
            upperLimitNumber = TimeDurationsStorage.getTotalTimeInMinDuration() - 1;
        } else if (id.equals("use_touch_screen")) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            SettingsStorage.setUseTouchScreen(toggleItem.isEnabled());
            return;
        } else if (id.equals("is_screen_always_on")) {
            var toggleItem = item as WatchUi.ToggleMenuItem;
            SettingsStorage.setIsScreenAlwaysOn(toggleItem.isEnabled());
            return;
        } 
        
        var picker = new NumberPicker(label, color, lowerLimitNumber, upperLimitNumber, increment, initialValue);
        var delegate = new NumberPickerDelegate(callback);

         WatchUi.pushView(picker, delegate, WatchUi.SLIDE_LEFT);
    }


    function updateTotalTimeInMin(value as Number) as Void {
        _mainMenuView.updateSubLabel("total_time", value);
        TimeDurationsStorage.setTotalTimeInMinDuration(value);
        _progressManager.reset();
    }

    function updateIntervalTimeInMin(value as Number) as Void {
        _mainMenuView.updateSubLabel("interval_time", value);
        TimeDurationsStorage.setIntervalTimeInMinDuration(value);
        _progressManager.reset();
    }
}
