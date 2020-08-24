//=============================================================================
// BloodParticles. 
//=============================================================================
class BloodParticles expands ParticleFX;

//#exec Texture Import Name=Blood File=Blood.bmp Mips=Off Flags=2

defaultproperties
{
     ParticlesPerSec=(Base=64,Max=128)
     SourceWidth=(Base=5)
     SourceHeight=(Base=5)
     SourceDepth=(Base=5)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=20,Rand=30)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=128,G=0,B=0),Max=(R=128))
     ColorEnd=(Base=(R=128),Max=(R=128))
     AlphaStart=(Base=0.5,Rand=0.25)
     AlphaEnd=(Base=0.15,Rand=0.15)
     SizeWidth=(Base=1,Rand=1)
     SizeLength=(Base=0.3,Max=0.3)
     SizeEndScale=(Base=4,Rand=4)
     GravityModifier=0.4
     Textures(0)=Texture'Aeons.Blood'
     RenderPrimitive=PPRIM_Liquid
     Style=STY_AlphaBlend
}
