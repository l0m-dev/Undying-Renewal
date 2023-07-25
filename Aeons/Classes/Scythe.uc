//=============================================================================
// Scythe.
//=============================================================================
class Scythe expands AeonsWeapon;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv
//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts

//=============================================================================
//					Meshes
//=============================================================================
// 3rd Person Mesh
//#exec MESH IMPORT MESH=Scythe_m SKELFILE=Scythe.ngf

//=============================================================================
// 1st person Mesh
//#exec MESH IMPORT MESH=Scythe1st_m SKELFILE=Scythe1st\Scythe1st.ngf MOVERELATIVE=0
//#exec MESH ORIGIN MESH=Scythe1st_m YAW=64

// Notifys
//#exec MESH NOTIFY SEQ=Select TIME=0.350 FUNCTION=PlaySelectSound

//#exec MESH NOTIFY SEQ=Fire TIME=0.261 FUNCTION=FireWeapon
//#exec MESH NOTIFY SEQ=Fire TIME=0.280 FUNCTION=PreSurfaceStrike
//#exec MESH NOTIFY SEQ=Fire TIME=0.304 FUNCTION=SurfaceStrike

//#exec MESH NOTIFY SEQ=Fire TIME=0.1 FUNCTION=StartBlur		// motion blur for the blade (start)
//#exec MESH NOTIFY SEQ=Fire TIME=0.65 FUNCTION=EndBlur			// motion blur for the blade (end)

// regular fire anim
//#exec MESH NOTIFY SEQ=Fire_Normal TIME=0.233 FUNCTION=FireWeapon
//#exec MESH NOTIFY SEQ=Fire_Normal TIME=0.235 FUNCTION=PreSurfaceStrike
//#exec MESH NOTIFY SEQ=Fire_Normal TIME=0.240 FUNCTION=SurfaceStrike

//#exec MESH NOTIFY SEQ=Fire_Normal TIME=0.186 FUNCTION=StartBlur		// motion blur for the blade (start)
//#exec MESH NOTIFY SEQ=Fire_Normal TIME=0.400 FUNCTION=EndBlur			// motion blur for the blade (end)

// berserk fire anim
//#exec MESH NOTIFY SEQ=Fire_Slow TIME=0.458 FUNCTION=FireWeapon
//#exec MESH NOTIFY SEQ=Fire_Slow TIME=0.465 FUNCTION=PreSurfaceStrike
//#exec MESH NOTIFY SEQ=Fire_Slow TIME=0.475 FUNCTION=SurfaceStrike
//#exec MESH NOTIFY SEQ=Fire_Slow TIME=0.400 FUNCTION=AddMomentum

//#exec MESH NOTIFY SEQ=Fire_Slow TIME=0.407 FUNCTION=StartBlur		// motion blur for the blade (start)
//#exec MESH NOTIFY SEQ=Fire_Slow TIME=0.576 FUNCTION=EndBlur			// motion blur for the blade (end)

//=============================================================================
var() sound HardSounds[3];
var() sound SoftSounds[3];
var() sound WaterSound;
var() sound PawnImpactSound;
var() sound DrinkLifeSound;
var() sound WhisperSounds[3];

var travel bool bBerserk;			// in berserk mode?
var float Damage, Timer1, SwingTime;
var vector BladeLocA, BladeLocB, SlashDir;
var int HealthRefreshAmt;

var PersistentWound Wound;
var ScytheBlurFX Trail;
var ScytheWoundFX BloodDrip;
var() sound BerserkONSound;
var() sound BerserkOFFSound;
var() sound WindUpSound;
var() sound AbsorbHealthSound;
var() sound MadSound;
var() sound ThirstSound;
var int SndID;

var bool bMad;
var bool bThirsty;
var bool bThirstyFiring;

//=============================================================================
function PreBeginPlay()
{
	super.preBeginPlay();
	Damage = 40;
}
function PostBeginPlay()
{
	super.PostBeginPlay();
	AmmoType.AmmoAmount = 9999;
}

function Berserk()
{
	if (bBerserk && bThirsty)
		return;
	
	bBerserk = !bBerserk;
	
	if ( bBerserk )
	{
		PlaySound(BerserkONSound);
		Damage = 60;		
		// Add Glow
	} else {
		PlaySound(BerserkOFFSound);
		Damage = 40;
	}
}

