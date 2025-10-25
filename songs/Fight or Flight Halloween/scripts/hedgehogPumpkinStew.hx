import flixel.ui.FlxBar;
import flixel.ui.FlxBarFillDirection;

//hi im nova i made this ok bye
var lastCamTarget:Int = -1;

var barData = {fear: 0}

var targetBoyfriendY:Float = 300;
var targetCameraY:Float = -10;

var myLerp:Float = 0.03;
var dontZoomYet:Bool = true;

var cameraYOffset:Float = 0;
var cameraXOffset:Float = 0;
var cameraMoveStrength:Float = 15;

introSounds = [null];
introSprites = [null];

function create() {

    // START CIRCLE
    black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    black.camera = camHUD;

    startCircle = new FlxSprite().loadGraphic(Paths.image('circle/circle'));
    startCircle.camera = camHUD;
    startCircle.x += 900;

	startText = new FlxSprite().loadGraphic(Paths.image('circle/text'));
    startText.camera = camHUD;
    startText.x -= 1200;

    // FEAR MECHANIC
    fearBarImage = new FlxSprite().loadGraphic(Paths.image('fearBar'));
    fearBarImage.x = FlxG.width - 100;
    fearBarImage.y = 100;
    fearBarImage.camera = camHUD;

    fearBarBG = new FlxSprite().loadGraphic(Paths.image('fearbarBG'));
    fearBarBG.x = fearBarImage.x;
    fearBarBG.y = fearBarImage.y;
    fearBarBG.camera = camHUD;

    fearBar = new FlxBar(fearBarImage.x + 30, fearBarImage.y + 18, FlxBarFillDirection.BOTTOM_TO_TOP, 20, 260, barData, "fear", 0, 1);
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
    new FlxTimer().start(0.6, function(tmr:FlxTimer) {
		FlxTween.tween(startCircle, {x: 0}, 0.5);
		FlxTween.tween(startText, {x: 0}, 0.5);
	});

	new FlxTimer().start(1.9, function(tmr:FlxTimer) {
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

function update(elapsed:Float) {
    var zoom = FlxG.camera.zoom;
    if (tailsPerspective) boyfriend.scale.set(zoom * 1.2, zoom * 1.2);

    if (curCameraTarget != lastCamTarget) {
        lastCamTarget = curCameraTarget;
        if(curCameraTarget == 0) {
            defaultCamZoom = 1.1;
            targetBoyfriendY = 500;
            targetCameraY = -100;
        } else if(curCameraTarget == 1) {
            defaultCamZoom = 0.85;
            targetBoyfriendY = 270;
            targetCameraY = -50;
        }
    }

    switch (dad.animation.curAnim.name) {
        case "singDOWN", "singDOWN-alt":
            cameraYOffset = cameraMoveStrength;
        case "singUP", "singUP-alt":
            cameraYOffset = -cameraMoveStrength;
        case "singLEFT", "singLEFT-alt":
            cameraXOffset = -cameraMoveStrength;
        case "singRIGHT", "singRIGHT-alt":
            cameraXOffset = cameraMoveStrength;
        default:
    }

    cameraYOffset = lerp(cameraYOffset, 0, 0.3);
    cameraXOffset = lerp(cameraXOffset, 0, 0.3);
    
    boyfriend.y = lerp(boyfriend.y, targetBoyfriendY, myLerp); 
    camera.scroll.y = lerp(camera.scroll.y, targetCameraY + cameraYOffset, myLerp);
    camera.scroll.x = lerp(camera.scroll.x, 250 + cameraXOffset, myLerp);
    
    if (barData.fear == 1) health = -10;
    if (barData.fear > 1) barData.fear = 1;
}

function updateLerp(lerp:Float){
    myLerp = lerp;
    camGameZoomLerp = myLerp;
    trace("Updated Lerp: " + myLerp + " camGameZoomLerp: " + camGameZoomLerp);
}


// camera intense things
function stepHit(curStep:Int) {
    switch (curStep) {
        case 60:
            FlxTween.tween(camera, {zoom: 0.85}, 2, {ease: FlxEase.quadOut});
        case 256:
            dontZoomYet = false;
        case 511:
            updateLerp(0.05);
        case 767:
            updateLerp(0.06);
        case 1023:
            updateLerp(0.065);
        case 1279:
            updateLerp(0.01);
            tailsPerspective = false;
            defaultCamZoom = 0.65;
        case 1311:
            updateLerp(0.065);
        case 1312:
            tailsPerspective = true;
        case 2127:
            updateLerp(0.05);
            defaultCamZoom = 1.15;
        case 2134:
            updateLerp(0.04);
            targetBoyfriendY = 510;
            defaultCamZoom = 1.25;
        case 2141:
            updateLerp(0.03);
            defaultCamZoom = 1;
        case 2144:
            tailsPerspective = false;
            defaultCamZoom = 0.65;
    }
}

// blahblahlbaljbadafsdfmvsof
function onNoteHit(_){
    if(dontZoomYet) _. enableCamZooming = false;
    else _.enableCamZooming = true;
}

function onDadHit(event:NoteHitEvent){
    if (barData.fear <= 1) barData.fear += 0.0016;
}

function onPlayerHit(event:NoteHitEvent){
    if (barData.fear <= 1) barData.fear -= 0.0026;
}

function onPlayerMiss(event:NoteMissEvent){
    if (barData.fear <= 1) barData.fear += 0.0026;
}

// copypasted from og code LOL
function beatHit(curBeat:Int) {
    if (curBeat >= 346 && curBeat < 536) {
        if (health >= 0.08 && barData.fear <= 1) {
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