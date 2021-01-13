package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;

class TitleState extends FlxSubState
{
    var logo:FlxSprite;
    var titleText:FlxText;

    override public function create()
    {
        super.create();

        logo = new FlxSprite();
        logo.loadGraphic(AssetPaths.logo__png);
        logo.x = (FlxG.width - logo.width) / 2;
        logo.y = 16;
        logo.scrollFactor.set(0, 0);
        add(logo);

        titleText = new FlxText();
        titleText.autoSize = true;
        titleText.size = 16;
        titleText.text = "Click to start the game";
        titleText.x = (FlxG.width - titleText.width) / 2;
        titleText.y = FlxG.height - titleText.size * 3;
        titleText.scrollFactor.set(0, 0);
        add(titleText);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        titleText.alpha = Std.int(FlxG.game.ticks / 500) % 2;

        if (FlxG.mouse.justPressed)
            close();
    }
}
