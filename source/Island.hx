package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;

class Island extends FlxSprite
{
    override public function new(?X:Float = 0, ?Y:Float = 0)
    {
        super(X, Y, AssetPaths.island__png);
        scale.x = 1.5;
        scale.y = 0.75;
        updateHitbox();
        solid = false;
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
}
