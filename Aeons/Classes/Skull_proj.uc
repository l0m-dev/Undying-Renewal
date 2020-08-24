//=============================================================================
// Skull_proj.
//=============================================================================
class Skull_proj expands SpellProjectile;

//#exec MESH IMPORT MESH=Skull_Proj SKELFILE=skull_Proj.ngf

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

// User vars
var() 	float 		evalInterval; 				// time interval the projectile re-evaluates itself for speed and direction
var() 	float 		seekVelocitySeed;
var() 	float 		waitDistance;
var() 	float 		waitDistanceOffset;
var() 	float 		randomSpawnPosOffset;
var() 	float 		hOffset;
var()	float		randFlight;
var()	sound		UnderWaterExplosionSound;

// Sequences
var(Skull_Sequences)	Sequence	GreetSeq[7];
var(Skull_Sequences)	Sequence	InquireSeq[3];
var(Skull_Sequences)	Sequence	ThreatenSeq[6];
var(Skull_Sequences)	Sequence	SeeEnemySeq[3];
var(Skull_Sequences)	Sequence	SecretSeq[3];

var(Sound)  SkullSoundParams SpawnSounds[10];
var(Sound)  SkullSoundParams GreetSounds[10];
var(Sound)  SkullSoundParams ChatSounds[10];
var(Sound)  SkullSoundParams ScreamSounds[10];

var(Sound)	sound	SpawningSounds[1];				// Spawning Sounds
//var(Sound)	sound	GreetingSounds[5];				// Greeting Sounds
var(Sound)	sound	CommentSounds[3];				// Comment sounds
var(Sound)	sound	ScreamingSounds[2];				// Screaming sounds

// Internal vars
var		bool		bLookRandom;
var		bool		bInWater;
var 	int 		spawnCount, i;
var 	int 		Count, numSkull;
var		int			SkullSlot;
var 	float 		floatDistance, floatDistOffset, seekVelocity, defaultSeekVelocity, defaultDrawScale, rotPercent, rf, bobRate, bobAmount, fBob;
var 	vector 		X,Y,Z, offsetZ, offsetX, offsetY, seekDir, seekLoc, tempSeekLoc, rVector, skullPos, spawnOffset, fOffset, vOffset, randomVector, loc, masterDir;
var 	rotator 	rot, rotOffset, desiredRotOffset;
var 	Actor 		lookAtActor; 				// actor the skull will look at
var		SkullStorm	WeaponOwner;
var		Vector		SourceSkullPositions[3];	// the offset skull positions in player space (center, left, and right)
var		Vector		SkullPositions[3];			// the offset skull positions in player space (center, left, and right)
var		SkullStorm_particles	ps;				// particleSystem Trail

var		ParticleFX	REyeFire;					// Right Eye Fire
var		ParticleFX	LEyeFire;					// Left Eye Fire
var		ParticleFX	MouthFire;					// Mouth Fire

// Sibling data
var 	Skull_proj 	skullSiblings[2]; 			// array holds sibling Skull_proj classes
var 	int 		numSiblings; 				// number of siblings this skull has

// Skull Bahavior
var		float		turnRate;					// 0->1 value used to modify the rate the skulls turn at
var		float		excitement;					// how excited the skull is 0->1
var		float		playerMoveRate;				//
var 	pawn 		seekPawn; 					// Pawn to seek (fireFly spell support)
var		vector		warpOffset;
var		vector		eyeOffset;
var		vector		lookOffset;
var		LightningPoint lp;
var		Wind		wind;

///////////////////////////////////////////////////////
function PreBeginPlay()
{
	// lookAtActor = Pawn(Owner);
	turnRate = 0.1;

	SourceSkullPositions[0].x = waitDistance;
	SourceSkullPositions[0].y = hOffset;
	SourceSkullPositions[0].z = -8;

	SourceSkullPositions[1].x = waitDistance-8;
	SourceSkullPositions[1].y = 0;
	SourceSkullPositions[1].z = -14;

	SourceSkullPositions[2].x = waitDistance-8;
	SourceSkullPositions[2].y = hOffset * 2;
	SourceSkullPositions[2].z = -14;
	
	SkullPositions[0] = SourceSkullPositions[0];
	SkullPositions[1] = SourceSkullPositions[1];
	SkullPositions[2] = SourceSkullPositions[2];
	
	excitement = 0.01;
	
	eyeOffset.z = Pawn(Owner).baseEyeheight;
	// lp = spawn(class 'LightningPoint');
	
}

