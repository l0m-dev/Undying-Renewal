//=============================================================================
// Phoenix_proj. 
//=============================================================================
class Phoenix_proj expands SpellProjectile;

// #exec MESH IMPORT MESH=Phoenix_m SKELFILE=Phoenix_proj_m.ngf
//#exec MESH IMPORT MESH=Phoenix_m SKELFILE=Phoenix.ngf INHERIT=DarkBat_m

var Pawn Guider;
var rotator OldGuiderRotation, GuidedRotation;
var float CurrentTimeStamp, LastUpdateTime,ClientBuffer,ServerUpdate;
var bool bUpdatePosition;
var bool bDestroyed;

var SavedMove SavedMoves;
var SavedMove FreeMoves;

var sound LaunchSound;
var sound ReleaseSound;
var sound Flap1Sound, Flap2Sound;
var sound ExpireSound;
var vector RealLocation, RealVelocity;
var ParticleFX SmokeTrail;

replication
{
	// Things the server should send to the client.
	unreliable if( Role==ROLE_Authority )
		ClientAdjustPosition, bDestroyed;
	unreliable if ( Role==ROLE_Authority && bNetOwner && bNetInitial )
		GuidedRotation, OldGuiderRotation;
	unreliable if( Role==ROLE_Authority && !bNetOwner )
		RealLocation, RealVelocity;
	unreliable if( Role==ROLE_AutonomousProxy )
		ServerMove;
}

simulated function ZoneChange( Zoneinfo NewZone )
{
	if ( NewZone.bWaterZone)
	{
		Destroy();
	}
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	if ( Other.IsA('Pawn') )
		PlaySound(PawnImpactSound);

	if (bCanHitInstigator || Other != Owner)
	{
		Other.ProjectileHit(Instigator, HitLocation, (MomentumTransfer * Normal(Velocity)), self, getDamageInfo());
		if (Other.IsA('Pawn'))
			Pawn(Other).OnFire(true);
	}
}

simulated function Timer()
{
	//local ut_SpriteSmokePuff b;
	local float SmokeRate;

	if ( (Role == ROLE_Authority) && (Level.TimeSeconds - ServerUpdate > 4) )
	{
		Explode(Location,Vect(0,0,1));
		return;
	}

//	if ( Trail == None )
	//	Trail = Spawn(class'RedeemerTrail',self);

	/*
	CannonTimer += SmokeRate;
	if ( CannonTimer > 0.6 )
	{
		WarnCannons();
		CannonTimer -= 0.6;
	}
*/
	if ( Region.Zone.bWaterZone || (Level.NetMode == NM_DedicatedServer) )
	{
		SetTimer(SmokeRate, false);
		Return;
	}

	if ( Level.bHighDetailMode )
	{
		if ( Level.bDropDetail )
			SmokeRate = 0.07;
		else
			SmokeRate = 0.02; 
	}
	else 
	{
		SmokeRate = 0.15;
	}
	//b = Spawn(class'ut_SpriteSmokePuff');
	//b.RemoteRole = ROLE_None;
	SetTimer(SmokeRate, false);
}


