class MinigunMutator extends Mutator
	transient;

event PreBeginPlay()
{
	DefaultWeapon = class'Minigun';
	Level.Game.DefaultWeapon = DefaultWeapon;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	bSuperRelevant = 0;

	if (Level.NetMode != NM_Standalone)
		return True;

	if (Other.IsA('Revolver'))
	{
		ReplaceWith(Other, string(class'Minigun'));
		return False;
	}
	else if (Other.IsA('BulletAmmo') && MinigunAmmo(Other) == None)
	{
		ReplaceWith(Other, string(class'MinigunAmmo'));
		return False;
	}

	return True;
}

defaultproperties
{
     
}
