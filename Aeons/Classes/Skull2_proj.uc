//=============================================================================
// Skull2_proj.
//=============================================================================
class Skull2_proj expands SpellProjectile
	transient;

#exec MESH IMPORT MESH=Skull_Proj SKELFILE=skull_Proj.ngf

#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

struct Sequence
{
	var() Sound SoundSample;
	var() Name Animation;
};

struct SkullSoundParams
{
	var() Sound Sound;
	var() float Weight;
	var() string Comment;
};

// ===========================================================================
// Internal Vars
// ===========================================================================

var bool bFlying, bCanSeeEnemy, bComReady, bInWater, bSpawning;
var float NextTimeCheck, NextInputCheck, NextComTime, Frenzy, Age, fBob, BobRate, LevelTime, PctToHoldLoc;
var vector PlayerOffset, SeekDir, CurrentDir, SpawnLocation;
var name Comm;
var int SndID;

var Skull2_proj CommSkull;
var actor LookAtActor;
var SkullStormInfo MySkullInfo;
var Pawn Player, SeekPawn;
var ParticleFX SmokeTrail;

var		ParticleFX	REyeFire;					// Right Eye Fire
var		ParticleFX	LEyeFire;					// Left Eye Fire
var		ParticleFX	MouthFire;					// Mouth Fire

// ===========================================================================
// User Vars
// ===========================================================================
var() float FrenzyAge; // how old I need to be to start causing trouble
var()	sound		UnderWaterExplosionSound;
var(Skull_Sequences)	Sequence	GreetSeq[7];
var(Skull_Sequences)	Sequence	InquireSeq[3];
var(Skull_Sequences)	Sequence	ThreatenSeq[6];
var(Skull_Sequences)	Sequence	SeeEnemySeq[3];
var(Skull_Sequences)	Sequence	SecretSeq[3];

var(Sound)	sound	SpawningSounds[1];				// Spawning Sounds
var(Sound)	sound	CommentSounds[3];				// Comment sounds
var(Sound)	sound	ScreamingSounds[2];				// Screaming sounds
var(Sound)	sound	OnFireSound;
// ================================================
// This function is called after the skull is spawned from SkullStorm.uc
// the Spell knows how many skulls it has created, and calls this function
// on each after spawning them to give then their location offset from the player.
function SetOffset(int i)
{
	switch(i)
	{
		case 0:
			PlayerOffset = vect(16,2,-5);
			break;

		case 1:
			PlayerOffset = vect(16,7,0);
			break;

		case 2:
			PlayerOffset = vect(16,12,-5);
			break;

		case 3:
			PlayerOffset = vect(16,7,-10);
			break;
	};
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	SpawnLocation = Location;
	
	if ( Owner == none )
	{
		// no owner?  go away
		Destroy();
	} else {
		// set Player as my owner
		Player = Pawn(Owner);
		
		// randomize the rotation rate
		RotationRate.Yaw = RandRange(32768, 60000);
		RotationRate.Pitch = RandRange(32768, 60000);
		RotationRate.Roll = RandRange(32768, 60000);
		
		// next time 
		NextTimeCheck = Level.TimeSeconds + 15;

		Frenzy = 0.0;
		DrawScale = 0.075;
	}
}

function ZoneChange( ZoneInfo NewZone )
{
	if ( NewZone.bWaterZone )
	{
		if (!bInWater)
		{
			bInWater = true;
			spawn(class 'WaterBigHitFX',,,Location, rotator(vect(0,0,1)));
		}
	} else {
		bInWater = false;
	}
}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	SetLocation(Location+(HitNormal * 32));
	Destroy();
}

function StartEyeFire()
{
	local vector Loc;

	// Left Eye

	// get the eye joint location
	Loc = JointPlace('LEye00').pos;

	// create and attach the flame
	LEyeFire = spawn(class 'SkullEyeFireFX',self,,Loc, rotation);
	LEyeFire.setBase(self, 'LEye00', 'root');

	// Right Eye

	// get the eye joint location
	Loc = JointPlace('REye00').pos;

	// create and attach the flame
	REyeFire = spawn(class 'SkullEyeFireFX',self,,Loc, rotation);
	REyeFire.setBase(self, 'REye00', 'root');
	
	StopSound(SndID);
	SndID = PlaySound(OnFireSound);
	
	SetTimer(1.5, false);
}

function StartFireMouth()
{
	local vector Loc;

	if (MouthFire == none)
	{
		// get the eye joint location
		Loc = JointPlace('Mouth').pos;
	
		// create and attach the flame
		REyeFire = spawn(class 'SkullMouthFireFX',self,,Loc, rotation);
		REyeFire.setBase(self, 'Mouth', 'root');
		PlaySound(OnFireSound);
	}
}

