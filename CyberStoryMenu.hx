import funkin.game.PlayState;
import funkin.backend.MusicBeatState;
var coverart:FlxSprite;
var storyShit = ["chap1", "chap2", "chap3","chap4", "chap5"];
var storyGroup:FlxTypedGroup;
var gap:Int = 300;
var curSelected:Int = 0;
var scaleOG = [0,0];
var tween:FlxTween;

//Side Select
var sideShit = ["main", "side"];
var sideGroup:FlxTypedGroup;
var sideart:FlxSprite;
var text:FunkinText;
var chapter:FunkinText;
var desc:FunkinText;
var picknow:Bool = false;
var mainsongs = ["main", "side"];
var sidesongs = ["main", "side"];
var intro:Bool = false;
var onside:Bool = false;

//Text
var chaptername = ["Chapter 1", "Chapter 2", "Chapter 3", "Chapter 4", "Final Chapter"];
var chapternameth = ["บท 1", "บท 2", "บท 3", "บท 4", "บทสุดท้าย"];
var descname = ['The Beginning','Nonsensical Outbreak', 'Cyber Mayhem', 'Breakout', 'The End'];
var descnameth = ['จุดเริ่มต้น','นอนเซนซิเคอร์ เอาท์เบรค', 'ไซเบอร์ เมเฮม', 'เบรคเอาท์', 'จุดจบ'];
var ypost = 655;
var chname = chaptername;
var dname = descname;


