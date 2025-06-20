function getTimeInSec(time) {
    var totalSeconds = time.hour * 3600 + time.min * 60 + time.sec;
    return totalSeconds;
}
