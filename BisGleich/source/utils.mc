import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

function getTimeInSec(time) {
    var totalSeconds = time.hour * 3600 + time.min * 60 + time.sec;
    return totalSeconds;
}

function drawDots(dc as Dc, baseAngle as Number, color as ColorValue) as Void {
    var centerX = dc.getWidth() / 2;
    var centerY = dc.getHeight() / 2;
    var radius = dc.getWidth() / 2 - 8; // 8px margin from edge
    var dotRadius = 3;
    var glowRadius = 5;

    // Create angles relative to the base angle
    var angles = [baseAngle + 5, baseAngle, baseAngle - 5];

    for (var i = 0; i < angles.size(); i++) {
        var angle = angles[i];
        var rad = angle * Math.PI / 180.0;
        var x = centerX + radius * Math.cos(rad);
        var y = centerY + radius * Math.sin(rad);

        // Draw glow (simulate with a larger, semi-transparent circle)
        if (dc has :setFill) {
            dc.setFill(0x40FFFFFF);
            dc.fillCircle(x, y, glowRadius);
        } else {
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.fillCircle(x, y, dotRadius);
        }
    }
}
