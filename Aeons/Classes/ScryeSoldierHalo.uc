//=============================================================================
// ScryeSoldierHalo.
//=============================================================================
class ScryeSoldierHalo expands GlowScriptedFX;

var() color GlowColor;

simulated function PreBeginPlay()
{
	super.PreBeginPlay();

	if ( Owner == none )
	{
		Destroy();
		return;
	}

	SetLocation( Owner.Location );
	SetBase( Owner );
}

simulated function Tick( float DeltaTime )
{
	local int	i;

	if ( pawn(Owner) == none )
	{
		Destroy();
		return;
	}

	if ( ( NumJoints > 0 ) && !Owner.IsA('Rat') )
	{
		for ( i=0; i<NumJoints; i++ )
		{
			GetParticleParams( i, Params );
			Params.Position = Owner.JointPlace(JointNames[i]).pos;
			Params.Color = GlowColor;
			Params.Alpha = default.AlphaStart.Base * Owner.Opacity;
			SetParticleParams( i, Params );
		}
	}
	else
	{
		GetParticleParams( 1, Params );
		Params.Position = Owner.Location;
		Params.Color = GlowColor;
		Params.Alpha = default.AlphaStart.Base * Owner.Opacity;
		SetParticleParams( 1, Params );
	}
}

defaultproperties
{
     GlowColor=(R=63,G=63,B=127)
     AlphaStart=(Base=0.1)
     AlphaEnd=(Base=0.1)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     bTimedTick=True
     MinTickTime=0.05
}
