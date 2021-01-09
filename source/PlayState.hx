package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.FlxGraphic;

class PlayState extends FlxState
{
    static inline final TOOLBAR_HEIGHT = 40;

    var showcaseMode = true;

    var scrolling = false;
    var xScrollStart:Int;

    var toolbar:FlxSprite;
    var island:IslandSprite;

    override public function create()
    {
        super.create();

        bgColor = 0xff4379B7;

        toolbar = new FlxSprite(0, 0,
            FlxGraphic.fromRectangle(FlxG.width, TOOLBAR_HEIGHT, 0xff87adff));

        island = new IslandSprite();
        island.x = (FlxG.width - island.width) / 2;
        island.y = (FlxG.height - island.height) * 43 / 70;
        add(island);

        persistentUpdate = true;
        openSubState(new TitleState());
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (showcaseMode)
        {
            island.angularForce = 60;
        }
        else
        {
            if (scrolling)
            {
                island.angularForce = (FlxG.mouse.screenX - xScrollStart) * 2.5;
            }
            else if (FlxG.mouse.screenY > TOOLBAR_HEIGHT)
            {
                if (FlxG.mouse.screenX > 0 && FlxG.mouse.screenX < 40)
                    island.angularForce = -460;
                else if (FlxG.mouse.screenX > FlxG.width - 40 && FlxG.mouse.screenX < FlxG.width)
                    island.angularForce = 460;
                else
                    island.angularForce = 0;
            }
            else
            {
                island.angularForce = 0;
            }
        }

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

    override function openSubState(SubState:FlxSubState)
    {
        showcaseMode = true;
        remove(toolbar);
        super.openSubState(SubState);
    }

    override function closeSubState()
    {
        super.closeSubState();
        add(toolbar);
        showcaseMode = false;
    }
}