// find a sibling skull
function GetSibling(optional Skull2_proj Skull)
{
	local Skull2_proj TempSkull;
	
	if (Skull != none)
	{
		LookAtActor = Skull;
	} else {
		LookAtActor = none;
		ForEach AllActors(class 'Skull2_proj', TempSkull, Tag)
		{
			if ( LookAtActor == none )
				LookAtActor = TempSkull;
			else
				if (FRand() > 0.5)
					LookAtActor = TempSkull;
		}
	}
}

function Timer()
{
	StopSound(SndID);
}

// play an animation and sound that go together
function PlaySequence(Sequence Seq, float Vol)
{
	Owner.MakeNoise(1.0, 1280);
	PlaySound(Seq.SoundSample,, Vol);
	PlayAnim(Seq.Animation);
}

// Chat to another skull
function Chat(optional Actor Skull)
{
	// log ("Chat Called", 'Misc');
	if ( Skull == none )
		GetSibling(Skull2_proj(Skull));

	if ( LookAtActor != none )
	{
		PlaySequence(GreetSeq[Rand(4)], 0.5);
		NextComTime = LevelTime + 1.5;
		Comm = 'Chat';
		bComReady = true;
		NextTimeCheck = Level.TimeSeconds + 1 + ((1-Frenzy) * (1.0 + (Frand() * 2.0)));
	}
}

// Threaten another skull
function Threaten(optional Actor Skull)
{
	// log ("Chat Called", 'Misc');
	if ( Skull == none )
	{
		GetSibling( Skull2_proj(Skull) );
	}

	if ( LookAtActor != none )
	{
		StartEyeFire();
		Frenzy += 0.25;
		PlaySequence(threatenSeq[Rand(4)], 1);
		NextComTime = LevelTime + 1.5;
		Comm = 'Threaten';
		bComReady = true;
		NextTimeCheck = Level.TimeSeconds + 1 + ((1-Frenzy) * (1.0 + (Frand() * 2.0)));
	}
}

// chat to the player
function ChatPlayer()
{
	GetPlayer();
	if ( LookAtActor != none )
	{
		PlaySequence(GreetSeq[Rand(4)], 0.5);
	}
}

// look to see if we have any enemies
function CheckEnemies()
{
	local Pawn P;
	
	ForEach RadiusActors(class 'Pawn', P, 2048)
	{
		if ( FastTrace(Location, P.Location) )
		{
			if ( (P.Health > 0) && (P != Player) && !P.bScryeOnly )
			{
				bCanSeeEnemy = true;
				LookAtActor = P;
				Frenzy = 1.0;
				break;
			}
		}
	}
}

// recieving a communication from another skull
function AcceptCommunication(Skull2_proj Skull, name Type)
{
	// log ("Accept Communication from "$Skull.name,'Misc');
	switch(Type)
	{
		case 'Chat':
			// log("Accept Communication CHAT",'Misc');
			if (Frenzy < 0.5)
				Chat(Skull);
			else if (FRand() < 0.5)
				Threaten(Skull);
			break;

		case 'Threaten':
			// log("Accept Communication Threaten",'Misc');
			if (Frenzy < 0.5)
				Chat(Skull);
			else if (FRand() < 0.5)
				Threaten(Skull);
			break;
	};
	// recieved communication from skull - let him know not to chat again
	Skull.bComReady = false;
}

// get the player
function GetPlayer()
{
	LookAtActor = Player;
}

function Touch(Actor Other)
{
	if ( !Other.IsA('Skull2_proj') && (Other != Player) && bFlying )
	{
		Super.Touch(Other);
	}
}

function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if ( DamageType == 'none' )
		DamageType = MyDamageType;

	DInfo.Damage = Damage;
	DInfo.DamageType = 'Skull_Concussive';
	DInfo.JointName = CheckJoint();
	DInfo.DamageString = MyDamageString;
	DInfo.bMagical = true;
	DInfo.Deliverer = self;
	DInfo.ManaCost = ManaCost;
	DInfo.DamageMultiplier = 1.0;
	return DInfo;
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other.IsA('Pawn') )
		PlaySound( PawnImpactSound );

	Other.ProjectileHit(Instigator, HitLocation, (MomentumTransfer * Normal(Velocity)), self, getDamageInfo());
}

// look for SkullInfo actors
function CheckSkullInfos()
{
	local SkullStormInfo SkullInfo;

	ForEach VisibleActors(class 'SkullStormInfo', SkullInfo, 512)
	{
		break;
	}

	MySkullInfo = SkullInfo;
	if (MySkullInfo != none)
		LookAtActor = MySkullInfo;
}

