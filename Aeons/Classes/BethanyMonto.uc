class BethanyMonto expands Monto;

var(AICombat) float DrainRate;

function bool AcknowledgeDamageFrom( pawn Instigator )
{
	DebugInfoMessage( ".AcknowledgeDamageFrom() Instigator is a " $ Instigator.class.name );
	if( Instigator.IsA( 'Bethany' ) ||
		Instigator.IsA( 'Handmaiden' ) ||
		Instigator.IsA( 'BethanyFlickeringStalker' ) ||
		Instigator.IsA( 'BethanyMonto' ) )
	{
		DebugInfoMessage(".AcknowledgeDamageFrom() Ignoring damage.");
		return false;
	}
	else
		super.AcknowledgeDamageFrom( Instigator );
}

function ReactToDamage( pawn Instigator, DamageInfo DInfo )
{
	if( Instigator.IsA( 'Bethany' ) ||
		Instigator.IsA( 'Handmaiden' ) ||
		Instigator.IsA( 'BethanyFlickeringStalker' ) ||
		Instigator.IsA( 'BethanyMonto' ) )
		return;
	else
		super.ReactToDamage( Instigator, DInfo );	
}

function TookDamage( actor Other )
{
	if( Other.IsA( 'Bethany' ) ||
		Other.IsA( 'Handmaiden' ) ||
		Other.IsA( 'BethanyFlickeringStalker' ) ||
		Other.IsA( 'BethanyMonto' ) )
		return;
	else
		super.TookDamage( Other );
}

function Tick( float DeltaTime )
{
	local DamageInfo DInfo;

	super.Tick(DeltaTime);
	
	Health -= DeltaTime * DrainRate;
	if( Health <= 0.0 )
	{
		Died( none, '', Location, DInfo );
	}
}

state Dying
{
	function bool CanBeInvoked()
	{
		return false;
	}
}

defaultproperties
{
     DrainRate=2
     Health=200
}
