//=============================================================================
// King_Body.
//=============================================================================
class King_Body expands King_Part;

/* Force-Recompile */

//#exec MESH IMPORT MESH=King_Body_m SKELFILE=King_Body.ngf

//#exec MESH NOTIFY SEQ=headshoots TIME=0.5 FUNCTION=SetHeadOut
//#exec MESH NOTIFY SEQ=headretracts TIME=0.5 FUNCTION=SetHeadIn

//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.1 FUNCTION=SetHeadIn
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headin TIME=0.99 FUNCTION=LoopMultiMouthShotCycle
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.99 FUNCTION=LoopMultiMouthShotCycle
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.4 FUNCTION=SetBrainOpen
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headin TIME=0.4 FUNCTION=SetBrainOpen

//#exec MESH NOTIFY SEQ=AcidSpray TIME=0.277 FUNCTION=SpitAcid
//#exec MESH NOTIFY SEQ=AcidSpray TIME=0.441 FUNCTION=SpitAcid
//#exec MESH NOTIFY SEQ=AcidSpray TIME=0.605 FUNCTION=SpitAcid
//#exec MESH NOTIFY SEQ=AcidSpray TIME=0.769 FUNCTION=SpitAcid

//#exec MESH NOTIFY SEQ=Headshoots TIME=0.350 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=Headshoots TIME=0.400 FUNCTION=DoNearDamage3
//#exec MESH NOTIFY SEQ=Headshoots TIME=0.450 FUNCTION=DoNearDamage4
//#exec MESH NOTIFY SEQ=Headshoots TIME=0.500 FUNCTION=DoNearDamage5
//#exec MESH NOTIFY SEQ=Headshoots TIME=0.550 FUNCTION=DoNearDamage6
//#exec MESH NOTIFY SEQ=Headshoots TIME=0.600 FUNCTION=DoNearDamage6

//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.154 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.200 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.277 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.338 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.415 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.492 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.554 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.615 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.677 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=AcidSpray TIME=0.125 FUNCTION=PlaySound_N ARG="AcidSpray PVar=0.2"
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.078 FUNCTION=PlaySound_N ARG="WhooshHvy PVar=0.2 V=0.8"
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.218 FUNCTION=PlaySound_N ARG="WhooshLt PVar=0.2 V=0.8"
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.515 FUNCTION=PlaySound_N ARG="WhooshLt PVar=0.2 V=0.8"
//#exec MESH NOTIFY SEQ=HeadClawAttack TIME=0.640 FUNCTION=PlaySound_N ARG="WhooshLt PVar=0.2 V=0.8"
//#exec MESH NOTIFY SEQ=HeadRetracts TIME=0.000 FUNCTION=PlaySound_N ARG="HeadRetract PVar=0.2"
//#exec MESH NOTIFY SEQ=HeadShoots TIME=0.000 FUNCTION=PlaySound_N ARG="ClickA CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=HeadShoots TIME=0.125 FUNCTION=PlaySound_N ARG="ClickB CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=HeadShoots TIME=0.200 FUNCTION=PlaySound_N ARG="ClickC CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=HeadShoots TIME=0.300 FUNCTION=PlaySound_N ARG="HeadShoots PVar=0.2 V=1.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.022 FUNCTION=PlaySound_N ARG="Mvmt CHANCE=0.7 PVar=0.25 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.066 FUNCTION=PlaySound_N ARG="ClickAll CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.111 FUNCTION=PlaySound_N ARG="ClickAll CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.144 FUNCTION=PlaySound_N ARG="ClickAll CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.388 FUNCTION=PlaySound_N ARG="ClickAll CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.511 FUNCTION=PlaySound_N ARG="Mvmt CHANCE=0.7 PVar=0.25 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.622 FUNCTION=PlaySound_N ARG="ClickAll CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.666 FUNCTION=PlaySound_N ARG="ClickAll CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle1 TIME=0.733 FUNCTION=PlaySound_N ARG="ClickAll CHANCE=0.7 PVar=0.25 V=0.7 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle2 TIME=0.022 FUNCTION=PlaySound_N ARG="Mvmt CHANCE=0.7 PVar=0.25 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=Idle2 TIME=0.511 FUNCTION=PlaySound_N ARG="Mvmt CHANCE=0.7 PVar=0.25 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Brainshot TIME=0.000 FUNCTION=PlaySound_N ARG="HeadShot PVar=0.2 V=1.5"
//#exec MESH NOTIFY SEQ=Multi_Brainshot TIME=0.000 FUNCTION=PlaySound_N ARG="HeadClose PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headin TIME=0.000 FUNCTION=PlaySound_N ARG="HeadOpenVocal PVar=0.2 V=1.5"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headin TIME=0.354 FUNCTION=PlaySound_N ARG="HeadOpen PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headin TIME=0.546 FUNCTION=PlaySound_N ARG="HeadBeat PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headin TIME=0.695 FUNCTION=PlaySound_N ARG="HeadBeat PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headin TIME=0.844 FUNCTION=PlaySound_N ARG="HeadBeat PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.000 FUNCTION=PlaySound_N ARG="HeadRetract PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.000 FUNCTION=PlaySound_N ARG="HeadOpenVocal PVar=0.2 V=1.5"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.349 FUNCTION=PlaySound_N ARG="HeadOpen PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.539 FUNCTION=PlaySound_N ARG="HeadBeat PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.687 FUNCTION=PlaySound_N ARG="HeadBeat PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Headout TIME=0.834 FUNCTION=PlaySound_N ARG="HeadBeat PVar=0.2"
//#exec MESH NOTIFY SEQ=Multi_Mouthshot_Recover TIME=0.000 FUNCTION=PlaySound_N ARG="HeadRecover PVar=0.2"
//#exec MESH NOTIFY SEQ=Taunt TIME=0.000 FUNCTION=PlaySound_N ARG="Taunt PVar=0.2 V=1.5"


