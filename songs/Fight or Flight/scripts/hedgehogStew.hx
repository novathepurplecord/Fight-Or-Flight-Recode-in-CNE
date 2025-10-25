import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

// hi im nova i made this ok bye

var barData = { fear: 0.0 };
var targetBoyfriendY:Float = 270.0;
var targetCameraY:Float = -50.0;

var myLerp:Float = 0.03;
var dontZoomYet:Bool = true;
defaultCamZoom = 0.85;

var cameraYOffset:Float = 0.0;
var cameraXOffset:Float = 0.0;
var cameraMoveStrength:Float = 10.0;

introSounds = [null];
introSprites = [null];

function create() {

    // START CIRCLE
    black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.camera = camHUD;

    startCircle = new FlxSprite(900, 0).loadGraphic(Paths.image('circle/circle'));
    startCircle.camera = camHUD;

	startText = new FlxSprite(-1200, 0).loadGraphic(Paths.image('circle/text'));
    startText.camera = camHUD;

    // FEAR MECHANIC
    fearBarImage = new FlxSprite(FlxG.width - 100, 100).loadGraphic(Paths.image('fearBar'));
    fearBarImage.camera = camHUD;

    fearBarBG = new FlxSprite(fearBarImage.x + 20, fearBarImage.y).loadGraphic(Paths.image('fearbarBG'));
    fearBarBG.camera = camHUD;

    fearBar = new FlxBar(fearBarImage.x + 50, fearBarImage.y + 23, FlxBarFillDirection.BOTTOM_TO_TOP, 20, 250, barData, "fear", 0, 1);
    fearBar.createColoredEmptyBar(null);
    fearBar.createColoredFilledBar(FlxColor.RED);
    fearBar.camera = camHUD;
    fearBar.numDivisions = 400;

    add(fearBarBG);
    add(fearBar);
    add(fearBarImage);
}

function postCreate() {

    // CAMERA STUFF
    camera.zoom = 1;
    camera.scroll.x = 250;
    camera.scroll.y = -50;
    camera.follow();

    // START CIRCLE ANIMATION
    new FlxTimer().start(0.6, function(_) {
		FlxTween.tween(startCircle, {x: 0}, 0.5);
		FlxTween.tween(startText, {x: 0}, 0.5);
	});

	new FlxTimer().start(1.9, function(_) {
		FlxTween.tween(startCircle, {alpha: 0}, 1);
		FlxTween.tween(startText, {alpha: 0}, 1);
		FlxTween.tween(black, {alpha: 0}, 1);
	});

    add(black);
    add(startCircle);
    add(startText);
}

// Death below  |
//              \/
var tailsPerspective:Bool = true;

function onEvent(_:EventGameEvent) {
    var event = _.event;
    if (event.name != "Camera Movement") return;
    
    if (event.params[0] == 0) { // Tails
        defaultCamZoom = 1.1;
        targetBoyfriendY = 500;
        if (curStep >= 1472 && curStep <= 1728) targetCameraY = -150;
        else targetCameraY = -100;
        //targetCameraY = -100;
    } else { // Starved
        defaultCamZoom = 0.85;
        targetBoyfriendY = 270;
        targetCameraY = -50;
    }
}

function update() {
    var zoom = FlxG.camera.zoom;
    if(tailsPerspective) boyfriend.scale.set(zoom * 1.2, zoom * 1.2);

    switch (dad.animation.curAnim.name) {
        case "singDOWN", "singDOWN-alt":
            cameraYOffset = cameraMoveStrength;
        case "singUP", "singUP-alt":
            cameraYOffset = -cameraMoveStrength;
        case "singLEFT", "singLEFT-alt":
            cameraXOffset = -cameraMoveStrength;
        case "singRIGHT", "singRIGHT-alt":
            cameraXOffset = cameraMoveStrength;
    }

    cameraYOffset = lerp(cameraYOffset, 0, 0.3);
    cameraXOffset = lerp(cameraXOffset, 0, 0.3);
    
    boyfriend.y = lerp(boyfriend.y, targetBoyfriendY, myLerp); 
    camera.scroll.y = lerp(camera.scroll.y, targetCameraY + cameraYOffset, myLerp);
    camera.scroll.x = lerp(camera.scroll.x, 250 + cameraXOffset, myLerp);
    
    if(barData.fear >= 1.0) health = -10;
    barData.fear = CoolUtil.bound(barData.fear, 0.0, 1.0);
}

function postUpdate() {
    missesTxt.text = "Sacrifices: " + misses;
}

function updateLerp(lerp:Float){
    myLerp = lerp;
    camGameZoomLerp = myLerp;
    trace("Updated Lerp: " + myLerp + " camGameZoomLerp: " + camGameZoomLerp);
}

// camera intense things
function stepHit(curStep:Int) {
    switch (curStep) {
        case 3:
            //eh uh ieh eh eh uh eeh
            FlxTween.tween(camera, {zoom: 0.85}, 2, {ease: FlxEase.quadOut});
        case 128:
            //eh oo uh eh eh uh ee uu-eh
            dontZoomYet = false;
            cameraMoveStrength = 15;
        case 383:
            updateLerp(0.05);
        case 638:
            updateLerp(0.065);
            cameraMoveStrength = 20;
        case 895:
            updateLerp(0.05);
            cameraMoveStrength = 15;
        case 1151:
            updateLerp(0.01);
            tailsPerspective = false;
            defaultCamZoom = 0.65;
        case 1183:
            updateLerp(0.065);
            cameraMoveStrength = 20;
        case 1184:
            tailsPerspective = true;
        case 1999:
            updateLerp(0.05);
            defaultCamZoom = 1.15;
        case 2007:
            updateLerp(0.04);
            cameraMoveStrength = 15;
            targetBoyfriendY = 510;
            defaultCamZoom = 1.25;
        case 2015:
            updateLerp(0.03);
            defaultCamZoom = 1;
        case 2144:
            updateLerp(0.01);
            tailsPerspective = false;
            defaultCamZoom = 0.65;
            camera.fade(FlxColor.BLACK, 5);
    }
}

// blahblahlbaljbadafsdfmvsof
function onNoteHit(_:NoteHitEvent) {
    if(dontZoomYet) _.enableCamZooming = false;
    else _.enableCamZooming = true;
}

function onDadHit() {
    barData.fear = CoolUtil.bound(barData.fear + 0.0025, 0.0, 1.0);
}

function onPlayerHit() {
    barData.fear = CoolUtil.bound(barData.fear - 0.0026, 0.0, 1.0);
}

function onPlayerMiss() {
    barData.fear = CoolUtil.bound(barData.fear + 0.0026, 0.0, 1.0);
    // health += 0.5;
}

// copypasted from og code LOL
function beatHit(curBeat:Int) {
    if (curBeat >= 346 && curBeat < 536) {
        if (health >= 0.08 && barData.fear <= 1.0) {
            health -= 0.046;
        }
    }
}

// cne 1.0.1 crash bypass
function onSongEnd(_) validScore = false;

// silly nova was to lazy to make death screen
function onGameOver(){
    CoolUtil.openURL("https://youtu.be/m2GywoS77qc");
}