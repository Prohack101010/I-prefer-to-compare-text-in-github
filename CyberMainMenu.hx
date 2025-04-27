import funkin.ui.FunkinText;
import flixel.text.FlxTextBorderStyle;
import haxe.io.Path;
import flixel.effects.FlxFlicker;
import funkin.options.OptionsMenu;
import funkin.backend.MusicBeatState;
import funkin.menus.credits.CreditsMain;
import funkin.game.PlayState;
var o;
var square:FlxSprite;
var fade:FlxSprite;
var texts:Array<Dynamic> = [];
var images:Array<FlxSprite> = [];

var bglist:Array<String> = [
	'desk',
	'grrrr',
	'shadum'
];

var textGroups:FlxTypedGroup;
var time:Float;
var lang:String = '';
function create() {
	o = optionShit;
	optionShit = ["story mode", "freeplay", "options","extra","my channel", "credits"];
	optionShitth = ["โหมดเนื้อเรื่อง", "ฟรีเพลย์", "ตั้งค่า","เพิ่มเติม", "เครดิต"];

}
function postCreate() {
	remove(members[1]);
	remove(members[4]);
	magenta.destroy();
	remove(magenta);

	optionShit = ["story mode", "freeplay", "options", "credits","extra","my channel"];

	for(i in menuItems) {
		i.visible = false;
		i.alpha = 0;
		i.destroy();
	}

	var randombg = bglist[FlxG.random.int(0, bglist.length-1)];
	var image = new FlxSprite(0, -FlxG.height * 0.25);
	image.antialiasing = true;
	image.scrollFactor.set(0, 0.25);
	image.loadGraphic(Paths.image('menus/mainmenu/art/' + randombg));
	image.setGraphicSize(FlxG.width * 1.4, FlxG.height * 1.4);
	image.updateHitbox();
	image.screenCenter(FlxAxes.X);
	add(image);

	fade = new FlxSprite();
	fade.antialiasing = true;
	fade.scrollFactor.set();
	fade.loadGraphic(Paths.image('menus/mainmenu/fade'));
	add(fade);

	var logo = new FlxSprite();
	logo.antialiasing = true;
	logo.scrollFactor.set(0, 0);
	if(FlxG.save.data.thaiSub) {logo.loadGraphic(Paths.image('menus/titlescreen/logo-th'));}
	else{logo.loadGraphic(Paths.image('menus/titlescreen/logo'));}

	logo.scale.set(2/3, 2/3);
	logo.updateHitbox();
	logo.setPosition(FlxG.width - logo.width - 25, 25);
	add(logo);

	textGroups = new FlxTypedGroup();
	add(textGroups);

	if(FlxG.save.data.thaiSub){o = optionShitth;}
	else {o = optionShit;}

	for(i2 in 0...o.length) {
		var i = o.length - i2 - 1;

		var text = new FunkinText(0, FlxG.height - 120 - (i2 * 60), 0, upper(o[i]), 48);
		if(FlxG.save.data.thaiSub) {text.font = Paths.font('thai-font.ttf');}
		text.borderStyle = FlxTextBorderStyle.NONE;
		text.alignment = "right";
		text.antialiasing = true;
		text.scrollFactor.set();
		text.x = FlxG.width - 100 - text.width;

		text.ID = i;
		trace(text);
		textGroups.add(text);

		var bar = new FlxSprite(text.x, text.y + text.height + 4).makeGraphic(1, 1, 0xFFF70174);
		bar.scale.set(text.width, 6);
		if(FlxG.save.data.thaiSub) {bar.y -= 10;}
		bar.updateHitbox();
		bar.scrollFactor.set();
		add(bar);

		texts.insert(0, {
			bar: bar,
			text: text,
			t: 0
		});
	}

	square = new FlxSprite(texts[0].text.x - 32, texts[0].text.y + (texts[0].text.height / 2) - 8).makeGraphic(16, 16, 0xFF02F4F0);
	square.angle = FlxG.random.float(20, 45);
	square.scrollFactor.set();
	square.antialiasing = true;
	add(square);

	versionShit = new FunkinText(5, FlxG.height - 2, 0, 'Cyber Sensation: Malware Breakout V1');
	versionShit.scrollFactor.set();
	versionShit.y -= versionShit.height;
	add(versionShit);

	transitionCamera = new FlxCamera();
	transitionCamera.bgColor = 0;
	FlxG.cameras.add(transitionCamera, false);
}

