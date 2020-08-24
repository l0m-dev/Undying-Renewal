//=============================================================================
// SigilHitFX. 
//=============================================================================
class SigilHitFX expands HitFX;

/*
function PreBeginPlay()
{
	super.PreBeginPlay();
	
}
auto state Expanding
{
	function Timer()
	{
		gotoState('Contracting');
	}

	Begin:
		setTimer(0.75, false);
}


state Contracting
{

	Begin:
		Elasticity = 2;
}

*/

defaultproperties
{
     ParticlesPerSec=(Base=1024)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Lifetime=(Base=2)
     ColorStart=(Base=(R=118,G=254,B=121))
     ColorEnd=(Base=(R=0,G=140,B=7))
     SizeWidth=(Base=24)
     SizeLength=(Base=24)
     SizeEndScale=(Base=6)
     Attraction=(X=2,Y=2,Z=2)
     ParticlesMax=24
     Textures(0)=Texture'Aeons.Particles.Flare'
}
