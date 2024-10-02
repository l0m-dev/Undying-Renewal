//=============================================================================
// MindshatterTrigger.
//=============================================================================
class MindshatterTrigger expands MagicalTrigger;

function Touch( actor Other )
{
	local actor A;
	
	if ( Other != Instigator ) // should not be the player
		if ( Other.IsA('AeonsPlayer'))
		{
			if ( AeonsPlayer(Other).MindshatterMod.isInState('Activated') )
			{
				AeonsPlayer(Other).MindshatterMod.gotoState('Deactivated');
				if (Level.NetMode == NM_Client)
					MindshatterModifier(AeonsPlayer(Other).MindshatterMod).ClientDeactivated();
			}
			else
			{
				AeonsPlayer(Other).MindshatterMod.gotoState('Activated');
				if (Level.NetMode == NM_Client)
					MindshatterModifier(AeonsPlayer(Other).MindshatterMod).ClientActivated(2);
			}
		}
}

defaultproperties
{
}