// Find something interesting
function CheckInputs()
{
	local float Decision;

	LookAtActor = none;
	
	CheckSkullInfos();		// look for skull interest points
	
	CheckEnemies();			// look for enemies
	
	if ( LookAtActor == none )
	{
		Decision = FRand();
		
		if ( Decision < 0.35 )
			GetSibling();
		else if ( Decision < 0.55 )
			GetPlayer();
		else
			LookAtActor = none;
	}
}

// update everything
function Tick(float DeltaTime)
{
	local vector x, y, z, Loc, dir;
	local float Decision, LevelTime, Dist;
	
	LevelTime = Level.TimeSeconds; //DeltaTime;

	if ( bSpawning )
	{
		PctToHoldLoc += DeltaTime * 3.0;

		// get the view axes of the player - for positioning
		GetAxes(Player.ViewRotation, x, y, z);
		
		// initial location in front of the player
		Loc = (Player.Location + (Vect(0,0,1) * Player.EyeHeight)) + (x * PlayerOffset.x) + (y * PlayerOffset.y) + (z * PlayerOffset.z);
		
		Dist = VSize(Loc - SpawnLocation);
		Dir = Normal(Loc - SpawnLocation) * (Dist * PctToHoldLoc);
		
		// place it
		SetLocation( SpawnLocation + Dir );
		
		if ( PctToHoldLoc >= 1.0 )
			bSpawning = false;

	}
	else if ( !bFlying )
	{
		if ( !AeonsPlayer(Owner).AttSpell.IsA('SkullStorm') || (AeonsPlayer(Owner).bFireAttSpell == 0) )
		{
			Fire();
		}
		
		Age += DeltaTime;		// get older
		
		if ( Age > FrenzyAge )
			Frenzy = FClamp((Frenzy + (DeltaTime * (FRand() * 0.02))), 0, 1);

//		Frenzy = 0;

		if ( (LevelTime >= NextComTime) && bComReady )
		{
			CommSkull.AcceptCommunication(self, Comm);
			bComReady = false;
		}

		// an enemy present overrides frenzy by SkullInfo
		if ( bCanSeeEnemy )
		{
			Frenzy = 1;
		} else {
			// SkullInfo overrides frenzy by age
			if ( MySkullInfo != none )
			{
				LookAtActor = MySkullInfo;
				Frenzy = MySkullInfo.SkullFrenzy;
			}
		}
		
		// get the view axes of the player - for positioning
		GetAxes(Player.ViewRotation, x, y, z);
		
		// initial location in front of the player
		Loc = (Player.Location + (Vect(0,0,1) * Player.EyeHeight)) + (x * PlayerOffset.x) + (y * PlayerOffset.y) + (z * PlayerOffset.z);
		
		// add the bobing movement
		if ( Frenzy < 1 )
		{
			fBob += DeltaTime * (3.0 + (Frenzy * 24.0));
			Loc.z += ( cos(fBob) * (1.0 + ( 1.0 - Frenzy )) );
		} else {
			// removed the skull shake
			//if ( bCanSeeEnemy )
			//	Loc += VRand() * 0.25;
			//else
			//	Loc += VRand() * 0.75;
		}
		
		// place it
		SetLocation(Loc);

		// I have something to look at
		if ( LookAtActor != none )
		{
			// looking at the player... make sure to look at the camera location,
			// or it seems like the skull is looking at your crotch.
			if ( LookAtActor == Player )
				DesiredRotation = Rotator((Player.Location + vect(0,0,1) * Player.EyeHeight) - Location);
			else
				DesiredRotation = Rotator(LookAtActor.Location - Location);
		} else {
			// not looking at anything.. look in the direction the player is looking.
			DesiredRotation = Player.ViewRotation;
		}

		// time to search for input?
		if ( !bComReady )
		{
			if ( LevelTime >= NextInputCheck )
			{
				CheckInputs();
				NextInputCheck = LevelTime + 1;
			}
		}

		// no enemy
		if ( !bCanSeeEnemy )
		{
			// log ("No Enemy", 'Misc');
			if ( !bComReady )
			{
				// log ("bComReady = false", 'Misc');
				// log ("LevelTime = "$LevelTime$" NextTimeCheck = "$NextTimeCheck, 'Misc');
				if ( LevelTime >= NextTimeCheck )
				{
					// log ("bComReady = false", 'Misc');
					
					Decision = FRand();
					
					if ( Frenzy < 0.75 )
					{
						if ( Decision < 0.45 )
						{
							Chat();
						} else if ( Decision < 0.90 ) {
							GetPlayer();
						} else {
							// only a 10% chance they will threaten something if their frenzy is low.
							Threaten();
						}
					} else {
						Threaten();
					}
					NextTimeCheck = LevelTime + 1 + ((1-Frenzy) * (1.0 + (Frand() * 2.0))) * 2;
					// log ("NextTimeCheck set to "$NextTimeCheck, 'Misc');
				}
			} else {
				// log ("bComReady = true", 'Misc');
			}
		} else {
			if ( LevelTime >= NextTimeCheck )
				Threaten(LookAtActor);
		}
	} else {
		// ============================================================================
		// we are flying ==============================================================
		// ============================================================================
		if ( SeekPawn == none )
			SeekPawn = GetLitPawn(seekPawn, 4096, Location);
		
		if ( SeekPawn != none )
		{
			SeekDir = Normal(SeekPawn.Location - Location);
			CurrentDir = vector(rotation);
			
			SetRotation(Rotator(Normal((SeekDir * DeltaTime * SeekPawn.LitAmplitude) + CurrentDir)));
			Velocity = Vector(Rotation) * Speed;
		
			/*
			currentDir = Normal(Vector(Rotation));
			SeekingDir = Normal(seekPawn.location - Location);
			SeekWt = seekWeight[SeekPawn.LitAmplitude];
			SeekingDir = Normal( (SeekingDir * SeekWt) + (currentDir * (1.0 - SeekWt)) );
			deviation *= 0.5;
			*/

		}

		// ============================================================================
	}
}