var(AICombat) float		TentacleRange;
var(AICombat) float		MinChestAttackDist;
var(AICombat) float		KeepHeadOutTime;
var(AICombat) float		AttackDelay;
var(AICombat) float		VulnerableTime;

var(KingSetup) float	BrainRadius;

var float				HeadOutTimer;

var King_Mouth			KingMouth;
var King_Ass			KingAss;
var King_L_Arm			KingLeftArm;
var King_R_Arm			KingRightArm;
var King_L_Mandible		KingLeftMandible;
var King_R_Mandible		KingRightMandible;
var bool				HeadOut;
var bool				BrainOpen;
var(AICombat) name		VulnerableJoint[16];
var(AICombat) int		NumVulnerableJoints;
var(AICombat) name		BrainJoint[16];
var(AICombat) int		NumBrainJoints;

function SetBrainOpen()
{
	DebugInfoMessage(".SetBrainOpen()");
	BrainOpen=true;
	HealthBar.State = HBS_ReallyVulnerable;
}

function SetBrainClosed()
{
	DebugInfoMessage(".SetBrainClosed()");
	BrainOpen=false;
	HealthBar.State = HBS_Vulnerable;
}

function SpitAcid()
{
	local place HeadJoint;
	local rotator rot;

	DebugInfoMessage( ".SpitAcid() called." );

	HeadJoint = JointPlace( 'head' );

	if( Enemy != none )
	{
		rot = WeaponAim( Enemy.Location, HeadJoint.pos, WeaponAccuracy );
	}
	else
	{
		rot = ConvertQuat(HeadJoint.rot);
	}

	spawn( class'KingAcid_proj', self,, HeadJoint.pos + 64*Vector(rot), rot );
}

function SetHeadOut()
{
	HeadOut = true;
	ResetHeadOutTimer();
}

function SetHeadIn()
{
	HeadOut = false;
}

function LoopMultiMouthShotCycle()
{
	LoopAnim( 'Multi_Mouthshot_cycle' );
}

