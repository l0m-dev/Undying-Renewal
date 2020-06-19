//=============================================================================
// Patrick.
//=============================================================================
class Patrick expands AeonsSinglePlayer;

#exec MESH IMPORT MESH=BaseBiped_m SKELFILE=..\ScriptedBiped\BaseBiped.ngf
#exec MESH JOINTNAME Head=Hair Neck=Head

#exec MESH IMPORT MESH=PlayerBase_m SKELFILE=..\ScriptedBiped\PlayerBase\PlayerBase.ngf INHERIT=BaseBiped_m
#exec MESH JOINTNAME Head=Hair Neck=Head

#exec MESH IMPORT MESH=Patrick_m SKELFILE=Patrick.ngf INHERIT=PlayerBase_m
#exec MESH JOINTNAME Head=Hair Neck=Head 
#exec MESH MODIFIERS Hair:PatrickHair
#exec MESH NOTIFY SEQ=scarrow_death TIME=0.890 FUNCTION=TurnOffShadow					//

#exec MESH IMPORT MESH=PatrickHead_m SKELFILE=PatrickHead\PatrickHead.ngf

var int i;
var bool bOnFire;
var bool bAckClickThrough;

//----------------------------------------------------------------------------

function StartLevel()
{
	if ( (Player != None) && (Player.Console != None) )
		WindowConsole(Player.Console).bShellPauses = False;
	CrouchTime = 0;
	super.StartLevel();
}

function TurnOffShadow()
{
	ShadowImportance = 0;
}

function PreBeginPlay()
{
	local LightningPoint lp;
	local vector eyeAdjust;
	
	// eyeAdjust.z = BaseEyeHeight;
	// lp = spawn(class 'LightningPoint',,,Location + eyeAdjust);
	// lp.setBase(self);
	super.PreBeginPlay();
	
	// bBloodyFootprints = true;
	
	/*
	EnableLog('Spell');
	EnableLog('Weapon');
	EnableLog('Trigger');
	EnableLog('CutScenes');
	EnableLog('Misc');
	EnableLog('Ward');
	EnableLog('Hound');
	EnableLog('Molotov');
	EnableLog('Dispel');
	EnableLog('AI');
	EnableLog('Galvan');
	EnableLog('CameraDebug');
	EnableLog('GameState');
	EnableLog('GameEvents');
	EnableLog('Pickups');
	*/
	
	ClientAdjustGlow( 0.0, vect(1,0,0) );
}
	
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	ServerReStartPlayer();
	
	if (Player != None)
		WindowConsole(Player.Console).bShellPauses = false;
	Level.bDontAllowSavegame = false;
	
	ReplicateAnimations();
}

function bool IsAlert()
{
	return false;
}

function PlaySoundFallImpact()
{
	local Texture	HitTexture;
	local int		Flags;

	HitTexture = TraceTexture( Location - vect(0,0,500), Location, Flags );
	if ( HitTexture != none )
	{
		PlayImpactSound( 1, HitTexture, 0, Location, 1.0, 800.0, 1.0 );
	}
}

function BFallBig()
{
	ImpactSoundClass = class'Aeons.BodyFallBImpactSoundSet';
	PlaySoundFallImpact();
}

function BFallSmall()
{
	ImpactSoundClass = class'Aeons.BodyFallSImpactSoundSet';
	PlaySoundFallImpact();
}

exec function FireMe()
{
	onFire(true);
}

exec function CastFire()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	eyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( A != none )
		if ( A.IsA('Pawn') && (A != self) )
			Pawn(A).OnFire(true);
}

exec function CastGlow()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	eyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( A != none )
		if ( A.IsA('Pawn') && (A != self) )
			spawn(class 'GlowScriptedFX',A,,A.Location);
}


/*
exec function MakeWet(bool bWet)
{	
	if ( bWet )
	{
		if (WetMod != none)
			WetMod.Activate();
	} else {
		if (WetMod != none)
			WetMod.Deactivate();
	}
}
*/

