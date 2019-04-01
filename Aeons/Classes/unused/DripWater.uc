//=============================================================================
// DripWater. 
//=============================================================================
class DripWater expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=1.9)
     SourceWidth=(Base=512)
     SourceHeight=(Base=512)
     bSteadyState=True
     Speed=(Base=1)
     Lifetime=(Base=4)
     ColorStart=(Base=(G=255))
     ColorEnd=(Base=(G=255,B=255))
     DripTime=(Base=1)
     GravityModifier=0.5
     SoundRadius=32
     SoundPitch=40
}
