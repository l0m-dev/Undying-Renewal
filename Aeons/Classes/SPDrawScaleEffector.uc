//=============================================================================
// SPDrawScaleEffector.
//=============================================================================
class SPDrawScaleEffector expands SPEffector;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var float					DesiredDrawScale;		//
var float					DeltaDrawScale;		//
var float					FadeTimer;			//
var float					FadeRate;			//


//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Handle per-frame tick.
function Tick( float DeltaTime )
{
	local ScriptedPawn	spOwner;
	local float			spDrawScale;

	super.Tick( DeltaTime );

	spOwner = ScriptedPawn(Owner);
	if ( ( FadeTimer > 0.0 ) && ( spOwner != none ) )
	{
		FadeTimer -= DeltaTime;
		if ( FadeTimer <= 0.0 )
		{
			FadeTimer = 0.0;
			spDrawScale = DesiredDrawScale;
		}
		else
		{
			spDrawScale = Adjust( spOwner.DrawScale, DesiredDrawScale, DeltaDrawScale * FadeRate * DeltaTime );
		}
		spOwner.SetDrawScale( spDrawScale );
	}
}


//****************************************************************************
// New member funcs.
//****************************************************************************
//
function SetFade( float DDrawScale, float Time )
{
	local ScriptedPawn	spOwner;

	spOwner = ScriptedPawn(Owner);

	if ( spOwner != none )
	{
		if ( Time <= 0.0 )
		{
			spOwner.SetDrawScale( DDrawScale );
		}
		else
		{
			DesiredDrawScale = DDrawScale;
			DeltaDrawScale = Abs(DDrawScale - spOwner.DrawScale);
			FadeRate = 1.0 / Time;
			FadeTimer = Time;
		}
	}
}

//
function float Adjust( float Start, float Target, float Delta )
{
	if ( Start < Target )
	{
		return FMin(Start + Delta, Target);
	}
	else
	{
		return FMax(Start - Delta, Target);
	}
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
}