// Destroyed .. cleanup
function Destroyed()
{
	if ( SndID > 0 )
		StopSound(SndID);
	
	if ( bInWater )
	{
		Spawn (class 'UnderwaterExplosionFX',,,Location);
		PlaySound(UnderWaterExplosionSound);
	} else {
		Spawn(class 'SkullExplosion',Owner,,Location);
	}

	// kill the smoke trail
	SmokeTrail.bShuttingDown = true;
}

function Fire()
{
	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fSkulls += 1.0;
	
	bFlying = true;					// I am flying - Tick() checks this to see if positions, etc need to be updated.
	
	// turn off the timer
	SetTimer(0 ,false);

	// turn on mrm
	bMRM = true;

	// make it go
	Velocity = Vector(Player.ViewRotation) * Speed;

	// eyes front!
	SetRotation(Player.ViewRotation);
	SetPhysics(PHYS_Projectile);

	// a little bigger - normal drawscale is 0.25
	DrawScale = 0.35;
	// SetCollisionSize(16, 16);

	// Smoke Trail
	SmokeTrail = spawn(class'SkullStorm_particles', self,,Location);
	SmokeTrail.setBase(self);

	// Sound
	PlaySound(ScreamingSounds[Rand(2)]);

	// Animation
	LoopAnim('OpenBig');
}

defaultproperties
{
     bSpawning=True
     FrenzyAge=10
     UnderWaterExplosionSound=Sound'Aeons.Weapons.E_Wpn_DynaExplUnderwater01'
     GreetSeq(0)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullTalkS01',Animation=TalkS01)
     GreetSeq(1)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullTalkS02',Animation=TalkS02)
     GreetSeq(2)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullTalkS03',Animation=TalkS03)
     GreetSeq(3)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullTalkS04',Animation=TalkS04)
     GreetSeq(4)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullTalkL01',Animation=TalkL01)
     GreetSeq(5)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullTalkL02',Animation=TalkL02)
     GreetSeq(6)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullTalkL03',Animation=TalkL03)
     ThreatenSeq(0)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullThreatL01',Animation=ThreatL01)
     ThreatenSeq(1)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullThreatS01',Animation=ThreatS01)
     ThreatenSeq(2)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullThreatL02',Animation=ThreatL02)
     ThreatenSeq(3)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullThreatS02',Animation=ThreatS02)
     ThreatenSeq(4)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullThreatL03',Animation=ThreatL03)
     ThreatenSeq(5)=(SoundSample=Sound'Aeons.Spells.E_Spl_SkullThreatL04',Animation=ThreatL04)
     SpawningSounds=Sound'Aeons.Spells.E_Spl_Skulllaunch01'
     CommentSounds(0)=Sound'Aeons.Spells.E_Spl_SkullTalkS01'
     CommentSounds(1)=Sound'Aeons.Spells.E_Spl_SkullTalkS02'
     CommentSounds(2)=Sound'Aeons.Spells.E_Spl_SkullTalkS03'
     ScreamingSounds(0)=Sound'Aeons.Spells.E_Spl_SkullScream02'
     ScreamingSounds(1)=Sound'Aeons.Spells.E_Spl_SkullScream01'
     OnFireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_SkullFireLoop01'
     Speed=2000
     MaxSpeed=10000
     Damage=20
     ExploWallOut=32
     Physics=PHYS_Rotating
     RotationRate=(Pitch=32768,Yaw=32768,Roll=32768)
     Mesh=SkelMesh'Aeons.Meshes.Skull_proj'
     DrawScale=0.25
     bMRM=False
     CollisionRadius=3
     CollisionHeight=4
     bRotateToDesired=True
}
