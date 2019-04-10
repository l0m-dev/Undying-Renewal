//=============================================================================
// TibetianWarCannon. 
//=============================================================================
class TibetianWarCannon expands AeonsWeapon;

#exec MESH IMPORT MESH=TibetianWarCannon1st_m SKELFILE=TibetianWarCannon1st\TibetianWarCannon1st.ngf MOVERELATIVE=0
#exec MESH ORIGIN MESH=TibetianWarCannon1st_m YAW=128

#exec MESH IMPORT MESH=Cannon3rd_m SKELFILE=TibetianWarCannon3rd\CannonPat.ngf MOVERELATIVE=0

// User vars
var() 	float 		PawnSpeedMultiplier[5];
var() 	float 		ProjectileSpeedMultiplier[5];
var()	sound		ChargingSound;
var		float		ChargeSoundHoldTime;
var()	float		ChargeSoundHoldDelay;
var()	sound		HoldingSound;
var() 	sound 		SnortSound;

// Internal vars
var 	SphereOfCold_proj s;
var 	int 		i, numSpheres, SndID;
var 	vector 		seekLoc;
var		int			ChargedMana;		// This weapon has an internal mana supply
var		int			internalMana;		// This weapon has an internal mana supply
var		bool		bAltProjectile;
var 	float 		heldTime;
var		bool		bLaunched;
var		TWCNoseParticleFX	MouthSmoke;
var		Light		ChargeLight;
var		float tmr;

var() class<Projectile> ProjClass[4];

function PreBeginPlay()
{
	Super.PreBeginPlay();
	internalMana = 10;
}

function Fire( float Value )
{
	bPointing = true;
	CheckVisibility();
	GotoState('NormalFire');
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local Vector X,Y,Z, eyeAdjust, HitLocation, HitNormal, eyeAdj, TraceEnd, start;
	local rotator bulletDir;
	local vector barrelPlace;

	// Pawn(Owner).eyeTrace(HitLocation,,4096);

	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);

	barrelPlace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	bulletDir = Rotator(Normal(PlayerPawn(Owner).EyeTraceLoc - barrelPlace));

	Spawn(ProjClass,,, barrelPlace, bulletDir);

	// Test PlayActuator here!!
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_FadeOut, 1.0f);

	HeldTime = 0;
	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fCannon = 1.0;
}

state NormalFire
{
	ignores Fire;

	function Timer()
	{
		if (internalMana < 10)
			internalMana += 1;
	}

	function Tick(float deltaTime)
	{
		local name PlayerState;
		tmr += deltaTime;
		
		if (tmr > 0.5)
		{
			if (ChargedMana < 4)
				ChargedMana += 1;
			tmr = 0;
		}

		ChargeSoundHoldTime -= DeltaTime;
		
		if ( ChargeSoundHoldTime <= 0.0 ) 
		{
			StopSound(SndID);
			AmbientSound = HoldingSound;
			//SndID = PlaySound(HoldingSound);
		}
		
		if ( (PlayerPawn(Owner).bFire == 0) && !bLaunched && (ChargedMana >= 1))
		{
			// fire charged sphere
			bAltProjectile = true;
			
			// km -- removed from EndState() -- we need to stop this sound before
			// we play the fire sound
			StopSound(SndID);
			AmbientSound = None;

			// Check the player's state
			PlayerState = AeonsPlayer(Owner).GetStateName();
			// Cutscenes and dialog scene states force bFire = 0, but we don't want to actually fire the projectile in if the player is in a lock down state.
			if ( (PlayerState != 'PlayerCutscene') && (PlayerState != 'DialogScene') && (PlayerState != 'SpecialKill') )
			{
				if ( useInternalMana(ChargedMana) )
				{
					if ( AeonsPlayer(Owner).bWeaponSound )
					{
						PlaySound(FireSound);
						AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
					}

					PlayAnim('AltFire',,,,0);
					bLaunched = true;
					ProjectileFire(ProjClass[ChargedMana], ProjectileSpeed, false, true);
					ChargedMana = 0;
				}
			}
			MouthSmoke.bShuttingDown = true;
			gotoState('Finishing');
		}
	}

	function BeginState()
	{
		if ( AeonsPlayer(Owner).bWeaponSound )
		{
			ChargeSoundHoldTime = ChargeSoundHoldDelay;

			SndID = PlaySound(ChargingSound);
			AeonsPlayer(Owner).MakePlayerNoise(1.0, 1280);
		}
	}

	function EndState(){}

	Begin:
		MouthSmoke = spawn(class 'TWCMouthParticleFX',Pawn(Owner),,JointPlace('Barrel1').pos);
		MouthSmoke.SetBase(self, 'Barrel1', 'none');
		setTimer(1.0,true);
		
		// Testing PlayActuator (this is set to a long period to account for virtually any amount of charging time.)
		PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_LightShake, 100000.0f);
		loopAnim('Charging');
}

