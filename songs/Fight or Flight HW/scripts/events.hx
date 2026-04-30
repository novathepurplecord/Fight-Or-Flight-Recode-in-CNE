import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

// hi im nova i made this ok bye x2

var barData = {fear: 0.0};
var cameraMoveStrength:Int = 10;

var heatShader:CustomShader = new CustomShader('heat');
var vignetteShader:CustomShader = new CustomShader('vignette');

var introBlack:FlxSprite;

function create() {
    // FearBar ™
    insert(members.indexOf(strumLines) + 1, fearBarImage = new FlxSprite(FlxG.width - 100, 102, Paths.image('fearBar'))).camera = camHUD;
    insert(members.indexOf(strumLines) + 2, fearBar = new FlxBar(FlxG.width - 47, 125, FlxBarFillDirection.BOTTOM_TO_TOP, 14, 250, barData, "fear", 0, 1)).camera = camHUD;
    fearBar.createImageBar(Paths.image('fearbarBG'), null, 0, FlxColor.RED);
    fearBar.unbounded = true;
}

var starvedCalm = strumLines.members[0].characters[0];
var starved = strumLines.members[0].characters[1];
var starvedAngry = strumLines.members[0].characters[2];

var tailsBrave = strumLines.members[1].characters[0];
var tailsAfraid = strumLines.members[1].characters[1];
var tailsDetermined = strumLines.members[1].characters[2];

public function getCurStarved() { // i'm doing anything atp :sob:
    for (char in [starvedAngry, starved, starvedCalm]) if (char.visible) return char;
}

function postCreate() {
    // Camera Stuff
    camera.zoom = 1;
    camZoomingStrength = 0;
    updateLerp(0.03);

    // Intro Stuff
    add(introBlack = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK)).camera = camHUD;
    add(startCircle = new FlxSprite(900, 0, Paths.image('circle/circle'))).camera = camHUD;
	add(startText = new FlxSprite(-1200, 0, Paths.image('circle/text'))).camera = camHUD;

    // Intro animation
	new FlxTimer().start(0.6, () -> for (i in [startCircle, startText]) FlxTween.tween(i, {x: 0}, 0.5));
	// Fade out
	new FlxTimer().start(1.9, () -> for (i in [startCircle, startText, introBlack]) FlxTween.tween(i, {alpha: 0}, 1));

    // chars hiding
    for (char in [starved, starvedAngry, tailsDetermined, tailsAfraid]) char.visible = false;
    remove(comboGroup);

    // sonic exe 2.5 flashbacks
    tailsBrave.origin.x = tailsBrave.width - 200; 
    tailsAfraid.origin.x = tailsAfraid.width - 200;
    // perspective effect
    for (tail in [tailsBrave, tailsAfraid, tailsDetermined]) tail.origin.y = tail.x - tail.width;
}

/**
    Life below   ↓
**/

var tailsPerspective:Bool = true;

function onEvent(_) {
    if (_.event.name != "Camera Movement") return;
    defaultCamZoom = (_.event.params[0] == 0) ? 1.1 : 0.85;
}

function update() {
    // perspective effect x2
    if (tailsPerspective) for (tail in [tailsBrave, tailsAfraid, tailsDetermined]) tail.scale.set(FlxG.camera.zoom * 1.1, FlxG.camera.zoom * 1.1);

    if (barData.fear >= 1.0) health = -10;
    barData.fear = CoolUtil.bound(barData.fear, 0.0, 1.0);
}

function postUpdate() {
    missesTxt.text = "Sacrifices: " + misses;
    heatShader.iTime = Conductor.songPosition * 0.001;
    if (curStep >= 1856 && curStep <= 2144) vignetteShader.intensity = Math.abs(FlxMath.fastSin(Conductor.curBeatFloat * Math.PI * 0.25));

    var posY = (curCameraTarget == 0) ? 260 : 320; // starved : tails
    camFollow.setPosition(900, posY);

    switch (getCurStarved().animation.curAnim.name) {
        case "singLEFT", "singLEFT-alt": camFollow.x -= cameraMoveStrength;
        case "singRIGHT", "singRIGHT-alt": camFollow.x += cameraMoveStrength;
        case "singUP", "singUP-alt": camFollow.y -= cameraMoveStrength;
        case "singDOWN", "singDOWN-alt": camFollow.y += cameraMoveStrength;
    }
}

function updateLerp(updatedLerpValue:Float) {
    camGame.followLerp = updatedLerpValue;
    camGameZoomLerp = updatedLerpValue;
    trace("camlerp: " + camGame.followLerp, "zoomlerp: " + camGameZoomLerp);
}


// camera intense things
function stepHit(_:Int) {
    switch (_) {
        case 10:
            FlxTween.tween(camera, {zoom: 0.85}, 2, {ease: FlxEase.quadOut, onComplete: () -> defaultCamZoom = camera.zoom});
        case 256:
            starvedCalm.visible = !(starved.visible = true);
            updateLerp(0.04);
            camZoomingStrength = 1; // Flags.DEFAULT_CAM_ZOOM_STRENGTH doesn't work for some reason
            cameraMoveStrength = 15;
        case 512:
            tailsBrave.visible = !(tailsAfraid.visible = true);
            updateLerp(0.05);
        case 768:
            starved.visible = !(starvedAngry.visible = true);
            updateLerp(0.06);
            cameraMoveStrength = 18;
        case 1024:
            updateLerp(0.065);
            cameraMoveStrength = 20;
        case 1280:
            updateLerp(0.01);
            tailsPerspective = false;
            defaultCamZoom = 0.65;
        case 1312:
            tailsAfraid.visible = !(tailsDetermined.visible = true);
            camGame.addShader(heatShader);
            updateLerp(0.065);
            cameraMoveStrength = 20;
            tailsPerspective = true;
        case 1856:
            camGame.addShader(vignetteShader);
            vignetteShader.intensity = 0;
        case 2128:
            updateLerp(0.05);
            defaultCamZoom = 1.15;
        case 2136:
            updateLerp(0.04);
            cameraMoveStrength = 15;
            defaultCamZoom = 1.25;
        case 2144:
            camGame.removeShader(vignetteShader);
            updateLerp(0.03);
            defaultCamZoom = 1;
        case 2272:
            updateLerp(0.01);
            tailsPerspective = false;
            defaultCamZoom = 0.65;
            camera.fade(FlxColor.BLACK, 5);
    }
}

// better sustains and fearbar
function onNoteHit(e) {
    if (!e.note.isSustainNote) barData.fear = CoolUtil.bound(barData.fear + ((e.character == dad) ? 0.0029 : -0.0025), 0.0, 1.0);
    if (e.note.isSustainNote) {
        e.animCancelled = true;
        // this thing looks weird on other sprites rather then these
        for (char in [starvedCalm, tailsBrave, tailsAfraid]) char.lastHit = Conductor.songPosition;
    }
}

function onPlayerMiss() barData.fear = CoolUtil.bound(barData.fear + 0.0026, 0.0, 1.0);

// copypasted from og code LOL
function beatHit(_:Int) if (_ >= 346 && _ < 504 && health >= 0.08 && barData.fear <= 1.0) health -= 0.046;

function onCountdown(e) e.cancel();

// cne 1.0.1 crash bypass
function onSongEnd(_) validScore = false;

// silly nova was to lazy to make death screen
function onGameOver() CoolUtil.openURL("https://youtu.be/m2GywoS77qc");