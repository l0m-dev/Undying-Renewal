//=============================================================================
// Phoenix_Camera.
//=============================================================================
class Phoenix_Camera expands SpellProjectile;

/*
var 	Phoenix_proj	Bird;
var 	Phoenix 		PhoenixSpell;

// Special actor that the player's camera uses to see through the phoenix bird projectile by the Phoenix

function PreBeginPlay()
{
	//log("-----------CAMERA PreBeginPlay() Location: "$Location);
	if (Bird != none)
		setBase(Bird);
	//setTimer(0.25,true);
	Super.PreBeginPlay();
}

/*
function Timer()
{
	log("");
	log("-------------Location: "$Location);
	log("-------------State: "$GetStateName());
	log("-------------Owner ViewTarget: "$PlayerPawn(Owner).ViewTarget);
	log("-------------Base: "$Base);
	log("");
}
*/
auto state Flying
{

	simulated function Tick(float deltaTime)
	{
		if (Owner != none)
		{
			setRotation(Pawn(Owner).ViewRotation);
			setLocation(Bird.Location);
		} else {
			gotoState('ShutDownRightNow');
		}
	}

	Begin:
}

state watchBird
{

	Begin:
		setPhysics(PHYS_Projectile);
		Velocity += vect(0,0,32);
}

state ShutDown
{
	simulated function Tick(float deltaTime)
	{
		Velocity *= 0.7;
	}

	Begin:
		sleep(2);
		PhoenixSpell.bActivePhoenix = false;
		PhoenixSpell.gotoState('Finishing');
		PlayerPawn(Owner).ViewTarget = None;
		AeonsPlayer(Owner).bDrawCrosshair = true;
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		PlayerPawn(Owner).ViewSelf();
		Destroy();
}

state ShutDownRightNow
{
	Begin:
		PhoenixSpell.bActivePhoenix = false;
		PhoenixSpell.gotoState('Finishing');
		PlayerPawn(Owner).ViewTarget = None;
		AeonsPlayer(Owner).bDrawCrosshair = true;
		PlayerPawn(Owner).desiredFOV = PlayerPawn(Owner).defaultFOV;
		PlayerPawn(Owner).ViewSelf();
		Destroy();
}

*/

defaultproperties
{
     Physics=PHYS_None
     LifeSpan=0
     DrawType=DT_Sprite
     bCollideActors=False
     bCollideWorld=False
}
