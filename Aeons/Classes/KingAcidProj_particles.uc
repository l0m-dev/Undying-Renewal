//=============================================================================
// KingAcidProj_particles. 
//=============================================================================
class KingAcidProj_particles expands SpellParticleFX;

function initSystem()
{
	ColorStart.Base = AmpColors[castingLevel];
}

defaultproperties
{
     AmpColors(0)=(R=78,G=45,B=7)
     AmpColors(1)=(R=156,G=85,B=14)
     AmpColors(2)=(R=234,G=128,B=21)
     AmpColors(3)=(R=241,G=170,B=99)
     AmpColors(4)=(R=248,G=213,B=177)
     ParticlesPerSec=(Base=48)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Base=0)
     ColorStart=(Base=(G=126))
     ColorEnd=(Base=(R=244,G=122))
     SizeWidth=(Base=24)
     SizeLength=(Base=24)
     SizeEndScale=(Base=4,Rand=2)
     SpinRate=(Base=1,Rand=2)
     GravityModifier=-0.02
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
}