function ResetHeadOutTimer()
{
	DebugInfoMessage( ".ResetHeadOutTimer() called." );
	HeadOutTimer = FVariant(KeepHeadOutTime, 0.25*KeepHeadOutTime);
}

function Tick( float deltaTime )
{
	HeadOutTimer -= deltaTime;
	super.Tick( deltaTime );
}

// See if location of specified joint is within specified distance of specified actor.
function bool JointStrikeValid( actor Victim, name JName, float Range )
{
	local vector	DLoc;
	local vector	DVect;
	local float		XY, Z;

	DLoc = JointPlace( JName ).pos;

	DVect = Victim.Location - DLoc;
	Z = FMax( 0.0, Abs(DVect.Z) - Victim.CollisionHeight );
	DVect.Z = 0.0;
	XY = FMax( 0.0, VSize(DVect) - Victim.CollisionRadius );

	DebugInfoMessage(".JointStrikeValid(), Z = " $ Z $ ", XY = " $ XY );
	if ( ( ( Square( XY ) + Square( Z ) ) < Square( Range ) ) &&
		 FastTrace( Victim.Location, DLoc ) )
		return true;
	else
		return false;
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	local bool valid;

	valid = false;
	if( DamageNum == 0 )
	{
		valid = JointStrikeValid( Victim, 'head', DamageRadius );
	}
	else
	{
		if( DamageNum > 4 )
			valid = JointStrikeValid( Victim, 'head', DamageRadius );
		if( DamageNum > 3 )
			valid = valid || JointStrikeValid( Victim, 'neck5', DamageRadius );
		if( DamageNum > 2 )
			valid = valid || JointStrikeValid( Victim, 'neck4', DamageRadius );
		if( DamageNum > 1 )
			valid = valid || JointStrikeValid( Victim, 'neck3', DamageRadius );
		if( DamageNum > 0 )
			valid = valid || JointStrikeValid( Victim, 'neck2', DamageRadius );
	}

	DebugInfoMessage(".NearStrikeValid( " $ Victim.name $ ", " $ DamageNum $ " ) returned " $ valid);
	return valid;
}

// Event called prior to stepping skeletal animation.
function PreSkelAnim()
{
	local vector	rVect;

	if ( bUseLooking && LookAtManager.IsTracking() )
	{
		/*
		if( LookAtManager.KeyTargetActor() != none )
		{
			DebugInfoMessage( ".PreSkelAnim() look at " $ LookAtManager.KeyTargetActor().name $ "." );
		}
		else
		{
			DebugInfoMessage( ".PreSkelAnim() look at location." );
		}
		*/

		rVect = LookAtManager.GetTargetLocation() - JointPlace('neck1').Pos;
		ViewRotation = rotator(rVect);
//		ViewRotation.Pitch += (20 * 32768 / 180);
		ViewRotation.Pitch = 0;
		if ( ( rVect dot vector(Rotation) ) < 0.50 )
		{
			ClearTargets();
			return;
		}
		PointJoint( 'neck1' );
//		AddTargetRot( 'spine3', ConvertRot(ViewRotation), true );
	}
	else
	{
//		DebugInfoMessage( ".PreSkelAnim() not looking at anything." );
		ClearTargets();
	}
}

function SetMovementPhysics()
{
	DebugInfoMessage( ".SetMovementPhysics(), bCollideWorld = " $ bCollideWorld $ "." );
	SetPhysics( PHYS_None );
}

function PlayWait()
{
	DebugInfoMessage( ".PlayWait()." );
	if( HeadOut )
		LoopAnim( 'Idle1',, MOVE_Anim );
	else
		LoopAnim( 'Idle2',, MOVE_Anim );
}

