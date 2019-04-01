//=============================================================================
// EctoplasmDrip_particles. 
//=============================================================================
class EctoplasmDrip_particles expands SpellParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=64)
     SourceWidth=(Base=8)
     SourceHeight=(Base=1)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=0,Rand=25)
     Lifetime=(Base=0.25,Rand=0.35)
     ColorStart=(Base=(G=255,B=255))
     ColorEnd=(Base=(R=4,G=83,B=179))
     SizeWidth=(Base=0.5,Rand=0.25)
     SizeLength=(Base=0.5,Rand=0.25)
     SizeEndScale=(Base=0.25,Rand=1)
     bSystemRelative=True
     Attraction=(X=20,Y=20,Z=20)
     Textures(0)=Texture'Aeons.Particles.EctoFX03'
     RemoteRole=ROLE_None
     LightType=LT_Steady
     LightBrightness=255
     LightHue=153
     LightSaturation=77
     LightRadius=16
}
