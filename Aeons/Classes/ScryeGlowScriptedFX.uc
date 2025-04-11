//=============================================================================
// ScryeGlowScriptedFX.
//=============================================================================
class ScryeGlowScriptedFX expands GlowScriptedFX;

var() color Healthy;
var() color Wounded;
var() color HeavilyWounded;
var() color NormalColor;

var color col;
var bool bShowHealth;
var bool bActive;

replication
{
	unreliable if (Role == ROLE_Authority)
		bShowHealth, bActive;
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	
	if ( (ScriptedPawn(Owner) == none) || !ScriptedPawn(Owner).bScryeGlow )
		Destroy();

	SetLocation(Owner.Location);
	SetBase(Owner);
	SetTimer(1, true);
}

simulated function color DeriveColor()
{
	local color c, blk;
	local float pct, RelativeHealth;
	
	if (bShowHealth)
	{
		blk.r = 0;
		blk.g = 0;
		blk.b = 0;

		if (Owner.IsA('ScriptedPawn'))
			RelativeHealth = Pawn(Owner).Health / ScriptedPawn(Owner).InitHealth;
		else
			RelativeHealth = Pawn(Owner).Health / Pawn(Owner).default.Health;
		
		// RelativeHealth should be clamped to 0 but it kinda looks cool so leave it for now
		
		if (RelativeHealth > 0.65)
			c = (Healthy * ((RelativeHealth - 0.65) / 0.35)) + ( Wounded * abs(((RelativeHealth - 0.65) / 0.35)-1) );
		else if (RelativeHealth > 0.35)
			c = (Wounded * ((RelativeHealth - 0.35) / 0.65)) + ( HeavilyWounded * abs(((RelativeHealth - 0.35) / 0.65)-1) );
		else 
			c = (HeavilyWounded * (RelativeHealth)) + ( blk * abs(RelativeHealth - 1) );
	} else {
		c = NormalColor;
	}

	return c;
}

function Timer()
{
	if (Pawn(Owner) == none)
		Destroy();
}


simulated function UpdateParticles()
{
	local int i;

	if (Pawn(Owner) == none)
	{
		Destroy();
		return;
	}
	
	col = DeriveColor();

	if ( NumJoints > 0 && (!Owner.IsA('Rat')) )
	{
		for (i=0; i<NumJoints; i++)
		{
			GetParticleParams(i,Params);
			Params.Position = Owner.JointPlace(JointNames[i]).pos;
			Params.Color = col;
			Params.Alpha = default.AlphaStart.Base * Owner.Opacity;
			SetParticleParams(i, Params);
		}
	} else {
		GetParticleParams(1,Params);
		Params.Position = Owner.Location;
		Params.Color = col;
		Params.Alpha = default.AlphaStart.Base * Owner.Opacity;
		SetParticleParams(1, Params);
	}
}

state Activated
{
	function BeginState()
	{
		if ( !ScriptedPawn(Owner).bScryeGlow )
		{
			Destroy();
			// GotoState('Deactivated');
		}
		else
		{
			bActive = true;
			UpdateParticles();
		}
	}

	simulated function Tick(float DeltaTime)
	{
		UpdateParticles();
		if (Level.NetMode == NM_Client && !bActive)
			GotoState('Deactivated');
	}
}

auto state Deactivated
{
	function BeginState()
	{
		bActive = false;
	}
	simulated function Tick(float DeltaTime)
	{
		if (Level.NetMode == NM_Client && bActive)
			GotoState('Activated');
	}
}

defaultproperties
{
     Healthy=(R=63,G=255,B=15)
     Wounded=(R=250,G=255,B=23)
     HeavilyWounded=(R=255,G=15,B=15)
     NormalColor=(R=115,G=47,B=240)
     AlphaStart=(Base=0.1)
     AlphaEnd=(Base=0.1)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     bTimedTick=True
     MinTickTime=0.05
     bScryeOnly=True
     RemoteRole=ROLE_None
}
