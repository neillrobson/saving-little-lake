package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;

class GroundSprite extends FlxSprite
{
    var perspective:PerspectivePlugin;

    var cx:Float;
    var cy:Float;

    override public function new(?X:Float = 0, ?Y:Float = 0)
    {
        super(X, Y, AssetPaths.lake__png);
        cx = X;
        cy = Y;
        solid = false;

        perspective = cast FlxG.plugins.get(PerspectivePlugin);
        updatePerspective();
    }

    override function draw()
    {
        super.draw();
        updatePerspective();
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

    function updatePerspective():Void
    {
        if (perspective != null)
        {
            if (perspective.scaleX != scale.x || perspective.scaleY != scale.y)
            {
                scale.x = perspective.scaleX;
                scale.y = perspective.scaleY;
                updateHitbox();
                x = -origin.x + offset.x + cx;
                y = -origin.y + offset.y + cy;
            }

            angle = perspective.angle;
        }
    }
}
