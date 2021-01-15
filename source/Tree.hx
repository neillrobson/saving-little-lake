package;

class Tree extends Entity
{
    override public function new(cx:Float, cy:Float)
    {
        super(cx, cy, 4);
        loadGraphic(AssetPaths.sheet__png, true, 8, 16);
        animation.frameIndex = 4;
        offset.set(4, 16);
    }
}
