import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import flixel.FlxObject;
#if windows
import Discord.DiscordClient;
import sys.thread.Thread;
#end

import flixel.group.FlxGroup.FlxTypedGroup;
import openfl.ui.Keyboard;
import flixel.FlxSprite;
import flixel.FlxG;

class CharacterCustomizeState extends MusicBeatState
{

    var defaultX:Float = FlxG.width * 0.55 - 135;
    var defaultY:Float = FlxG.height / 2 - 50;

    var background:FlxSprite;

    var text:FlxText;
    var blackBorder:FlxSprite;

    var bf:Boyfriend;
    var tempBfX:Float;
    var tempBfY:Float;
    var tempBf:Boyfriend;
    var tempPreBf:Boyfriend;
    var tempPreBfX:Float;
    var tempPreBfY:Float;
    var preBf:Boyfriend;
    var postBf:Boyfriend;
    var preCharacter:Int;
    var postCharacter:Int;

    var characters:Array<String> = ['bf', 'bf-pixel-corrupted', 'carne-pixel-corrupted'];

    private var camHUD:FlxCamera;
    
    public override function create() {
        #if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Customizing Character", null);
		#end

        background = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBGBlue','preload'));

		Conductor.changeBPM(139);
		persistentUpdate = true;

        super.create();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
        FlxG.cameras.add(camHUD);

        background.scrollFactor.set(0.9,0.9);

        add(background);

		var camFollow = new FlxObject(0, 0, 1, 1);

        if(FlxG.save.data.character < 0 || FlxG.save.data.character > characters.length - 1){
            FlxG.save.data.character = 0;
        }
        preCharacter = FlxG.save.data.character;
        postCharacter = FlxG.save.data.character;
        preCharacter--;
        postCharacter++;
        if(FlxG.save.data.character < 1){
            preCharacter = 2;
        }
        if(FlxG.save.data.character > characters.length - 1){
            preCharacter = 0;
        }


        bf = new Boyfriend(450, 150, characters[FlxG.save.data.character]);
        preBf = new Boyfriend(450 - 300, 150 - 50, characters[preCharacter]);
        postBf = new Boyfriend(450 + 300, 150 - 50, characters[postCharacter]);
        postBf.alpha = 0.5;
        preBf.alpha = 0.5;
        
        /*bf.x = 0;
        bf.y = 0;*/

		var camPos:FlxPoint = new FlxPoint(0, 0);

		camFollow.setPosition(camPos.x, camPos.y);

        add(preBf);
        add(postBf);

        add(bf);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = 1.5;
		FlxG.camera.focusOn(bf.getGraphicMidpoint());
        

        text = new FlxText(5, FlxG.height + 40, 0, "Arrow keys or WASD to change skin.", 12);
		text.scrollFactor.set();
		text.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        
        blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(text.width + 900)),Std.int(text.height + 600),FlxColor.BLACK);
		blackBorder.alpha = 0.5;

		add(blackBorder);

		add(text);

		FlxTween.tween(text,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

        if (!FlxG.save.data.changedHit)
        {
            FlxG.save.data.changedHitX = defaultX;
            FlxG.save.data.changedHitY = defaultY;
        }


        FlxG.mouse.visible = true;

    }

    override function update(elapsed:Float) {
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        super.update(elapsed);

        FlxG.camera.zoom = FlxMath.lerp(0.9, FlxG.camera.zoom, 0.95);
        camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);

        if (controls.BACK)
        {
            FlxG.mouse.visible = false;
            FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new OptionsMenu());
        }

        if (controls.LEFT_P)
            {
                trace('pe');
                remove(bf);
                remove(preBf);
                remove(postBf);
                FlxG.save.data.character++;
                preCharacter = FlxG.save.data.character;
                postCharacter = FlxG.save.data.character;
                preCharacter--;
                postCharacter++;
                if(FlxG.save.data.character < 1){
                    preCharacter = 2;
                }
                if(FlxG.save.data.character > characters.length - 1){
                    preCharacter = 0;
                }
                tempBfX = bf.x;
                tempBfY = bf.y;
                tempPreBfX = preBf.x;
                tempPreBfY = preBf.y;
                tempBf = bf;
                tempPreBf = preBf;
                bf = postBf;
                preBf = tempBf;
                postBf = tempPreBf;
                bf.alpha = 0.5;
                postBf.alpha = 0.5;
                add(bf);
                add(preBf);
                add(postBf);
                FlxTween.tween(bf,
                    {
                        x: 450,
                        y: 150,
                        alpha: 1
                    }, 0.5,
                    {
                        type: FlxTweenType.ONESHOT,
                        ease: FlxEase.elasticInOut
                    });
                FlxTween.tween(preBf,
                    {
                        x: 450 - 300,
                        y: 150 - 50,
                        alpha: 0.5
                    }, 0.5,
                    {
                        type: FlxTweenType.ONESHOT,
                        ease: FlxEase.elasticInOut
                    });
                FlxTween.tween(postBf,
                    {
                        x: 450 + 300,
                        y: 150 - 50,
                        alpha: 0.5
                    }, 0.5,
                    {
                        type: FlxTweenType.ONESHOT,
                        ease: FlxEase.elasticInOut
                    });
            }

    }

    override function beatHit() 
    {
        super.beatHit();

        bf.playAnim('idle');
        preBf.playAnim('idle');
        postBf.playAnim('idle');

        FlxG.camera.zoom += 0.015;
        camHUD.zoom += 0.010;

        trace('beat');

    }
}