function GetParts()
{
	local ScriptedPawn aPawn;

	foreach AllActors( class'ScriptedPawn', aPawn )
	{
		if( King_Mouth(aPawn) != none )
		{
			KingMouth = King_Mouth(aPawn);
			KingMouth.SetOwner( self );
		}
		if( King_Ass(aPawn) != none )
		{
			KingAss = King_Ass(aPawn);
			KingAss.SetOwner( self );
		}
		if( King_L_Arm(aPawn) != none )
		{
			KingLeftArm = King_L_Arm(aPawn);
			KingLeftArm.SetOwner( self );
		}
		if( King_R_Arm(aPawn) != none )
		{
			KingRightArm = King_R_Arm(aPawn);
			KingRightArm.SetOwner( self );
		}
		if( King_L_Mandible(aPawn) != none )
		{
			KingLeftMandible = King_L_Mandible(aPawn);
			KingLeftMandible.SetOwner( self );
		}
		if( King_R_Mandible(aPawn) != none )
		{
			KingRightMandible = King_R_Mandible(aPawn);
			KingRightMandible.SetOwner( self );
		}
	}
}

function PostBeginPlay()
{
	local rotator Rot;
	local vector X, Y, Z;

	super.PostBeginPlay();
	
	GetParts();

	if( KingMouth != none )
	{
		DebugInfoMessage( ".PostBeginPlay() setting up King's mouth." );
		KingMouth.SetBase( self, 'MOUTH_HANDLE', 'MouthRoot' );
	}
	else
		DebugInfoMessage( ".PostBeginPlay() couldn't spawn King's mouth." );

	if( KingLeftArm != none )
	{
		DebugInfoMessage( ".PostBeginPlay() setting up King's left arm." );
		KingLeftArm.SetBase( self, 'BIGCLAW_L_HANDLE', 'BIGCLAW_L_ROOT' );
	}
	else
		DebugInfoMessage( ".PostBeginPlay() couldn't spawn King's left arm." );

	if( KingRightArm != none )
	{
		DebugInfoMessage( ".PostBeginPlay() setting up King's right arm." );
		KingRightArm.SetBase( self, 'BIGCLAW_R_HANDLE', 'BIGCLAW_R_Root' );
	}
	else
		DebugInfoMessage( ".PostBeginPlay() couldn't spawn King's right arm." );

	if( KingLeftMandible != none )
	{
		DebugInfoMessage( ".PostBeginPlay() setting up King's left mandible." );
		KingLeftMandible.SetBase( self, 'BIGPINCER_L_HANDLE', 'Mand_L_Root' );
	}
	else
		DebugInfoMessage( ".PostBeginPlay() couldn't spawn King's left mandible." );

	if( KingRightMandible != none )
	{
		DebugInfoMessage( ".PostBeginPlay() setting up King's right mandible." );
		KingRightMandible.SetBase( self, 'BIGPINCER_R_HANDLE', 'Mand_R_Root01' );
	}
	else
		DebugInfoMessage( ".PostBeginPlay() couldn't spawn King's right mandible." );

	if( KingMouth != none ) 
	{
		KingMouth.Init( KingLeftMandible, KingRightMandible );
	}

	// Health bar.
	HealthBar = class'HealthBar'.static.CreateHealthBar(self, false);
	HealthBar.State = HBS_Invulnerable;
}

function bool IsBrainJoint( name Joint )
{
	local int i;

	for( i=0; i < NumBrainJoints; ++i )
		if( Joint == BrainJoint[i] )
			return true;

	return false;
}

function name NearestBrainJoint( vector HitLocation )
{
	local int j, bestJoint;
	local float dist, bestDist;

	bestJoint = 0;
	bestDist = VSize(JointPlace( BrainJoint[0] ).pos - HitLocation);
	
	for( j=1; j < NumBrainJoints; ++j )
	{
		dist = VSize(JointPlace( BrainJoint[j] ).pos - HitLocation);
		if( dist < bestDist )
		{
			bestDist = dist;
			bestJoint = j;
		}
	}

	DebugInfoMessage(".NearestBrainJoint() is " $ BrainJoint[bestJoint] $ ", dist = " $ bestDist);
	return BrainJoint[bestJoint];
}

function bool IsVulnerableJoint( name Joint )
{
	local int i;

	for( i=0; i < NumVulnerableJoints; ++i )
		if( Joint == VulnerableJoint[i] )
			return true;
	return false;
}