simulated function StartBlur()
{
	if ( Level.NetMode == NM_DedicatedServer ) 
		return;

	Trail = Spawn (class 'ScytheBlurFX',,,JointPlace('EndBlade').pos);
	Trail.SetBase(self,'EndBlade','root');
	Trail.bHidden = true;
}

function AddMomentum()
{
	local vector X, Y, Z, HitLocation, HitNormal, start, end;
	local int HitJoint;
	
	Start = Owner.Location;
	End = Owner.Location + (vect(0,0,-1) * (Owner.CollisionHeight + 32));

	Trace(HitLocation, HitNormal, HitJoint, end, start);
	if (HitLocation != vect(0,0,0) || Owner.Physics == PHYS_Walking)
	{
		GetAxes(PlayerPawn(Owner).ViewRotation, X, Y, Z);
		x.z = 0;
		PlayerPawn(Owner).GroundFriction = 2;
		PlayerPawn(Owner).Velocity += X * 1024;
	}
}



simulated function EndBlur()
{
	if ( Level.NetMode == NM_DedicatedServer ) 
		return;

	if (Trail != none)
		Trail.bShuttingDown = true;
}

/*
function Tick(float DeltaTime)
{
	if (Owner == none)
		Destroy();
}*/

// Hit effects
function genSpark(vector Loc, vector Dir)
{
	spawn(class 'ScytheSparksFX',,,Loc, Rotator(Dir));
}

function genSplash(vector Loc)
{
	spawn(class 'ScytheSplashFX',,,Loc);
}

function PreSurfaceStrike()
{
	BladeLocA = jointPlace('Blade5').pos;
}

function Drink(){}

simulated function PlaySelect()
{
	//LogActorState("AeonsWeapon: PlaySelect");
	bForceFire = false;
	bCanClientFire = false;
	if ( !IsAnimating() || (AnimSequence != 'Select') )
		PlayAnim('Select');//rb ,1.0,0.0);
}

simulated function PlaySelectSound()
{
	Owner.PlaySound(SelectSound, SLOT_Misc, 1.0);
}

function TweenDown()
{
	Super.TweenDown();
}

function SurfaceStrike()
{
	local int HitJoint;
	local int Flags;
	local vector Start, End, HitLocation, HitNormal, eyeOffset;
	local Texture HitTexture;
	local Decal D;

	BladeLocB = jointPlace('Blade5').pos;

	SlashDir = Normal(BladeLocB-BladeLocA);
	
	eyeOffset.z = PlayerPawn(Owner).EyeHeight;

	start = Pawn(Owner).Location + eyeOffset;
	end = start + (Vector(Pawn(Owner).ViewRotation) * 128);

	HitTexture = TraceTexture(End, Start, Flags);

	if (HitTexture != none)
	{
		Trace(HitLocation, HitNormal, HitJoint,end, start, false, true);

		PlayImpactSound(1, HitTexture, 0, Pawn(Owner).Location, 2.0, 800.0, 1.0);
		MakeNoise(1.0, 1280);

		Dust(HitLocation, HitNormal, HitTexture, 1.0);

		if ( (134217728 & Flags) != 0 )
		{
			Spawn(class'Aeons.GlassHitDecal',self,,HitLocation, rotator(HitNormal));
		} else {
		
			switch( HitTexture.ImpactID )
			{
				case TID_Default:				// Default
					PlaySound(SoftSounds[Rand(3)], SLOT_Misc);
					D = Spawn(ExplosionDecal,self,,HitLocation, rotator(HitNormal));
					D.AttachToSurface(SlashDir);

					break;

				case TID_Stone:					// Stone
				case TID_Metal:					// Metal
					PlaySound(HardSounds[Rand(3)], SLOT_Misc);
					// don't create sparks in a water zone
					if (!Owner.Region.Zone.bWaterZone)
						genSpark(HitLocation, NOrmal(SlashDir + HitNormal));
					D = Spawn(ExplosionDecal,self,,HitLocation, rotator(HitNormal));
					D.AttachToSurface(SlashDir);

					break;

				case TID_WoodHollow:				// Water
				case TID_WoodSolid:				// Water
					PlaySound(HardSounds[Rand(3)], SLOT_Misc);
					D = Spawn(ExplosionDecal,self,,HitLocation, rotator(HitNormal));
					D.AttachToSurface(SlashDir);
					break;

				case TID_Water:					// Water
					PlaySound(WaterSound, SLOT_Misc);
					break;
				
				case TID_Glass:					// Water
					Spawn(class'Aeons.GlassHitDecal',self,,HitLocation, rotator(HitNormal));
					break;

				default:						// default
					PlaySound(SoftSounds[Rand(3)], SLOT_Misc);
					D = Spawn(ExplosionDecal,self,,HitLocation, rotator(HitNormal));
					D.AttachToSurface(SlashDir);
					break;
			};
		}
	}
}

