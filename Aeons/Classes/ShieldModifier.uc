//=============================================================================
// ShieldModifier.
//=============================================================================
class ShieldModifier expands PlayerModifier;

#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var travel bool 	bHUDEffect;
var travel int		ShieldHealth, NumCracks, CrackID[8];
var float 	str, initialStr, CrackStr[8], InitialCrackStr[8];
var vector 	col, adjLoc, CrackLocations[8];
var travel float OverlayStr;

var Shield3rdPerson shieldMesh;
var travel AeonsPlayer Player;
var int i;

/*----------------------------------------------------------------------------
	Replication
----------------------------------------------------------------------------*/
replication
{
	// Variables the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner)
		OverlayStr;
}

//----------------------------------------------------------------------------

function PreBeginPlay()
{
	Super.PreBeginPlay();

	if (Owner.IsA('AeonsPlayer'))
		Player = AeonsPlayer(Owner);
	
	col = vect(0.5,0.5,1) * 200;	// hud change color
	str = 0.05;					// HUD change strength
}

//----------------------------------------------------------------------------

function AddCrack(float Str)
{
	local int i;
	local vector Loc;
	
	for (i=0; i<8; i++)
	{
		if (CrackStr[i] <= 0.25)
		{
			CrackStr[i] = Str;
			InitialCrackStr[i] = Str;
			Loc.x = RandRange(0.15,0.65);
			Loc.y = RandRange(0.15,0.65);
			CrackLocations[i] = Loc;
			CrackID[i] = rand(3);
			break;
		}
	}
}

//----------------------------------------------------------------------------

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	local int iDamage;
	local DamageInfo NewDInfo;

	if (bActive)
		if (shieldHealth <= DInfo.Damage)
		{
			NewDInfo.Damage = (DInfo.Damage - shieldHealth);
			// log("Shield taking damage: "$Damage);
			// log("Shield passing on damage to the player: "$iDamage);
			Owner.PlaySound(EffectSound);
			shieldHealth = 0;
			if ( Owner.AcceptDamage(NewDInfo) )
				AeonsPlayer(Owner).TakeDamage(EventInstigator, HitLocation, Momentum, NewDInfo);
			OverlayStr = 0;
			gotoState('Deactivated');
		} else {
			// log("Shield taking damage: "$Damage);
			AddCrack(1.0);
			shieldHealth -= DInfo.Damage;
			OverlayStr = shieldHealth * 0.01;
			Owner.PlaySound(EffectSound);
		}
}

function TravelPostAccept()
{
	if( bActive )
	{
		if( shieldHealth > 0 )
			GotoState( 'Activated', 'AlreadyActive' );
		else
			GotoState('Deactivated');
	}
	else
		GotoState( 'Idle' );
}
//----------------------------------------------------------------------------

state Activated
{
	function Timer()
	{
		shieldHealth -= 1.0;

		OverlayStr = shieldHealth * 0.01;
		if ((shieldHealth <= 0) || ( AeonsPlayer(owner).mana <= 5 ))
			gotoState('Deactivated');
	}

	function Tick(float DeltaTime)
	{
		local int i;

		for (i=0; i<8; i++)
		{
			CrackStr[i] -= (deltaTime/10.0);
			CrackStr[i] = FClamp(CrackStr[i], 0, InitialCrackStr[i]);
		}
	}

	Begin:
		log("Shield Activated:Begin Label", 'Misc');
		if( !bActive )
		{
			if (Player != none)
				Player.bShieldActive = true;

			bActive = true;

			Disable('Tick');
			if ( !bHUDEffect )
			{
				ManaModifier(AeonsPlayer(Owner).ManaMod).manaMaint += 2;
				ManaModifier(AeonsPlayer(Owner).ManaMod).updateManaTimer();
				Owner.PlaySound(ActivateSound);
				// PlayerPawn(Owner).ClientAdjustGlow( str, col );
				bHUDEffect = true;
			}
		}
		else
		{
			if (Player != none)
				Player.bShieldActive = true;

			if( !bHUDEffect )
			{
				Owner.PlaySound(ActivateSound);
				bHudEffect = true;
			}				
		}

		if( shieldMesh == none )
			shieldMesh = spawn(class 'Shield3rdPerson',Pawn(Owner),,Owner.Location + (Vector(PlayerPawn(Owner).ViewRotation) * 16), PlayerPawn(Owner).ViewRotation );

		if ( castingLevel == 0 ) {
			shieldHealth = 15;
			OverlayStr = 0.15;
		} else if ( castingLevel == 1 ) {
			shieldHealth = 25;
			OverlayStr = 0.3;
		} else if ( castingLevel == 2 ) {
			shieldHealth = 35;
			OverlayStr = 0.45;
		} else if ( castingLevel == 3 ) {
			shieldHealth = 45;
			OverlayStr = 0.6;
		} else if ( castingLevel == 4 ) {
			shieldHealth = 55;
			OverlayStr = 1.0;
		} else if ( castingLevel == 5 ) {
			shieldHealth = 65;
			OverlayStr = 1.0;
		} else {
			log("CastingLevel is invalid!!!");
			gotoState('Deactivated');	// bail out
		}
		// Reset Cracks
		NumCracks = 0;
		for (i=0; i<8; i++)
			CrackStr[i] = 0;

		Enable('Tick');
		SetTimer(1.0, true);
		Stop;

	AlreadyActive:
		adjLoc = Pawn(Owner).location;
		adjLoc.z -= 48;
		OverlayStr = shieldHealth * 0.01;
		setTimer(1.0, true);
		Enable('Tick');
}

//----------------------------------------------------------------------------

state Deactivated
{
	function resetCracks()
	{
		local int i;
		
		for (i=0; i<8; i++)
			CrackStr[i] = 0;
	}

	Begin:
		if (Player != none)
			Player.bShieldActive = false;

		bActive = false;
		if ( bHUDEffect )
		{
			ManaModifier(AeonsPlayer(Owner).ManaMod).manaMaint -= 2;
			ManaModifier(AeonsPlayer(Owner).ManaMod).updateManaTimer();

			// create shield breaking effect
			if ( (AeonsPlayer(Owner).GetStateName() != 'PlayerCutscene') && (AeonsPlayer(Owner).GetStateName() != 'DialogScene') && (AeonsPlayer(Owner).GetStateName() != 'SpecialKill') )
			{
				Owner.PlaySound(DeactivateSound);
				spawn(class'ShieldHitFX',,,Owner.Location+vect(0,0,50),PlayerPawn(Owner).ViewRotation);
			}

			bHUDEffect = false;
			shieldMesh.Destroy();
			shieldMesh = none;
			resetCracks();
		}
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
     DeactivateSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDestroy01'
     EffectSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldDeflect01'
}
