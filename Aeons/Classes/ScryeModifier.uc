//=============================================================================
// ScryeModifier.
//=============================================================================
class ScryeModifier expands PlayerModifier;

var float str;
var vector Col;
var travel ScryeLight MyScryeLight;
var ScriptedPawn P;
var name EndEvent;
var() sound ActiveLoopSound;
var() sound EndSound;
var int ScryeSoundId;
var ScryeHintTrigger SHT;
var travel bool bGlowOn;

function Timer();

function TravelPostAccept()
{
	if( bActive )
		GotoState( 'Activated', 'AlreadyActive' );
	else {
		PlayerPawn(Owner).ScryeTimer = 0;
		GotoState( 'Idle' );
		AmbientSound = None;
	}
}

state Activated
{
	function BeginState()
	{
		ForEach AllActors(class 'ScriptedPawn', P)
		{
			// log ("Considering "$P.name$" to turn on glow", 'Misc');
			if ( P.bScryeGlow )
			{
				// log (""$P.name$" turning on glow", 'Misc');
				if (CastingLevel > 2)
					P.ScryeGlow.bShowHealth = true;
				else
					P.ScryeGlow.bShowHealth = false;
				P.ScryeGlow.GotoState('Activated');
				bGlowOn = true;
			}
		}
	}

	function Timer()
	{
		ForEach AllActors(class 'ScriptedPawn', P)
		{
			if ( P.bScryeGlow )
			{
				if (CastingLevel > 2)
					P.ScryeGlow.bShowHealth = true;
				else
					P.ScryeGlow.bShowHealth = false;
				P.ScryeGlow.GotoState('Activated');
				bGlowOn = true;
			}
		}
	}

	function Tick(float DeltaTime)
	{
		if (Owner == None)
			return;
		
		PlayerPawn(Owner).ScryeTimer -= DeltaTime;
		
		if ((PlayerPawn(Owner).GetStatename() == 'PlayerCutscene') || (PlayerPawn(Owner).GetStatename() == 'DialogScene') || (PlayerPawn(Owner).GetStatename() == 'SpecialKill'))
		{
			if (bGlowOn)
			{
				gotoState('Deactivated');
			}
		} else {
			if ( !bGlowOn )
			{
				ForEach AllActors(class 'ScriptedPawn', P)
				{
					if ( P.bScryeGlow )
					{
						P.ScryeGlow.bHidden = false;
					}
				}
				bGlowOn = true;
				AmbientSound = ActiveLoopSound;
			}
		}


		if (PlayerPawn(Owner).Health <= 0)
			PlayerPawn(Owner).ScryeTimer = 0;

		if ( PlayerPawn(Owner).ScryeTimer < 0.2f )
		{
			// PlayerPawn(Owner).ScryeTimer = 0.0f;
			gotoState('Deactivated');
		}
	}

	Begin:
		ForEach Owner.TouchingActors(class 'ScryeHintTrigger', SHT)
			SHT.bEventSeen = true;

		if ( !bActive )
		{
			SetBase(Owner, 'root', 'root');
			AmbientSound = ActiveLoopSound;		
		}

		col = vect(233,196,255);	// hud change color
		str = 0.5;					// HUD change strength
		PlayerPawn(Owner).ClientAdjustGlow( str, col );
		sleep(0.1);
		PlayerPawn(Owner).ClientAdjustGlow( -str, -col );
		sleep(0.05);
		str = 0.1;					// HUD change strength
		PlayerPawn(Owner).ClientAdjustGlow( str, col );
		if ( PlayerPawn(Owner).ScryeTimer < PlayerPawn(Owner).ScryeFullTime )
			PlayerPawn(Owner).ScryeTimer = PlayerPawn(Owner).ScryeFullTime;
		sleep(0.1);
		PlayerPawn(Owner).ClientAdjustGlow( -str, -col );
		
		
		setTimer(0.25, true);
		if ( !bActive )
		{
			MyScryeLight = spawn (class 'scryeSpellLight',Owner,,Location);
			MyScryeLight.setBase(Owner, 'pelvis', 'root');
		}
		AeonsPlayer(Owner).bScryeActive = true;
		bActive = true;
		stop;

	AlreadyActive:
		MyScryeLight = spawn (class 'scryeSpellLight',Owner,,Location);
		MyScryeLight.setBase(Owner, 'pelvis', 'root');
		AeonsPlayer(Owner).bScryeActive = true;
		setTimer(0.25, true);
		AmbientSound = ActiveLoopSound;	
}

//----------------------------------------------------------------------------

function CallEndEvent()
{
	local Actor A;

	if (EndEvent != 'none')
	{
		ForEach AllActors(class 'Actor', A, EndEvent)
		{
			if ( A.IsA('Trigger') )
			{
				// handle Pass Thru message
				if ( Trigger(A).bPassThru )
				{
					Trigger(A).PassThru(Owner);
				}
			}
			A.Trigger(Owner, Pawn(Owner));
		}
		EndEvent = 'none';
	}
}

//----------------------------------------------------------------------------

state Deactivated
{

	function BeginState()
	{
		ForEach AllActors(class 'ScriptedPawn', P)
		{
			P.ScryeGlow.GotoState('Deactivated');
		}
		bGlowOn = false;
	}

	Begin:
		if (Owner == None)
			stop;

		col = vect(233,196,255);	// hud change color
		AeonsPlayer(Owner).bScryeActive = false;

		SetBase(None);
		AmbientSound = None;

		str = 0.1;					// HUD change strength
		PlayerPawn(Owner).ClientAdjustGlow( str, col );
		sleep(0.1);
		PlayerPawn(Owner).ClientAdjustGlow( -str, -col );
		str = 0.5;					// HUD change strength
		sleep(0.1);
		PlayerPawn(Owner).ClientAdjustGlow( str, col );
		sleep(0.2);
		PlayerPawn(Owner).ClientAdjustGlow( -str, -col );
		PlayerPawn(Owner).ScryeTimer = 0.0f;

		if (MyScryeLight != none)
			MyScryeLight.Destroy();

		bActive = false;
		PlayerPawn(Owner).ScryeTimer = 0.0f;
		CallEndEvent();
}

defaultproperties
{
     EndEvent=EndScrye
     ActiveLoopSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ScryeLoop01'
     EndSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ScryeEnd01'
	 SoundRadius=255
     SoundVolume=96
}
