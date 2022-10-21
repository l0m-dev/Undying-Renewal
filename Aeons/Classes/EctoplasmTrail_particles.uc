//=============================================================================
// EctoplasmTrail_particles. 
//=============================================================================
class EctoplasmTrail_particles expands SpellParticleFX transient;

defaultproperties
{
     ParticlesPerSec=(Base=180)
     SourceWidth=(Base=4)
     SourceHeight=(Base=4)
     AngularSpreadWidth=(Base=0)
     AngularSpreadHeight=(Base=0)
     Speed=(Base=32)
     Lifetime=(Base=0.2,Rand=0.2)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(R=0,B=128))
     SizeWidth=(Base=16)
     SizeEndScale=(Base=0)
     AlphaDelay=1
     Textures(0)=Texture'fxB.Spells.ecto2B'
     RenderPrimitive=PPRIM_Liquid
     bTrailerSameRotation=False
     Physics=PHYS_Trailer
     RemoteRole=ROLE_None
     LifeSpan=2
}