simulated function Destroyed()
{
	local Phoenix W;
	local name StateName;
	
	StateName = GetStateName();
	SmokeTrail.bShuttingDown = true;
	switch (StateName)
	{
		case 'Flying':
			if (LifeSpan > 0)
			{
				spawn(class 'PhoenixExplosion', Owner,,Location);
				spawn (class 'MolotovExplosion',Owner,,Location);
			} else {
				if ( ExpireSound != none )
					PlaySound(ExpireSound,,2,,4096);
			}
			if ( (PlayerPawn(Guider) != None) )
				PlayerPawn(Guider).ViewTarget = None;
			break;
		
		case 'Release':
			switch ( CastingLevel )
			{
				case 0:
					spawn(class 'PhoenixExplosion0', Owner,,Location);
					break;
		
				case 1:
					spawn(class 'PhoenixExplosion1', Owner,,Location);
					break;
		
				case 2:
					spawn(class 'PhoenixExplosion2', Owner,,Location);
					break;
		
				case 3:
					spawn(class 'PhoenixExplosion3', Owner,,Location);
					break;
		
				case 4:
					spawn(class 'PhoenixExplosion4', Owner,,Location);
					break;
			
				case 5:
					spawn(class 'PhoenixExplosion5', Owner,,Location);
					break;
			}	
			break;
	}
	
	bDestroyed = true;



	While ( FreeMoves != None )
	{
		FreeMoves.Destroy();
		FreeMoves = FreeMoves.NextMove;
	}

	While ( SavedMoves != None )
	{
		SavedMoves.Destroy();
		SavedMoves = SavedMoves.NextMove;
	}

	if ( (Guider != None) && (Level.NetMode != NM_Client) )
	{
		W = Phoenix(Guider.FindInventoryType(class'Phoenix'));
		if ( W != None )
		{
			W.GuidedShell = None;
			W.GotoState('Finishing');
		}
	}
	Super.Destroyed();
}

simulated function Tick(float DeltaTime)
{
	local int DeltaYaw, DeltaPitch;
	local int YawDiff, PitchDiff;
	local SavedMove NewMove;

	if ( Level.NetMode == NM_Client )
	{
		if ( (PlayerPawn(Instigator) != None) && (ViewPort(PlayerPawn(Instigator).Player) != None) )
		{
			Guider = Instigator;
			if ( bDestroyed || (Instigator.health < 0) )
			{
				// PlayerPawn(Instigator).ViewTarget = None;
				Destroy();
				if ( Instigator.Weapon.IsA('Phoenix') )
					Phoenix(Instigator.Weapon).bGuiding = false;
				return;
			}
			// PlayerPawn(Instigator).ViewTarget = self;
			if ( Instigator.Weapon.IsA('Phoenix') )
			{
				Phoenix(Instigator.Weapon).GuidedShell = self;
				Phoenix(Instigator.Weapon).bGuiding = true;
			}
		} else {
			if ( RealLocation != vect(0,0,0) )
			{
				SetLocation(RealLocation);
				RealLocation = vect(0,0,0);
			}
			if ( RealVelocity != vect(0,0,0) )
			{
				Velocity = RealVelocity;
				SetRotation(rotator(Velocity));
				RealVelocity = vect(0,0,0);
			}
			return;
		}
	}
	else if ( (Level.NetMode != NM_Standalone) && (RemoteRole == ROLE_AutonomousProxy) ) 
			return;

	// if server updated client position, client needs to replay moves after the update
	if ( bUpdatePosition )
		ClientUpdatePosition();

	DeltaYaw = (Guider.ViewRotation.Yaw & 65535) - (OldGuiderRotation.Yaw & 65535);
	DeltaPitch = (Guider.ViewRotation.Pitch & 65535) - (OldGuiderRotation.Pitch & 65535);
	if ( DeltaPitch < -32768 )
		DeltaPitch += 65536;
	else if ( DeltaPitch > 32768 )
		DeltaPitch -= 65536;
	if ( DeltaYaw < -32768 )
		DeltaYaw += 65536;
	else if ( DeltaYaw > 32768 )
		DeltaYaw -= 65536;

	YawDiff = (Rotation.Yaw & 65535) - (GuidedRotation.Yaw & 65535) - DeltaYaw;
	if ( DeltaYaw < 0 )
	{
		if ( ((YawDiff > 0) && (YawDiff < 16384)) || (YawDiff < -49152) )
			GuidedRotation.Yaw += DeltaYaw;
	}	
	else if ( ((YawDiff < 0) && (YawDiff > -16384)) || (YawDiff > 49152) )
		GuidedRotation.Yaw += DeltaYaw;

	GuidedRotation.Pitch += DeltaPitch;
	OldGuiderRotation = Guider.ViewRotation;
	if ( Role == ROLE_AutonomousProxy )
	{
		// Send the move to the server
		// skip move if too soon
		if ( ClientBuffer < 0 )
		{
			ClientBuffer += DeltaTime;
			MoveRocket(DeltaTime, Velocity, GuidedRotation);
			return;
		}
		else
			ClientBuffer = ClientBuffer + DeltaTime - 80.0/PlayerPawn(Instigator).Player.CurrentNetSpeed;

		// I'm  a client, so I'll save my moves in case I need to replay them
		// Get a SavedMove actor to store the movement in.
		if ( SavedMoves == None )
		{
			SavedMoves = GetFreeMove();
			NewMove = SavedMoves;
		}
		else
		{
			NewMove = SavedMoves;
			while ( NewMove.NextMove != None )
				NewMove = NewMove.NextMove;
			NewMove.NextMove = GetFreeMove();
			NewMove = NewMove.NextMove;
		}

		NewMove.TimeStamp = Level.TimeSeconds;
		NewMove.Delta = DeltaTime;
		NewMove.Velocity = Velocity;
		NewMove.SetRotation(GuidedRotation);

		MoveRocket(DeltaTime, Velocity, GuidedRotation);
		ServerMove(Level.TimeSeconds, Location, NewMove.Rotation.Pitch, NewMove.Rotation.Yaw);
		return;
	}
	MoveRocket(DeltaTime, Velocity, GuidedRotation);
}

