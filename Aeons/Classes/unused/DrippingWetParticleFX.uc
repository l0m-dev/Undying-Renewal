//=============================================================================
// DrippingWetParticleFX. 
//=============================================================================
class DrippingWetParticleFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=4,Rand=2)
     AngularSpreadWidth=(Base=90)
     AngularSpreadHeight=(Base=90)
     bSteadyState=True
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=132,G=125,B=255))
     ColorEnd=(Base=(G=255,B=255))
     SizeWidth=(Base=4)
     SizeLength=(Base=1,Rand=0.25)
     Elasticity=0.1
     Gravity=(Z=-950)
     Textures(0)=Texture'Aeons.Particles.Bubble'
     RenderPrimitive=PPRIM_Liquid
}