function PlaySequence(Sequence Seq)
{
	PlaySound(Seq.SoundSample);
	PlayAnim(Seq.Animation);
}


function StartFireLeftEye()
{
	local vector Loc;

	if (LEyeFire == none)
	{
		// get the eye joint location
		Loc = JointPlace('LEye00').pos;
	
		// create and attach the flame
		LEyeFire = spawn(class 'SkullEyeFireFX',self,,Loc, rotation);
		LEyeFire.setBase(self, 'LEye00', 'root');
	}
}

function StopFireLeftEye()
{
	if (LEyeFire != none)
	{
		// shut it down
		LEyeFire.bShuttingDown = true;
	}
}

function StartFireRightEye()
{
	local vector Loc;

	if (REyeFire == none)
	{
		// get the eye joint location
		Loc = JointPlace('REye00').pos;
	
		// create and attach the flame
		REyeFire = spawn(class 'SkullEyeFireFX',self,,Loc, rotation);
		REyeFire.setBase(self, 'REye00', 'root');
	}
}

function StopFireRightEye()
{
	if (REyeFire != none)	
	{
		// shut it down
		REyeFire.bShuttingDown = true;
	}
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
	}

}

function StopFireMouth()
{
	if (MouthFire != none)
	{
		// shut it down
		MouthFire.bShuttingDown = true;
	}
}

// returns the location of the closest point in the level geometry withing the radius specified.
function vector getCloseLevelLoc(float Radius)
{
	local int HitJoint;
	local float closeDist, iDist;
	local vector skullViewDir, startTrace, endTrace, HitNormal, HitLocation, LevelLocation;
	local rotator aimOffset, PawnViewRot;
	
	closeDist = radius;
	
	//aimOffset.roll = 60 * randRange(-1.0,1.0) * 182.04;
	//aimOffset.pitch = 60 * randRange(-1.0,1.0) * 182.04;
	//aimOffset.yaw = 60 * randRange(-1.0,1.0) * 182.04;

	PawnViewRot = Pawn(Owner).ViewRotation;

	skullViewDir = Normal(Vector(PawnViewRot));
	startTrace = Location;
	endTrace = startTrace + (skullViewDir * Radius);
	Trace(HitLocation, HitNormal, HitJoint, endTrace, startTrace, false);
	LevelLocation = HitLocation;
	
/*
	for (i = 0; i < 8; i++)
	{
		// skullViewDir = Normal(Vector(Rotation));
		skullViewDir = Normal(Vector(PawnViewRot));
		startTrace = Location;
		endTrace = startTrace + (skullViewDir * Radius);
		Trace(HitLocation, HitNormal, HitJoint, endTrace, startTrace, false);
		iDist = VSize(HitLocation - Location);
		if ( iDist < closeDist)
		{
			closeDist = iDist;
			LevelLocation = HitLocation;
		}
	}
*/
	return LevelLocation;
}

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	//if ( DInfo.damage > 5 )
	//	BlowUp(Location, vect(0,0,1));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	if (ps != none)
		ps.bShuttingDown = true;	// Destroy the particle system
	Destroy();		// Destroy self
}

// called when the class enters the game
function PostBeginPlay()
{
	// Velocity = Vector(Rotation) * Speed;
	Super.PostBeginPlay();
	defaultDrawScale = DrawScale;
	DrawScale = 0.0;
	offsetX.x = 64;
	offsetZ.z = 64;
	//floatDistOffset = (FRand() * waitDistanceOffset * randomSign());
	floatDistOffset = 0;
	floatDistance = waitDistance + floatDistOffset;
	// rVector = normal(rVector);
	seekVelocity = seekVelocitySeed + ( RandRange(0.0, 1.0) * (seekVelocitySeed * 0.8) );
	defaultSeekVelocity = seekVelocity;
}

// -------------------------------------------------------------
// Skull conversations
// -------------------------------------------------------------

