import openfl.display.BlendMode;

var fireShader:CustomShader = new CustomShader("fire");
var fireShaderHud:CustomShader = new CustomShader("anotherfire");

var fireHud:FlxSprite;

function postCreate() {
    add(fireHud = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK)).camera = camHUD;
    black.alpha = fire.alpha = fireHud.alpha = 0;

    fire.blend = BlendMode.ADD;
    fireHud.blend = BlendMode.MULTIPLY;
}

function stepHit(_:Int) {
    switch (PlayState.SONG.meta.name) {
        case "Fight or Flight":
            switch (_) {
                case 1184:
                    fire.alpha = sonic.alpha = 1;
                    fire.shader = fireShader;
                    black.alpha = 0.9;
                    bg.kill();
                case 1472:
                    fireHud.shader = fireShaderHud;
                    fireHud.alpha = 0.2;
                    black.alpha = 1;
                case 1728:
                    black.alpha = fire.alpha = fireHud.alpha = 0;
            }
        case "Fight or Flight HW":
            switch (_) {
                case 1312:
                    fire.alpha = sonic.alpha = 1;
                    fire.shader = fireShader;
                    black.alpha = 0.9;
                    bg.kill();
                case 1600:
                    fireHud.shader = fireShaderHud;
                    fireHud.alpha = 0.2;
                    black.alpha = 1;
                case 1856:
                    black.alpha = fire.alpha = fireHud.alpha = 0;
            }
    }
}

function postUpdate() {
    fireShader.iTime = Conductor.songPosition * 0.001;
    fireShaderHud.iTime = Conductor.songPosition * 0.001;
}
