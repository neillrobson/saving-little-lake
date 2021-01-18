package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxSort;
import openfl.display.Graphics;

class Entity extends FlxSprite
{
    final perspective:PerspectivePlugin;

    public var cx(get, set):Float;
    public var cy(get, set):Float;
    public var r(default, set):Float;

    var transformPoint:FlxPoint = FlxPoint.get();

    final island:Island;

    public static inline function sq(i:Float)
        return i * i;

    public static function isOverlapping(e1:Entity, e2:Entity)
    {
        return sq(e1.cx - e2.cx) + sq(e1.cy - e2.cy) < sq(e1.r + e2.r);
    }

    public static function viewSort(order:Int, e1:Entity, e2:Entity)
        return FlxSort.byValues(order, e1.transformPoint.y, e2.transformPoint.y);

    override public function new(?cx:Float = 0, ?cy:Float = 0, ?r:Float = 0, island:Island)
    {
        super();
        this.r = r;
        this.cx = cx;
        this.cy = cy;
        this.island = island;
        perspective = cast FlxG.plugins.get(PerspectivePlugin);
    }

    /**
     * Overridden to set the radius of the entity for collision-checking
     * purposes, rather than having size set to the dimensions of the graphic.
     */
    override function graphicLoaded()
    {
        super.graphicLoaded();
        r = r;
    }

    /**
     * Transform the on-screen point by the coordinate transform matrix provided
     * by the `PerspectivePlugin` if it exists.
     */
    override function draw()
    {
        transformPoint.set(cx, cy);
        if (perspective != null)
            transformPoint.transform(perspective.coordinateTransform);
        super.draw();
    }

    override function getScreenPosition(?point:FlxPoint, ?Camera:FlxCamera):FlxPoint
    {
        if (point == null)
            point = FlxPoint.get();

        if (Camera == null)
            Camera = FlxG.camera;

        point.copyFrom(transformPoint);

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

        point.copyFrom(transformPoint);

        if (perspective != null)
        {
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