function FireWeapon()
{
	local float Value;

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);

	if ( !bRapidFire && (FiringSpeed > 0) )
		Pawn(Owner).PlayRecoil(FiringSpeed);

	if ( bInstantHit )
		TraceFire(Value);
	else
	{
		if ( bAltAmmo )
			ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget, true);
		else
			ProjectileFire(AltProjectileClass, ProjectileSpeed, bWarnTarget, true);
	}
	if ( AeonsPlayer(Owner).bWeaponSound )
	{
	    AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280 * 3);
		if (bBerserk)
		    Owner.PlaySound(AltFireSound);
		else
		    Owner.PlaySound(FireSound);
	}

	bPointing=True;
	
	//ClientFire(Value);

	if ( Owner.bHidden )
		CheckVisibility();

	if (!bThirsty)
		gotoState('NormalFire');

	MeleeAttack(128);
	
	if ( bBerserk )
		AddMomentum();
	
	// Test Actuator
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_FadeOut, 0.4f);
}

//----------------------------------------------------------------------------
//----------------------------------------------------------------------------
// Note:	This was in the original AeonsWeapon.  Brought up here for
//			now so that AeonsWeapon can continue to resemble TournamentWeapon
//----------------------------------------------------------------------------
function Fire( float Value )
{
	if (!bThirsty)
		GotoState('');
	Super.Fire(Accuracy);
}

//----------------------------------------------------------------------------

simulated function PlayFiring()
{
	SwingTime = Level.TimeSeconds;

	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fScythe = 1.0;
	
	if ( bBerserk ) {
		PlayAnim( 'Fire_Slow', 1.0 / AeonsPlayer(Owner).refireMultiplier,,,0.0);
		PlaySound(WindUpSound);
	} else
		PlayAnim( 'Fire_Normal', 1.0 / AeonsPlayer(Owner).refireMultiplier,,,0.0);
}

//----------------------------------------------------------------------------

state NormalFire
{
	function Fire(float F){}

	function AnimEnd()
	{
		// Log("Scythe: state NormalFire: AnimEnd", 'Misc');
		Finish();
	}

	Begin:
		//log ("Scythe: BeginState NormalFire", 'Misc');
		// PlayAnim('Fire');
		//log ("...Scythe: about to FinishAnim() ... sleeping for "$(refireRate * (1.0 / RefireMult)), 'Misc');
		FinishAnim();

		if ( (VSize(PlayerPawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) && (AeonsPlayer(Owner).GetStateName() != 'PlayerFlying'))
			LoopAnim('MoveIdle', RefireMult);
		else
			LoopAnim('StillIdle', RefireMult);

		//log ("...Scythe: FinishAnim() completed ... sleeping for "$(refireRate * (1.0 / RefireMult)), 'Misc');
		Sleep(refireRate * (1.0 / RefireMult));
		Finish();
}

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	
	DInfo.Damage = Damage;
	DInfo.DamageType = DamageType;
	DInfo.DamageMultiplier = 1.0;
	
	switch(DamageType)
	{
		case 'ScytheDouble':
			DInfo.Damage = Damage * 3.0;
			break;

		case 'Scythe':
			if (DInfo.JointName == 'Head')
				DInfo.Damage = Damage * 2.0;
			else
				DInfo.Damage = Damage;
			break;
	}

	return DInfo;	
}

function bool ValidHit( actor StartActor, actor TargetActor, 
						out vector HitLocation, out vector HitNormal, out int HitJoint, 
						vector end, vector start )
{
	local actor A;
	local vector currentStart, traceDirection;
	local float traceLength, threshold, dist, bestDist;

	A = none;
	currentStart = start;
	traceDirection = Normal( end - start );
	traceLength = (end - start) dot traceDirection;
	threshold = 0.05 * traceLength;
	bestDist = 2.0*traceLength;
	dist = traceLength;

	while( (StartActor != none) && (dist < bestDist) && (dist > threshold) )
	{
		bestDist = dist;
//		log( "" $ name $ ".ValidHit() checking for " $ TargetActor.name $ " from " $ StartActor.name $ " " $ currentStart $ " to " $ end $ "." );

		A = StartActor.Trace(HitLocation, HitNormal, HitJoint, end, currentStart, true, true);
	
		if (A == TargetActor)
			return true;
		else
		{
			currentStart = HitLocation;
			StartActor = A;
			dist = (end - currentStart) dot traceDirection;
		}
	}

	return false;
}

