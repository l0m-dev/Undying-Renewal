//=============================================================================
// ManaModifier.
//=============================================================================
class ManaModifier expands PlayerModifier;

var savable travel int manaPerSec;		// mana per sec refresh rate
var savable travel int manaMaint;		// Maintenance per sec
var float timerLen;
var bool bNegMana;				// mana refresh amount is negative.
var travel float fHaste;				// modification by the haste modifier
var AeonsPlayer Player;
var int ScytheMaint;
var float f;

function int Dispel(optional bool bCheck)
{
	return -1;
}

// hacked timer
function Tick(float DeltaTime)
{
	f += DeltaTime;

	if ( f >= 0.2 )
	{
		if ( Owner != None && AeonsPlayer(Owner).Weapon.IsA('Scythe') )
		{
			if ( Scythe(AeonsPlayer(Owner).Weapon).bBerserk )
			{
				if (ScytheMaint != 10)
				{
					ScytheMaint = 10;
					UpdateManaTimer();
				}
			} else {
				if (ScytheMaint != 5)
				{
					ScytheMaint = 5;
					UpdateManaTimer();
				}
			}
		} else {
			if (ScytheMaint != 0)
			{
				ScytheMaint = 0;
				UpdateManaTimer();
			}
		}
		f = 0;
	}
}

function Timer()
{
	if ( Owner != None )
	{
		if ( Pawn(Owner).Health > 0 )
		{
			if ( Pawn(Owner).Mana <= Pawn(Owner).ManaCapacity ) {
				SetTimer(timerLen, true);
				if ( !bNegMana )
					Pawn(Owner).AddMana(1, false);
				else
					Pawn(Owner).UseMana(1);
			} else {
				SetTimer(1, true);
				Pawn(Owner).useMana(1);
			}
		}
	} else {
		Destroy();
	}
}

function updateManaTimer()
{
	manaPerSec = clamp(manaPerSec, 0, 10);
	if ( (manaPerSec * fHaste) < (ManaMaint + ScytheMaint) )
	{
		timerLen = 1.0 / ((ManaMaint + ScytheMaint) - (manaPerSec * fHaste));
		bNegMana = true;
	} else {
		timerLen = 1.0 / ((manaPerSec * fHaste) - (ManaMaint + ScytheMaint));
		bNegMana = false;
	}
	setTimer(timerLen, true);
}

function BeginPlay()
{
	bNegMana = false;
	timerLen = 1.0 / ((manaPerSec * fHaste) - (manaMaint + ScytheMaint));
	SetTimer(timerLen, true);
}

defaultproperties
{
     manaPerSec=5
     fHaste=1
     RemoteRole=ROLE_None
}
