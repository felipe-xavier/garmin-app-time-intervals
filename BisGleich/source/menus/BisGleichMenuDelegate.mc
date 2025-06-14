import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class BisGleichMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
        System.println("BisGleichDelegate onMenu initialize");

    }

    function onMenuItem(item as Symbol) as Void {
        System.println("BisGleichDelegate onMenuItem called with item: " + item);

        if (item == :item_1) {
            System.println("item 1");
        } else if (item == :item_2) {
            System.println("item 2");
        }
    }

}
