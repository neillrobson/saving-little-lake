package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.graphics.FlxGraphic;

class PlayState extends FlxState
{
    var showcaseMode = true;

    var toolbar:FlxSprite;
    var island:FlxSprite;

    override public function create()
    {
        super.create();

        bgColor = 0xff4379B7;

        toolbar = new FlxSprite(0, 0, FlxGraphic.fromRectangle(FlxG.width, 32, 0xff87adff));

        island = new Island();
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
            island.angle += 0.2;
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
