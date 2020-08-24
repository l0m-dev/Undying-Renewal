//=============================================================================
// SoCIce_particles. 
//=============================================================================
class SoCIce_particles expands SpellParticleFX
	transient;

defaultproperties
{
     ParticlesPerSec=(Base=32,Rand=32)
     SourceWidth=(Base=32)
     SourceHeight=(Base=32)
     SourceDepth=(Base=32)
     AngularSpreadWidth=(Base=360)
     AngularSpreadHeight=(Base=360)
     Speed=(Base=0,Rand=20)
     ColorStart=(Base=(R=162,G=130,B=255))
     ColorEnd=(Base=(G=255,B=255))
     AlphaEnd=(Base=1)
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Base=0.25)
     SpinRate=(Base=-2,Rand=4)
     Attraction=(X=0.5,Y=0.5,Z=0.5)
     Gravity=(Z=-350)
     Textures(0)=Texture'Aeons.Particles.Star5_pfx'
}
