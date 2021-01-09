package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;

class IslandSprite extends FlxSprite
{
    /**
     * The acceleration for the island is computed from scratch every tick, based on the force
     * acting upon it (this variable) and `angularDrag` (which we interpret as a factor of the
     * current velocity).
     */
    public var angularForce = 0.0;

    override public function new(?X:Float = 0, ?Y:Float = 0)
    {
        super(X, Y, AssetPaths.island__png);
        scale.x = 1.5;
        scale.y = 0.75;
        updateHitbox();
        solid = false;

        angularDrag = 5;
    }

    /**
     * Rotate this sprite before scaling it, to give the illusion of a 3D perspective view.
     *
     * @param camera The camera on which the sprite is to be drawn.
     */
    override function drawComplex(camera:FlxCamera):Void
    {
        _frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
        _matrix.translate(-origin.x, -origin.y);

        if (bakedRotationAngle <= 0)
        {
            updateTrig();

            if (angle != 0)
                _matrix.rotateWithTrig(_cosAngle, _sinAngle);
        }

        _matrix.scale(scale.x, scale.y);

        _point.add(origin.x, origin.y);
        _matrix.translate(_point.x, _point.y);

        if (isPixelPerfectRender(camera))
        {
            _matrix.tx = Math.floor(_matrix.tx);
            _matrix.ty = Math.floor(_matrix.ty);
        }

        camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing,
            shader);
    }

    override function updateMotion(elapsed:Float):Void
    {
        angle += angularVelocity * elapsed;
        angularVelocity += angularAcceleration * elapsed;
        angularAcceleration = angularForce - angularDrag * angularVelocity;
    }
}
