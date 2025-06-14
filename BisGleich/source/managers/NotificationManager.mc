import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Attention;
import Toybox.Timer;
import Toybox.Time;

class NotificationManager {
  private var VIBE_DURATION as Dictionary<AttentionLevel, Number> =
    ({
      AttentionLevel.Low => 250,
      AttentionLevel.Medium => 700,
      AttentionLevel.High => 1500,
    }) as Dictionary<AttentionLevel, Number>;

  private var _timer = new Timer.Timer();

  private var _callbacks as Dictionary<String, Method> = {};
  private var _turnOffBacklightAt = null;

  /* Constructor **/
  function initialize() {
    _timer = new Timer.Timer();
    _timer.start(method(:triggerCallbacks), 1000, true);
  }

  /* Subscribe a callback to be called every second **/
  function callEverySecond(key, callbackFn) as Void {
    _callbacks.put(key, callbackFn);
  }

  /* Unsubscribe a callback by specified key **/
  function removeCallback(key) as Void {
    _callbacks.remove(key);
  }

  /* Calls all existing timer callbacks **/
  function triggerCallbacks() as Void {
    var keys = _callbacks.keys();
    for (var i = 0; i < keys.size(); i++) {
      var key = keys[i];
      var cb = _callbacks.get(key);
      if (cb != null) {
        cb.invoke();
      }
    }

    if (_turnOffBacklightAt != null && _turnOffBacklightAt < System.getTimer()) {
      turnOffBacklight();
    }
  }

  /* Calls an attention by vibration and backlight **/
  function callAttention(level, backlight) as Void {
    if (Attention has :vibrate) {
      var vibeData = [new Attention.VibeProfile(100, VIBE_DURATION[level])];
      Attention.vibrate(vibeData);
    }

    if (backlight) {
      tryToggleBacklight(true);

      _turnOffBacklightAt = System.getTimer() + 3000;
    }
  }

  /* Turns off backlight **/
  function turnOffBacklight() as Void {
    tryToggleBacklight(false);

    _turnOffBacklightAt = null;
  }

  function tryToggleBacklight(enable) {
    try {
      Attention.backlight(enable);
    } catch (ex) {}
  }
}
