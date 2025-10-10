//=============================================================================
// ScriptedFX. 
//=============================================================================
class ScriptedFX expands ParticleFX;

#exec OBJ LOAD FILE=..\Textures\fxB.utx PACKAGE=fxB
#exec OBJ LOAD FILE=..\Textures\Lightning.utx PACKAGE=Lightning

//#exec Texture Import Name=Lightning File=Lightning.pcx Group=Particles Mips=Off
//#exec Texture Import Name=Shaft File=Shaft.pcx Group=Particles Mips=Off

var ParticleParams Params;

defaultproperties
{
     ParticlesPerSec=(Base=0)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=0)
     AngularSpreadHeight=(Base=0)
     Speed=(Base=0)
     Lifetime=(Base=0)
     ColorStart=(Base=(R=128,B=128))
     ColorEnd=(Base=(R=128,G=128,B=128))
     AlphaEnd=(Base=1)
     Textures(0)=Texture'Aeons.Particles.Shaft'
     RenderPrimitive=PPRIM_Line
}
