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
                fire.alpha = 1;
                bg.alpha = 0;
                sonic.alpha = 1; 
            case 1472:
                black.alpha = 1;
                fireHud.alpha = 0.2;
                enableShaderHud = true;
            case 1728:
                black.alpha = 0;
                enableShaderHud = false;
                enableShader = false;
                fire.alpha = 0;
                fireHud.alpha = 0;
        }
    } else if (curSong == "fight or flight halloween"){
        switch (curStep) {
            case 1312:
                enableShader = true;
                fire.alpha = 1;
                bg.alpha = 0;
                sonic.alpha = 1; 
            case 1600:
                fireHud.alpha = 0.2;
                enableShaderHud = true;
            case 1728:
                enableShaderHud = false;
                enableShader = false;
                fire.alpha = 0;
                fireHud.alpha = 0;
        }
    }
}

function postCreate() {
    black.alpha = 0;

    fire.alpha = 0;
    fire.shader = fireShader;
    fire.blend = BlendMode.ADD;

    fireHud.alpha = 0;
    fireHud.shader = fireShaderHud;
    fireHud.blend = BlendMode.MULTIPLY;
    add(fireHud);
}

function postUpdate(elapsed:Float) {
    if (enableShader) fireShader.iTime = Conductor.songPosition / 1000;
    if (enableShaderHud) fireShaderHud.iTime = Conductor.songPosition / 1000;
}
