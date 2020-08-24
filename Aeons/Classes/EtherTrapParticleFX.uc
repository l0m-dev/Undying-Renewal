//=============================================================================
// EtherTrapParticleFX.
//=============================================================================
class EtherTrapParticleFX expands GlowFX;

defaultproperties
{
     ParticlesPerSec=(Base=320)
     SourceWidth=(Base=16)
     SourceHeight=(Base=16)
     SourceDepth=(Base=16)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=0)
     Speed=(Base=160)
     Lifetime=(Base=1.5)
     ColorStart=(Base=(R=255,G=0,B=0))
     ColorEnd=(Base=(R=128,G=0,B=0),Rand=(G=0,B=0))
     AlphaStart=(Base=1)
     SizeWidth=(Base=0,Rand=16)
     SizeLength=(Base=0)
     SizeEndScale=(Rand=3)
     SpinRate=(Base=0,Rand=0)
     AlphaDelay=0.75
     Chaos=0
     Damping=0.4
     Gravity=(Z=384)
     Textures(0)=Texture'Aeons.Particles.EctoFX02'
     RenderPrimitive=PPRIM_Line
     Tag=DoorCrackGlowFX
}
