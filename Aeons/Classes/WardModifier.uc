//=============================================================================
// WardModifier.
//=============================================================================
class WardModifier expands PlayerModifier;

var AeonsPlayer Player;
var int ScytheMaint;
var int TotalMaint;
var int Maint;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Player = AeonsPlayer(Owner);
	SetTimer(0.1,true);
}

function Timer()
{
	/*
	if ( AeonsPlayer(Owner).Weapon.IsA('Scythe') )
	{
		if ( Scythe(AeonsPlayer(Owner).Weapon).bBerserk )
			ScytheMaint = 10;
		else
			ScytheMaint = 5;
	} else {
		ScytheMaint = 0;
	}
	if ( Maint != (TotalMaint + ScytheMaint) )
	{
		Maint = (TotalMaint + ScytheMaint);
		ManaModifier(Player.ManaMod).manaMaint = (TotalMaint + ScytheMaint);
		ManaModifier(Player.ManaMod).updateManaTimer();
	}
	*/
}

function AddWard(optional int n)
{
	local int cost;
	
	if (n == 0)
		cost = 2;
	else	
		cost = n;

	if ( (Player != none) && (Player.ManaMod != none) )
	{
		TotalMaint += cost;
	}
}

function RemoveWard(optional int n)
{
	local int cost;
	
	if (n == 0)
		cost = 2;
	else	
		cost = n;
	
	if ( (Player != none) && (Player.ManaMod != none) )
	{
		TotalMaint -= cost;
	}
}

defaultproperties
{
     RemoteRole=ROLE_None
}
