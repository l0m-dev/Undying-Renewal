//=============================================================================
// SpearTrailFX.  
//=============================================================================
class SpearTrailFX expands ParticleTrailFX;

defaultproperties
{
     ParticlesPerSec=(Base=32)
     SourceWidth=(Base=0)
     SourceHeight=(Base=0)
     AngularSpreadWidth=(Base=0)
     AngularSpreadHeight=(Base=0)
     Lifetime=(Base=0.5)
     ColorStart=(Base=(R=194,G=224,B=218))
     AlphaStart=(Base=0.5)
     SizeWidth=(Base=1)
     SizeLength=(Base=1)
     SizeEndScale=(Base=8)
     Textures(0)=Texture'Aeons.Particles.SoftShaft01'
     RemoteRole=ROLE_None
     LODBias=5
     CollisionRadius=1024
     CollisionHeight=1024
}