function update(elapsed)
{
	if (controls.ACCEPT)
	{
		selectItem();
	}

	if (controls.UP_P)
		changeItem(-1);
	if (controls.DOWN_P)
		changeItem(1);
}

function postUpdate(elapsed:Float) {
	time += elapsed;
	for(m in menuItems)
		m.x -= FlxG.width * 0.2;

	if (FlxG.keys.justPressed.FOUR) {
		FlxG.switchState(new ModState("PsychToCodename"));
	}
	if (FlxG.keys.justPressed.F5) {
		FlxG.resetState();
	}

	if(!selectedSomethin)
	{
		for(i in 0...texts.length) {
			var t = texts[i];
			t.t = lerp(t.t, (curSelected == i ? 1 : 0), 0.5);
			t.bar.alpha = FlxEase.cubeOut(t.t);
			t.bar.scale.set((t.t * t.text.width) - 4, 6);
			t.bar.updateHitbox();
			t.bar.x = FlxG.width - 100 - t.bar.width;
		}
	}

	if(!selectedSomethin)
	{
		square.x = lerp(square.x, texts[curSelected].text.x - 32, 0.5);
		square.y = lerp(square.y, texts[curSelected].text.y + (texts[curSelected].text.height / 2) - 8, 0.5);
		square.angle += elapsed * 75;
	}
	else
	{
		texts[curSelected].text.x -= 0.1;
		texts[curSelected].bar.x -= 0.12;
		square.x += elapsed * texts[curSelected].text.x;
		square.height += elapsed * texts[curSelected].text.height;
		square.angle += elapsed * 100;


		textGroups.forEach(function(text:FunkinText) {
			if (text.ID != curSelected)
			{
				text.x += 1 / text.x + 2;
				text.alpha -= 0.02;
			}
		});
	}
}

function upper(str:String) {
	var c = str.split(" ");
	for(i in 0...c.length)
		c[i] = c[i].substr(0, 1).toUpperCase() + c[i].substr(1);
	return c.join(" ");
}


function changeItem(huh:Int = 0)
{
	var value = FlxMath.wrap(curSelected + huh, 0, menuItems.length-1);
	curSelected = value;
	FlxG.sound.play(Paths.sound('menu/scroll'), 0.7);
}

function selectItem() {
	selectedSomethin = true;
	var daChoice:String = o[curSelected];
	FlxG.sound.play(Paths.sound('menu/selected'), 1);
	var duration = FlxG.sound.play(Paths.sound('menu/selected')).length;
	FlxG.camera.flash(FlxColor.WHITE, duration/1000);
	new FlxTimer().start(duration/1000, function(tmr:FlxTimer)
	{
		switch (daChoice)
		{
			case 'story mode' | 'โหมดเนื้อเรื่อง':
				FlxG.switchState(new StoryMenuState());
				//FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay' | 'ฟรีเพลย์':
				FlxG.switchState(new FreeplayState());
				//FlxG.switchState(new FreeplayState());
				trace("Freeplay Menu Selected");
			case 'credits' | 'เครดิต':
				PlayState.storyWeek = 'credits';
				PlayState.storyPlaylist = ["credits"];

				trace(PlayState.storyPlaylist);
				PlayState.isStoryMode = true;
				PlayState.chartingMode = false;
				PlayState.__loadSong(PlayState.storyPlaylist[0], 'credits');
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.switchState(new PlayState());
				});
				/*
				FlxG.switchState(new CreditsMain());
				trace("Credits Main Selected");
				*/
			case 'extra':
				FlxG.resetState();	
				CoolUtil.openURL('https://drive.google.com/drive/folders/15-gk54nWrAZYGaCs3vHzcljNz146VMTO?usp=sharing');
			case 'my channel':
				FlxG.resetState();	
				CoolUtil.openURL('https://youtube.com/@KralOyuncuRBX');
			case 'options' | 'ตั้งค่า':
				FlxG.switchState(new OptionsMenu());
				trace("Options Menu Selected");
			case 'back' | 'กลับ':
				FlxG.switchState(new TitleState());
				trace("Back Selected");
		}
	});
}

//TURN OFF OLD FUNCTION
function onSelectItem(event)
{
	event.cancelled = true;
}
function onChangeItem(event)
{
	event.cancelled = true;
}
