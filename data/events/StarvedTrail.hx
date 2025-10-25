// Starved red trail leleodoakffm
import flixel.addons.effects.FlxTrail;

var trail:FlxTrail;

function postCreate() {
	trail = new FlxTrail(dad, null, 4, 24, 0.4, 0.069);
	trail.visible = false;
	PlayState.instance.insert(PlayState.instance.members.indexOf(dad) - 1, trail);
}

function onEvent(e:EventGameEvent){
   if (e.event.name == "StarvedTrail") {
		if (e.event.params[0] == true) {
			trail.visible = true;
		} else {
			trail.visible = false;
		}
   }
}

// Change Character support
function onChangeCharacter(oldChar:Character, newChar:Character, strumIndex:Int, memberIndex:Int) {
    if (strumIndex == 0) {
        trail.target = newChar;
    }
}
