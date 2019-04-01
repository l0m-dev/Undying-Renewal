//=============================================================================
// SmokeSignal.
//=============================================================================
class SmokeSignal expands Effects;

function Trigger(Actor Other, Pawn Instigator)
{
	Spawn(class 'SmokeSignalFX',,,Location,Rotation);
}

defaultproperties
{
     bHidden=True
     bDirectional=True
     DrawType=DT_Sprite
}
