import funkin.options.OptionsMenu;
import funkin.game.PlayState;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import funkin.backend.shaders.FunkinShader;
import openfl.utils.Assets;
import funkin.backend.MusicBeatState;
import Sys;
//Quit Song imports (Mobile)
import funkin.editors.charter.Charter;
import funkin.backend.scripting.events.MenuChangeEvent;

var optionShit = ["resume", "retry", "setting", "home"];
var imgss:FlxSprite;
var optionGroup:FlxTypedGroup;
var curSelected:Int = 0;
var levelInfo:FunkinText;
var username:FunkinText;
var welcome:FunkinText;
var levelDifficulty:FunkinText;
var image:FlxSprite;
var lifeTime:Float = 0;
var decay:Float = 0;
var originalScale:Float = 1;
var glowParticles:FlxTypedGroup;
var pit:FlxSprite;
var select:Bool = false;

function postCreate()
{
	trace('delete');
	#if mobile
	FlxG.mouse.visible = false;
	#else
	FlxG.mouse.visible = true;
	#end
	for(i in grpMenuShit) {
		i.visible = false;
		i.alpha = 0;
		i.destroy();
		remove(i);
	}
	levelInfo = new FunkinText(130, -10, 0, 'GO', 32);
	username = new FunkinText(1080, 100, 0, Sys.getEnv("USERNAME"), 22);
	welcome = new FunkinText(960, 100, 0, "Welcome Back", 22);
	trace(PlayState.instance.camGame);

	blurShader = new FunkinShader(Assets.getText(Paths.fragShader("blur")));
	PlayState.instance.camGame.addShader(blurShader);
	PlayState.instance.camHUD.addShader(blurShader);
	levelDifficulty = new FunkinText(980, -10 + 32, 0, PlayState.difficulty.toUpperCase(), 32);
	levelInfo.alpha = 0;
	add(levelInfo);
	members[2].destroy();
	members[3].destroy();
	optionGroup = new FlxTypedGroup();
	image = new FlxSprite(0, 0);
	image.antialiasing = true;
	image.loadGraphic(Paths.image('game/pause/hologram'));
	image.blend = 9;
	//image.setGraphicSize(FlxG.width * 1.4, FlxG.height * 1.4);
	image.updateHitbox();
	image.screenCenter(FlxAxes.XY);
	add(image);

	fade = new FlxSprite(0, 0);
	fade.antialiasing = true;
	fade.loadGraphic(Paths.image('game/pause/fade'));
	fade.blend = 0;
	//image.setGraphicSize(FlxG.width * 1.4, FlxG.height * 1.4);
	fade.updateHitbox();
	fade.screenCenter(FlxAxes.XY);
	add(fade);

	fade2 = new FlxSprite(0, 240);
	fade2.antialiasing = true;
	fade2.loadGraphic(Paths.image('menus/titlescreen/fade'));
	fade2.blend = 0;
	//image.setGraphicSize(FlxG.width * 1.4, FlxG.height * 1.4);
	fade2.screenCenter(FlxAxes.X);
	fade2.flipY = true;
	fade2.alpha = 0.3;
	fade2.updateHitbox();

	add(fade2);
	add(optionGroup);

	glowParticles = new FlxTypedGroup();
	add(glowParticles);

	if (optionGroup == null)
		return;

	if (optionGroup.members != null && optionGroup.members.length > 0)
		optionGroup.forEach(function(_:FlxSprite) {optionGroup.remove(_); _.destroy(); } );

	camPause = new FlxCamera();
	camPause.bgColor = 0;
	FlxG.cameras.add(camPause, false);

	for(i in 0...optionShit.length)
	{
		imgss = new FlxSprite(200 * i,240).loadGraphic(Paths.image("game/pause/" + optionShit[i]));
		imgss.antialiasing = true;
		imgss.scrollFactor.set(0, 0);
		imgss.cameras = [camPause];
		imgss.ID = i;
		if(imgss.ID == 0) {
			imgss.screenCenter(FlxAxes.X); 
			imgss.y = 769;  
		} //512.5 232.5
		if(imgss.ID == 1) {
			imgss.offset.set(-200,78);
			imgss.setPosition(-107 ,563);
		}//200 247  
		if(imgss.ID == 2) {
			imgss.offset.set(207,79);
			imgss.setPosition(1074,551); 
		}//900 272
		if(imgss.ID == 3) {
			imgss.offset.set(279,-215);
			imgss.setPosition(1394,-205);
		}//900 272
		imgss.y += FlxG.height;
		optionGroup.add(imgss);
	}

	FlxTween.tween(optionGroup.members[0], {y: 327}, 0.7, {ease: FlxEase.quartInOut});
	FlxTween.tween(optionGroup.members[1], {y:563}, 0.6, {ease: FlxEase.quartInOut});
	FlxTween.tween(optionGroup.members[2], {y: 551}, 0.8, {ease: FlxEase.quartInOut});
	FlxTween.tween(optionGroup.members[3], {y: -205}, 0.65, {ease: FlxEase.quartInOut});

	for(i in 0...optionGroup.members.length)
	{
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			select = true;
		});
	}
	floating();
}

