import Toybox.Lang;

class FormatManager {

    static function formatTime(hour as Number, min as Number, sec as Number) as String {
        if (GlobalVariables.deviceSettings.is24Hour) {
            return Lang.format(
                "$1$:$2$:$3$",
                [hour.format("%02d"), min.format("%02d"), sec.format("%02d")]
            );
        } else {
            var period = hour >= 12 ? "PM" : "AM";
            var hour12 = hour % 12;
            if (hour12 == 0) {
                hour12 = 12; // Handle midnight and noon
            }
            return Lang.format(
                "$1$:$2$:$3$ $4$",
                [hour12.format("%d"), min.format("%02d"), sec.format("%02d"), period]
            );
        }
    }

    static function formatTimeMMSS(totalSeconds as Number) as String {
        var minutes = totalSeconds / 60;
        var seconds = totalSeconds % 60;
        return Lang.format("$1$:$2$", [minutes.format("%d"), seconds.format("%02d")]);
    }

    static function formatIntervals(cycles as Number) as String {
        if (cycles == null || cycles < 0) {
            return "";
        }
        var multipleSign = cycles == 1 ? "" : "s";
        return cycles.toString() + " alert" + multipleSign + " left";
    }

    static function formatHeartRate(heartRate as Number or Null) as String {
         if (heartRate == null) {
            return "--";
        }
        return heartRate.format("%i");
    }
} 