var time:Float = 0;
function postCreate()
{
	canSelect = false;
	trace('DELETE');

	for(i in members) {
		remove(i);
	}

	if(FlxG.save.data.thaiSub){dname = descnameth; chname = chapternameth;}

	//BF MODE AUTO TO OFF
	FlxG.save.data.bfmode = false;


	fade = new FlxSprite(0, 0);
	fade.antialiasing = true;
	fade.loadGraphic(Paths.image('game/pause/fade'));
	fade.blend = 0;
	if(FlxG.save.data.ShaderHigh)
	{
    	fadeShader = new CustomShader('bloom');
    	fade.shader = fadeShader;
	}
	//image.setGraphicSize(FlxG.width * 1.4, FlxG.height * 1.4);
	fade.updateHitbox();
	fade.screenCenter(FlxAxes.XY);
	add(fade);

	fade2 = new FlxSprite(0, 0);
	fade2.antialiasing = true;
	fade2.loadGraphic(Paths.image('game/pause/hologram'));
	fade2.blend = 0;
	if(FlxG.save.data.ShaderHigh)
	{
    	bgShader = new CustomShader('storybg');
    	fade2.shader = bgShader;
	}
	fade2.updateHitbox();
	fade2.setGraphicSize(FlxG.width * 1.2, FlxG.height * 1.2);
	fade2.screenCenter(FlxAxes.XY);
	fade2.alpha = 0.3;
	add(fade2);

	fade = new FlxSprite(0, 0);
	fade.antialiasing = true;
	fade.loadGraphic(Paths.image('game/pause/hologram'));
	fade.blend = 11;
	//image.setGraphicSize(FlxG.width * 1.4, FlxG.height * 1.4);
	fade.updateHitbox();
	fade.screenCenter(FlxAxes.XY);
	fade.alpha = 0.1;

	add(fade);

	trace('CREATE COVER ART');
	storyGroup = new FlxTypedGroup();
	add(storyGroup);
	if (storyGroup == null)
		return;

	if (storyGroup.members != null && storyGroup.members.length > 0)
		storyGroup.forEach(function(_:FlxSprite) {
			storyGroup.remove(_); _.destroy();
		});
	gap = 470;

	for(i in 0...storyShit.length)
	{
		imgss = new FlxSprite(99 + i* gap + FlxG.width,20).loadGraphic(Paths.image("menus/story/cover/" + storyShit[i]));
		imgss.antialiasing = true;
		imgss.setGraphicSize(392,554);
		imgss.updateHitbox();
		imgss.blend = 11;
		imgss.alpha = 0;
		imgss.screenCenter(FlxAxes.Y);
		imgss.ID = i;
		//if(imgss.ID == 0) imgss.screenCenter(FlxAxes.XY); //512.5 232.5
		//if(imgss.ID == 1) {imgss.screenCenter(FlxAxes.Y); imgss.x = 200; imgss.y +=10;}//200 247
		//if(imgss.ID == 2) {imgss.screenCenter(FlxAxes.Y); imgss.x = 900;}//900 272
		storyGroup.add(imgss);
	}
	scaleOG[0] = imgss.scale.x;
	scaleOG[1] = imgss.scale.y;

	//Create Side Menu
	sideGroup = new FlxTypedGroup();
	add(sideGroup);
	if (sideGroup == null)
		return;

	if (sideGroup.members != null && sideGroup.members.length > 0)
		sideGroup.forEach(function(_:FlxSprite) {
			sideGroup.remove(_); _.destroy();
		});

	sideShader = new CustomShader('glow');

	for(i in 0...sideShit.length)
	{
		sideart = new FlxSprite(10 + i).loadGraphic(Paths.image("menus/story/side/" + sideShit[i]));
		sideart.antialiasing = true;
		sideart.updateHitbox();
		sideart.screenCenter(FlxAxes.Y);
		sideart.alpha = 0;

		sideart.scale.set(0.4,0.4);
		sideart.ID = i;
		if(sideart.ID == 0) {sideart.screenCenter(FlxAxes.XY); sideart.setPosition(-733,sideart.y + FlxG.height);} //-733 -514
		if(sideart.ID == 1) {sideart.screenCenter(FlxAxes.Y); sideart.setPosition(-14,sideart.y + FlxG.height);} // -14 ,-494
		sideGroup.add(sideart);
		//trace(sideart.ID);
	}

	text = new FunkinText(0,0,0,"PICK A STORY",64);
	text.antialiasing = true;
	text.screenCenter(FlxAxes.X);
	text.alpha = 0;
	text.updateHitbox();
	add(text);

	chapter = new FunkinText(0,0,0,chname[0],64);
	chapter.antialiasing = true;
	if(FlxG.save.data.thaiSub) {chapter.font = Paths.font('thai-font.ttf');}
	chapter.screenCenter(FlxAxes.X);
	chapter.y += 9;
	chapter.alpha = 0;
	chapter.y -= FlxG.height;
	chapter.updateHitbox();
	add(chapter);

	desc = new FunkinText(0,0,0,dname[0],64);
	desc.antialiasing = true;
	if(FlxG.save.data.thaiSub) {desc.font = Paths.font('thai-font.ttf');}

	desc.screenCenter(FlxAxes.X);
	desc.y = 655;
	desc.alpha = 0;
	desc.updateHitbox();
	desc.y += FlxG.height;
	add(desc);

	mid = new FlxSprite().loadGraphic(Paths.image("menus/story/mid"));
	mid.antialiasing = true;
	mid.updateHitbox();
	mid.screenCenter(FlxAxes.XY);
	//add(mid);

	fade2 = new FlxSprite(0, -100);
	fade2.antialiasing = true;
	fade2.loadGraphic(Paths.image('menus/titlescreen/fade'));
	fade2.blend = 1;
	//image.setGraphicSize(FlxG.width * 1.4, FlxG.height * 1.4);
	fade2.screenCenter(FlxAxes.X);
	fade2.alpha = 0.4;
	fade2.updateHitbox();

	add(fade2);

	if(FlxG.save.data.thaiSub) {ypost -= 20;}

	FlxTween.tween(chapter, {y: 9 , alpha:1}, 0.7, {ease: FlxEase.cubeOut});
	FlxTween.tween(desc, {y: ypost , alpha:1}, 0.7, {ease: FlxEase.cubeOut});

	#if mobile addTouchPad('LEFT_RIGHT', 'A_B'); #end

	storyGroup.forEach(function(sprite:FlxSprite) 
	{
		FlxTween.tween(sprite, {alpha: 1, x: 444 + sprite.ID * gap}, 0.7, {ease: FlxEase.cubeOut,
			onComplete: function(twn:FlxTween)
			{
				intro = true;
			}});
	});

	new FlxTimer().start(0.6, function(tmr:FlxTimer)
	{
		if(curSelected >= storyShit.length) curSelected = 0;
		changeSelection(0,true);
	});
}