function create()
{
	trace('create');
}

function particle(x:Float, y:Float)
{
	pit = new FlxSprite(x,y);
	pit.antialiasing = true;
	pit.loadGraphic(Paths.image('game/pause/particle'));
	lifeTime = FlxG.random.float(0.6, 0.9);
	decay = FlxG.random.float(0.8, 1);

	originalScale = FlxG.random.float(0.75, 1);
	pit.scale.set(originalScale, originalScale);
	pit.alpha = 0.3;
	pit.scrollFactor.set(FlxG.random.float(0.3, 0.75), FlxG.random.float(0.65, 0.75));
	pit.velocity.set(FlxG.random.float(-40, 40), FlxG.random.float(-175, -250));
	pit.acceleration.set(FlxG.random.float(-10, 10), 25);
}

function floating()
{
	var particlesNum:Int = FlxG.random.int(0, 5);
	var width:Float = (2000 / particlesNum);
	var color:FlxColor = FlxColor.WHITE;
	lifeTime = FlxG.random.float(0.6, 0.9);
	decay = FlxG.random.float(0.8, 1);
	for (j in 0...3)
	{
		for (i in 0...particlesNum)
		{
			particle(-400 + width * i + FlxG.random.float(-width / 5, width / 5), fade.y + 900 + (FlxG.random.float(0, 125) + j * 40));
			glowParticles.add(pit);
		}
	}
}

function update(elapsed:Float)
{
	#if mobile
	if (touchPad.buttonB.justPressed) {
		PlayState.resetSongInfos();
		if (Charter.instance != null) Charter.instance.__clearStatics();
		CoolUtil.playMenuSong();
		FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
	}
	#end
	__cancelDefault = true;

	/*var damngod = optionGroup.members[3];
	if (FlxG.keys.pressed.LEFT) damngod.x -= 1;
	if (FlxG.keys.pressed.RIGHT) damngod.x += 1;
	if (FlxG.keys.pressed.UP) damngod.y -= 1;
	if (FlxG.keys.pressed.DOWN) damngod.y += 1;
	if (FlxG.keys.pressed.M) trace(damngod);

	if (FlxG.keys.pressed.J) damngod.offset.x -= 1;
	if (FlxG.keys.pressed.L) damngod.offset.x += 1;
	if (FlxG.keys.pressed.I) damngod.offset.y -= 1;
	if (FlxG.keys.pressed.K) damngod.offset.y += 1;
	if (FlxG.keys.pressed.P) trace(damngod.offset);*/

	if(FlxG.keys.justPressed.LEFT)
	{
		switch(curSelected)
		{
			case 0:
				changeSelect(1);
			case 1:
				changeSelect(1);
			case 2:
				changeSelect(0);
			case 3:
				changeSelect(2);
		}
	}

	if(FlxG.keys.justPressed.UP)
	{
		switch(curSelected)
		{
			case 0:
				changeSelect(3);
			case 1:
				changeSelect(0);
			case 2:
				changeSelect(3);
		}
	}

	if(FlxG.keys.justPressed.RIGHT)
	{
		switch(curSelected)
		{
			case 0:
				changeSelect(2);
			case 1:
				changeSelect(0);
			case 2:
				changeSelect(3);
		}
	}

	if(FlxG.keys.justPressed.DOWN)
	{
		switch(curSelected)
		{
			case 3:
				changeSelect(2);
		}
	}

	if(glowParticles != null)
	{
		glowParticles.forEach(function(spr:FlxSprite) {});
		lifeTime -= FlxG.elapsed;
		glowParticles.forEach(function(spr:FlxSprite)
		{
			if(lifeTime < 0)
			{
				lifeTime = 0;
				spr.alpha -= 0.8 * FlxG.elapsed;
				if(spr.alpha > 0)
				{
					spr.scale.set(originalScale * spr.alpha, originalScale * spr.alpha);
					floating();
				}

				if(spr.alpha < 0)
				{
					spr.kill();
					glowParticles.remove(spr, true);
					spr.destroy();
					trace('KILL');
				}
			}
		});
	}



	var lerp = FlxEase.sineOut(curBeatFloat % 1);

	if(controls.ACCEPT)
	{
		select = false;
		selectItem();
	}

	optionGroup.forEach(function(spr:FlxSprite) {
		if (FlxG.mouse.overlaps(spr))
		{
			changeSelect(spr.ID);
		}
	});


	for (i in 0...optionGroup.members.length) {
		imgss.ID = i;
		if(select)
		{
			if (FlxG.mouse.overlaps(optionGroup.members[i]) && FlxG.mouse.justPressed) {
				curSelected = imgss.ID;
				select = false;
				trace(curSelected);
				selectItem();
			}
		}
	}
}

