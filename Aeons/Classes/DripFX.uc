//=============================================================================
// DripFX.
//=============================================================================
class DripFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=0.25)
     SourceWidth=(Base=4)
     SourceHeight=(Base=0)
     SourceDepth=(Base=4)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     bSteadyState=True
     Speed=(Base=0)
     Lifetime=(Base=2)
     ColorStart=(Base=(R=0,G=0,B=128),Rand=(B=64))
     ColorEnd=(Base=(R=0,B=128),Rand=(B=160))
     AlphaStart=(Base=0.5,Rand=0.5)
     AlphaEnd=(Rand=0.25)
     SizeWidth=(Base=3)
     SizeLength=(Base=0.5)
     SizeEndScale=(Base=2)
     DripTime=(Base=0.25)
     AlphaDelay=0.5
     Elasticity=0.01
     GravityModifier=1
     Textures(0)=Texture'Aeons.Blood'
     RenderPrimitive=PPRIM_Liquid
     Style=STY_AlphaBlend
}
