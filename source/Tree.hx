package;

import flixel.FlxG;

class Tree extends Entity
{
    /** About eleven seconds per "sprite change" growth **/
    public static inline final GROW_SPEED = 1 / 11;

    static inline final NUM_SPRITES = 16;

    public static inline final MATURE_AGE = NUM_SPRITES - 1;

    /** Try to grow a new tree once every seventeen minutes or so **/
    static inline final SPREAD_SPEED = 1 / 1000;

    private var age(default, set):Float;
    private var spreadDelay:Float;

    override public function new(cx:Float, cy:Float, age:Float, island:Island)
    {
        super(cx, cy, 3, island);
        loadGraphic(AssetPaths.sheet__png, true, 8, 16);
        offset.set(4, 16);

        this.age = age;
        spreadDelay = FlxG.random.float();
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (age < MATURE_AGE)
        {
            age += GROW_SPEED * elapsed;
        }
        else if ((spreadDelay += SPREAD_SPEED * elapsed) >= 1)
        {
            var xp = x + FlxG.random.floatNormal() * 8;
            var yp = y + FlxG.random.floatNormal() * 8;
            var tree = new Tree(xp, yp, 0, island);
            if (island.isFree(tree))
            {
                island.add(tree);
                --spreadDelay;
            }
        }
    }

    function set_age(age:Float)
    {
        animation.frameIndex = 4 + MATURE_AGE - Std.int(age);
        return this.age = age;
    }
}
