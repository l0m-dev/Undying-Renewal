//=============================================================================
// FireTrigger.
//=============================================================================
class FireTrigger expands Trigger;

var() int DamagePerSec;
var() int DamageThreshold;
var float Totaldamage[8];
var float DamageInc;
var float DamageTimer;
var Actor LastTouchList[8];

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	DInfo.Damage = 1.0;
	DInfo.DamageType = 'Fire';
	DInfo.DamageMultiplier = 1.0;
	return DInfo;	
}

function PreBeginPlay()
{
	Super.PreBeginPlay();
	setRotation(Rot(0,0,0));
	DamageTimer = 1.0 / DamagePerSec;
	SetTimer(DamageTimer, true);
}

// Check the touch list against
function Timer()
{
	local int i;
	local DamageInfo DInfo;

	DInfo = GetDamageInfo();

	for ( i=0; i<8; i++ )
	{
		if (Touching[i] != none)
		{
			// log("FireTrigger is touching "$Touching[i].name, 'Misc');
			if (Touching[i].AcceptDamage(DInfo) )
			{
				Touching[i].TakeDamage( Pawn(Owner), Location, vect(0,0,0), DInfo);
			}
		}
	}
}

// first entry into the fire.... just take some damage
function Touch(Actor Other)
{
	local DamageInfo DInfo;
	
	if (!bInitiallyActive)
		return;

	DInfo = GetDamageInfo();
	if ( Other.AcceptDamage(DInfo) )
		Other.TakeDamage( Instigator, Location, vect(0,0,0), GetDamageInfo());
}

// Leaving the fire, take what damage we have accumated and apply it.
function UnTouch(Actor Other)
{
	local int i, idx;
	local DamageInfo DInfo;
	
	if (!bInitiallyActive)
		return;

	DInfo = GetDamageInfo();
	
	for (i=0; i<8; i++)
	{
		if (LastTouchList[i] == Other)
		{
			if ( Other.AcceptDamage(DInfo) )
			{
				DInfo.Damage = TotalDamage[i] + 0.5;
				Other.TakeDamage(Pawn(Owner), Location, vect(0,0,0), DInfo);
				TotalDamage[i] = 0;
			}
			
		}
	}
}

defaultproperties
{
     DamagePerSec=2
     DamageThreshold=5
     ReTriggerDelay=0.5
     bCollideWorld=True
}
