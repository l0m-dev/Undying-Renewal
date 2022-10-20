//=============================================================================
// HasteModifier.
//=============================================================================
class HasteModifier expands PlayerModifier;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var travel bool 	bHUDEffect;		// HUD can be activated?
var travel float 	str;			// strength of HUD Effect
var travel vector 	col;			// color of HUD effect
var float 	dmt;			// Default Mana Refresh rate
var HasteTrailFX ht;		// Haste Trail
var travel float	speedMultiplier;
var travel float sMult[6];
var travel float RefireMult[6];
var int sID;
var() sound ActiveLoopSound;
var() sound EffectEndSound;
var travel float TimeLeft;

//----------------------------------------------------------------------------

function PreBeginPlay()
{
	Super.PreBeginPlay();

	col = vect(1,1,1) * 100;	// hud change color
	str = 0.05;					// HUD change strength
	bHUDEffect = true;
	speedMultiplier = 1.0;
	
	sMult[0] = 1.5;
	sMult[1] = 1.5;
	sMult[2] = 1.75;
	sMult[3] = 2.0;
	sMult[4] = 2.0;
	sMult[5] = 2.5;

	RefireMult[0] = 1.0;
	RefireMult[1] = 0.85;
	RefireMult[2] = 0.75;
	RefireMult[3] = 0.65;
	RefireMult[4] = 0.5;
	RefireMult[5] = 0.5;
}

//----------------------------------------------------------------------------
   
state Activated
{
	function Timer()
	{
		gotoState('Deactivated');
	}

	function BeginState()
	{
		if (Owner == none)
			Destroy();
		SetBase(Owner, 'root', 'root');
		AmbientSound = ActiveLoopSound;		
		log("HasteModifier "$self.name$" Owner == "$Owner.name$" IsPlayer = "$AeonsPlayer(Owner).bIsPlayer, 'Misc');
	}

	function Tick(float DeltaTime)
	{
		if (Owner == none)
			Destroy();
		TimeLeft -= DeltaTime;
	}
	
	function EndState()
	{
		SetBase(None);
		AmbientSound = None;
		Owner.PlaySound(EffectEndSound);
	}

	Begin:
		bActive = true;
		AeonsPlayer(Owner).bHasteActive = true;
		//if (ActiveLoopSound != none)
			//sID = Owner.PlaySound(ActiveLoopSound);

		if ( bHUDEffect )
		{
			PlayerPawn(Owner).ClientAdjustGlow( str, col );
			bHUDEffect = false;
		}

		//km fix this to work directly on the player modifier....
		dmt = Pawn(Owner).default.ManaRefreshTime;

		if ( ht == none )
			ht = spawn(class 'HasteTrailFX',self);

		ht.setBase(Owner, 'root', 'root');

		if ( (CastingLevel >= 0) && (CastingLevel <= 5) )
		{
			AeonsPlayer(Owner).Haste ( sMult[CastingLevel] );
			speedMultiplier = sMult[CastingLevel];
			AeonsPlayer(Owner).refireMultiplier = RefireMult[CastingLevel];
			SoundModifier(AeonsPlayer(Owner).SoundMod).adjVolume(sMult[CastingLevel]);

			// The player gets a faster mana refresh rate above amplitude 3 ( Casting Level 2 internally )
			if ( CastingLevel >= 2 )
			{
				ManaModifier(AeonsPlayer(Owner).ManaMod).fHaste = 1.2;		// refresh mana faster
				ManaModifier(AeonsPlayer(Owner).ManaMod).updateManaTimer();
			} else {
				// no extra mana refresh
				ManaModifier(AeonsPlayer(Owner).ManaMod).fHaste = 1.0;
				ManaModifier(AeonsPlayer(Owner).ManaMod).updateManaTimer();
			}
		
		} else {
			gotoState('Deactivated');	// bail out
		}
		
//		sID = playSound(EffectSound);
		setTimer(10, false);
		TimeLeft = 10;
		stop;

	AlreadyActive:
		if (Owner == none)
			Destroy();
		if ( ht == none )
			ht = spawn(class 'HasteTrailFX',self);
		ht.setBase(Owner, 'root', 'root');
		SetTimer(TimeLeft, false);
		col = vect(1,1,1) * 100;	// hud change color
		str = 0.05;					// HUD change strength
		PlayerPawn(Owner).ClientAdjustGlow( str, col );
		bHUDEffect = false;
		AeonsPlayer(Owner).bHasteActive = true;
}

function TravelPreAccept()
{
	if ( Owner != none )
	{
		if (Owner.IsA('AeonsPlayer'))
		{
			AeonsPlayer(Owner).HasteMod = self;
		} else {
			Destroy();
		}
	} else {
		Destroy();
	}
}

function TravelPostAccept()
{
	if( bActive )
		GotoState( 'Activated', 'AlreadyActive' );
	else
		GotoState( 'Idle' );
}

//----------------------------------------------------------------------------

state Deactivated
{
	Begin:
		AeonsPlayer(Owner).bHasteActive = false;
		//rb doesn't appear this mod is even using the player's ambient sound and so we could be shutting off another ambientsound
		//Owner.AmbientSound = none;
		//stopSound(sID);
		
		//PlaySound(EffectEndSound);
		ht.bShuttingDown = true;
		
		bActive = false;
		if ( !bHUDEffect )
			PlayerPawn(Owner).ClientAdjustGlow( -str, -col );
		
		// reset to defaults
		speedMultiplier = 1.0;
		AeonsPlayer(Owner).Haste(1.0);
		ManaModifier(AeonsPlayer(Owner).ManaMod).fHaste = 1.0;
		ManaModifier(AeonsPlayer(Owner).ManaMod).updateManaTimer();
		AeonsPlayer(Owner).refireMultiplier = 1.0;
		AeonsWeapon(AeonsPlayer(Owner).Weapon).RefireMult = 1.0;
		SoundModifier(AeonsPlayer(Owner).SoundMod).adjVolume(1.0 / sMult[CastingLevel]);

		bHUDEffect = true;
		gotoState('Idle');
}

//----------------------------------------------------------------------------

auto state Idle
{

	Begin:

}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     ActiveLoopSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_Haste01'
     EffectEndSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_HasteEnd01'
     SoundRadius=255
     SoundVolume=96
}
