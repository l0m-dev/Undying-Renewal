//=============================================================================
// ShieldModifier.
//=============================================================================
class ShieldModifier expands PlayerModifier;

#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var travel bool 	bHUDEffect;
var travel int		ShieldHealth, NumCracks, CrackID[8];
var float 	str, initialStr, CrackStr[8], InitialCrackStr[8];
var vector 	col, adjLoc, CrackLocations[8];
var travel float OverlayStr;

var Shield3rdPerson shieldMesh;
var travel AeonsPlayer Player;
var int i;

var int ShieldHealthPerLevel[6];
var float OverlayStrPerLevel[6];

/*----------------------------------------------------------------------------
	Replication
----------------------------------------------------------------------------*/
replication
{
	// Variables the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner)
		OverlayStr;
	unreliable if( Role==ROLE_Authority )
		ClientAddCrack;
}

//----------------------------------------------------------------------------

function PreBeginPlay()
{
	if (RGC())
	{
		ShieldHealthPerLevel[0] = 15;
		ShieldHealthPerLevel[1] = 25;
		ShieldHealthPerLevel[2] = 35;
		ShieldHealthPerLevel[3] = 45;
		ShieldHealthPerLevel[4] = 55;
		ShieldHealthPerLevel[5] = 65;
	}
	Super.PreBeginPlay();

	if (Owner.IsA('AeonsPlayer'))
		Player = AeonsPlayer(Owner);
	
	col = vect(0.5,0.5,1) * 200;	// hud change color
	str = 0.05;					// HUD change strength
}

//----------------------------------------------------------------------------

simulated function AddCrack(float Str)
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

simulated function ClientAddCrack(float Str)
{
	AddCrack(Str);
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

		if ( castingLevel < 6 ) {
			shieldHealth = ShieldHealthPerLevel[castingLevel];
			OverlayStr = OverlayStrPerLevel[castingLevel];
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
		if( shieldMesh == none )
			shieldMesh = spawn(class 'Shield3rdPerson',Pawn(Owner),,Owner.Location + (Vector(PlayerPawn(Owner).ViewRotation) * 16), PlayerPawn(Owner).ViewRotation );

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
			if ( !AeonsPlayer(Owner).IsInCutsceneState() )
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
     ShieldHealthPerLevel(0)=15
     ShieldHealthPerLevel(1)=30
     ShieldHealthPerLevel(2)=45
     ShieldHealthPerLevel(3)=60
     ShieldHealthPerLevel(4)=100
     ShieldHealthPerLevel(5)=125
     OverlayStrPerLevel(0)=0.15
     OverlayStrPerLevel(1)=0.3
     OverlayStrPerLevel(2)=0.45
     OverlayStrPerLevel(3)=0.6
     OverlayStrPerLevel(4)=1.0
     OverlayStrPerLevel(5)=1.0
     RemoteRole=ROLE_SimulatedProxy
}