// threaten another skull
function threaten(Skull_proj skull)
{
	local vector dir;
	local int id;
	
	StartFireLeftEye();
	StartFireRightEye();
 	StartFireMouth();

	dir = Normal( skull.location - location );
	turnRate = 0.5;
	PlaySequence(ThreatenSeq[Rand(6)]);
//	id = playSound(GreetingSounds[Rand(4)]);
	//loopAnim('OpenJawBig',2);
	// FinishSound(id);
	// play threaten animation
	// play threaten sound
	//log("Hey... up yours, "$skull.name);
	//log("I am "$self.name);
	skull.beThreatened(self);
	lunge(dir);
}

// be threatened by another skull
function beThreatened(Skull_proj skull)
{
	//log("Are you threatening me?");
	if (FRand() > 0.5)
		threaten(skull);	// threaten him back
	else {
		//log("Look, it's my fault... sorry, "$skull.name);
		lookAtActor = none;
		lookOffset = vect(0,0,0);
		return;
	}
}

// strike up a conversation with another skull
function chat(Skull_proj skull)
{
	local string s;

	StopFireLeftEye();
	StopFireRightEye();

	s = "";
	// play chat animation
	// play chatting sound
	//log("Hi what's up, "$skull.name);
	//log("I am "$self.name);
	PlaySequence(GreetSeq[Rand(4)]);
	// playSound(GreetingSounds[Rand(4)]);
	//loopAnim('Open');
	skull.doneChatting(self);	// done chatting, ket the other skull know
	lookAtActor = skull;	// keep looking at him
	lookOffset = vect(0,0,0);
	SetTimer((2.0 + fRand()), True);
	return;
}

// called within the chat function of another skull when he is dome saying something
function doneChatting(Skull_proj skull)
{
	if ( Frand() > 0.5 ) {
		Chat(skull);	// chat back
		//log("Hello, "$skull.name);
		//log("I am "$self.name);
	} else {
		lookAtActor = none;
		lookOffset = vect(0,0,0);
		if ( FRand() > 0.5 )
		{
			//log("I don't want to talk to you, "$skull.name);
			//log("I am "$self.name);
		} else {
			 threaten(skull);
		}
		return;			// don't chat
	}
}

// lunge in a direction
function lunge(vector direction)
{
	// implement this
	
}


/*
Each skull spawned goes through several states - Spawning, Waiting, and Flying.  During the Spawning state,
the skull re-evaluates itself each Tick(), growing in size.  When it reaches it's desired DrawScale, it goes into
the Waiting state, where it constantly seeks a position infrom of the players view.  When the player lets up the fire button,
all skull actors are put into their flying state.
*/

// Spawning state (growing from the ground)
auto state Spawning
{
	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
	}

	/*
	function Tick (float DeltaTime)
	{
		if ( DrawScale < defaultDrawScale )
		{
			// seekLoc = (skullPos >> Pawn(Owner).ViewRotation) + Pawn(Owner).Location;
			// SetLocation(((Pawn(Owner).Location) + (Vector(Pawn(Owner).ViewRotation) * floatDistance + rVector) - offsetZ));
			// SetLocation((Pawn(Owner).Location) + (Vector(Pawn(Owner).ViewRotation) * floatDistance) - offsetZ + offsetY);
			DrawScale += 0.08;
		}
		
		/* else {
			gotoState('Waiting');
		}*/
	}
	*/

	function Timer()
	{
		DrawScale = defaultDrawScale;
		gotoState('Waiting');
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
	}

	Begin:
		setTimer(0.5, false);
		SetPhysics(PHYS_None);
}

function Warped(vector oldLocation)
{
	warpOffset = Location - oldLocation;
}

