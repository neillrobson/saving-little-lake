package;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.display.BitmapData;

class Lake extends FlxTypedGroup<Entity>
{
    final image:BitmapData;

    public function new(image:BitmapData)
    {
        super();

        this.image = image;

        for (_ in 0...7)
        {
            var x = Math.random() * 256 - 128;
            var y = Math.random() * 256 - 128;
            addForest(x, y);
        }
    }

    function addForest(x0:Float, y0:Float)
    {
        for (_ in 0...200)
        {
            var x = x0 + FlxG.random.floatNormal() * 12;
            var y = y0 + FlxG.random.floatNormal() * 12;
            var tree = new Tree(x, y, FlxG.random.float() * Tree.MATURE_AGE, this);
            if (isFree(tree))
                add(tree);
        }
    }

    public function isFree(obj:Entity)
    {
        if (!isOnGround(obj.cx, obj.cy))
            return false;

        return !FlxG.overlap(obj, this, null, Entity.isOverlapping);
    }

    function isOnGround(x:Float, y:Float):Bool
    {
        var xPixel = Math.round(x + 128);
        var yPixel = Math.round(y + 128);
        if (xPixel < 0 || yPixel < 0 || xPixel >= 256 || yPixel >= 256)
        {
            return false;
        }
        var px = image.getPixel32(xPixel, yPixel);
        return px >>> 24 > 128 && px != 0xff5b6ee1;
    }
}