function update(elapsed:Float)
{
	if (FlxG.keys.justPressed.R) {FlxG.resetState();}
	if(FlxG.save.data.ShaderHigh)
	{
    	bgShader.iTime = (time += elapsed);
	}
	if (controls.BACK && intro) 
	{
		if(!onside)
		{
			FlxG.switchState(new MainMenuState());
		}
		else
		{
			onside = false;
			picknow = false;

			FlxTween.tween(sideGroup.members[0], {y: sideGroup.members[0].y+FlxG.height , alpha:0}, 0.7, {ease: FlxEase.cubeOut});
			FlxTween.tween(sideGroup.members[1], {y: sideGroup.members[0].y+FlxG.height, alpha:0}, 0.6, {ease: FlxEase.cubeOut});
			FlxTween.tween(text, {y: -10 , alpha:0}, 0.7, {ease: FlxEase.cubeOut});
			FlxTween.tween(chapter, {y: 9 , alpha:1}, 0.7, {ease: FlxEase.cubeOut});
			FlxTween.tween(desc, {y: ypost , alpha:1}, 0.7, {ease: FlxEase.cubeOut});
			storyGroup.forEach(function(sprite:FlxSprite) 
			{
				FlxTween.tween(sprite, {y:83}, 0.7, {ease: FlxEase.cubeOut,
					onComplete: function(twn:FlxTween)
					{
						intro = true;
					}});
			});
			switch(chapter.text)
			{
				case 'Chapter 2':
				curSelected = 0;
				changeSelection(1);
				case 'Chapter 4':
				curSelected = 2;
				changeSelection(1);
			}
		}
	}
	if (controls.LEFT_P && intro) {changeSelection(-1);}
	if (controls.RIGHT_P && intro) {changeSelection(1);}

	if (controls.ACCEPT && intro)
	{
		if(!picknow)
		{
			FlxG.sound.play(Paths.sound('menu/selected'), 1);
			switch (curSelected)
			{
				case 0:
					var songs:Array<String> = ["Open System", "wear a mask", "last hope"];
					loadStory(songs);
					transition(true);
				case 1: //Has Side Story
					picknow = true;
					changeSelection(0,true);
					mainsongs = ["sensical", "sensational", "resensation"];
					sidesongs = ["guideline"];
					transition();
				case 2:
					var songs:Array<String> = ["you and me", "fun till end", "light it up"];
					loadStory(songs);
					transition(true);
				case 3:
					picknow = true;
					changeSelection(0,true);
					mainsongs = ["bobalolazing", "feathered firewall", "trolameme", "julius", "shini", "fun gang","new hope","hoax"];
					sidesongs = ["brand new life", "soft machine", "new day", "yawarakai", "underground", "karma"];
					transition();
				case 4: // Has Side Story  
					picknow = true;
					changeSelection(0,true);
					mainsongs = ["errorians", "our hope"];
					sidesongs = ["virus", "crowd control", "malware",'kowase', "your hope", "our hope"];
					transition();
			}
		}
		else
		{
			FlxG.sound.play(Paths.sound('menu/selected'), 1);
			FlxG.sound.music.fadeOut(0.3,0);
			for (i in 0...sideGroup.members.length)
			{	//32 146
				// 731 181
				FlxTween.tween(sideGroup.members[0], {y: -FlxG.height , alpha:0}, 0.7, {ease: FlxEase.cubeOut});
				FlxTween.tween(sideGroup.members[1], {y: -FlxG.height, alpha:0}, 0.6, {ease: FlxEase.cubeOut});
				FlxTween.tween(text, {y: -10 , alpha:0}, 0.7, {ease: FlxEase.cubeOut});
				FlxTween.tween(desc, {y: -10 , alpha:0}, 0.7, {ease: FlxEase.cubeOut});
			}

			switch (curSelected)
			{
				case 0:
					loadStory(mainsongs);
				case 1:
					FlxG.save.data.bfmode = true;
					loadStory(sidesongs);
			}
		}
	}
}

function postUpdate(elapsed:Float)
{
	if (FlxG.keys.pressed.J) desc.x -= 5;
	if (FlxG.keys.pressed.L) desc.x += 5;
	if (FlxG.keys.pressed.I) desc.y -= 5;
	if (FlxG.keys.pressed.K) desc.y += 5;
	if (FlxG.keys.pressed.O) trace(desc);
	sideShader.iTime = (time += elapsed);
}