// Server sends ClientAdjustPosition to the client to adjust the warhead position on the client side when the error
// is excessive
simulated function ClientAdjustPosition
(
	float TimeStamp, 
	float NewLocX, 
	float NewLocY, 
	float NewLocZ, 
	float NewVelX, 
	float NewVelY, 
	float NewVelZ
)
{
	local vector NewLocation;

	if ( CurrentTimeStamp > TimeStamp )
		return;
	CurrentTimeStamp = TimeStamp;

	NewLocation.X = NewLocX;
	NewLocation.Y = NewLocY;
	NewLocation.Z = NewLocZ;
	Velocity.X = NewVelX;
	Velocity.Y = NewVelY;
	Velocity.Z = NewVelZ;

	SetLocation(NewLocation);

	bUpdatePosition = true;
}

// Client calls this to replay moves after getting its position updated by the server
simulated function ClientUpdatePosition()
{
	local SavedMove CurrentMove;
	local int realbRun, realbDuck;
	local bool bRealJump;

	bUpdatePosition = false;
	CurrentMove = SavedMoves;
	while ( CurrentMove != None )
	{
		if ( CurrentMove.TimeStamp <= CurrentTimeStamp )
		{
			SavedMoves = CurrentMove.NextMove;
			CurrentMove.NextMove = FreeMoves;
			FreeMoves = CurrentMove;
			FreeMoves.Clear();
			CurrentMove = SavedMoves;
		}
		else
		{
			MoveRocket(CurrentMove.Delta, CurrentMove.Velocity, CurrentMove.Rotation);
			CurrentMove = CurrentMove.NextMove;
		}
	}
}
	
// server moves the rocket based on clients input, and compares the resultant location to the client's view of the location
function ServerMove(float TimeStamp, vector ClientLoc, int Pitch, int Yaw)
{
	local float ClientErr, DeltaTime;
	local vector LocDiff;

	if ( CurrentTimeStamp >= TimeStamp )
		return;

	if ( CurrentTimeStamp > 0 )
		DeltaTime = TimeStamp - CurrentTimeStamp;
	CurrentTimeStamp = TimeStamp;
	GuidedRotation.Pitch = Pitch;
	GuidedRotation.Yaw = Yaw;
	if ( DeltaTime > 0 )	
		MoveRocket(DeltaTime, Velocity, GuidedRotation);
	if ( Level.TimeSeconds - LastUpdateTime > 0.3 )
	{
		ClientErr = 10000;
	}
	else if ( Level.TimeSeconds - LastUpdateTime > 0.07 )
	{
		LocDiff = Location - ClientLoc;
		ClientErr = LocDiff Dot LocDiff;
	}

	// If client has accumulated a noticeable positional error, correct him.
	if ( ClientErr > 3 )
	{
		LastUpdateTime = Level.TimeSeconds;
		ClientAdjustPosition(TimeStamp, Location.X, Location.Y, Location.Z, Velocity.X, Velocity.Y, Velocity.Z);
	}
}

