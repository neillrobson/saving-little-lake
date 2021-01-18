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
    var scaleY:Float;

    var toolbar:FlxSprite;
    var groundSprite:GroundSprite;
    var lake:Lake;

    override public function create()
    {
        super.create();

        FlxG.worldBounds.set(-128, -128, 256, 256);

        camera.scroll.set(-FlxG.width / 2, -FlxG.height * 43 / 70);

        perspective = FlxG.plugins.add(new PerspectivePlugin());
        scaleY = perspective.scaleY;

        bgColor = 0xff696a6a;

        toolbar = new FlxSprite(0, 0,
            FlxGraphic.fromRectangle(FlxG.width, TOOLBAR_HEIGHT, 0xff847e87));
        toolbar.scrollFactor.set(0, 0);

        groundSprite = new GroundSprite();
        add(groundSprite);

        lake = new Lake(groundSprite.graphic.bitmap);
        add(lake);

        openSubState(new TitleState());
    }

    override function draw()
    {
        super.draw();

        checkScrolling();
        perspective.angularForce = getAngularForce();

        lake.sort(Entity.viewSort);
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
