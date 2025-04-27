import options.OptionsState;
import MusicBeatState;
import flixel.text.FlxTextBorderStyle;
import haxe.io.Path;
import flixel.effects.FlxFlicker;
import MusicPlayer;
import options.OptionsState;
import MusicBeatState;
import CreditsState;
import PlayState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxTypedGroup;
import options.OptionsState;
import backend.Mods;
import PlayState;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import MusicBeatState;
import StoryMenuState;
import FreeplayState;
import Sys;
import flixel.math.FlxMath;
import HealthIcon;
import Difficulty;


var virusSpookyPath:String;
var diff:Float = 0;
var time:Float = 0;

var virusLocked:Bool = false;
var virusIndex:Int = -1;

var curSelected:Int = 0;
var grpSongsText:FlxTypedGroup;
var grpSongBars:FlxTypedGroup;

var selected = false;
var songbar:FlxSprite;
var songText:FunkinText;
var diffText2:FlxText;
var icon:HealthIcon;
var grpIcon:FlxTypedGroup;

//ART
var grpArt:FlxTypedGroup;
var artname = ["mayhem","sha", "ct","old","def","soft","tans","dust","hope", "gacha"];
var artcover:FlxSprite;

//SONG CHECK
var ch1song = ["Open System","Wear A Mask","Last Hope"];
var mayhemSong = ["You And Me","Fun Till End","Light It Up"];
var shaSong = ["Virus","Malware","Crowd Control", "Errorians", "Our Hope"];

//Background

function onCreate()
{
	_virtualpad.cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
	//PRELOAD

	for (i in 0...songs.length)
	{
		//curPlayingInstt = Paths.inst(songs[i].name, songs[i].difficulties);
		//FlxG.sound.cache(curPlayingInstt);
		//curPlayingInstt = Paths.inst(songs[i].name, songs[i].difficulties['EX']);
		// FlxG.sound.cache(curPlayingInstt);
		// curPlayingInstt = null;
	}
}
function postCreate() {
	remove(members[1]);
	remove(members[3]);
	virusSpookyPath = Paths.getPath("songs/virus/song/her.ogg");

	//BG
	members[2].visible = false;
	bglol = new FlxSprite(-800, -800);
	bglol.makeGraphic(FlxG.width, FlxG.height, 0xFF616161);
	bglol.scrollFactor.set(0, 0);
	bglol.screenCenter();
	bgShader = new CustomShader('bgMenu');
	bglol.shader = bgShader;
	add(bglol);

	grpSongBars = new FlxTypedGroup();
	add(grpSongBars);

	grpSongsText = new FlxTypedGroup();
	add(grpSongsText);

	grpIcon = new FlxTypedGroup();
	add(grpIcon);

	grpArt = new FlxTypedGroup();
	add(grpArt);

	_virtualpad.cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];

	for (i in 0...songs.length)
	{
		songText = new FunkinText(983.12, (0 * i) + 30,0, songs[i].songName, 42);
		songText.alignment = 'RIGHT';
		songText.font = Paths.font('freeplay.ttf');
		songText.y = i * 129;

		songText.ID = i;

		songbar = new FlxSprite(0, (0 * i) + 100);
		songbar.loadGraphic(Paths.image('menus/freeplay/songbar'));
		songbar.antialiasing = true;
		songbar.scrollFactor.set(0, 0);
		songbar.x = FlxG.width - songbar.width + 260;
		songbar.y = songText.y - 33;
		songbar.scale.set(2/3, 2/3);
		songbar.updateHitbox();

		songbar.ID = i;

		grpSongBars.add(songbar);
		grpSongsText.add(songText);

		Mods.currentModDirectory = songs[i].folder;
		icon = new HealthIcon(songs[i].songCharacter);
		icon.x = songText.x - 130;
		icon.scale.set(0.6,0.6);
		icon.y = songText.y - 54;
		icon.ID = i;

		grpIcon.add(icon);

	}

	for(i in 0...artname.length)
	{
		artcover = new FlxSprite(94, 115).loadGraphic(Paths.image("menus/freeplay/cover/" + artname[i]));
		artcover.antialiasing = true;
		artcover.scale.set(2/3, 2/3);
		artcover.angle = -10;
		artcover.alpha = 0;
		artcover.updateHitbox();
		artcover.ID = i;
		//if(imgss.ID == 0) imgss.screenCenter(FlxAxes.XY); //512.5 232.5
		//if(imgss.ID == 1) {imgss.screenCenter(FlxAxes.Y); imgss.x = 200; imgss.y +=10;}//200 247
		//if(imgss.ID == 2) {imgss.screenCenter(FlxAxes.Y); imgss.x = 900;}//900 272
		grpArt.add(artcover);
	}

	diffText2 = new FunkinText(1050,320, 0, "DIFF", 24);
	diffText2.font = songText.font;
	diffText2.alpha = 1;
	add(diffText2);

	overlay = new FlxSprite(0, 0);
	overlay.loadGraphic(Paths.image('menus/freeplay/overlay'));
	overlay.antialiasing = true;
	overlay.scrollFactor.set(0, 0);
	overlay.updateHitbox();
	add(overlay);

	funText = new FunkinText(10,10, songs[curSelected].songName, 62);
	funText.alignment = 'RIGHT';
	funText.font = Paths.font('freeplay.ttf');
	funText.text = songs[curSelected].songName + " - " + Difficulty.getString(curDifficulty) + " - " + "Ported by KralOyuncu";
	funText.size = 42;
	funText.antialiasing = true;
	add(funText);

	comText = new FunkinText(10,53, songs[curSelected].songName, 62);
	comText.alignment = 'RIGHT';
	comText.font = Paths.font('freeplay.ttf');
	comText.text = "Ported by KralOyuncu";
	comText.size = 32;
	comText.antialiasing = true;
	add(comText);

	scText = new FunkinText(10,FlxG.height - 46, songs[curSelected].songName, 62);
	scText.alignment = 'LEFT';
	scText.font = Paths.font('freeplay.ttf');
	scText.text = "Ported by KralOyuncu";
	scText.size = 32;
	scText.antialiasing = true;
	add(scText);

	/*
	changeSelection2(0);
	updateOptions();*/

	changeItem(0, true);
	changedaDiff(0,true);
}

