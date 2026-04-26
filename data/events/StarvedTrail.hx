// Starved red trail leleodoakffm
import flixel.addons.effects.FlxTrail;

var trail:FlxTrail;

function postCreate() insert(members.indexOf(dad) - 1, trail = new FlxTrail(dad, null, 4, 24, 0.4, 0.069)).visible = false;

function onEvent(e) {
   	if (e.event.name != "StarvedTrail") return;
	trail.visible = e.event.params[0];
	trail.target = getCurStarved();
}

// Change Character support
// function onChangeCharacter(oldChar:Character, newChar:Character, strumIndex:Int, memberIndex:Int) if (strumIndex == 0) trail.target = newChar;