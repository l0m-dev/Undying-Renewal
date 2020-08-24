//=============================================================================
// MindshatterExplosionFX. 
//=============================================================================
class MindshatterExplosionFX expands ExplosionFX;

//#exec Texture Import Name=Pinwheel_pfx File=Pinwheel_pfx.pcx Group=Particles Mips=OFF

function PreBeginPlay()
{
	setTimer(0.75,false);
}


function Timer()
{
	Damping = 10;
}

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=1000)
     Lifetime=(Base=0.85)
     ColorStart=(Base=(R=163,G=33,B=36))
     ColorEnd=(Base=(R=107,B=166))
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2)
     SpinRate=(Base=-6,Rand=12)
     Attraction=(X=20,Y=20,Z=20)
     ParticlesMax=128
     Textures(0)=Texture'Aeons.Particles.Flare'
     LODBias=5
}
