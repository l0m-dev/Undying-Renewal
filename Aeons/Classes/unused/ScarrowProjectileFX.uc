//=============================================================================
// ScarrowProjectileFX.
//=============================================================================
class ScarrowProjectileFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=80)
     SourceWidth=(Base=18)
     SourceHeight=(Base=18)
     Lifetime=(Base=0.65)
     ColorStart=(Base=(R=102,G=109,B=58))
     ColorEnd=(Base=(R=54,G=74,B=45))
     SizeWidth=(Base=40)
     SizeLength=(Base=40)
     Chaos=1
     Attraction=(X=50,Y=50)
     Textures(0)=Texture'Aeons.Particles.Smoke32_01'
     Style=STY_AlphaBlend
}
