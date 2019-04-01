//=============================================================================
// OldPotDust.
//=============================================================================
class OldPotDust expands DustFX;

defaultproperties
{
     bInitiallyOn=False
     ParticlesPerSec=(Base=256)
     SourceWidth=(Base=16)
     SourceHeight=(Base=96)
     SourceDepth=(Base=16)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=128)
     Lifetime=(Base=1.25)
     ColorEnd=(Base=(R=102,G=51,B=0),Rand=(R=102,G=0,B=0))
     Chaos=8
     Damping=0
     GravityModifier=0.05
     ParticlesAlive=48
     Tag=potdust
     CollisionRadius=40
     CollisionHeight=40
}