state Finishing
{
	function Fire(float F){}

	Begin:
		bLaunched = false;
		FinishAnim();
		Finish();
		
}

function Timer()
{
	if ( internalMana < 10 )
		internalMana += 1;
}

function bool useInternalMana(int amt)
{
	if ( amt > internalMana )
		return false;
	
	internalMana -= amt;
	return true;
}

state NewClip
{
	Begin:
	
}

simulated function Tick(float DeltaTime)
{
	local rotator r;

	if ( (GetStateName() == 'Pickup') && (Owner == none) )
	{
		r = rotation;
		r.yaw += 8192 * DeltaTime;
		SetRotation(r);
	}

	tmr += deltaTime;
	if (tmr > 0.5)
	{
		tmr = 0;
		if (internalMana < 10)
			internalMana += 1;
	}
}

state Idle
{
	simulated function Tick(float DeltaTime)
	{
		tmr += deltaTime;
		if (tmr > 0.5)
		{
			tmr = 0;
			if (internalMana < 10)
				internalMana += 1;
		}

		if ( (VSize(PlayerPawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) )
			loopAnim('MoveIdle');
		else
			loopAnim('StillIdle');
	}

	simulated function Timer()
	{
		if ( (FRand() < 0.5) && (AeonsPlayer(Owner).GetStateName() != 'DialogScene') && (AeonsPlayer(Owner).GetStateName() != 'PlayerCutScene'))
		{
			PlaySound(SnortSound);
			spawn(class 'TWCNoseParticleFX',Pawn(Owner),,JointPlace('RWhiskerBase').pos, PlayerPawn(Owner).ViewRotation);
			spawn(class 'TWCNoseParticleFX',Pawn(Owner),,JointPlace('LWhiskerBse').pos, PlayerPawn(Owner).ViewRotation);
		}

		if ( VSize(PlayerPawn(Owner).Velocity) < 300 )
			if (FRand() > 0.75)
				GotoState(getStateName(),'Flourish');
	}

	FLOURISH:
		Disable('Tick');
		PlayAnim('Flourish');
		FinishAnim();
		goto 'Begin';

	Begin:
		Enable('Tick');
		SetTimer(5 + FRand()*5,true);
}

defaultproperties
{
     PawnSpeedMultiplier(0)=1
     PawnSpeedMultiplier(1)=1
     PawnSpeedMultiplier(2)=0.5
     PawnSpeedMultiplier(3)=0.5
     ProjectileSpeedMultiplier(0)=1
     ProjectileSpeedMultiplier(1)=1
     ProjectileSpeedMultiplier(2)=0.5
     ProjectileSpeedMultiplier(3)=0.5
     ChargingSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCCharge01'
     ChargeSoundHoldDelay=2
     HoldingSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCChargeLp01'
     SnortSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCSnort01'
     ProjClass(0)=Class'Aeons.TWC_0_proj'
     ProjClass(1)=Class'Aeons.TWC_1_proj'
     ProjClass(2)=Class'Aeons.TWC_2_proj'
     ProjClass(3)=Class'Aeons.TWC_3_proj'
     ThirdPersonJointName=CannonAtt
     FireOffset=(Y=-10,Z=-10)
     AIRating=0.5
     RefireRate=1
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCFire01'
     SelectSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCPU01'
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=3
     InventoryGroup=4
     PickupMessage="You picked up a Tibetan War Cannon"
     ItemName="Tibetan War Cannon"
     PlayerViewOffset=(X=6.0,Y=-8.4,Z=-10)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.TibetianWarCannon1st_m'
     PlayerViewScale=0.125
     PickupViewMesh=SkelMesh'Aeons.Meshes.Cannon3rd_m'
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.Cannon3rd_m'
     PickupSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_TWCPU01'
     Mesh=SkelMesh'Aeons.Meshes.TibetianWarCannon1st_m'
     DrawScale=0.5
}