function name NearestVulnerableJoint( vector HitLocation )
{
	local int j, bestJoint;
	local float dist, bestDist;
	
	bestJoint = 0;
	bestDist = VSize(JointPlace( VulnerableJoint[0] ).pos - HitLocation);
	
	for( j=1; j < NumVulnerableJoints; ++j )
	{
		dist = VSize(JointPlace( VulnerableJoint[j] ).pos - HitLocation);
		if( dist < bestDist )
		{
			bestDist = dist;
			bestJoint = j;
		}
	}

	DebugInfoMessage(".NearestVulnerableJoint() is " $ VulnerableJoint[bestJoint] $ ", dist = " $ bestDist);
	return VulnerableJoint[bestJoint];
}

function float ScaleExplosiveDamage( name Joint, vector HitLocation, float DamageRadius )
{
	local float DamageScale;

	DamageScale =  (DamageRadius + BrainRadius - VSize( JointPlace( Joint ).pos - HitLocation )) / DamageRadius;

	if( DamageScale > 1.0 )
		DamageScale = 1.0;
	else if( DamageScale < 0.0 )
		DamageScale = 0.0;

	return DamageScale;
}

function AdjustDamage( out DamageInfo DInfo )
{
	local vector X, Y, Z, dir;
	local float dist;

	if( (DInfo.JointName == 'none') && (DInfo.DamageRadius > 0.0) )
	{
		DInfo.Damage *= 
			PhysicalScalar * 
			ScaleExplosiveDamage( NearestVulnerableJoint( DInfo.DamageLocation ), DInfo.DamageLocation, DInfo.DamageRadius );
	}
	else if( IsVulnerableJoint( DInfo.JointName ) )
	{
		DInfo.Damage *= PhysicalScalar;
	}	
	else
	{
		DInfo.Damage = 0;
	}

	DInfo.ImpactForce = vect(0,0,0);

	DebugInfoMessage( ".AdjustDamage() called, damage = " $ DInfo.Damage $ "." );
}

function StartMultiMouthShot()
{
	DebugInfoMessage( ".StartMultiMouthShot() called." );

	if( HeadOut )
		PlayAnim( 'Multi_Mouthshot_Headout' );
	else
		PlayAnim( 'Multi_Mouthshot_HeadIn' );

	if( KingMouth != none )
		KingMouth.StartMultiMouthShot();
	if( KingLeftArm != none )
		KingLeftArm.StartMultiMouthShot();
	if( KingRightArm != none )
		KingRightArm.StartMultiMouthShot();

	GotoState( 'KingVulnerable' );
}

function StartMultiBrainShot()
{
	DebugInfoMessage( ".StartMultiBrainShot() called." );

	PlayAnim( 'Multi_Brainshot' );

	if( KingMouth != none )
		KingMouth.StartMultiBrainShot();
	if( KingLeftArm != none )
		KingLeftArm.StartMultiBrainShot();
	if( KingRightArm != none )
		KingRightArm.StartMultiBrainShot();
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	StartMultiBrainShot();
}

function Destroyed()
{
	if( KingMouth != none )
		KingMouth.Destroy();
	if( KingLeftArm != none )
		KingLeftArm.Destroy();
	if( KingRightArm != none )
		KingRightArm.Destroy();
}

function StartMultiMouthShotRecover()
{
	DebugInfoMessage( ".StartMultiMouthShotRecover() called." );

	PlayAnim( 'Multi_Mouthshot_Recover' );

	if( KingMouth != none )
		KingMouth.RecoverMultiMouthShot();
	if( KingLeftArm != none )
		KingLeftArm.RecoverMultiMouthShot();
	if( KingRightArm != none )
		KingRightArm.RecoverMultiMouthShot();
}

function bool UseChestAttack( actor Enemy )
{
	return EnemyInRange();
}