// waiting to be fired, looking for input
state Waiting
{

	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
		if ( Pawn(Other) != Pawn(Owner) )
			Destroy();
	}

	simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
	{
	}

	// updateds the seekVelocity if needed
	// some functions slow the skulls down, this function
	// speeds them back up gradually to their target velocity, defaultSeekVelocity
	function updateSeekVelocity()
	{
		if ( seekVelocity < defaultSeekVelocity )
		{
			seekVelocity *= 1.3;
			if ( seekVelocity > defaultSeekVelocity )
				seekVelocity = defaultSeekVelocity;
		}
	}

	function Tick (float DeltaTime)
	{

		local vector currentDir, finalDir, closeLocation, eyeLoc;
		local WarpZoneInfo zi;
		local WarpZoneInfo OtherSideActor;
		local rotator r;

		if ( Owner == None ) 
		{
			Destroy();
			return;
		}
		// setPhysics(PHYS_None);

		fBob += bobRate;
		

		skullPos.z = SourceSkullPositions[numSkull].z + (cos(fBob) * bobAmount);

		closeLocation = getCloseLevelLoc(256.0);
		
		// track the player's movement rate
		playerMoveRate = VSize(Owner.velocity);

		// current direction we are looking
		currentDir = Normal(Vector(Rotation));
		
		eyeLoc = Pawn(Owner).Location + eyeOffset;

		// transform the location in playerspace to a location in World Space
		seekLoc = (skullPos >> Pawn(Owner).ViewRotation) + eyeLoc + tempSeekLoc;

		if ( VSize(closeLocation - eyeLoc) < VSize(seekLoc - eyeLoc) )
			seekLoc = closeLocation + Normal(eyeLoc - closeLocation * 64);

		/*
		if (Level.getZone(seekLoc) != region.zoneNumber)	// seek location zone ID is a different location than the actor location
		{
			forEach AllActors(class 'WarpZoneInfo', zi)
			{
				if ( Level.GetZone(seekLoc) == Level.GetZone(zi.Location) )		// same zone
				{
					foreach AllActors( class 'WarpZoneInfo', OtherSideActor )
						if( string(OtherSideActor.ThisTag) ~= zi.OtherSideURL && OtherSideActor != zi )
							break;
					// log("OthersideActor = "$OthersideActor$"   zi = "$zi);
					warpOffset = OtherSideActor.Location - zi.Location;
					// log("warpOffset: "$warpOffset);
					// setLocation(seekLoc + warpOffset);
				}
			}
		} else {
			// log("setting warpOffset to [0,0,0]");
			warpOffset = vect(0,0,0);
		}
*/
		// the seeking location in front of the player
		// seekLoc += warpOffset;


		
		if (Level.getZone(seekLoc) == 0)
			log("Out of level");

		/*
		if (Level.getZone(seekLoc) != region.zoneNumber)
			forEach AllActors(class 'WarpZoneInfo', zi)
			{
				if ( Level.GetZone(seekLoc) == Level.GetZone(zi.Location) )
				{
					foreach AllActors( class 'WarpZoneInfo', OtherSideActor )
						if( string(OtherSideActor.ThisTag) ~= zi.OtherSideURL && OtherSideActor != zi )
							break;
					
					zi.UnWarp(seekLoc, Velocity, r);
					OtherSideActor.Warp(seekLoc, Velocity, r);
				}
			}
*/

		// lp.setLocation(closeLocation);
		// lp.setLocation(seekLoc + warpOffset);
		// setLocation(seekLoc);

		// log("Zone ID: "$Level.getZone(seekLoc));
		// log("ZoneInfo: "$Region.Zone);
		// log("ZoneNumber: "$Region.ZoneNumber);
		// calculate what direction the skull needs to move to get to it's seeking location

		seekDir = (seekLoc + warpOffset) - Location;

		// calc the velocity - note the seekDir is not normalized,
		// this allows for the skull to move slower when it it closer to it's seeking target,
		// as the magnitude of the vector is < 1

		updateSeekVelocity();
		Velocity = ( seekDir * seekVelocity );

		// cunstruct a rotator from the vector direction between it's position
		// and the actor position and apply it
		if ( !bLookRandom )
		{
			if ( lookAtActor != none )
				finalDir = Normal( (Normal((lookAtActor.Location + lookOffset) - Location) * turnRate) + (currentDir * (1.0 - turnRate)) );
			else if( PlayerPawn(Owner) != none )
				finalDir = Normal( (Normal(Vector(PlayerPawn(Owner).ViewRotation)) * turnRate) + (currentDir * (1.0 - turnRate)) );
				// finalDir = Normal( (Normal(PlayerPawn(Owner).velocity) * turnRate) + (currentDir * (1.0 - turnRate)) );
			else if( ScriptedPawn(Owner) != none )
				finalDir = Normal( (Normal(Vector(Owner.Rotation)) * turnRate) + (currentDir * (1.0 - turnRate)) );
		} else {
			finalDir = (randomVector * turnRate) + (currentDir * (1.0 - turnRate));
		}
		setRotation(rotator(finalDir));
	}

	// returns a random skull from the weapon owner
	function skull_proj getRandomSkull()
	{
		local 	int 		i;				// iterator
		local 	Skull_proj 	tempSkull;		// temporary skull

		i = Rand(WeaponOwner.numSummonedSkulls);
		if (tempSkull != self) 
			return WeaponOwner.summonedSkulls[i];
	}

	// polls the weapon owner and gets a new skull to look at
	function getNewLookAtSkull()
	{
		local 	int 		i;				// iterator
		local 	Skull_proj 	tempSkull;		// temporary skull

		i = Rand(WeaponOwner.numSummonedSkulls);
		tempSkull = WeaponOwner.summonedSkulls[i];
		if (tempSkull != self) 
			lookAtActor = tempSkull;
	}

	// polls the weapon owner for another skull that is not itself and swaps positions with it
	function swapSkull()
	{
		local 	int 			i, tempSlot;
		local	Skull_proj		tempSkull;
		
		bLookRandom = false;
		i = Rand(WeaponOwner.numSummonedSkulls);
		tempSkull = WeaponOwner.summonedSkulls[i];
		
		if (tempSkull != self)
		{
			self.skullPos = SourceSkullPositions[tempSkull.SkullSlot];
			self.seekVelocity = (0.3 + FRand());
			self.lookAtActor = tempSkull;
			
			tempSkull.skullPos = SourceSkullPositions[SkullSlot];
			tempSkull.seekVelocity = (0.3 + FRand());
			tempSkull.lookAtActor = self;			

			tempSlot = self.SkullSlot;
			self.SkullSlot = tempSkull.SkullSlot;
			tempSkull.SkullSlot = tempSlot;
		}
		
		//log(name$"--- Skull Slot ---"$SkullSlot);
	}

	function Comment()
	{
		local int	i, sndIdx;
		local float total, Weights[10], decision;
		local float offsets[10], bigOffset;
		
		for (i=0; i<10; i++)
			total += ChatSounds[i].Weight;

		for (i=0; i<10; i++)
			weights[i] = ChatSounds[i].Weight / total;

		decision = FRand();
		
		for (i=0; i<10; i++)
			offsets[i] = weights[i]-decision;
		
		sndIdx = 0;
		for (i=0; i<10; i++)
		{
			
		}

		playSound(CommentSounds[Rand(2)]);
		LoopAnim('OpenJawBig');
	}

	// threaten the player
	function threatenPlayer()
	{
		local vector dir;

		lookAtPlayer();
		// play threaten animation
		// play threaten sound
		dir = Normal(Owner.location - location);
		lunge(dir);
	}
	
	// look forward, in the player viewRotation direction
	function lookForward()
	{
		bLookRandom = false;
		lookAtActor = none;
		SetTimer((0.5 + fRand()), True);
		turnRate = 0.1;
	}

	// look at the player
	function lookRandom()
	{
		bLookRandom = true;
		randomVector = Normal(VRand());
		turnRate = 0.2;
		SetTimer((3.0 + fRand()), True);
		if ( FRand() > 0.33 )
			Comment();
	}

	// look at the player
	function lookAtPlayer()
	{
		bLookRandom = false;
		lookAtActor = Owner;
		lookOffset = vect(0,0,1) * Pawn(Owner).baseEyeheight; 
		turnRate = 0.2;
		SetTimer((1.0 + fRand()), True);
		if ( FRand() > 0.5 )
		{
			PlaySequence(GreetSeq[rand(7)]);
			LoopAnim('OpenJaw');
		}
	}

	// look at another skull
	function lookAtSkull()
	{
		bLookRandom = false;
		getNewLookAtSkull();
		SetTimer((3.0 + fRand()), True);
		turnRate = 0.3;
		if ( FRand() > 0.5 )
		{
			PlaySequence(GreetSeq[rand(7)]);
			//playSound(CommentSounds[Rand(2)]);
			//LoopAnim('OpenJaw');
		}
	}

	function Timer()
	{
		local 	Pawn 		p;
		local 	float 		decision;
		local 	float		lookSkullWt, lookPlayerWt, lookDirWt;
		
		PlayAnim('none');
		// log("Warp Offset: "$warpOffset);
		// try and find an enemy
		forEach VisibleActors(class 'Pawn',p)
		{
			if ( (p != Pawn(Owner)) && (p.Health > 0) )
			{
				lookAtActor = p;
				turnRate = 0.6;
				bobRate = 0.5;
				bobAmount = 6;
			} else {
				lookAtActor = none;
				turnRate = 0.2;
				bobRate = 0.1;
				bobAmount = 4;
			}
		}

		if ( (ScriptedPawn(Owner) != none) && (ScriptedPawn(Owner).Enemy != none) )	// Just go.
		{
			// SkullStorm(TraceFire(0.0, HitLocation);
			seekLoc = Owner.Location + 4096 * Normal(ScriptedPawn(Owner).Enemy.Location - Location);
			lookAtActor = ScriptedPawn(Owner).Enemy;
			gotoState('Flying');
		}
		// no enemy, do waiting bahaviors
		else if ( lookAtActor == none )
		{
			decision = FRand();
			
			if ( decision < 0.5 )
				lookForward();
			else
				doSomethingElse();		// start doing waiting bahaviors
		}
	}

	// this function decides what the skull is going to do if it does not look forward
	function doSomethingElse()
	{
		local float 		decision;
		local skull_proj	tempSkull;
		
		decision = FRand();
		
		if ( decision < 0.2 )
			swapSkull();					// swap positions with another skull
		else if ( decision < 0.4 )
			lookAtPlayer();					// look at the player
		else if ( decision < 0.5 )
			lookrandom();					// look in a random direction
		else if ( decision < 0.6 )
			lookAtSkull();					// look at another skull
		else {
			tempSkull = getRandomSkull();
			if ( tempSkull != self )
				Chat( tempSkull );			// chat with another skull
		}
	}

	Begin:
		//log("My Name is "$name$" and I'm in slot"$skullSlot);
		SetPhysics(PHYS_Projectile);
		// bCollideWorld = false;

		if (numSkull == 0)
			skullPos = SourceSkullPositions[0];

		if (numSkull == 1)
			skullPos = SourceSkullPositions[1];

		if (numSkull == 2)
			skullPos = SourceSkullPositions[2];

		SetTimer((1.0 + fRand()), True);
		
		// bobbing
		fBob = 0;
		bobRate = 0.1;
		bobAmount = 4;
		loopAnim('OpenClose');
		// sleep(3);
		if( (PlayerPawn(Owner) != none) && (PlayerPawn(Owner).bFireAttSpell == 0) )
		{
			// SkullStorm(TraceFire(0.0, HitLocation);
			seekLoc = PlayerPawn(Owner).Location + (vector(PlayerPawn(Owner).ViewRotation) * 4096);
			lookAtActor = none;
			gotoState('Flying');
		}
}