function bool CheckScytheHeadshot(name JointName)
{
	switch ( JointName )
	{
		case 'Hair':
		case 'Hair1':
		case 'Hair2':
		case 'Hair3':
		case 'Neck':
		case 'Head':
			return true;
	}
	return false;
}

function MeleeAttack(float Range)
{
	local bool bHeadShot, bSpawnWounds;
	local vector x, y, z, hitloc, momentum, MyView, YourView, Start, End, HitLocation, HitNormal, eyeOffset;
	local int HitJoint, Flags, healthTaken;
	local name JointName;
	local float TotalDamage;

	local Texture HitTexture;
	local Decal D;
	local DamageInfo DInfo;
	local ScriptedPawn SP;
	local Pawn Other;
	local Actor A;

	if ( (AeonsPlayer(Owner).GetStateName() == 'DialogScene') || (AeonsPlayer(Owner).GetStateName() == 'PlayerCutscene') || (AeonsPlayer(Owner).GetStateName() == 'SpecialKill'))
		return;
	
	if (RGORE())
		Patrick(Owner).DetachJoint(PawnImpactSound, Range);
	
	BladeLocB = jointPlace('Blade5').pos;
	
	GetAxes(Pawn(Owner).ViewRotation, x, y, z);

	SlashDir = y;
	// SlashDir = Normal(BladeLocB-BladeLocA);
	EyeOffset.z = PlayerPawn(Owner).EyeHeight;
	Start = Pawn(Owner).Location + eyeOffset;
	End = start + Vector(Pawn(Owner).ViewRotation) * (Range * 2);
	Trace(HitLocation, HitNormal, HitJoint, End, Start);

	if ( HitLocation != vect(0,0,0) )
		End = HitLocation;

	GetAxes(PlayerPawn(Owner).ViewRotation, x, y, z);

	foreach TraceActors( class'Actor', A, HitLocation, HitNormal, HitJoint, end, start, true, true, vect(48,48,24) )
	{
		if ( !A.IsA('Pawn') )
		{
			DInfo = getDamageInfo('Scythe');
			if ( A.AcceptDamage(DInfo) )
				A.TakeDamage(Pawn(Owner), hitloc, 300.0 * x, DInfo);
			continue;
		}
		else
		{
			Other = Pawn(A);
		}

		if ( Other.Health <= 0 )
			continue;
		
		if ( (Other.Location - Owner.Location) Dot X <= 0)
			continue;
		
		if (!FastTrace(Other.Location, Start) &&
			!FastTrace(Other.Location + vect(0,0,0.85)*Other.CollisionHeight, Start) &&
			!FastTrace(Other.Location - vect(0,0,0.85)*Other.CollisionHeight, Start))
		{
			continue;
		}
		
		// Reset the total damage accumulator with each traced pawn
		TotalDamage = 0;
		
		JointName = Other.JointName(PlayerPawn(Owner).EyeTraceJoint);

		if (Level.bDebugMessaging)
			PlayerPawn(Owner).ClientMessage(""$JointName);
		
		// log( "" $ name $ " registered valid hit on " $ Other.name $ ", joint " $ JointName $ ".", 'Misc');
			
		bSpawnWounds = false;
		bHeadShot = CheckScytheHeadshot(JointName);
		if (bHeadShot)
			JointName = 'Head';

		// allows us to exit BloodThirst state in boss fights
		if (ScriptedPawn(Other).bIsBoss)
		{
			if (bThirsty)
			{
				GotoState('NormalFire');
			}
		}

		/*
		if ( bHeadShot )
		{
			MyView = Vector(PlayerPawn(Owner).ViewRotation);
			MyView.z = 0;

			YourView = Vector(Other.Rotation);
			YourView.z = 0;

			if ( (MyView dot YourView) > 0 )
				PlayerPawn(Owner).Health = clamp((PlayerPawn(Owner).Health + (Other.Health * 0.5)), 0, 200);

			Other.PlayDamageMethodImpact('RipSlice', Other.Location, SlashDir);
			// Other.Decapitate((SlashDir + vect(0,0,0.5)) * 256);
			if( Other.Decapitate((y + vect(0,0,0.8)) * 256) )
			{ 
				Other.Died( Pawn(Owner), 'Decapitated', HitLocation, DInfo );
			}
		}
		else
		*/

		// log(""$(Vector(PlayerPawn(Owner).ViewRotation) dot Vector(Other.ViewRotation)));

		hitloc = Other.Location + (Other.Location - Owner.Location) * Other.CollisionRadius;

		if (PawnImpactSound != none) 
		{
			PlaySound(PawnImpactSound,,4.0,,1024, RandRange(0.8,1.2));
			MakeNoise(1.0, 1280);
		}

		Other.PlayDamageMethodImpact('RipSlice', hitloc, -Vector(Pawn(Owner).ViewRotation)); 

		MyView = Vector(PlayerPawn(Owner).ViewRotation);
		MyView.z = 0;

		YourView = Vector(Other.Rotation);
		YourView.z = 0;

		if ( (MyView dot YourView) < 0 )
		{
			// hit in front
			healthTaken = 0;	

			// This is the limb hacking stuff
			if ( Other.IsA('ScriptedPawn') )
			{
				SP = ScriptedPawn(Other);
				
				DInfo = getDamageInfo('Scythe');
				DInfo.JointName = JointName;
				DInfo.Damage *= 0.5;
				DInfo.bMagical = true;
				if ( SP.AcceptDamage(DInfo) )
				{
					SP.AdjustDamage(DInfo);
					DInfo = SP.AdjustDamageByLocation(DInfo);
					TotalDamage += DInfo.Damage;
				}
				
				DInfo = getDamageInfo('Scythe');
				DInfo.JointName = JointName;
				DInfo.Damage *= 0.5;
				DInfo.bMagical = false;
				if ( SP.AcceptDamage(DInfo) )
				{
					SP.AdjustDamage(DInfo);
					DInfo = SP.AdjustDamageByLocation(DInfo);
					TotalDamage += DInfo.Damage;
				}

				bSpawnWounds = TotalDamage > 5.0;							

				if ( TotalDamage >= SP.Health && SP.bHackable && !SP.bIsBoss )
				{
					// we now know that the creature is going to die
					healthTaken = 0.5 * Other.Health;
					HackLimb(SP, DInfo.JointName, SlashDir);
				}
			}
			else
				bSpawnWounds = true;

			DInfo = getDamageInfo('Scythe');
			DInfo.JointName = JointName;
		} 
		else 
		{
			// hit from behind
			healthTaken = 0;

			// This is the limb hacking stuff
			if ( Other.IsA('ScriptedPawn') )
			{
				SP = ScriptedPawn(Other);
				
				DInfo = getDamageInfo('ScytheDouble');
				DInfo.JointName = JointName;
				DInfo.Damage *= 0.5;
				DInfo.bMagical = true;
				if ( SP.AcceptDamage(DInfo) )
				{
					SP.AdjustDamage(DInfo);
					DInfo = SP.AdjustDamageByLocation(DInfo);
					TotalDamage += DInfo.Damage;
				}
				
				DInfo = getDamageInfo('ScytheDouble');
				DInfo.JointName = JointName;
				DInfo.Damage *= 0.5;
				DInfo.bMagical = false;
				if ( SP.AcceptDamage(DInfo) )
				{
					SP.AdjustDamage(DInfo);
					DInfo = SP.AdjustDamageByLocation(DInfo);
					TotalDamage += DInfo.Damage;
				}
				
				bSpawnWounds = TotalDamage > 5.0;

				if ( TotalDamage >= SP.Health && SP.bHackable && !SP.bIsBoss)
				{
					// we now know that the creature is going to die
					healthTaken = Other.Health * 0.5;
					HackLimb(SP, DInfo.JointName, SlashDir);
				}
			}
			else
				bSpawnWounds = true;

			DInfo = getDamageInfo('ScytheDouble');
			DInfo.JointName = JointName;
		}

		momentum = 300.0 * x;
		
		DInfo.Damage *= 0.5;

		DInfo.bMagical = true;
		if ( Other.AcceptDamage(DInfo) )
			Other.TakeDamage(Pawn(Owner), hitloc, momentum, DInfo);

		DInfo.bMagical = false;
		if ( Other.AcceptDamage(DInfo) )
			Other.TakeDamage(Pawn(Owner), hitloc, momentum, DInfo);

		// if we hit a scripted pawn and the scripted pawn can be hit by a scythe
		// Only in berserk mode!
		if (bBerserk)
		{
			if ( (HealthTaken > 0) && Other.IsA('ScriptedPawn'))
				if (ScriptedPawn(Other).bGiveScytheHealth)
				{
					log ("Health Taken = "$HealthTaken, 'Misc');
					HealthRefreshAmt = healthTaken;
					if (bThirsty)
					{
						PlayerPawn(Owner).Mana = FMin(PlayerPawn(Owner).Mana, 50);
					}
					GotoState('AbsorbHealth');
				} else {
					log ("bGiveScytheHealth = "$ScriptedPawn(Other).bGiveScytheHealth, 'Misc');
				}
		}

		if (bSpawnWounds )
		{
			if (Other.IsA('DecayedSaint'))
			{
				Spawn(class 'DustPuffFX',Other,,HitLocation);
				//Wound = Spawn(class 'DustPuffFX',Other,,Other.JointPlace(JointName).pos, Rotator(HitNormal));
				//Wound.AttachJoint = JointName;
				//Wound.setup();
			}
			else
			{
				if (BloodDrip == none)
				{
					BloodDrip = Spawn(class 'ScytheWoundFX',,,JointPlace('Blade5').pos);
					BloodDrip.SetBase(self,'Blade5','root');
				}

				if (JointName != 'none')
				{
					Spawn(class 'InstantScytheWound',Other,,HitLocation);
					Wound = Spawn(class 'ScytheWound',Other,,Other.JointPlace(JointName).pos, Rotator(HitNormal));
					Wound.AttachJoint = JointName;
					Wound.setup();
				}
			}
		}
	}

	// momentum = (Other.Location - Owner.Location) * 300/Other.Mass;
	// Other.Velocity += momentum;
}

