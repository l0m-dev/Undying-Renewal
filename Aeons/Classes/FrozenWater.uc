//=============================================================================
// FrozenWater.
//=============================================================================
class FrozenWater expands Effects;

//#exec MESH IMPORT MESH=FrozenWater_m SKELFILE=FrozenWater.ngf


function PreBeginPlay()
{
	setTimer(5,false);
	PlaySound(EffectSound1);
	super.PreBeginPlay();
}

function Timer()
{
	gotoState('Thaw');
}

state Thaw
{
	function Timer()
	{
		Opacity -= 0.1;
		if ( Opacity <= 0 )
			Destroy();
	}

	Begin:
		setTimer(0.5, true);
}

function Shatter()
{
	// spawn particle system
	Destroy();
}

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	Shatter();
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.FrozenWater_m'
     DrawScale=1.5
     CollisionRadius=32
     CollisionHeight=8
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
