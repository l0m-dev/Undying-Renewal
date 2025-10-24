//=============================================================================
// SlimeModifier.
//=============================================================================
class SlimeModifier expands PlayerModifier;

var() float					EffectDuration;
var float					EffectIntensity;


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
	EffectIntensity = 1.0;
	AeonsPlayer(Owner).bSlimeActive = true;

	SetTimer( EffectDuration, false );
}

state Deactivated
{
	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		EffectIntensity -= ( DeltaTime * 0.75 );
		if ( EffectIntensity <= 0 )
		{
			EffectIntensity = 0.0;
			bActive = false;
			AeonsPlayer(Owner).bSlimeActive = false;
			GotoState( 'Idle' );
		}
	}

Begin:
}

auto state Idle
{
Begin:
}

defaultproperties
{
     EffectDuration=5
     RemoteRole=ROLE_None
}