function bool RetractHead()
{
	local vector HeadDelta, EnemyDelta, RootPos;

	if( !HeadOut )
	{
		return false;
	}
	else if( HeadOutTimer <= 0 )
	{
		DebugInfoMessage( ".RetractHead() retracting because timer == " $ HeadOutTimer $ "." );
		return true;
	}
	else
	{
		RootPos = JointPlace( RootJointName ).pos;
		HeadDelta = JointPlace( 'neck4' ).pos - RootPos;
		EnemyDelta = Enemy.Location - RootPos;

		if( (EnemyDelta dot HeadDelta) < (HeadDelta dot HeadDelta) )
		{
			DebugInfoMessage( ".RetractHead() retracting because enemy closer than head." );
			return true;
		}
		else
		{
//			ResetHeadOutTimer();
			return false;
		}
	}
}
		

state KingChestAttack expands AIFarAttackAnim
{
Resume:
Damaged:
Dodge:
Begin:
	if( HeadOut )
		PlayAnim( 'HeadClawAttack' );
	else
		PlayAnim( 'Headshoots' );
	FinishAnim();

Finish:
	GotoState( 'AIAttackPlayer', 'Attacked' );
}

state KingAcidAttack expands AIFarAttackAnim
{
Resume:
Damaged:
Dodge:
Begin:
	if( !HeadOut )
	{
		PlayAnim( 'HeadShoots' );
		FinishAnim();
	}

	PlayAnim( 'AcidSpray' );
	FinishAnim();

Finish:
	GotoState( 'AIAttackPlayer', 'Attacked' );
}

state KingVulnerable expands AIScriptedState
{
	function BeginState()
	{
		DebugBeginState();

		HealthBar.State = HBS_Vulnerable;
	}

	function EndState()
	{
		DebugEndState();

		HealthBar.State = HBS_Vulnerable;
	}

	function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
	{
		global.Died( Killer, damageType, HitLocation, DInfo );
	}

	function Killed( pawn Killer, pawn Other, name damageType )
	{
		global.Killed( Killer, Other, damageType );
	}
	
	function KilledBy( pawn EventInstigator )
	{
		global.KilledBy( EventInstigator );
	}

	function bool Decapitate( optional vector Dir )
	{
		return super.Decapitate( Dir );
	}

	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
	{
		if( (DInfo.JointName == 'none') && (DInfo.DamageRadius > 0.0) )
			DInfo.DamageLocation = HitLocation;

		global.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
	}
	function AdjustDamage( out DamageInfo DInfo )
	{
		local vector X, Y, Z, dir;
		local float dist, damage, damageScale;
		local name nearJoint;
	
		damage = DInfo.Damage;

		if( (DInfo.JointName == 'none') && (DInfo.DamageRadius > 0.0) )
		{
			nearJoint = NearestVulnerableJoint( DInfo.DamageLocation );
			damageScale = ScaleExplosiveDamage( nearJoint, DInfo.DamageLocation, DInfo.DamageRadius );
			if( BrainOpen )
			{
				DInfo.Damage = PhysicalScalar * damageScale * damage +
					 ScaleExplosiveDamage( NearestBrainJoint( DInfo.DamageLocation ), DInfo.DamageLocation, DInfo.DamageRadius ) * damage;
			}
			else 
			{
				DInfo.Damage = PhysicalScalar * damageScale * damage;
			}
		}
		else if( !IsBrainJoint(DInfo.JointName) )
		{
			if( IsVulnerableJoint( DInfo.JointName ) && (DInfo.JointName != 'mouth') )
			{	// Don't take damage from mouth in this state.
				DInfo.Damage *= PhysicalScalar;
			}	
			else
				DInfo.Damage = 0;
		}

		DInfo.ImpactForce = vect(0,0,0);

		DebugInfoMessage( ".KingVulnerable.AdjustDamage() called, joint = " $ DInfo.JointName $ ", type = " $ DInfo.DamageType $ ", damage = " $ DInfo.Damage $ "." );
	}

	function Timer()
	{
		GotoState( , 'Recover' );
	}

Damaged:
	if( !BrainOpen )
		goto 'Wait';

	StartMultiBrainShot();
	FinishAnim();
	goto 'Finish';

Resume:
Dodge:
Recover:
	StartMultiMouthShotRecover();
	FinishAnim();

Finish:
	SetBrainClosed();
	GotoState( 'AIAttackPlayer' );

Begin:
	SetTimer( VulnerableTime, false );
Wait:
//	FinishAnim();
}