function postUpdate(elapsed:Float) {}

function selectItem()
{
	switch(curSelected)
	{
		case 0:
		var swagCounter:Int = 0;
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				Countdown(swagCounter++);
			}, 4);
		});

		for (i in 0...optionGroup.members.length)
		{
			FlxTween.tween(optionGroup.members[0], {y: -111 , alpha:0}, 0.7, {ease: FlxEase.quadIn});
			FlxTween.tween(optionGroup.members[1], {y: -166, alpha:0}, 0.6, {ease: FlxEase.quadIn});
			FlxTween.tween(optionGroup.members[2], {y: -232, alpha:0}, 0.8, {ease: FlxEase.quadIn});
			FlxTween.tween(optionGroup.members[3], {y: -490, alpha:0}, 0.65, {ease: FlxEase.quadIn});
		}

		case 1:
			parentDisabler.reset();
			PlayState.instance.registerSmoothTransition();
			FlxG.resetState();
		case 2:
			FlxG.switchState(new OptionsMenu());
		case 3:
			CoolUtil.playMenuSong();
			FlxG.switchState(PlayState.isStoryMode ? new StoryMenuState() : new FreeplayState());
	}
}

function selectOption(event:MenuChangeEvent)
{
	event.cancelled = true;
	trace('select');
}

function changeSelect(huh:Int = 0)
{
	curSelected = huh;
	trace(curSelected);

	optionGroup.forEach(function(spr:FlxSprite) {
		if (spr.ID == curSelected)
		{
			FlxTween.tween(spr, {alpha: 1}, 0.2);
		}
		else
		{
			FlxTween.tween(spr, {alpha: 0.5}, 0.2);
		}
	});
}



function Countdown(swagCounter:Int) {
	switch(swagCounter) {
		case 0:
			three = new FunkinText(0, 0, 0, '3', 72, true);
			three.antialiasing = true;
			three.updateHitbox();
			three.screenCenter();
			add(three);

			FlxTween.tween(three, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeIn
			});

		case 1:
			two = new FunkinText(0, 0, 0, '2', 72, true);
			two.antialiasing = true;
			two.updateHitbox();
			two.screenCenter();
			add(two);

			FlxTween.tween(two, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeIn
			});

		case 2:
			one = new FunkinText(0, 0, 0, '1', 72, true);
			one.antialiasing = true;
			one.updateHitbox();
			one.screenCenter();
			add(one);

			FlxTween.tween(one, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeIn
			});
		case 3:
			go = new FunkinText(0, 0, 0, 'GO!', 72, true);
			go.antialiasing = true;
			go.updateHitbox();
			go.screenCenter();
			add(go);

			FlxTween.tween(go, {width: 215, height: 33}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeOut,
				onComplete: function() {
					go.destroy();
					remove(go, true);
					close();

					PlayState.instance.camGame.removeShader(blurShader);
					PlayState.instance.camHUD.removeShader(blurShader);
					blurShader = null;
					trace('remove');
				}
			});
			FlxTween.tween(go, {alpha: 0}, Conductor.crochet / 1000, {
				ease: FlxEase.cubeIn, onComplete: function() {
					close();
					FlxG.cameras.remove(camPause);
				}
			});
	}
}
