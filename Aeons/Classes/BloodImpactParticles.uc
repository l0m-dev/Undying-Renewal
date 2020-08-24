//=============================================================================
// BloodImpactParticles. 
//=============================================================================
class BloodImpactParticles expands ParticleFX;

//#exec Texture Import Name=Blood File=Blood.bmp Mips=Off Flags=2

defaultproperties
{
     ParticlesPerSec=(Base=4096)
     SourceWidth=(Base=5)
     SourceHeight=(Base=5)
     SourceDepth=(Base=5)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=60,Rand=50)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=192,G=0,B=0))
     ColorEnd=(Base=(R=128))
     AlphaStart=(Base=0.5,Rand=0.25)
     SizeWidth=(Base=1.5,Rand=0.5)
     SizeLength=(Base=0.3)
     GravityModifier=0.3
     ParticlesMax=40
     Textures(0)=Texture'Aeons.Blood'
     RenderPrimitive=PPRIM_Liquid
     Style=STY_AlphaBlend
}
