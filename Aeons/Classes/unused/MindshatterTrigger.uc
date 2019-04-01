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
				AeonsPlayer(Other).MindshatterMod.gotoState('Deactivated');
			else
				AeonsPlayer(Other).MindshatterMod.gotoState('Activated');
		}
}

defaultproperties
{
}
