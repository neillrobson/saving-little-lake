package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import openfl.display.Graphics;

class Entity extends FlxSprite
{
    final perspective:PerspectivePlugin;

    public final anchor:FlxPoint = FlxPoint.get();

    public var cx(get, set):Float;
    public var cy(get, set):Float;
    public var r(default, set):Float;

    override public function new(?cx:Float = 0, ?cy:Float = 0, ?r:Float = 0)
    {
        super();
        this.r = r;
        this.cx = cx;
        this.cy = cy;
        perspective = cast FlxG.plugins.get(PerspectivePlugin);
    }

    override function graphicLoaded()
    {
        super.graphicLoaded();
        r = r;
    }

    /**
     * Transform the on-screen point by the coordinate transform matrix provided
     * by the `PerspectivePlugin` if it exists.
     *
     * @param point
     * @param Camera
     * @return FlxPoint
     */
    override function getScreenPosition(?point:FlxPoint, ?Camera:FlxCamera):FlxPoint
    {
        if (point == null)
            point = FlxPoint.get();

        if (Camera == null)
            Camera = FlxG.camera;

        point.set(cx, cy);

        if (perspective != null)
            point.transform(perspective.coordinateTransform);

        // We want the object to appear in the game world with its anchor point
        // at its (x, y) coordinates.
        point.subtractPoint(anchor);

        if (pixelPerfectPosition)
            point.floor();

        return point.subtract(Camera.scroll.x * scrollFactor.x, Camera.scroll.y * scrollFactor.y);
    }

    function getBoundingBoxScreenPosition(?point:FlxPoint, ?Camera:FlxCamera):FlxPoint
    {
        if (point == null)
            point = FlxPoint.get();

        if (Camera == null)
            Camera = FlxG.camera;

        point.set(cx, cy);

        if (perspective != null)
        {
            point.transform(perspective.coordinateTransform);
            point.subtract(r * perspective.scaleX, r * perspective.scaleY);
        }
        else
        {
            point.subtract(r, r);
        }

        if (pixelPerfectPosition)
            point.floor();

        return point.subtract(Camera.scroll.x * scrollFactor.x, Camera.scroll.y * scrollFactor.y);
    }

    function get_cx()
    {
        return x + r;
    }

    function get_cy()
    {
        return y + r;
    }

    function set_cx(cx:Float):Float
    {
        x = cx - r;
        return cx;
    }

    function set_cy(cy:Float):Float
    {
        y = cy - r;
        return cy;
    }

    function set_r(r:Float):Float
    {
        setSize(r * 2, r * 2);
        return this.r = r;
    }

    override function drawDebugOnCamera(camera:FlxCamera)
    {
        if (!camera.visible || !camera.exists || !isOnScreen(camera))
            return;

        var rect = getBoundingBox(camera);
        var gfx = beginDrawDebug(camera);
        drawDebugBoundingEllipse(gfx, rect, allowCollisions, immovable);
        endDrawDebug(camera);
    }

    function drawDebugBoundingEllipse(gfx:Graphics, rect:FlxRect, allowCollisions:Int,
            partial:Bool)
    {
        // Find the color to use
        var color:Null<Int> = debugBoundingBoxColor;
        if (color == null)
        {
            if (allowCollisions != FlxObject.NONE)
            {
                color = partial ? debugBoundingBoxColorPartial : debugBoundingBoxColorSolid;
            }
            else
            {
                color = debugBoundingBoxColorNotSolid;
            }
        }

        gfx.lineStyle(1, color, 0.5);
        gfx.drawEllipse(rect.x, rect.y, rect.width, rect.height);
    }

    @:access(flixel.FlxCamera)
    override function getBoundingBox(camera:FlxCamera):FlxRect
    {
        getBoundingBoxScreenPosition(_point, camera);

        var w = width;
        var h = height;

        if (perspective != null)
        {
            w *= perspective.scaleX;
            h *= perspective.scaleY;
        }

        _rect.set(_point.x, _point.y, w, h);
        _rect = camera.transformRect(_rect);

        if (isPixelPerfectRender(camera))
        {
            _rect.floor();
        }

        return _rect;
    }
}