state AIIgnore
{
	function TakeDamage( Pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
	{
		DebugInfoMessage( ".TakeDamage() delta = " $ JointPlace('KingRoot').pos - Location $ ", location = " $ Location $ "." );
	}
}

state AITakeDamage
{
	function BeginState()
	{
		super.BeginState();

		PopState();
	}

Dodged:
Resume:
Damaged:
Begin:
}

state AIAttackPlayer
{
	// *** new (state only) functions ***
	// dispatch to next appropriate (attack) state
	function Dispatch()
	{
		local Place RootJoint;
		local vector Delta;

		RootJoint = JointPlace( RootJointName );
		Delta = Enemy.Location - RootJoint.pos;

		if( VSize( Delta ) >= MinChestAttackDist )
		{
			if( UseChestAttack( Enemy ) )
				GotoState( 'KingChestAttack' );
			else if( Delta dot Vector(Rotation) > 0.0 )
				GotoState( 'KingAcidAttack' );
		}
	}

// Entry point when returning from AITakeDamage
DAMAGED:
	PlayAnim( 'Taunt' );

// Entry point when resuming this state
DODGED:
RESUME:

// Default entry point
BEGIN:
	if ( ( Enemy != none ) && ( Enemy.Health > 0 ) )
	{
		Dispatch();
	}

Attacked:
	if( RetractHead() )
	{
		PlayAnim( 'Headretracts' );
		FinishAnim();
	}

	PlayWait();
	Sleep( FVariant( AttackDelay, 0.25*AttackDelay) );

	goto 'RESUME';
}

defaultproperties
{
     TentacleRange=2000
     MinChestAttackDist=150
     KeepHeadOutTime=10
     AttackDelay=2.5
     BrainRadius=96
     VulnerableJoint(0)=Neck2
     VulnerableJoint(1)=Neck3
     VulnerableJoint(2)=Neck4
     VulnerableJoint(3)=Neck5
     VulnerableJoint(4)=Mouth
     NumVulnerableJoints=5
     BrainJoint(0)=Brain1
     BrainJoint(1)=Spine4
     BrainJoint(2)=Brain_TentLeftR_1
     BrainJoint(3)=Brain_TentB_1
     BrainJoint(4)=Brain_TentC_1
     BrainJoint(5)=Brain_TentD_L_1
     BrainJoint(6)=Brain_TentE_1
     BrainJoint(7)=Brain_TentF_1
     BrainJoint(8)=Brain_TentG_1
     BrainJoint(9)=HeadBackR1
     BrainJoint(10)=HeadBackL1
     NumBrainJoints=11
     RootJointName=KingRoot
     bTakesDamage=True
     MeleeInfo(0)=(Damage=30,EffectStrength=0.125,Method=RipSlice)
     MeleeInfo(1)=(Damage=60,EffectStrength=0.25,Method=RipSlice)
     MeleeInfo(2)=(Damage=60,EffectStrength=0.25,Method=RipSlice)
     MeleeInfo(3)=(Damage=60,EffectStrength=0.25,Method=RipSlice)
     MeleeInfo(4)=(Damage=60,EffectStrength=0.25,Method=RipSlice)
     MeleeInfo(5)=(Damage=60,EffectStrength=0.25,Method=RipSlice)
     WeaponAccuracy=0.99
     DamageRadius=350
     PhysicalScalar=0.15
     ReactToDamageThreshold=15
     MeleeRange=1000
     Health=1500
     SoundSet=Class'Aeons.KingSoundSet'
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.King_Body_m'
     bAlwaysRelevant=True
}