function bool HackLimb(ScriptedPawn SP, name JointName, vector Dir)
{
	local int Parent, i;
	local Actor B;
	local bool bNoHack;

	if (Level.bDebugMessaging)
		Pawn(Owner).CLientMessage("JointName = "$JointName);
	
	switch ( SP.Class.Name )
	{
		case 'Jile':
			bNoHack = true;
			break;
		
		default:
			break;

	}

	if ( bNoHack )
		return false;

	switch (JointName)
	{
		case 'none':
		case 'root':
		case 'pelvis':
			return false;
			break;
		
		default:
			break;
	};

	B = SP.DetachLimb(JointName, Class 'BodyPart');

	B.Velocity = (Dir + vect(0,0,0.25)) * 256;
	B.DesiredRotation = RotRand();
	B.bBounce = true;
	B.SetCollisionSize((B.CollisionRadius * 0.65), (B.CollisionHeight * 0.15));

	SP.bHacked = true;
	SP.Hacked(PlayerPawn(Owner));
	/*
	if ( SP.PersistentBlood != none )
	{
		PBlood = spawn(PersistentBlood,,,JointPlace(JointName).pos);
		PBlood.SetBase(self, JointName, 'root');
	}
	*/

	return true;
}


/*
function Pawn getClosePawn(out pawn p, optional float Radius, optional vector Loc)
{
	local 	Pawn 		tPawn; // temp pawn
	local 	float 		len, tLen; // length and temp length

	len = 4096; // big len
	
	p = none;
	forEach VisibleActors(class'Pawn',tPawn, Radius, Loc)
	{
		if ( tPawn != Pawn(Owner) && (tPawn.health > 0) ) // not the player and not dead
		{
			tLen = VSize(Location - tPawn.Location);
			if ( tLen < len )
			{
				len = tLen;
				p = tPawn;
			}
		}
	}
	return p;
}*/

