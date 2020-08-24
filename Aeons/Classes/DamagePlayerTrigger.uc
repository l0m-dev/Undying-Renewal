//=============================================================================
// DamagePlayerTrigger.
//=============================================================================
class DamagePlayerTrigger expands Trigger;

var() float DamagePerSec;
var() name MyDamageType;
var() localized string MyDamageString;

function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if (DamageType == 'none')
		DamageType = MyDamageType;

	DInfo.Damage = 1;
	DInfo.DamageType = DamageType;
	DInfo.DamageString = MyDamageString;
	DInfo.DamageMultiplier = 1.0;

	return DInfo;

}

//=============================================================================
// Trigger states.

// Trigger is always active.
state() NormalTrigger
{
}

// Other trigger toggles this trigger's activity.
state() OtherTriggerToggles
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		bInitiallyActive = !bInitiallyActive;
		if ( bInitiallyActive )
			CheckTouchList();
	}
}

// Other trigger turns this on.
state() OtherTriggerTurnsOn
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		local bool bWasActive;

		bWasActive = bInitiallyActive;
		bInitiallyActive = true;
		if ( !bWasActive )
			CheckTouchList();
	}
}

// Other trigger turns this off.
state() OtherTriggerTurnsOff
{
	function Trigger( actor Other, pawn EventInstigator )
	{
		bInitiallyActive = false;
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1.0 / DamagePerSec, true);
}

function Timer()
{
	CheckTouchList();
}

function Touch(Actor Other)
{
	if ( bInitiallyActive )
	{
		if ( Other.IsA('AeonsPlayer') )
		{
			AeonsPlayer(Other).TakeDamage( none, Location, vect(0,0,0), GetDamageInfo(MyDamageType));
		}
	}
}

defaultproperties
{
     DamagePerSec=10
}
