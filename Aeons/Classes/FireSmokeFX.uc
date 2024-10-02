//=============================================================================
// FireSmokeFX.
//=============================================================================
class FireSmokeFX expands AeonsParticleFX;

function ZoneChange(ZoneInfo NewZone)
{
	if (NewZone.bWaterZone)
		Shutdown();
}

defaultproperties
{
     ParticlesPerSec=(Base=24,Rand=12)
     SourceWidth=(Base=32)
     SourceHeight=(Base=32)
     SourceDepth=(Base=32)
     bSteadyState=True
     Speed=(Base=0)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=96,G=96,B=96),Rand=(R=73,G=73,B=73))
     ColorEnd=(Base=(R=0))
     AlphaStart=(Base=0.5,Rand=0.25)
     SizeWidth=(Base=64)
     SizeLength=(Base=64)
     SizeEndScale=(Base=4,Rand=4)
     SpinRate=(Base=-4,Rand=8)
     AlphaDelay=0.25
     Chaos=16
     Elasticity=0.45
     Damping=2.5
     WindModifier=1
     Gravity=(Z=300)
     Textures(0)=Texture'Aeons.Particles.Smoke32_00'
     LODBias=5
     Style=STY_AlphaBlend
     bDrawBehindOwner=True
}