exec function DetachJoint(optional sound PawnImpactSound, optional int Distance)
{
	local vector start, end, eyeOffset, HitLocation, HitNormal, x, y, z;
	local int HitJoint;
	local Actor A, B;

	eyeOffset.z = eyeHeight;

	if (Distance == 0)
		Distance = 65536;

	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * Distance);

	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	GetAxes(ViewRotation, x, y, z);

	if ( A != none && A.IsA('ScriptedPawn') && Pawn(A).Health <= 0 )
	{
		B = A.DetachLimb(A.JointName(HitJoint), Class 'BodyPart');
		B.Velocity = (y + vect(0,0,0.25)) * 256;
		B.DesiredRotation = RotRand();
		B.bBounce = true;
		B.SetCollisionSize((B.CollisionRadius * 0.65), (B.CollisionHeight * 0.15));

		Pawn(A).PlayDamageMethodImpact('Bullet', HitLocation, -Normal(B.Velocity));
		if (PawnImpactSound != None)
			PlaySound(PawnImpactSound,,4.0,,1024, RandRange(0.8,1.2));
	}
}

exec function DestroyJoint()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	eyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( A != none )
		A.DestroyLimb(A.JointName(HitJoint));
}


exec function GibHim()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	local DamageInfo DInfo;
	
	DInfo.DamageType = 'Dyn_Concussive';
	DInfo.Damage = 200;
	DInfo.DamageMultiplier = 10;
	DInfo.ImpactForce = Vector(ViewRotation);
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( (Pawn(A) != none) && A.AcceptDamage(DInfo) )
		A.TakeDamage( self, HitLocation, vect(0,0,0), DInfo);
}

exec function WoundPawn()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	local PersistentWound w;
		
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( Pawn(A) != none )
	{
		w = spawn(class 'SpearWound',A,,HitLocation, rotator(HitNormal));
		w.AttachJoint = A.JointName(HitJoint);
		w.setup();
	}
}

exec function Jab()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	local PersistentWound w;
	local name JointName;
		
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( Pawn(A) != none )
	{
		JointName = Pawn(A).JointName(HitJoint);
		Pawn(A).AddDynamic (JointName, HitLocation, Vector(ViewRotation) * 2024,0.01);
	}
}

exec function AdvanceMover()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( UndMover(A) != none )
		UndMover(A).InterPolateTo(UndMover(A).KeyNum+1, 2);
}


exec function BumpOpacity()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( A != none )
		A.Opacity += 0.25;
}

exec function SendTouch()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 16384);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true);

	if ( A != none )
	{
		ClientMessage ("Touching ...."$A.name);
		A.Touch(self);
		A.Bump(self);
	}
}


exec function DecOpacity()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( A != none )
		A.Opacity -= 0.25;
}

exec function GetZoneChange()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	Spawn(class 'DebugLocationMarker',,,HitLocation);
}

function EncroachedBy( actor Other )
{
	local vector v;
	
	if ( Other.IsA('Mover') )
	{
		if ( Mover(Other).bTossPlayer )
		{
			v = Other.Velocity;
			v.z = FMax(v.Z, 0.65 * VSize(v));
			AddVelocity(v);
		}
	}
}

function C_TurnStepLeft()
{
}

function C_TurnStepRight()
{
}