simulated function MoveRocket(float DeltaTime, vector CurrentVelocity, rotator GuideRotation )
{
	local int OldRoll, RollMag;
	local rotator NewRot;
	local float SmoothRoll;
	local vector OldVelocity, X,Y,Z;

	if ( (Role == ROLE_Authority) && ( (Guider == None) || (Guider.Health <= 0)
				|| (Guider.IsA('PlayerPawn') && (PlayerPawn(Guider).ViewTarget != self)) || Guider.IsInState('FeigningDeath')) )
	{
		Explode(Location,Vect(0,0,1));
		return;
	}

	ServerUpdate = Level.TimeSeconds;
	OldRoll = Rotation.Roll & 65535;
	OldVelocity = CurrentVelocity;
	
	Velocity = Vector(GuideRotation);
	Velocity = Normal(Velocity) * speed;

	//Velocity = CurrentVelocity + Vector(GuideRotation) * 1500 * DeltaTime;
	//Velocity = Normal(Velocity) * 550;
	
	NewRot = Rotator(Velocity);

	/*
	// Roll Warhead based on acceleration
	GetAxes(NewRot, X,Y,Z);
	RollMag = int(10 * (Y Dot (Velocity - OldVelocity))/DeltaTime);
	if ( RollMag > 0 ) 
		NewRot.Roll = Min(12000, RollMag); 
	else
		NewRot.Roll = Max(53535, 65536 + RollMag);
	
	//smoothly change rotation
	if (NewRot.Roll > 32768)
	{
		if (OldRoll < 32768)
			OldRoll += 65536;
	}
	else if (OldRoll > 32768)
		OldRoll -= 65536;

	SmoothRoll = FMin(1.0, 5.0 * deltaTime);
	NewRot.Roll = NewRot.Roll * SmoothRoll + OldRoll * (1 - SmoothRoll);
	*/
	
	SetRotation(NewRot);

	if ( (Level.NetMode != NM_Standalone)
		&& ((Level.NetMode != NM_ListenServer) || (Instigator == None) 
			|| (Instigator.IsA('PlayerPawn') && (PlayerPawn(Instigator).Player != None)
				&& (ViewPort(PlayerPawn(Instigator).Player) == None))) )
		AutonomousPhysics(DeltaTime);

	if ( Role == ROLE_Authority )
	{
		RealLocation = Location;
		RealVelocity = Velocity;
	}
}

simulated function PostRender( canvas Canvas )
{
	/*
	local float Dist;
	local Pawn P;
	local int XPos, YPos;
	local Vector X,Y,Z, Dir;

	GetAxes(Rotation, X,Y,Z);
//	Canvas.Font = Font'TinyRedFont';
	if ( Level.bHighDetailMode )
		Canvas.Style = ERenderStyle.STY_Translucent;
	else
		Canvas.Style = ERenderStyle.STY_Normal;
	foreach visiblecollidingactors(class'Pawn', P, 2000,, true)
	{
		Dir = P.Location - Location;
		Dist = VSize(Dir);
		Dir = Dir/Dist;
		if ( (Dir Dot X) > 0.7 )
		{
			XPos = 0.5 * Canvas.ClipX * (1 + 1.4 * (Dir Dot Y));
			YPos = 0.5 * Canvas.ClipY * (1 - 1.4 * (Dir Dot Z));
			Canvas.SetPos(XPos - 8, YPos - 8);
			Canvas.DrawIcon(texture'CrossHair6', 1.0);
			Canvas.SetPos(Xpos - 12, YPos + 8);
			Canvas.DrawText(Dist, true);
		}
	}*/	
}		