// flying, possibly seeking
state Flying
{
	simulated function BeginState()
	{	
		// local LightningPoint ltpt;

		Super.BeginState();
		LifeSpan = 10;
		SetTimer(0.05, true);
		Velocity = Vector(Pawn(Owner).ViewRotation) * default.Speed;
		setRotation(Pawn(Owner).ViewRotation);
		randFlight = FClamp(randFlight, 0.0, 1.0);
		
		ps = spawn(class'SkullStorm_particles', self,,Location);
		ps.setBase(self);
	}

	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
		if ( Pawn(Other) != Pawn(Owner) )
		{
			//Other.ProjectileHit(Instigator, HitLocation, MomentumTransfer * Normal(Velocity), self, GetDamageInfo());
			//Other.HurtRadius(384.0, 'exploded', MomentumTransfer, Location, getDamageInfo() );
			BlowUp(HitLocation, Normal(Location-HitLocation));
		}
	}

	function Tick(float deltaTime)
	{
	}

	function Timer()
	{
		local vector 	SeekingDir, currentDir;
		local vector 	sd;						// weighted var for seeking direction
		local vector 	cd;						// weighted var for current direction
		local vector 	rd;						// weighted var for random direction

		randFlight *= 0.5;

		currentDir = Normal( Vector(Rotation) );

		if ( SeekPawn == none )
		{
			/// no pawn lit by firefly - look for one
			seekPawn = getLitPawn(seekPawn, 4096, Location);
			sd = Normal(seekLoc - Location);
			/// sd = vect(0,0,0);
			rd = VRand() * randFlight;
			cd = currentDir * 0.75;
		} else {
			// flying normally, calculate new direction
			sd = Normal(seekPawn.location - Location); // * 0.5;
			rd = vect(0,0,0); // VRand() * 0.1;
			cd = currentDir * 0.25;
		}

		// set seeking direction
		SeekingDir = Normal(sd + rd + cd);
		Velocity =  SeekingDir * speed;
		SetRotation(rotator(Velocity));

	}

	function ZoneChange( ZoneInfo NewZone )
	{
		// Handle Warpzone
		if ( NewZone.IsA('WarpZoneInfo') )
			seekLoc = Location + masterDir * 4096;

		// Handle water Zone
		if ( NewZone.bWaterZone )
			bInWater = true;
		else
			bInWater = false;
	}

	Begin:
		wind = spawn(class 'ProjectileWind',,,Location);
		wind.setBase(self);
		SetPhysics(PHYS_Projectile);
		bCollideWorld = true;
		playSound(ScreamingSounds[Rand(2)]);
		loopAnim('OpenBig');
}

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	if ( Role == ROLE_Authority )
	{
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			if ( Wall.AcceptDamage(GetDamageInfo()) )
				Wall.TakeDamage( instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo());
		MakeNoise(1.0);
	}
	BlowUp(Location, HitNormal);
}

