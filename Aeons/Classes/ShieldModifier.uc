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
var int ShieldTimePerLevel[6];

var travel int MaxShieldHealth;
var travel float MaxOverlayStr;
var travel int ManaMaint;

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
	local int i;

	if (RGC())
	{
		ShieldHealthPerLevel[0] = 20;
		ShieldHealthPerLevel[1] = 30;
		ShieldHealthPerLevel[2] = 40;
		ShieldHealthPerLevel[3] = 50;
		ShieldHealthPerLevel[4] = 60;
		ShieldHealthPerLevel[5] = 70;

		ShieldTimePerLevel[0] = 20;
		ShieldTimePerLevel[1] = 30;
		ShieldTimePerLevel[2] = 40;
		ShieldTimePerLevel[3] = 60;
		ShieldTimePerLevel[4] = 90;
		ShieldTimePerLevel[5] = 120;

		for (i=0; i<6; i++)
			OverlayStrPerLevel[i] = FMin(float(ShieldTimePerLevel[i]) / 100.0, 1.0);
	}
	Super.PreBeginPlay();

	if (Owner.IsA('AeonsPlayer'))
		Player = AeonsPlayer(Owner);
	
	col = vect(0.5,0.5,1) * 200;	// hud change color
	str = 0.05;					// HUD change strength
}

//----------------------------------------------------------------------------

simulated function AddCrack(float Str, vector HitLocation, vector Momentum)
{
	local int i;
	local vector Loc;
	local vector HitDir, X, Y, Z;
	local float Spread, CloudMin, CloudMax, CloudX, CloudY;
	local bool bFullyRandom;

	bFullyRandom = Momentum == vect(0,0,0) || !class'RenewalConfig'.default.bNewDamageFeedback;

	if ( !bFullyRandom )
	{
		Spread = FClamp(0.25 * Sqrt(Str), 0.1, 1.0);

		if ( Spread == 1.0 )
			bFullyRandom = true;
		else
		{
			//HitDir = Normal(HitLocation-Location);
			HitDir = Normal(Momentum);

			GetAxes(Pawn(Owner).ViewRotation, X, Y, Z);

			CloudMin = Spread * 0.5;
			CloudMax = 1.0 - CloudMin;

			CloudX = FClamp((-(HitDir Dot Y) + 1.0) * 0.5, CloudMin, CloudMax);
			CloudY = FClamp(((HitDir Dot Z) + 1.0) * 0.5, CloudMin, CloudMax);
		}
	}
	
	for (i=0; i<8; i++)
	{
		if (CrackStr[i] <= 0.25)
		{
			CrackStr[i] = Str;
			InitialCrackStr[i] = Str;
			if (bFullyRandom)
			{
				Loc.x = RandRange(0.15,0.8);
				Loc.y = RandRange(0.15,0.8);
			}
			else
			{
				Loc.x = CloudX + (FRand() - 0.5) * Spread;
				Loc.y = CloudY + (FRand() - 0.5) * Spread;
			}
			CrackLocations[i] = Loc;
			CrackID[i] = rand(3);
			break;
		}
	}
}

simulated function ClientAddCrack(float Str, vector HitLocation, vector Momentum)
{
	AddCrack(Str, HitLocation, Momentum);
}

//----------------------------------------------------------------------------

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	local int iDamage;
	local DamageInfo NewDInfo;

	if (bActive)
		if (shieldHealth <= DInfo.Damage)
		{
			// bugfix
			if (RGC())
			{
				NewDInfo = DInfo;

				// Absorb damage in multiples of 10, so even 1 health shield can absorb 10 damage
				NewDInfo.Damage = FMax(0, DInfo.Damage - (shieldHealth/10+1)*10);
			}
			else
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
			AddCrack(1.0, HitLocation, Momentum);
			shieldHealth -= DInfo.Damage;
			OverlayStr = float(shieldHealth) / MaxShieldHealth * MaxOverlayStr;
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

		OverlayStr = float(shieldHealth) / MaxShieldHealth * MaxOverlayStr;
		if (shieldHealth <= 0)
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

		if (AeonsPlayer(owner).mana <= 2) // RGC()? reduced 5 to 2, and moved check from Timer To Tick
			gotoState('Deactivated');
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
				ManaMaint = 2; // TODO: might want to increase this for ultra-nightmare
				ManaModifier(AeonsPlayer(Owner).ManaMod).manaMaint += ManaMaint;
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
			MaxShieldHealth = ShieldHealthPerLevel[castingLevel];
			shieldHealth = MaxShieldHealth;
			MaxOverlayStr = OverlayStrPerLevel[castingLevel];
			OverlayStr = MaxOverlayStr;
		} else {
			log("CastingLevel is invalid!!!");
			gotoState('Deactivated');	// bail out
		}
		// Reset Cracks
		NumCracks = 0;
		for (i=0; i<8; i++)
			CrackStr[i] = 0;

		Enable('Tick');
		SetTimer(float(ShieldTimePerLevel[castingLevel]) / MaxShieldHealth, true);
		Stop;

	AlreadyActive:
		if( shieldMesh == none )
			shieldMesh = spawn(class 'Shield3rdPerson',Pawn(Owner),,Owner.Location + (Vector(PlayerPawn(Owner).ViewRotation) * 16), PlayerPawn(Owner).ViewRotation );

		adjLoc = Pawn(Owner).location;
		adjLoc.z -= 48;
		OverlayStr = float(shieldHealth) / MaxShieldHealth * MaxOverlayStr;
		setTimer(float(ShieldTimePerLevel[castingLevel]) / MaxShieldHealth, true);
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
			ManaModifier(AeonsPlayer(Owner).ManaMod).manaMaint -= ManaMaint;
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
     ShieldTimePerLevel(0)=15
     ShieldTimePerLevel(1)=30
     ShieldTimePerLevel(2)=45
     ShieldTimePerLevel(3)=60
     ShieldTimePerLevel(4)=100
     ShieldTimePerLevel(5)=125
     RemoteRole=ROLE_SimulatedProxy
}