state Idle
{
	function BeginState()
	{
		// PlayerPawn(Owner).ClientMessage("Scythe Swing time = "$(Level.TimeSeconds-SwingTime));
	}

	simulated function Tick(float DeltaTime)
	{
		if ( PlayerPawn(Owner).Mana <= 1 )
		{
			if (RGC())
			{
				if (!bMad)
				{
					GotoState('BloodThirst');
				}
				else
				{
					Pawn(Owner).SwitchToBestWeapon();
					bMad = false;
				}
			}
			else
			{
				Pawn(Owner).SwitchToBestWeapon();
			}
		}
		// Blood dripping from the blade
		if (BloodDrip != none)
		{
			if (BloodDrip.ParticlesPerSec.Base > 1)
			{
				BloodDrip.ParticlesPerSec.Base -= 1;
			} else {
				BloodDrip.bShuttingDown = true;
				BloodDrip = none;
			}
		}

		//if ( AnimSequence != 'SelfDamage')
			//LoopAnim('StrayCycle',RefireMult);
		if ( (VSize(PlayerPawn(Owner).Velocity) > 300) && (!PlayerPawn(Owner).Region.Zone.bWaterZone) && (AeonsPlayer(Owner).GetStateName() != 'PlayerFlying') )
			loopAnim('MoveIdle', RefireMult);
		else
			loopAnim('StillIdle', RefireMult);
	}

	simulated function Timer()
	{
		local Sound S;

		log("Player's ViewTarget is : "$PlayerPawn(Owner).ViewTarget, 'Misc');
		//if ( bOverdrive )
		//	GotoState(GetStateName(), 'AttackOwner');
	}

	Begin:
		if (Trail != none)
		{
			Trail.bShuttingDown = true;
			Trail = none;
		}
		Enable('Tick');
		SetTimer(8 + FRand()*5,true);
}