simulated function BlowUp(vector HitLocation, vector HitNormal)
{
	if ( bInWater )
	{
		spawn (class 'UnderwaterExplosionFX',,,Location + HitNormal * 32);
		PlaySound(UnderWaterExplosionSound);
	} else {
		spawn (class 'SkullExplosion',Pawn(Owner),,Location);
	}
	MakeNoise(3.0);
	destroy();
}

simulated function Destroyed()
{
	if (ps != none)
		ps.bShuttingDown = true;
	wind.Destroy();
 	StopFireLeftEye();
 	StopFireRightEye();
 	StopFireMouth();
}

defaultproperties
{
     evalInterval=0.07
     seekVelocitySeed=7
     waitDistance=52
     waitDistanceOffset=8
     randomSpawnPosOffset=32
     hOffset=16
     randFlight=0.3
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
     ChatSounds(0)=(Sound=Sound'Aeons.Spells.E_Spl_SkullTalkL01',Comment="hmm hmmm ahhhh")
     ChatSounds(1)=(Sound=Sound'Aeons.Spells.E_Spl_SkullTalkL02',Comment="This is going to be cool")
     ChatSounds(2)=(Sound=Sound'Aeons.Spells.E_Spl_SkullTalkS03',Comment="he he he hmm hmm hmm")
     SpawningSounds=Sound'Aeons.Spells.E_Spl_Skulllaunch01'
     CommentSounds(0)=Sound'Aeons.Spells.E_Spl_SkullTalkS01'
     CommentSounds(1)=Sound'Aeons.Spells.E_Spl_SkullTalkS02'
     CommentSounds(2)=Sound'Aeons.Spells.E_Spl_SkullTalkS03'
     ScreamingSounds(0)=Sound'Aeons.Spells.E_Spl_SkullScream02'
     ScreamingSounds(1)=Sound'Aeons.Spells.E_Spl_SkullScream01'
     damagePerLevel(0)=40
     damagePerLevel(1)=40
     damagePerLevel(2)=40
     damagePerLevel(3)=40
     damagePerLevel(4)=40
     damagePerLevel(5)=40
     Speed=1200
     Damage=60
     MomentumTransfer=5000
     MyDamageType=skull_concussive
     MyDamageString="Blown up"
     ProjImpactSound=Sound'Aeons.Weapons.E_Wpn_DynaExpl03'
     ExplosionDecal=Class'Aeons.ExplosionDecal'
     bNetTemporary=False
     LifeSpan=0
     LODBias=3
     RotationRate=(Pitch=1024,Yaw=1024,Roll=1024)
     Mesh=SkelMesh'Aeons.Meshes.Skull_proj'
     DrawScale=0.25
     CollisionRadius=8
     CollisionHeight=8
     bRotateToDesired=True
}
