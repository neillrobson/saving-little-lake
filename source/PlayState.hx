package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.FlxGraphic;

class PlayState extends FlxState
{
    static inline final TOOLBAR_HEIGHT = 40;

    var perspective:PerspectivePlugin;

    var showcaseMode = true;

    var scrolling = false;
    var xScrollStart:Int;

    var toolbar:FlxSprite;
    var island:IslandSprite;

    override public function create()
    {
        super.create();

        FlxG.debugger.drawDebug = true;

        camera.scroll.set(-FlxG.width / 2, -FlxG.height * 43 / 70);

        perspective = FlxG.plugins.add(new PerspectivePlugin());

        bgColor = 0xff4379B7;

        toolbar = new FlxSprite(0, 0,
            FlxGraphic.fromRectangle(FlxG.width, TOOLBAR_HEIGHT, 0xff87adff));
        toolbar.scrollFactor.set(0, 0);

        island = new IslandSprite();
        island.x = -island.origin.x + island.offset.x;
        island.y = -island.origin.y + island.offset.y;
        add(island);

        persistentUpdate = true;
        openSubState(new TitleState());

        var tree = new Tree(40, -60);
        add(tree);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        checkScrolling();
        perspective.angularForce = getAngularForce();
    }

    override function openSubState(SubState:FlxSubState)
    {
        remove(toolbar);
        showcaseMode = true;
        super.openSubState(SubState);
    }

    override function closeSubState()
    {
        super.closeSubState();
        showcaseMode = false;
        add(toolbar);
    }

    function getAngularForce():Float
    {
        if (showcaseMode)
        {
            return 60;
        }
        else
        {
            if (scrolling)
            {
                return (FlxG.mouse.screenX - xScrollStart) * 2.5;
            }
            else if (FlxG.mouse.screenY > TOOLBAR_HEIGHT)
            {
                if (FlxG.mouse.screenX > 0 && FlxG.mouse.screenX < 40)
                    return -460;
                else if (FlxG.mouse.screenX > FlxG.width - 40 && FlxG.mouse.screenX < FlxG.width)
                    return 460;
            }
        }
        return 0;
    }

    function checkScrolling()
    {
        if (FlxG.mouse.justPressedMiddle)
        {
            scrolling = true;
            xScrollStart = FlxG.mouse.screenX;
        }
        if (FlxG.mouse.justReleasedMiddle)
        {
            scrolling = false;
        }
    }
}
