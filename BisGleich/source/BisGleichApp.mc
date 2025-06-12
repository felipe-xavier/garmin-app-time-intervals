import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class BisGleichApp extends Application.AppBase {

    private var _view;

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        System.println("BisGleichApp started");
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var notificationManager = new NotificationManager();
        _view = new BisGleichView(notificationManager);
        return [ _view, new BisGleichDelegate(notificationManager, _view) ];
    }

    // Returns main view instance
    function getView() as BisGleichView {
        return _view;
    }

}

function getApp() as BisGleichApp {
    return Application.getApp() as BisGleichApp;
}

// Returns main view instance
function getMainView() as BisGleichView {
  return Application.getApp().getView();
}
