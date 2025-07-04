import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

// Factory that controls which numbers can be picked
class NumberPickerFactory extends WatchUi.PickerFactory {
    private var _start as Number;
    private var _stop as Number;
    private var _increment as Number;
    
    // Constructor
    // @param start Number to start with
    // @param stop Number to end with
    // @param increment How far apart the numbers should be
    public function initialize(start as Number, stop as Number, increment as Number) {
        PickerFactory.initialize();

        _start = start;
        _stop = stop;
        _increment = increment;
    }

    // Get the index of a number item
    // @param value The number to get the index of
    // @return The index of the number
    static function getIndex(value as Number, increment as Number, start as Number) as Number {
        var index = (value / increment) - start;
        return index;
    }

    // Generate a Drawable instance for an item
    // @param index The item index
    // @param selected true if the current item is selected, false otherwise
    // @return Drawable for the item
    public function getDrawable(index as Number, selected as Boolean) as Drawable? {
        var text = getValue(index).toString();

        return new WatchUi.Text({
            :text=>text,
            :color=> Graphics.COLOR_WHITE,
            :font=>Graphics.FONT_NUMBER_MEDIUM,
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER,
            :locY=>WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    // Get the value of the item at the given index
    // @param index Index of the item to get the value of
    // @return Value of the item
    public function getValue(index as Number) as Object? {
        var value = _start + (index * _increment);
        return value;
    }

    // Get the number of picker items
    // @return Number of items
    public function getSize() as Number {
        return (_stop - _start) / _increment + 1;
    }
}
