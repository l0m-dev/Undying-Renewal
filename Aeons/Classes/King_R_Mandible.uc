//=============================================================================
// King_R_Mandible.
//=============================================================================
class King_R_Mandible expands King_Part;
//#exec MESH IMPORT MESH=King_R_Mandible_m SKELFILE=King_R_Mandible.ngf

//#exec MESH NOTIFY SEQ=Attack TIME=0.429 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.457 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.514 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack TIME=0.629 FUNCTION=DoNearDamage

//#exec MESH NOTIFY SEQ=Attack TIME=0.055 FUNCTION=PlaySound_N ARG="WhooshLt PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack TIME=0.333 FUNCTION=PlaySound_N ARG="WhooshLt PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack TIME=0.388 FUNCTION=PlaySound_N ARG="LightHit PVar=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage TIME=0.000 FUNCTION=PlaySound_N ARG="VDamage P=1.2 PVar=0.1 V=1.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death TIME=0.000 FUNCTION=PlaySound_N ARG="VDamage P=1.2 PVar=0.1 V=1.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death TIME=0.142 FUNCTION=C_BfallBig
//#exec MESH NOTIFY SEQ=Death TIME=0.476 FUNCTION=C_BfallSmall


var King_Mouth KingMouth;

function AdjustDamage( out DamageInfo DInfo )
{
	local vector X, Y, Z, dir;
	local float dist, damageScale;

	if( (DInfo.JointName == 'none') && (DInfo.DamageRadius > 0.0) )
	{
		dir = JointPlace( RootJointName ).pos - DInfo.DamageLocation;
		dist = FMax(1, VSize(dir));
		damageScale = FMax( 0.1, 1 - FMax(0, (dist - DamageRadius) / DInfo.DamageRadius) );
		DInfo.Damage *= damageScale;
	}
	
	super.AdjustDamage( DInfo );
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

		rVect = LookAtManager.GetTargetLocation() - JointPlace('Mand_R_Root01').Pos;
		ViewRotation = rotator(rVect);
		ViewRotation.Pitch = 0;
		if ( ( rVect dot vector(Rotation) ) < 0.50 )
		{
			ClearTargets();
			return;
		}
		AddTargetRot( 'Man_R_SHoulder01', ConvertRot(ViewRotation), true, true );
//		PointJoint( 'Man_R_SHoulder01' );
	}
	else
	{
//		DebugInfoMessage( ".PreSkelAnim() not looking at anything." );
		ClearTargets();
	}
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if( JointStrikeValid( Victim, 'Man_R_Elbow01', DamageRadius ) ||
		JointStrikeValid( Victim, 'Man_R_Wrist01', DamageRadius ) ||
		JointStrikeValid( Victim, 'Man_R_Claw02', DamageRadius ) ||
		JointStrikeValid( Victim, 'Man_R_Claw04', DamageRadius ) )
		return true;
	else
		return false;
}

function Init( King_Mouth Mouth )
{
	KingMouth = Mouth;
}

function bool PlayDamage( DamageInfo DInfo )
{
	if( (DInfo.DamageType == 'scythe') || (DInfo.DamageType == 'scythedouble') )
	{
		PlayAnim( 'Damage' );
		return true;
	}
	else
		return false;
}
	
//****************************************************************************
// AITakeDamage
// take damage, animate
//****************************************************************************
state AITakeDamage
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function TeamAIMessage( ScriptedPawn sender, ETeamMessage message, actor instigator ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function DelayedOrder( name OState, name OTag ){}

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState( "Physics is " $ Physics );
		PushLookAt( none );
	}

	function EndState()
	{
		global.EndState();
		PopLookAt();
	}

	function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
	{
		ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
	}

// Entry point when resuming this state
RESUME:

// Default entry point
BEGIN:
	FinishAnim();
	PopState();
} // state AITakeDamage

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'Death' );
}

state Dying
{
	function BeginState()
	{
		super.BeginState();

		KingMouth.MandibleDied( self );
	}
}
	

defaultproperties
{
     MinTanYaw=-0.1
     RootJointName=Mand_R_Root01
     bTakesDamage=True
     MeleeInfo(0)=(Damage=20,EffectStrength=0.25,Method=RipSlice)
     bHackable=True
     MeleeRange=1000
     Health=80
     SoundSet=Class'Aeons.KingSoundSet'
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.King_R_Mandible_m'
     bAlwaysRelevant=True
}