state Dying
{
	ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer, FireAttSpell, FireDefSpell, QuickSave; //SaveGameToMemoryCard, SaveGame;;

	function ServerReStartPlayer()
	{
		//log("calling restartplayer in dying with netmode "$Level.NetMode);
		if ( Level.NetMode == NM_Client )
			return;
		if( Level.Game.RestartPlayer(self) )
		{
			ServerTimeStamp = 0;
			TimeMargin = 0;
			Enemy = None;
			Level.Game.StartPlayer(self);
		}
		else
			log("Restartplayer failed");
	}

	function HidePlayer()
	{
		SetCollision(false, false, false);
		TweenToFighter(0.01);
		bHidden = true;
	}

	exec function SelectWeapon( optional float F );
	exec function SelectAttSpell( optional float F );
	exec function SelectDefSpell( optional float F );

	exec function Fire( optional float F )
	{
		if ( (Level.NetMode == NM_Standalone) || (Level.Game.IsA('Coop') && !Coop(Level.Game).bForceRespawn) )
		{
			ServerReStartPlayer();
		}
	}

	
	function PlayChatting();
	exec function Taunt( name Sequence );

	function ServerMove
	(
		float TimeStamp, 
		vector Accel, 
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbJumpStatus, 
		bool bFired,
		bool bForceFire,
        bool bFiredAttSpell,
		bool bForceFireAttSpell, 
		bool bFiredDefSpell,
		bool bForceFireDefSpell,
		byte ClientRoll, 
		int View,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		Global.ServerMove(
					TimeStamp,
					Accel, 
					ClientLoc,
					false,
					false,
					false,
					false,
					false,
					false, //bFiredAttSpell,	// false?
					false, //bFiredDefSpell,	// false?
					false, 
					false,
					ClientRoll, 
					View);
	}

	function PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
	{
		local vector View,HitLocation,HitNormal, FirstHit, spot;
		local float DesiredDist, ViewDist, WallOutDist;
		local actor HitActor;
		local Pawn PTarget;
		local int HitJoint;

		if ( ViewTarget != None )
		{
			ViewActor = ViewTarget;
			CameraLocation = ViewTarget.Location;
			CameraRotation = ViewTarget.Rotation;
			PTarget = Pawn(ViewTarget);
			if ( PTarget != None )
			{
				if ( Level.NetMode == NM_Client )
				{
					if ( PTarget.bIsPlayer )
						PTarget.ViewRotation = TargetViewRotation;
					PTarget.EyeHeight = TargetEyeHeight;
					if ( PTarget.Weapon != None )
						PTarget.Weapon.PlayerViewOffset = TargetWeaponViewOffset;
				}
				if ( PTarget.bIsPlayer )
					CameraRotation = PTarget.ViewRotation;
				CameraLocation.Z += PTarget.EyeHeight;
			}

			if ( Carcass(ViewTarget) != None )
			{
				if ( bBehindView || (ViewTarget.Physics == PHYS_None) )
					CameraRotation = ViewRotation;
				else 
					ViewRotation = CameraRotation;
				if ( bBehindView )
					CalcBehindView(CameraLocation, CameraRotation, CollisionHeight * 3.1);
			}
			else if ( bBehindView )
				CalcBehindView(CameraLocation, CameraRotation, FMax( ViewTarget.CollisionHeight * 3.0, 200.0 ));

			return;
		}

		// View rotation.
		CameraRotation = ViewRotation;
		DesiredFOV = DefaultFOV;		
		ViewActor = self;
		if( bBehindView ) //up and behind (for death scene)
			CalcBehindView(CameraLocation, CameraRotation, CollisionHeight * 3.0);
		else
		{
			// First-person view.
			CameraLocation = Location;
			CameraLocation.Z += Default.BaseEyeHeight;
		}
	}

	event PlayerTick( float DeltaTime )
	{
		DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;

		if ( !bFrozen )
		{
			if ( bPressedJump )
			{
				Fire(0);
				bPressedJump = false;
			}
			GetAxes(ViewRotation,X,Y,Z);
			// Update view rotation.
			aLookup  *= 0.24;
			aTurn    *= 0.24;
			ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
			ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
			ViewRotation.Pitch = ViewRotation.Pitch & 65535;
			If ((ViewRotation.Pitch > 99*DEGREES) && (ViewRotation.Pitch < 270*DEGREES))
			{
				If (aLookUp > 0) 
					ViewRotation.Pitch = 99*DEGREES;
				else
					ViewRotation.Pitch = 270*DEGREES;
			}
			if ( Role < ROLE_Authority ) // then save this move and replicate it
				ReplicateMove(DeltaTime, vect(0,0,0), rot(0,0,0));
		}
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
	}

	function FindGoodView()
	{
		local vector cameraLoc;
		local rotator cameraRot;
		local int tries, besttry;
		local float bestdist, newdist;
		local int startYaw;
		local actor ViewActor;
		
		//fixme - try to pick view with killer visible
		//fixme - also try varying starting pitch
		////log("Find good death scene view");
		ViewRotation.Pitch = 308*DEGREES;
		tries = 0;
		besttry = 0;
		bestdist = 0.0;
		startYaw = ViewRotation.Yaw;
		
		for (tries=0; tries<16; tries++)
		{
			cameraLoc = Location;
			PlayerCalcView(ViewActor, cameraLoc, cameraRot);
			newdist = VSize(cameraLoc - Location);
			if (newdist > bestdist)
			{
				bestdist = newdist;	
				besttry = tries;
			}
			ViewRotation.Yaw += 4096;
		}
			
		ViewRotation.Yaw = startYaw + besttry * 4096;
	}
	
	function TakeDamage( Pawn instigatedBy, Vector hitlocation,  Vector momentum, DamageInfo DInfo)
	{
		if ( !bHidden )
			Super.TakeDamage(instigatedBy, hitlocation, momentum, DInfo);
	}
	
	function Timer()
	{
		bFrozen = false;
		bShowScores = true;
		bPressedJump = false;
	}
	
	function BeginState()
	{
		if ( (HasteMod != none) && HasteMod.bActive )
			HasteMod.GotoState('Deactivated');
		Level.bDontAllowSavegame = true;
		WindowConsole(Player.Console).bShellPauses = true;
		//SpawnCarcass();
		AttSpell.OwnerDead();
		DefSpell.OwnerDead();
		
		// clean out saved moves
		while ( SavedMoves != None )
		{
			SavedMoves.Destroy();
			SavedMoves = SavedMoves.NextMove;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove = None;
		}
		
		//if singleplayer
		if (Level.NetMode == NM_Standalone) {
			ViewTarget = (Spawn(class 'PlayerDeathProjectile',self,,Location,ViewRotation));
			bHidden = true;
		} else {
			PlayAnim( 'death_gun_back' );
		}
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		if ( Carcass(ViewTarget) == None )
			bBehindView = true;
		bFrozen = true;
		bPressedJump = false;
		bJustFired = false;
		// FindGoodView();
		if ( (Role == ROLE_Authority) && bHidden )
			Super.Timer(); 
		SetTimer(1.0, false);
	}
	
	function EndState()
	{
		WindowConsole(Player.Console).bShellPauses = false;
		// clean out saved moves
		while ( SavedMoves != None )
		{
			SavedMoves.Destroy();
			SavedMoves = SavedMoves.NextMove;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove = None;
		}
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		bBehindView = false;
		bShowScores = false;
		bJustFired = false;
		bPressedJump = false;
		//rb since it was a projectile, this wouldn't activate.        if ( Carcass(ViewTarget) != None )
		ViewTarget = None;
		//Log(self$" exiting dying with remote role "$RemoteRole$" and role "$Role);
	}
}

