//=============================================================================
// FireDripFX.
//=============================================================================
class FireDripFX expands FireFX;

defaultproperties
{
     DynamicLifetime=5
     ParticlesPerSec=(Base=16,Rand=16)
     SourceWidth=(Base=8)
     SourceHeight=(Base=8)
     SourceDepth=(Base=8)
     Lifetime=(Rand=0.25)
     SizeWidth=(Base=8)
     SizeLength=(Base=8)
     Damping=0.1
     LODBias=5
     CollisionRadius=100
     CollisionHeight=100
}
