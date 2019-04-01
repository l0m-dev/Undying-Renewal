//=============================================================================
// SPDiffuseEffector.
//=============================================================================
class SPDiffuseEffector expands SPEffector;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************

var color					DesiredColor;		//
var color					DeltaColor;			//
var float					FadeTimer;			//
var float					FadeRate;			//


//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Handle per-frame tick.
function Tick( float DeltaTime )
{
	local ScriptedPawn	spOwner;
	local color			spColor;

	super.Tick( DeltaTime );

	spOwner = ScriptedPawn(Owner);
	if ( ( FadeTimer > 0.0 ) && ( spOwner != none ) )
	{
		FadeTimer -= DeltaTime;
		if ( FadeTimer <= 0.0 )
		{
			FadeTimer = 0.0;
			spColor = DesiredColor;
		}
		else
		{
			spColor.R = Adjust( spOwner.Lighting[0].Diffuse.R, DesiredColor.R, DeltaColor.R * FadeRate * DeltaTime );
			spColor.G = Adjust( spOwner.Lighting[0].Diffuse.G, DesiredColor.G, DeltaColor.G * FadeRate * DeltaTime );
			spColor.B = Adjust( spOwner.Lighting[0].Diffuse.B, DesiredColor.B, DeltaColor.B * FadeRate * DeltaTime );
			spColor.A = Adjust( spOwner.Lighting[0].Diffuse.A, DesiredColor.A, DeltaColor.A * FadeRate * DeltaTime );
		}
		spOwner.Lighting[0].Diffuse = spColor;
		spOwner.Lighting[0].SpecularHilite = spColor;
		spOwner.Lighting[0].TextureMask = -1;
	}
}


//****************************************************************************
// New member funcs.
//****************************************************************************
//
function SetFade( color DColor, float Time )
{
	local ScriptedPawn	spOwner;

	spOwner = ScriptedPawn(Owner);

	if ( spOwner != none )
	{
		if ( Time <= 0.0 )
		{
			spOwner.Lighting[0].Diffuse = DColor;
			spOwner.Lighting[0].SpecularHilite = DColor;
			spOwner.Lighting[0].TextureMask = -1;
		}
		else
		{
			DesiredColor = DColor;
			DeltaColor.R = Abs(DColor.R - spOwner.Lighting[0].Diffuse.R);
			DeltaColor.G = Abs(DColor.G - spOwner.Lighting[0].Diffuse.G);
			DeltaColor.B = Abs(DColor.B - spOwner.Lighting[0].Diffuse.B);
			DeltaColor.A = Abs(DColor.A - spOwner.Lighting[0].Diffuse.A);
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
