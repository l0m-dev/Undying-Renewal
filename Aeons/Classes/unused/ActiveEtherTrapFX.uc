//=============================================================================
// ActiveEtherTrapFX.
//=============================================================================
class ActiveEtherTrapFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=64,Rand=32)
     SourceWidth=(Base=64)
     SourceHeight=(Base=8)
     SourceDepth=(Base=64)
     AngularSpreadWidth=(Base=15)
     AngularSpreadHeight=(Base=15)
     Speed=(Base=100,Rand=200)
     Lifetime=(Base=0.5,Rand=0.25)
     ColorStart=(Base=(R=112,G=255))
     ColorEnd=(Base=(R=0,G=198,B=255),Rand=(R=78,G=78,B=78))
     AlphaEnd=(Base=0.25,Rand=0.25)
     SizeWidth=(Base=16)
     SizeLength=(Base=16)
     SizeEndScale=(Rand=2)
     SpinRate=(Base=-4,Rand=8)
     AlphaDelay=0.5
     Chaos=2
     Attraction=(X=5,Y=5,Z=15)
     Gravity=(Z=-100)
     Textures(0)=Texture'Aeons.Particles.Star1_pfx'
     LODBias=3
     LightType=LT_Steady
     LightEffect=LE_WateryShimmer
     LightBrightness=204
     LightHue=145
     LightSaturation=71
     LightRadius=16
}