var checkLastHold:Int;
var checkNewHold:Int;

function onUpdate(elapsed:Float) {
	if((controls.UI_DOWN || controls.UI_UP) && !(controls.UI_UP_P || controls.UI_DOWN_P)) checkLastHold = Math.floor((holdTime - 0.5) * 10);
	_virtualpad.cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
	player.cameras = [FlxG.cameras.list[FlxG.cameras.list.length-1]];
}

function onUpdatePost(elapsed:Float) {
	for (i in _lastVisibles) {
		iconArray[i].visible = false;
		iconArray[i].active = false;
	}

	if (controls.UI_LEFT_P || controls.UI_RIGHT_P) changedaDiff(0, true);
	if (controls.UI_UP_P || controls.UI_DOWN_P) changeItem(0, true);
	
	if((controls.UI_DOWN || controls.UI_UP) && !(controls.UI_UP_P || controls.UI_DOWN_P))
	{
		checkNewHold = Math.floor((holdTime - 0.5) * 10);

		if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
			changeItem(0, true);
	}

	time += elapsed;
	bgShader.hset("iTime", time);

	scText.text = "PERSONAL BEST: " + lerpScore;
}

function changeItem(change:Int = 0, force:Bool = false)
{
	if (change == 0 && !force) return;
	curSelected = state.curSelected;
	FlxG.sound.play(Paths.sound('menu/scroll'), 0.7);

	changedaDiff(0,true);
	changeArt();

	var tweenlol:FlxTween;
	diffText2.alpha = 0.5;
	diffText2.y -= 10;
	if(tweenlol != null){tweenlol.cancel();}
	tweenlol = FlxTween.tween(diffText2, {y:320,alpha: 1}, 0.2);

	grpSongsText.forEach(function(text:FunkinText) {
		if (text.ID == curSelected)
		{
			//trace(text.text);
			FlxTween.tween(text, {alpha: 1}, 0.2);
			FlxTween.tween(text, {x: 983.12, y: 280.05}, 0.2, {ease: FlxEase.expoOut});
			//FlxTween.tween(text, {width:174,height: 42}, 0.2, {ease: FlxEase.expoOut});
			FlxTween.tween(text.scale, {x:1,y: 1}, 0.2, {ease: FlxEase.expoOut});
		}
		else
		{
			FlxTween.tween(text, {alpha: 0.5}, 0.2);
			FlxTween.tween(text, {x:(983.12+ text.ID * 90) - (curSelected * 90) + 400 /2,y: (160 + text.ID * 128) - (curSelected * 128) + 128}, 0.2, {ease: FlxEase.expoOut});
			//lxTween.tween(text, {width:174/3,height: 42/3}, 0.2, {ease: FlxEase.expoOut});
			FlxTween.tween(text.scale, {x:2/3,y: 2/3}, 0.2, {ease: FlxEase.expoOut});
		}
	});

	grpSongBars.forEach(function(sprite:FlxSprite) {
		if (sprite.ID == curSelected)
		{
			FlxTween.tween(sprite, {alpha: 1}, 0.2);
			FlxTween.tween(sprite, {x: 777 , y: 244}, 0.2, {ease: FlxEase.expoOut});
			FlxTween.tween(sprite.scale, {x:2/3,y: 2/3}, 0.2, {ease: FlxEase.expoOut});
			//FlxTween.tween(sprite, {width:508}, 0.2, {ease: FlxEase.expoOut});
		}
		else
		{
			FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
			//777+100
			FlxTween.tween(sprite, {x:(777 + sprite.ID * 90) - (curSelected * 90) + 400 /2 + 40, y: (119.05 + sprite.ID * 128) - (curSelected * 128) + 128}, 0.2, {ease: FlxEase.expoOut});
			FlxTween.tween(sprite.scale, {x:0.5,y: 0.5}, 0.2, {ease: FlxEase.expoOut});
			// FlxTween.tween(sprite, {width:600}, 0.2, {ease: FlxEase.expoOut});
		}
	});

	grpIcon.forEach(function(sprite:HealthIcon) {
		if (sprite.ID == curSelected)
		{
			FlxTween.tween(sprite, {alpha: 1}, 0.2);
			FlxTween.tween(sprite, {x: 983.12-130, y: 280.05-54}, 0.2, {ease: FlxEase.expoOut});
			FlxTween.tween(sprite.scale, {x:0.6,y: 0.6}, 0.2, {ease: FlxEase.expoOut});
		}
		else
		{
			FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
			FlxTween.tween(sprite, {x:(983.12-70+ sprite.ID * 90) - (curSelected * 90) + 400 /2,y: (100  + sprite.ID * 128) - (curSelected * 128) + 128}, 0.2, {ease: FlxEase.expoOut});

			FlxTween.tween(sprite.scale, {x:2/5,y: 2/5}, 0.2, {ease: FlxEase.expoOut});
		}
	});

	autoplayElapsedd = 0;
	songInstPlayingg = false;

	funText.text = songs[curSelected].songName + " - " + Difficulty.getString(curDifficulty);
	updateScore();
	comText.text = "Ported by KralOyuncu";
}

