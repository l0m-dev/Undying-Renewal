//=============================================================================
// SlothModifier.
//=============================================================================
class SlothModifier expands PlayerModifier;

var() float					EffectDuration;
var() float					SpeedScalar;
var() float					RefireScalar;
var float					speedMultiplier;

function int Dispel( optional bool bCheck )
{
	if ( bCheck )
		return CastingLevel;
	else
		GotoState( 'Deactivated' );
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	speedMultiplier = 1.0;
}

function Activate()
{
	GotoState( 'Activated' );
}

state Activated
{
	function Timer()
	{
		GotoState( 'Deactivated' );
	}

	function Activate()
	{
		SetTimer( EffectDuration, false );
	}

Begin:
	bActive = true;
	AeonsPlayer(Owner).bSlothActive = true;
	AeonsPlayer(Owner).Haste ( SpeedScalar );
	AeonsPlayer(Owner).refireMultiplier = 1.0/RefireScalar;
	speedMultiplier = SpeedScalar;

	SetTimer( EffectDuration, false );
}

state Deactivated
{
Begin:
	bActive = false;
	AeonsPlayer(Owner).bSlothActive = false;
	AeonsPlayer(Owner).Haste( 1.0 );
	AeonsPlayer(Owner).refireMultiplier = 1.0;
	speedMultiplier = 1.0;

	GotoState( 'Idle' );
}

auto state Idle
{
	Begin:
}

defaultproperties
{
     EffectDuration=5
     SpeedScalar=0.5
     RefireScalar=0.5
     RemoteRole=ROLE_None
}
