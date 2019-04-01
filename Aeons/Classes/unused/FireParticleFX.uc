//=============================================================================
// FireParticleFX.  
//=============================================================================
class FireParticleFX expands AeonsParticleFX;

function ZoneChange(ZoneInfo NewZone)
{
	if (NewZone.bWaterZone)
		bShuttingDown = true;
}

defaultproperties
{
     ParticlesPerSec=(Base=64)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     bSteadyState=True
     Speed=(Base=0,Rand=50)
     Lifetime=(Base=0.25,Rand=1)
     ColorStart=(Base=(G=187,B=45))
     AlphaStart=(Base=0.25,Rand=0.75)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=0,Rand=8)
     SpinRate=(Base=-8,Rand=16)
     DripTime=(Rand=0.25)
     Damping=1
     WindModifier=1
     GravityModifier=-0.02
     Textures(0)=Texture'Aeons.Particles.PotFire07'
     LightEffect=LE_FireWaver
     LightBrightness=179
     LightHue=28
     LightSaturation=64
     LightRadius=18
     LightCone=60
}
