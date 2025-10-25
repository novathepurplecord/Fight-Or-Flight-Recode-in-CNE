import openfl.display.BlendMode;

var fireShader:CustomShader = new CustomShader("fire");
var fireShaderHud:CustomShader = new CustomShader("anotherfire");

var enableShader:Bool = false;
var enableShaderHud:Bool = false;

var fireHud:FlxSprite;

function create() {
    fireHud = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    fireHud.camera = camHUD;
}

function stepHit(curStep:Int) {
    if (curSong == "fight or flight") {
        switch (curStep) {
            case 1184:
                enableShader = true;
                black.alpha = 0.9;
                fire.alpha = sonic.alpha = 1;
                bg.alpha = 0;
            case 1472:
                black.alpha = 1;
                fireHud.alpha = 0.2;
                enableShaderHud = true;
            case 1728:
                black.alpha = fire.alpha = fireHud.alpha = 0;
                enableShaderHud = false;
                enableShader = false;
        }
    } else if (curSong == "fight or flight halloween"){
        switch (curStep) {
            case 1312:
                enableShader = true;
                fire.alpha = sonic.alpha = 1;
                bg.alpha = 0;
            case 1600:
                fireHud.alpha = 0.2;
                enableShaderHud = true;
            case 1728:
                enableShaderHud = false;
                enableShader = false;
                fire.alpha = fireHud.alpha = 0;
        }
    }
}

function postCreate() {

    black.alpha = fire.alpha = fireHud.alpha = 0;

    fire.shader = fireShader;
    fire.blend = BlendMode.ADD;

    fireHud.shader = fireShaderHud;
    fireHud.blend = BlendMode.MULTIPLY;
    add(fireHud);
}

function postUpdate() {
    if (enableShader) fireShader.iTime = Conductor.songPosition / 1000;
    if (enableShaderHud) fireShaderHud.iTime = Conductor.songPosition / 1000;
}