exec function TestLightning()
{
	local LightningBolt lb;
	lb = spawn(class 'LightningBolt',self,,Location, Rotation);
}

state DialogScene expands PlayerWalking
{
	ignores WeaponAction, DoJump, SeePlayer, HearNoise, Bump, FeignDeath, ProcessMove, SelectWeapon, SelectAttSpell, SelectDefSpell, SwitchWeapon, SwitchAttSpell, SwitchDefSpell, Scrye, NextItem, PrevItem, PrevWeapon, NextWeapon, QuickSave, ShowBook, ActivateItem;
	
	function FireAttSpell(float F)
	{
		log("Patrick Class - FireAttSpell Called - ", 'Misc');
	}

	function FireDefSpell(float F){}

	function BeginState()
	{
		if ( (HasteMod != none) && HasteMod.bActive )
			HasteMod.GotoState('Deactivated');
		bFire = 0;
		bFireAttSpell = 0;
		bFireDefSpell = 0;

		Velocity.X = 0.0;
		Velocity.Y = 0.0;
		if (WindowConsole(Player.Console) != None)
			WindowConsole(Player.Console).bShellPauses = true;
		Level.bDontAllowSavegame = true;
		bAckClickThrough = false;
		SetTimer( 1.5, false );		// delay until Fire() will cause click-though
	}
	
	function EndState()
	{
		UnFreeze();
		if (WindowConsole(Player.Console) != None)
			WindowConsole(Player.Console).bShellPauses = false;
		Level.bDontAllowSavegame = false;
		bFire = 0;
		bFireAttSpell = 0;
		bFireDefSpell = 0;
		Weapon.GotoState('Idle');
		AttSpell.GotoState('Idle');
	}

	function Timer()
	{
		bAckClickThrough = true;
	}

	exec function Fire( optional float F )
	{
		local ScriptedPawn	SP;

		if ( bAckClickThrough )
			foreach AllActors( class'ScriptedPawn', SP )
				SP.FastScript( true );
	}

Begin:
	if ( Physics == PHYS_Falling )
	{
		Velocity.X = 0.0;
		Velocity.Y = 0.0;
		Sleep( 0.1 );
		goto 'Begin';
	}
	Freeze();
	Velocity = vect(0,0,0);
	SetPhysics(PHYS_None);
}