function changedaDiff(change:Int = 0, force:Bool = false)
{
	if (change == 0 && !force) return;

	var curSong = songs[curSelected];
	var validDifficulties = Difficulty.list.length > 0;

	var value = FlxMath.wrap(curDifficulty + change, 0, Difficulty.list.length-1);
	curDifficulty = value;

	if (Difficulty.list.length > 1)
		diffText2.text = '< '+ Difficulty.getString(curDifficulty) +' >';
	else
		diffText2.text = validDifficulties ? Difficulty.getString(curDifficulty) : "-";

	funText.text = songs[curSelected].songName + " - " + Difficulty.getString(curDifficulty);
}

function changeArt()
{
	var curSong = songs[curSelected].songName;

	switch(curSong)
	{
		case "Open System","Wear A Mask","Last Hope":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 3)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.2);
					FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
				}

			});
		case "You And Me","Fun Till End","Light It Up":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 0)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.2);
					FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
				}
			});
		case "Virus","Malware","Crowd Control", "Errorians":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 1)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.2);
					FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
				}

			});
		case "Cyber Trouble":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 2)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.2);
					FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
				}
			});
		case "Soft Machine", "New Day", "Yawarakai":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 5)
					{
						FlxTween.tween(sprite, {alpha: 1}, 0.2);
						FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
					}
					else
					{
						FlxTween.tween(sprite, {alpha: 0}, 0.2);
						FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
					}
			});
		case "Underground", "Karma":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 6)
					{
						FlxTween.tween(sprite, {alpha: 1}, 0.2);
						FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
					}
					else
					{
						FlxTween.tween(sprite, {alpha: 0}, 0.2);
						FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
					}
			});
		case "New Hope", "Hoax":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 7)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.2);
					FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
				}
			});
		case "Our Hope":
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 8)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.2);
					FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
				}
			});
		default:
			grpArt.forEach(function(sprite:FlxSprite) {
				if(sprite.ID == 4)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite, {x: 140,y: 200,angle: -10}, 0.2);
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0}, 0.2);
					FlxTween.tween(sprite, {x: -100,y: -100,angle: 100}, 0.2);
				}
		});
	}
}
