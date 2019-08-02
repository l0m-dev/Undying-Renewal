//=============================================================================
// Effects, the base class of all gratuitous special effects.
//=============================================================================
class Effects extends Visible;

var() sound 	EffectSound1;
var() sound 	EffectSound2;
var() bool bOnlyTriggerable;

defaultproperties
{
     bNetTemporary=True
     DrawType=DT_None
     bGameRelevant=True
     CollisionRadius=0
     CollisionHeight=0
}
