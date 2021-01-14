package;

import flixel.FlxBasic;
import flixel.math.FlxMatrix;

class PerspectivePlugin extends FlxBasic
{
    public var scaleX = 1.5;
    public var scaleY = 0.75;
    public var angularForce = 0.0;
    public var angle(default, null) = 0.0;
    public var coordinateTransform(default, null) = new FlxMatrix();

    public var showcaseMode = true;

    var angularVelocity = 0.0;
    var angularAcceleration = 0.0;
    var angularDrag = 5.0;

    var scrolling = false;
    var xScrollStart:Int;

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        angle += angularVelocity * elapsed;
        angularVelocity += angularAcceleration * elapsed;
        angularAcceleration = angularForce - angularDrag * angularVelocity;
    }

    override function draw()
    {
        super.draw();
        coordinateTransform.identity();
        coordinateTransform.rotate(angle * Math.PI / 180);
        coordinateTransform.scale(scaleX, scaleY);
    }
}
