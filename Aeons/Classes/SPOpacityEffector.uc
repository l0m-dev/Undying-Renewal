//=============================================================================
// SPOpacityEffector.
//=============================================================================
class SPOpacityEffector expands SPEffector;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var float					DesiredOpacity;		//
var float					DeltaOpacity;		//
var float					FadeTimer;			//
var float					FadeRate;			//
var float					FlickerRate;		//


//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function Tick( float DeltaTime )
{
	local ScriptedPawn	spOwner;

	super.Tick( DeltaTime );

	spOwner = ScriptedPawn(Owner);
	if ( ( FadeTimer > 0.0 ) && ( spOwner != none ) )
	{
		FadeTimer -= DeltaTime;
		if ( FadeTimer <= 0.0 )
		{
			FadeTimer = 0.0;
			Opacity = DesiredOpacity;
		}
		else
		{
			Adjust( DesiredOpacity, DeltaOpacity * FadeRate * DeltaTime );
//			if ( FRand() < FlickerRate )
//				FadeTimer += Flicker( DesiredOpacity, DeltaOpacity * FadeRate * DeltaTime );
		}
		spOwner.SetOpacity( Opacity );
	}
}

//****************************************************************************
// New member funcs.
//****************************************************************************
function SetFade( float DOpacity, float Time )
{
	local ScriptedPawn	spOwner;

	spOwner = ScriptedPawn(Owner);

	if ( spOwner != none )
	{
		if ( Time <= 0.0 )
		{
			Opacity = DOpacity;
			spOwner.SetOpacity( Opacity );
			FadeTimer = 0.0;
		}
		else
		{
			Opacity = spOwner.Opacity;
			DesiredOpacity = DOpacity;
			DeltaOpacity = Abs(DOpacity - Opacity);
			FadeRate = 1.0 / Time;
			FadeTimer = Time;
		}
	}
}

//
function Adjust( float Target, float Delta )
{
	if ( Opacity < Target )
		Opacity = FMin(Opacity + Delta, Target);
	else
		Opacity = FMax(Opacity - Delta, Target);
}

//
function float Flicker( float Target, float Delta )
{
	local float		Flick;

	if ( Opacity < Target )
	{
		Flick = FMin(Opacity, 0.40) * 0.50;
		Opacity -= Flick;
	}
	else
	{
		Flick = FMin(1.0 - Opacity, 0.40) * 0.50;
		Opacity += Flick;
	}
	return ( Flick / Delta );
}

//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
}
