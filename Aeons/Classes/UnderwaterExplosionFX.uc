//=============================================================================
// UnderwaterExplosionFX. 
//=============================================================================
class UnderwaterExplosionFX expands ExplosionFX;

/*
auto state Exploding
{
	Begin:
		sleep(1.0);
		Attraction = vect(0,0,0);
		Speed.base = 0;
		GravityModifier = -0.15;
		Damping = 5;
		sleep(0.5);
		gotoState('Rising');
}

state Rising
{

	Begin:
		// Damping = 0;

}
*/

defaultproperties
{
     ParticlesPerSec=(Base=2048)
     SourceWidth=(Base=16)
     SourceHeight=(Base=128)
     SourceDepth=(Base=16)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=0,Rand=300)
     Lifetime=(Base=0.5,Rand=0.5)
     ColorStart=(Base=(R=144,G=144,B=144))
     ColorEnd=(Base=(G=255,B=255))
     AlphaStart=(Base=0,Rand=1)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2)
     Attraction=(X=10,Y=10,Z=10)
     GravityModifier=-0.15
     ParticlesMax=128
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
}