state GuidingPhoenix expands PlayerWalking
{
	// ignores Fire, FireAttSpell, FireDefSpell, ActivateItem, UseLantern, Jump,  NextItem, PrevItem, PrevWeapon, NextWeapon;
	ignores DoJump, SeePlayer, HearNoise, Bump, FeignDeath, ProcessMove, FireDefSpell, SelectWeapon, SelectAttSpell, SelectDefSpell, SwitchWeapon, SwitchAttSpell, SwitchDefSpell, Scrye, NextItem, PrevItem, PrevWeapon, NextWeapon, QuickSave, ShowBook;
	
	function BeginState()
	{
		Velocity.X = 0.0;
		Velocity.Y = 0.0;
		WindowConsole(Player.Console).bShellPauses = true;
		Level.bDontAllowSavegame = true;
		Velocity = vect(0,0,0);
	}

	function EndState()
	{
		UnFreeze();
		WindowConsole(Player.Console).bShellPauses = false;
		Level.bDontAllowSavegame = false;
	}

Begin:
	if ( Physics == PHYS_Falling )
	{
		Sleep( 0.1 );
		goto 'Begin';
	}
	Freeze();
	Velocity = vect(0,0,0);
}

// ============================================================================
// Falling Death - invoked by falling into a FallToDeathTrigger
// ============================================================================
state FallingDeath expands Dying
{
	ignores TakeDamage, Landed, DoJump, SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer, FireAttSpell, FireDefSpell, QuickSave, ShowBook, ActivateItem;
		
	event PlayerTick( float DeltaTime )
	{
		// DoEyeTrace();
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}
	
	exec function Fire(float F) {}

	function EndSpecialKill()
	{
		ServerRestartPlayer();
	}
	
	function PressedEnter()
	{
		if( bCanExitSpecialState )
			EndSpecialKill();
	}
	
	function PressedSpaceBar()
	{
		if( bCanExitSpecialState )
			EndSpecialKill();
	}

	function PressedEscape()
	{
		if( bCanExitSpecialState )
			EndSpecialKill();
	}

	function BeginState()
	{
		if ( (HasteMod != none) && HasteMod.bActive )
			HasteMod.GotoState('Deactivated');

		WindowConsole(Player.Console).bShellPauses = true;
		Level.bDontAllowSavegame = true;
		bHidden = false;
		if (Flight != none)
			Flight.GotoState('Idle');
		LoopAnim('Jump_Cycle');
		AttSpell.OwnerDead();
		DefSpell.OwnerDead();
		Behindview(true);
		SetPhysics(PHYS_Falling);
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		bFrozen = true;
		bPressedJump = false;
		bJustFired = false;
		if ( (Role == ROLE_Authority) && !bHidden )
			Super.Timer(); 
		SetTimer(0.1, false);

		// clean out saved moves
		while ( SavedMoves != None )
		{
			SavedMoves.Destroy();
			SavedMoves = SavedMoves.NextMove;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove = None;
		}
	}
	
	Begin:
		bCanExitSpecialState = false;
		stop;
	
	FadeAway:
		bCanExitSpecialState = true;
		ClientAdjustGlow(-1.0,vect(0,0,0));
		Health = 0;
		sleep(2);
		SetPhysics(PHYS_None);
		ClientAdjustGlow( 1.0, vect(1,0,0) );
		ServerRestartPlayer();
}

// ========================================================================
// Invoked by killing a NPC
// ========================================================================
state FadingDeath expands Dying
{
	ignores TakeDamage, Landed, SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer, FireAttSpell, FireDefSpell, QuickSave, ShowBook, ActivateItem;

	function BeginState()
	{
		if ( (HasteMod != none) && HasteMod.bActive )
			HasteMod.GotoState('Deactivated');

		// Health = 0;
		WindowConsole(Player.Console).bShellPauses = true;
		Level.bDontAllowSavegame = true;
		bHidden = false;
		// LoopAnim('Damage_Fire');
		AttSpell.OwnerDead();
		DefSpell.OwnerDead();
		// Behindview(true);
		// SetPhysics(PHYS_Falling);
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		bFrozen = true;
		bPressedJump = false;
		bJustFired = false;
		if ( (Role == ROLE_Authority) && !bHidden )
			Super.Timer(); 
		SetTimer(0.1, false);

		// clean out saved moves
		while ( SavedMoves != None )
		{
			SavedMoves.Destroy();
			SavedMoves = SavedMoves.NextMove;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove = None;
		}
	}
	
	Begin:
		ClientAdjustGlow(-1.0,vect(0,0,0));
		sleep(4);
		SetPhysics(PHYS_None);
		ClientAdjustGlow( 1.0, vect(1,0,0) );
		ServerRestartPlayer();
}