state AbsorbHealth
{
	ignores Fire, PutDown, Berserk;
	
	function BeginState()
	{
		PlayerPawn(Owner).bReloading = true;
		SndID = PlaySound(AbsorbHealthSound);
		
		if (bBerserk)
			Global.Berserk();
	}

	function EndState()
	{
		PlayerPawn(Owner).bReloading = false;
		StopSound(SndID);
	}

	function Tick(float DeltaTime)
	{
		if (Timer1 >= Level.TimeSeconds)
		{
			// PlaySound(DrinkLifeSound);
			Timer1 = Level.TimeSeconds + 0.5;
		}
		// Blood Drips
		if (BloodDrip != none)
		{
			if (BloodDrip.ParticlesPerSec.Base > 1)
			{
				BloodDrip.ParticlesPerSec.Base -= 1;
			} else {
				BloodDrip.bShuttingDown = true;
				BloodDrip = none;
			}
		}
	}

	function Timer()
	{
		if (HealthRefreshAmt > 0)
		{
			LoopAnim('Resting');
			if (PlayerPawn(Owner).Health < 198)
			{
				HealthRefreshAmt -= 1;
				PlayerPawn(Owner).Health = clamp((PlayerPawn(Owner).Health + 1), 0, 200);
			} else {
				HealthRefreshAmt = 0;
			}
		} else {
			PlayAnim('Awake');
			Finish();
			// GotoState('Idle');
		}
	}

	Begin:
		log ("HealthRefreshAmt = "$HealthRefreshAmt, 'Misc');
		Timer1 = Level.TimeSeconds + 0.5;
		if (Trail != none)
		{
			Trail.bShuttingDown = true;
			Trail = none;
		}
		PlayAnim('Eat');
		FinishAnim();
		SetTimer(0.2, true);
}

state Mad
{
	ignores Fire, PutDown;
	
	function BeginState()
	{
		bMad = true;
		PlayerPawn(Owner).bReloading = true;
		SndID = PlaySound(MadSound);
	}

	function EndState()
	{
		PlayerPawn(Owner).bReloading = false;
		StopSound(SndID);
	}

	simulated function Tick(float DeltaTime)
	{
		
	}
	
	function Timer()
	{
		local DamageInfo DInfo;
		local vector hitloc;
		
		//PlayAnim('Awake');
		if ( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).ShakeView(ShakeTime * 4, ShakeMag * 4, ShakeVert * 4);
			
			DInfo = getDamageInfo('Scythe');
			DInfo.JointName = 'head';
						
			DInfo.Damage *= 0.5;
			Owner.TakeDamage(Pawn(Owner), hitloc, hitloc, DInfo);
			PlaySound(PawnImpactSound,,4.0,,1024, RandRange(0.8,1.2));
			MakeNoise(1.0, 1280);
		}
	}

	Begin:
		PlayAnim('SelfDamage');
		SetTimer(1.0, false);
		Sleep(2.0);
		if ( PlayerPawn(Owner) != None )
		{
			PlayerPawn(Owner).bReloading = false;
		}
		GotoState('Idle');
		Finish();
}

