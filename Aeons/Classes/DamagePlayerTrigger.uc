//=============================================================================
// DamagePlayerTrigger.
//=============================================================================
class DamagePlayerTrigger expands Trigger;

var() float DamagePerSec;
var() name MyDamageType;
var() localized string MyDamageString;
var() float DamageMultiplier;

function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if (DamageType == 'none')
		DamageType = MyDamageType;

	DInfo.Damage = 1;
	DInfo.DamageType = DamageType;
	DInfo.DamageString = MyDamageString;
	DInfo.DamageMultiplier = DamageMultiplier;

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

	// limit this for now because Undying has some really high DamagePerSec numbers
	// this was framerate dependent on framerates lower than DamagePerSec
	DamagePerSec = FMin(DamagePerSec, 60.0);

	TimeSinceTick = 0.0;
	MinTickTime = 1.0 / DamagePerSec;
}

// simulate bTimedTick, but fixed
// this is already fixed in EngineRenewal, and we could just use bTimedTick
// keep this for a little while
function Tick( float DeltaTime )
{
	TimeSinceTick += DeltaTime;

	if( TimeSinceTick >= MinTickTime )
	{
		DamageMultiplier = default.DamageMultiplier * (TimeSinceTick / MinTickTime);
		CheckTouchList();

		TimeSinceTick = 0.0;
	}
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
     DamageMultiplier=1.0
}