// ========================================================================
// Invoked by killing a NPC
// ========================================================================
state InstantFadingDeath expands Dying
{
	ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, SwitchWeapon, Falling, PainTimer, FireAttSpell, FireDefSpell, QuickSave, ShowBook;

	function BeginState()
	{
		Health = 0;
		WindowConsole(Player.Console).bShellPauses = true;
		Level.bDontAllowSavegame = true;
		bHidden = false;
		// LoopAnim('Damage_Fire');
		AttSpell.OwnerDead();
		DefSpell.OwnerDead();
		// Behindview(true);
		// SetPhysics(PHYS_Falling);
		BaseEyeheight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
		bFrozen = true;
		bPressedJump = false;
		bJustFired = false;
		if ( (Role == ROLE_Authority) && !bHidden )
			Super.Timer(); 
		SetTimer(0.1, false);

		// clean out saved moves
		while ( SavedMoves != None )
		{
			SavedMoves.Destroy();
			SavedMoves = SavedMoves.NextMove;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove = None;
		}
	}
	
	Begin:
		ClientAdjustGlow(-1000.0,vect(0,0,0));
		sleep(1);
		SetPhysics(PHYS_None);
		ClientAdjustGlow( 1.0, vect(1,0,0) );
		ServerRestartPlayer();
}

exec function KillNPC()
{
	GotoState('FadingDeath');
}

// set the players location
exec function SetLoc(int x, int y, int z)
{
	local vector v;
	
	v.x = x;
	v.y = y;
	v.z = z;

	SetLocation(v);
}

// finds the first actor with the specified tag and teleports the player to that location
exec function SetLocTag(name NewTag)
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A, NewTag)
	{
		SetLocation(A.Location);
		break;
	}
}

simulated function ReplicateAnimations()
{	
	if ( Role == ROLE_Authority || Level.NetMode == NM_DedicatedServer )
		return;
	
	SetTimer( 1.0/60, true );
}

simulated function Timer()
{
	local Actor A;
	
	ForEach AllActors(class 'Actor', A)
	{
		A.bClientAnim = true;
		A.PlayAnim(A.AnimSequence);
	}
}

/*
exec function CS()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	local PersistentWound w;
	local name JointName;
		
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( Pawn(A) != none )
	{
		A.SetTexture(3, texture'Aeons.MonkA_KiesFace');
		//JointName = Pawn(A).JointName(HitJoint);
		//Pawn(A).AddDynamic (JointName, HitLocation, Vector(ViewRotation) * 2024,0.01);
	}
}
*/

exec function GP()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);

	if ( A != none )
	{
		ClientMessage("Default Location: "$A.default.Location);
		ClientMessage("Location: "$A.Location);
	}
}

/*	Eliminating this function removes reference to Undying King meshes from EntryPS2
exec function SetKing()
{
	local vector start, end, eyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	local King_Body King;


	EyeOffset.z = eyeHeight;
	
	start = Location + eyeOffset + (Vector(ViewRotation) * CollisionRadius);
	end = start + (Vector(ViewRotation) * 65536);
	
	ForEach AllActors(class 'King_Body', King)
	{
		break;
	}

	Trace(HitLocation, HitNormal, HitJoint, end, start, true, true);
	ClientMessage("King Collision is : "$King.CollisionHeight$", "$King.CollisionRadius);
	King.SetCollisionSize(16, 16);
	King.SetPhysics(PHYS_Falling);
	King.SetLocation(HitLocation);
}
*/

exec function SetupGameEvents()
{
	local GameEventSetup GES;

	ForEach AllActors(class 'GameEventSetup', GES )
	{
		break;
	}

	if (GES != none)
		GES.go(SELF);
}

exec function SetupInv()
{
	local LevelWeaponSetup lws;

	ForEach AllActors(class 'LevelWeaponSetup', lws )
	{
		break;
	}

	if (lws != none)
	{
		// AddAll();
		lws.go();
	}
}

exec function RainDance()
{
	Region.Zone.Weather = Weather_Rain;
	RainModifier(RainMod).UpdateForecast();
}

exec function SnowDance()
{
	Region.Zone.Weather = Weather_Snow;
	RainModifier(RainMod).UpdateForecast();
}

exec function ClearWeather()
{
	Region.Zone.Weather = Weather_Clear;
	RainModifier(RainMod).UpdateForecast();
}

