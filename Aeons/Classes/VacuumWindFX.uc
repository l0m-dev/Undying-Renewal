//=============================================================================
// VacuumWindFX.
//=============================================================================
class VacuumWindFX expands WindFX;

defaultproperties
{
     bInitiallyOn=False
     ParticlesPerSec=(Base=192)
     SourceWidth=(Base=640)
     SourceHeight=(Base=512)
     SourceDepth=(Base=512)
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Lifetime=(Base=0.5)
     AlphaStart=(Base=0.5,Rand=0.5)
     SizeEndScale=(Rand=1)
     AlphaDelay=0
     Chaos=0
     ChaosDelay=0
     bWindPerParticle=True
     RenderPrimitive=PPRIM_Liquid
     InitialState=TriggerTurnsOn
     Tag=VacuumWindFX
}