function AddParticles()
{
	local int NumJoints, i;
	local name JointName;
	local Actor A;
	local place P;

	NumJoints = Self.NumJoints();
	if ( NumJoints > 0 )
	{
		for (i=0; i<NumJoints; i++)
		{
			JointName = Self.JointName(i);
			P = JointPlace(JointName);
			A = Spawn(class 'BloodyMandorlaParticleFX', self,, P.pos);
			A.SetBase(self,JointName, 'root');
		}
	}
}

function RemoveParticles()
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A)
		if ( A.Owner == self )
			if ( A.IsA('BloodyMandorlaParticleFX') )
				ParticleFX(A).bShuttingDown = true;
}

state BloodThirst
{
	ignores PutDown;
	
	function BeginState()
	{
		bThirsty = true;
		Berserk();
		PlayerPawn(Owner).bReloading = false;
		PlayerPawn(Owner).Mana = 100;
		SndID = PlaySound(ThirstSound);
		if (BloodDrip == none)
		{
			BloodDrip = Spawn(class 'ScytheWoundFX',,,JointPlace('Blade5').pos);
			BloodDrip.SetBase(self,'Blade5','root');
		}
		AddParticles();
	}

	function EndState()
	{
		bThirsty = false;

		//PlayerPawn(Owner).Mana = FMin(PlayerPawn(Owner).Mana, 50);

		StopSound(SndID);

		BloodDrip.bShuttingDown = true;
		BloodDrip = none;

		RemoveParticles();
	}

	simulated function Tick(float DeltaTime)
	{
		if ( PlayerPawn(Owner).Mana <= 1 )
		{
			GotoState('Mad');
		}

		//if ( AnimSequence != 'SelfDamage')
			//LoopAnim('StrayCycle',RefireMult);

		if (!bThirstyFiring)
			LoopAnim('StrayCycle',RefireMult);
	}
	
	function Timer()
	{
		GotoState('Mad');
	}

	function Fire(float F)
	{
		//PlayFiring();
		if (!bThirstyFiring)
			GotoState(, 'ThirstFire');
	}

	ThirstFire:
		bThirstyFiring = true;
		PlayFiring();
		FinishAnim();
		bThirstyFiring = false;

	Begin:
		bThirstyFiring = false;
		SetTimer(60.0, false);
		Disable('Tick');
		PlayAnim('StartStray');
		FinishAnim();
		Enable('Tick');
}

defaultproperties
{
     HardSounds(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_ScyHitHard01'
     HardSounds(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_ScyHitHard02'
     HardSounds(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_ScyHitHard03'
     SoftSounds(0)=Sound'Impacts.SurfaceSpecific.E_Wpn_ScyHitSoft01'
     SoftSounds(1)=Sound'Impacts.SurfaceSpecific.E_Wpn_ScyHitSoft02'
     SoftSounds(2)=Sound'Impacts.SurfaceSpecific.E_Wpn_ScyHitSoft03'
     PawnImpactSound=Sound'Impacts.WpnSplSpecific.E_Wpn_ScyHit01'
     DrinkLifeSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScyEnergyLoop01'
     BerserkONSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScyBigOn01'
     BerserkOFFSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScyBigOff01'
     WindUpSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScyBigWindup01'
     AbsorbHealthSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScyEnergyLoop01'
     MadSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_InvokeMine01'
     ThirstSound=Sound'CreatureSFX.Chanter.C_Chanter_AmbLoop'
     bWaterFire=True
     bAltWaterFire=True
     ExplosionDecal=Class'Aeons.ScytheDecal'
     ThirdPersonJointName=ScytheAtt
	 AmmoName=Class'Aeons.ScytheAmmo'
     PickupAmmoCount=999
     bMeleeWeapon=True
     AIRating=0.4
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScySwing01'
     AltFireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScyBigSwing01'
     SelectSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScySelect01'
     ItemType=WEAPON_Conventional
     AutoSwitchPriority=5
     InventoryGroup=3
     ItemName="Scythe"
     PlayerViewOffset=(X=2.5,Y=7.5,Z=-11.6)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.Scythe1st_m'
     PlayerViewScale=0.1
     PickupViewMesh=SkelMesh'Aeons.Meshes.Scythe_m'
     PickupViewScale=0.1
     ThirdPersonMesh=SkelMesh'Aeons.Meshes.Scythe_m'
     PickupSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScyPU01'
     ActivateSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ScySelect01'
     ImpactSoundClass=Class'Aeons.DynImpact'
     Mesh=SkelMesh'Aeons.Meshes.Scythe_m'
     DrawScale=0.1
}