function changeSelection(change:Int = 0, ?reset:Bool)
{
	var arr = ['o','oo'];
	var group:FlxTypedGroup;

	FlxG.sound.play(Paths.sound('menu/scroll'), 0.4);
	if(reset){curSelected = 0;}
	else {curSelected += change;}

	if(picknow) {arr = sideShit; group = sideGroup;}
	else {arr = storyShit; group = storyShit;}

	if (curSelected < 0)
		curSelected = arr.length - 1;
	if (curSelected >= arr.length)
		curSelected = 0;

	trace(curSelected);
	if(!picknow)
	{
		storyGroup.forEach(function(sprite:FlxSprite) { //495 + i * 415
			if (curSelected == 0)//if(curSelected == 0)
			{
				tween = FlxTween.tween(sprite, {x: 444 + sprite.ID * gap}, 0.2, {ease: FlxEase.expoOut}); // just redid it cus that looked like a mess sorry taeyai lol
			}
			else
			{
				tween = FlxTween.tween(sprite, {x: (FlxAxes.XY + sprite.ID * gap) - (curSelected * gap) + gap -45}, 0.2, {ease: FlxEase.expoOut}); // just redid it cus that looked like a mess sorry taeyai lol
			}
		});
		storyGroup.forEach(function(sprite:FlxSprite) {
			if (sprite.ID == curSelected)
			{
				FlxTween.tween(sprite, {alpha: 1}, 0.2);
				FlxTween.tween(sprite.scale, {x: scaleOG[0], y: scaleOG[1]}, 0.2, {ease: FlxEase.expoOut});
			}
			else
			{
				FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
				FlxTween.tween(sprite, {width: 290, height: 410}, 0.2, {ease: FlxEase.expoOut});
			}
		});

		switch(curSelected)
		{
			case 0:
				chapter.text = chname[0];
				desc.text = dname[0];
				chapter.screenCenter(FlxAxes.X);
				desc.screenCenter(FlxAxes.X);
			case 1:
				chapter.text = chname[1];
				desc.text = dname[1];
				chapter.screenCenter(FlxAxes.X);
				desc.screenCenter(FlxAxes.X);
			case 2:
				chapter.text = chname[2];
				desc.text = dname[2];
				chapter.screenCenter(FlxAxes.X);
				desc.screenCenter(FlxAxes.X);
			case 3:
				chapter.text = chname[3];
				desc.text = dname[3];
				chapter.screenCenter(FlxAxes.X);
				desc.screenCenter(FlxAxes.X);
			case 4:
				chapter.text = chname[4];
				desc.text = dname[4];
				chapter.screenCenter(FlxAxes.X);
				desc.screenCenter(FlxAxes.X);
		}
	}
	else
	{
		sideGroup.forEach(function(sprite:FlxSprite) {
			if (sprite.ID == curSelected)
			{
				FlxTween.tween(sprite, {alpha: 1}, 0.2);
				//FlxTween.tween(sprite.scale, {x: scaleOG[0], y: scaleOG[1]}, 0.2, {ease: FlxEase.expoOut});
				sprite.shader = sideShader;
			}
			else
			{
				FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
				//FlxTween.tween(sprite, {width: 290, height: 410}, 0.2, {ease: FlxEase.expoOut});
				sprite.shader = null;
			}
		});
	}
}

function transition(?main:Bool)
{
	if(main)
	{
		FlxG.camera.fade(FlxColor.WHITE, 1, true, null, true);
		FlxTween.tween(fade, {alpha: 0}, 0.2); 
		FlxTween.tween(fade2, {alpha: 0}, 0.2);
		FlxTween.tween(chapter, {y: 9 - FlxG.height , alpha:0}, 0.7, {ease: FlxEase.cubeOut});
		FlxTween.tween(desc, {y: 655 + FlxG.height, alpha:0}, 0.7, {ease: FlxEase.cubeOut});
	}
	for (i in 0...storyGroup.members.length)
	{
		FlxTween.tween(storyGroup.members[0], {y: -111 , alpha:0}, 0.7, {ease: FlxEase.quadIn});
		FlxTween.tween(storyGroup.members[1], {y: -166, alpha:0}, 0.6, {ease: FlxEase.quadIn});
		FlxTween.tween(storyGroup.members[2], {y: -232, alpha:0}, 0.8, {ease: FlxEase.quadIn});
		FlxTween.tween(storyGroup.members[3], {y: -490, alpha:0}, 0.65, {ease: FlxEase.quadIn});
		FlxTween.tween(storyGroup.members[4], {y: -490, alpha:0}, 0.65, {ease: FlxEase.quadIn});
	}
	if(!main)
	{
		for (i in 0...sideGroup.members.length)
		{	//32 146
			// 731 181
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				onside = true;
				FlxTween.tween(sideGroup.members[0], {y: -514 , alpha:1}, 0.7, {ease: FlxEase.cubeOut});
				FlxTween.tween(sideGroup.members[1], {y: -494, alpha:0.5}, 0.6, {ease: FlxEase.cubeOut});
				FlxTween.tween(text, {y: 9 , alpha:1}, 0.7, {ease: FlxEase.cubeOut});
				FlxTween.tween(chapter, {y: -9 , alpha:0}, 0.6, {ease: FlxEase.cubeOut});
			});
		}
	}
}

function loadStory(songs:Array<String>)
{
	PlayState.storyWeek = 'lol';
	PlayState.storyPlaylist = songs;

	trace(PlayState.storyPlaylist);
	PlayState.isStoryMode = true;
	PlayState.chartingMode = false;
	PlayState.__loadSong(PlayState.storyPlaylist[0], 'regular');
	new FlxTimer().start(1, function(tmr:FlxTimer)
	{
		FlxG.switchState(new PlayState());
	});
}


//MAKE OG FUNCTION WON'T WORK!!!
function changeWeek(event)
{
	event.cancelled = true;
}
function changeDifficulty(event)
{
	event.cancelled = true;
}
function selectWeek(event)
{
	event.cancelled = true;
}