simulated function SavedMove GetFreeMove()
{
	local SavedMove s;

	if ( FreeMoves == None )
		return Spawn(class'SavedMove');
	else
	{
		s = FreeMoves;
		FreeMoves = FreeMoves.NextMove;
		s.NextMove = None;
		return s;
	}	
}

auto state Flying
{
	function Timer()
	{
		if ( FRand() >= 0.5 ) 
			PlaySound(Flap1Sound,,,,4096);
		else
			PlaySound(Flap2Sound,,,,4096);
		
		MakeNoise(1.0, 2560);

		setTimer( 0.75 + 0.5*FRand(), false );
		bCanHitInstigator = true;
	}

	function BeginState()
	{
		SmokeTrail = spawn(class'SkullStorm_particles', self,,Location);
		SmokeTrail.setBase(self);

		SetTimer(0.75, false);

		// PlaySound(LaunchSound,,2.0);

		ServerUpdate = Level.TimeSeconds;
		GuidedRotation = Rotation;
		OldGuiderRotation = Rotation;
		Velocity = speed*vector(Rotation);
		Acceleration = vect(0,0,0);
		if ( (Level.NetMode != NM_Standalone) && (Role == ROLE_Authority) )
		{
			if ( (PlayerPawn(Instigator) != None) 
				&& (ViewPort(PlayerPawn(Instigator).Player) != None) )
				RemoteRole = ROLE_SimulatedProxy;
			else
				RemoteRole = ROLE_AutonomousProxy;
		}
	}
}

state Release
{

	function Tick(float DeltaTime);
	
	function BeginState()
	{
		Owner.PlaySound(ReleaseSound,,,,4096);
		//AmbientSound=ReleaseSound;
		Velocity = Vector(Rotation) * speed * 2;
	}

	Begin:
}


/*
var vector LastDir, iDir;
var float damageScalar;
var Pawn Guider;
var Phoenix PhoenixSpell;
var PhoenixParticleFX ParticleTrail;
var MolotovFire_proj fProj;

/*
function Warped(vector oldLocation)
{
	fProj.setLocation(Location);
	fProj.setBase(self);
	PhoenixSpell.pCam.setLocation(Location);
	PhoenixSpell.pCam.setBase(self);
}
*/

function preBeginPlay()
{
	LastDir = Vector(PlayerPawn(Owner).ViewRotation);
	ParticleTrail = spawn(class 'PhoenixParticleFX', self,,Location);
	ParticleTrail.castingLevel = castingLevel;
	ParticleTrail.setup();
	ParticleTrail.setBase(self);
	super.PreBeginPlay();
}

// send a warning to ScriptedPawns within specified radius
function SendWarning()
{
	local ScriptedPawn		sPawn;

	foreach RadiusActors( class 'ScriptedPawn', sPawn, 8192 )
	{
		sPawn.WarnAvoidActor( self, 0.25, 1024, 1.0 );
	}
}

/* Kyle, this was our old   "auto state flying".. the Redeemer had it's own.  we need to merge the 2
auto state Flying
{
	simulated function ProcessTouch (Actor Other, Vector HitLocation)
	{
		if ( Other != Pawn(Owner) )
			Super.ProcessTouch (Other, HitLocation);
	}

	function Destroyed()
	{
		HurtRadius(256.0, 'exploded', MomentumTransfer, Location, getDamageInfo());
		MakeNoise(1.0);
		spawn (class 'DefaultParticleExplosionFX',,,Location);
		ParticleTrail.bShuttingDown = true;
		PhoenixSpell.Bird = none;
		PhoenixSpell.pCam.gotoState('ShutDownRightNow');
		// PhoenixSpell.bActivePhoenix = false;
	}

	function Tick(float DeltaTime)
	{
		iDir = Normal((LastDir * 0.8) + (Vector(PlayerPawn(Owner).ViewRotation) * 0.3));
		Velocity = speed * iDir;
		setRotation(PlayerPawn(Owner).ViewRotation);
		LastDir = iDir;
	}

	function Timer()
	{
		// Send Message out to Pawns within a range - "Fear me!"
		SendWarning();
		SetTimer( 0.20, false );
	}

	Begin:
		Velocity = speed * LastDir;
		Timer();
}
*/


