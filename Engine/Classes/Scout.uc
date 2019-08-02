//=============================================================================
// Scout used for path generation.
//=============================================================================
class Scout extends Pawn
	native;

function PreBeginPlay()
{
	Destroy(); //scouts shouldn't exist during play
}

defaultproperties
{
     AccelRate=1
     SightRadius=4100
     CollisionRadius=52
     CollisionHeight=50
     bCollideActors=False
     bCollideWorld=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
}