exec function wztt()
{
	local vector HitLocation, HitNormal;
	local int HitJoint;
	local Actor A, P;

	P = WarpZoneTrace(HitLocation, HitNormal, HitJoint, true, 4096, 3);
	
	A = Spawn(class 'DebugLocationMarker',,,HitLocation);
	A.bHidden = false;
}

exec function DebugMsg()
{
	Level.bDebugMessaging = !Level.bDebugMessaging;
}

function Actor WarpZoneTrace(out vector HitLocation, out vector HitNormal, out int HitJoint, bool TraceActors, float Range, int RecursionLimit)
{
	local vector Eh, EyeLoc, start, end, v;
	local rotator r;
	local WarpZoneInfo WZ;
	local int  HitZoneID, NumTraces;
	local bool bHitWall;
	local WarpZoneInfo OtherSideActor;
	local Actor A;

	Eh.z = EyeHeight;
	EyeLoc = Location + Eh;
	
	v = vector(ViewRotation);
	r = ViewRotation;

	start = EyeLoc;
	end = EyeLoc + Vector(ViewRotation) * Range;

	while ( !bHitWall && (NumTraces < RecursionLimit) )
	{
		NumTraces ++;
		log("Doing Trace "$NumTraces, 'Misc');
	
		A = Trace(HitLocation, HitNormal, HitJoint, end, start, TraceActors);
		
		// we've hit an actor ... just return.
		if ( A != none )
			if ( !A.IsA('LevelInfo') )
				return A;

		HitZoneID = Level.GetZone(HitLocation);

		log("HitZoneID = "$HitZoneID, 'Misc');

		bHitWall = true;

		ForEach AllActors(class 'WarpZoneInfo', WZ)
		{
			if ( Level.GetZone(WZ.Location) == HitZoneID )
			{
				log("Hit WarpZone .... ", 'Misc');

				// we've hit a warpzone
				bHitWall = false;
				OtherSideActor = none;

				foreach AllActors( class 'WarpZoneInfo', OtherSideActor )
					if( string(OtherSideActor.ThisTag) ~= WZ.OtherSideURL && OtherSideActor!=WZ )
						break;

				if ( OtherSideActor != none )
				{
					log("Found OtherSide Actor .... ", 'Misc');
					WZ.UnWarp(HitLocation, v, r);
					OtherSideActor.Warp(HitLocation, v, r);

					Start = HItLocation;
					End = HitLocation + vector(ViewRotation) * Range;
				}
				break;
			}
		}
	}

}


exec function LogJournals()
{
	local JournalPickup B;
	local string LevelName;
	local int i;
	local string url;

	url = Level.GetLocalURL();

	i=instr(url, "?");
	
	if ( i >0 )
		LevelName = Left(url, i);
	else
		LevelName = url;
	
	log("Level : "$LevelName, 'Galvan');

	ForEach AllActors(class 'JournalPickup', B)
	{
		log(""$B.JournalClass.name, 'Galvan');
	}
	log("",'Galvan');

}

exec function SetSkill(int Skill)
{
	Level.Game.Difficulty = Skill;
}

exec function GetGameEvent(name EventName)
{
	local bool Result;

	Result = CheckGameEvent(EventName);
	ClientMessage("Game Event: "$EventName$" = "$result);
}

exec function HoundAnim()
{
	if ( Weapon.IsA('GhelziabahrStone') )
	{
		GhelziabahrStone(Weapon).PlayHoundAnim();
	}
}

/*
exec function SetGameEvent(name EventName, bool NewFlag )
{
	local bool Result;

	CheckGameEvent(EventName, NewFlag);
	Result = CheckGameEvent(EventName);
	ClientMessage("Game Event Set: "$EventName$" to "$result);
}
*/

defaultproperties
{
     BackRightDecalClass=Class'Aeons.BldRightPrint'
     BackLeftDecalClass=Class'Aeons.BldLeftPrint'
     BackRightSnowDecalClass=Class'Aeons.RightSnowFootprint'
     BackLeftSnowDecalClass=Class'Aeons.LeftSnowFootprint'
     ManaRefreshAmt=1
     ManaRefreshTime=0.2
     bRunMode=True
     BaseEyeHeight=55
     FootSoundClass=Class'Aeons.DefaultFootSoundSet'
     bClientAnim=True
     Physics=PHYS_Walking
     LODBias=5
     Mesh=SkelMesh'Aeons.Meshes.Patrick_m'
     CollisionRadius=22
     CollisionHeight=57
     AirControl=0.8
}