// release state - go forth and destroy!
state Release
{

	function BeginState()
	{
		PhoenixSpell.pCam.Velocity = Velocity;
		// Speed up
		// Velocity *= 4;
	}

	function Tick(float deltaTime)
	{
		local vector dir;

		// Update rotation for control by the player
		dir = Normal(Location - PhoenixSpell.pCam.location);
		PhoenixSpell.pCam.setRotation(Rotator(dir));
		if ( VSize(Velocity) < (default.speed * 4) )
		{
			Velocity *= 1.1;
			damageScalar = (VSize(Velocity) / (default.speed * 4));
		}
	}
	
	function Timer()
	{
		// Send Message out to Pawns within a range - "Fear me!"
		SendWarning();
		SetTimer( 0.20, false );
	}
	
	function Destroyed()
	{
		local phoenixQuake pq;
		local DamageInfo DInfo;
		
		DInfo = getDamageInfo();
		DInfo.Damage = AltDamagePerLevel[castingLevel];
		
		HurtRadius(384, MyDamageType, MomentumTransfer, Location, DInfo);
		GibRadius(384, Location, DInfo);

		MakeNoise(5.0, 2580);
		spawn (class 'DefaultParticleExplosionFX',,,Location);

		// molotov / earthquake effect - only on higher amplitudes.
		if (castingLevel > 2)
		{
			// generate the earthquake
			pq = spawn(class 'PhoenixQuake',,,Location);
			pq.Trigger(none, none);
			SpawnMolotovExplosion(Location);
		}

		ParticleTrail.bShuttingDown = true;
		PhoenixSpell.Bird = none;
		PhoenixSpell.pCam.gotoState('ShutDown');
	}

	simulated function SpawnMolotovExplosion(vector HitLocation)
	{
		local int i;
		local MolotovFire_proj m;

		for (i=0; i<6; i++)
		{
			m = spawn(class 'MolotovFire_proj', self,,HitLocation);
			m.dir = VRand();
			m.gotoState('Flying');
		}
	}

	Begin:
		ParticleTrail.ParticlesPerSec.Base = 100;
		Timer();
}

*/

/*
function Explode(vector Location, vector Normal)
{
	spawn(class 'LightningExplosion',,,Location);
	Destroy();
}
*/

defaultproperties
{
     LaunchSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhoenixLaunch01'
     ReleaseSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhoenixCharge01'
     Flap1Sound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhoenixWingFlap01'
     Flap2Sound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhoenixWingFlap02'
     ExpireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhoenixExpire01'
     damagePerLevel(0)=50
     damagePerLevel(1)=50
     damagePerLevel(2)=50
     damagePerLevel(3)=50
     damagePerLevel(4)=50
     AltDamagePerLevel(0)=100
     AltDamagePerLevel(1)=100
     AltDamagePerLevel(2)=150
     AltDamagePerLevel(3)=150
     AltDamagePerLevel(4)=250
     Speed=1200
     Damage=100
     MyDamageType=phx_concussive
     MyDamageString="blown up"
     bOwnerNoSee=True
     LifeSpan=5
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.Phoenix_m'
     CollisionRadius=8
     CollisionHeight=16
     bProjTarget=True
     LightType=LT_Steady
     LightBrightness=255
     LightHue=28
     LightSaturation=64
     LightRadius=40
     LightRadiusInner=18
}
