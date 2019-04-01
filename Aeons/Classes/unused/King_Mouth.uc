//=============================================================================
// King_Mouth.
//=============================================================================
class King_Mouth expands King_Part;
#exec MESH IMPORT MESH=King_Mouth_m SKELFILE=King_Mouth.ngf

#exec MESH NOTIFY SEQ=SuctionStarts TIME=0.5 FUNCTION=SetMouthOpen
#exec MESH NOTIFY SEQ=SuctionStarts TIME=1.0 FUNCTION=SuctionCycle
#exec MESH NOTIFY SEQ=SuctionEnds TIME=0.01 FUNCTION=SetMouthClosed
#exec MESH NOTIFY SEQ=Multi_Mouthshot_Start TIME=0.01 FUNCTION=SetMouthClosed

#exec MESH NOTIFY SEQ=SuctionStarts TIME=0.000 FUNCTION=PlaySound_N ARG="SuctionStart"
//#exec MESH NOTIFY SEQ=SuctionCycle TIME=0.000 FUNCTION=PlaySound_N ARG="SuctionLoop"
#exec MESH NOTIFY SEQ=SuctionEnds TIME=0.000 FUNCTION=PlaySound_N ARG="SuctionEnd"


var TractorBeam			Beam;
var King_L_Mandible		LeftMandible;
var King_R_Mandible		RightMandible;
var King_Body			KingBody;
var bool				MouthOpen;

function SetMouthOpen()
{
	DebugInfoMessage( ".SetMouthOpen() called." );
	MouthOpen = true;

	if( Beam != none )
		Beam.bIsActive = true;
}

function SetMouthClosed()
{
	DebugInfoMessage( ".SetMouthClosed() called." );
	MouthOpen = false;
	
	if( Beam != none )
		Beam.bIsActive = false;
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	Beam = Spawn( class'KingTractorBeam', self,, Location );
	if ( Beam != none )
	{
		Beam.SetBase( self );
		Beam.bIsActive = false;
	}
}

function Destroyed()
{
	if ( Beam != none )
	{
		Beam.Destroy();
		Beam = none;
	}

	super.Destroyed();
}

function Init( King_L_Mandible LeftMand, King_R_Mandible RightMand )
{
	KingBody = King_Body( Owner );
	LeftMandible = LeftMand;
	RightMandible = RightMand;

	if( LeftMandible != none )
		LeftMandible.Init( self );
	if( RightMandible != none )
		RightMandible.Init( self );
}

function MandibleDied( King_Part Mandible )
{
	DebugInfoMessage( ".MandibleDied( " $ Mandible.name $ " ) called." );

	if( King_L_Mandible(Mandible) == LeftMandible )
		LeftMandible = none;
	if( KING_R_Mandible(Mandible) == RightMandible )
		RightMandible = none;
}

function bool MandiblesGone()
{
	return ( ((LeftMandible == none) || (LeftMandible.Health <= 0)) &&
			 ((RightMandible == none) || (RightMandible.Health <= 0)) );
}

function bool EnemyInRange()
{
	if( MandiblesGone() )
		return super.EnemyInRange();

	return false;
}

function PlayNearAttack()
{
	PlayAnim( 'SuctionStarts' );
}


//****************************************************************************
// AINearAttack
// attack near enemy (melee)
//****************************************************************************
state AINearAttack
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// *** overridden functions ***
	function BeginState()
	{
		if ( Enemy != none )
			DebugBeginState( " Enemy is " $ Enemy.name );
		else
			DebugBeginState( " Enemy is NONE" );
		StopTimer();
		bPendingBump = false;
	}

	function AnimEnd()
	{
	}

	function Bump( actor Other )
	{
		local DamageInfo DInfo;

		if( Pawn(Other) != none )
		{
			DInfo.Damage = Pawn(Other).Health * 2.0;
			DInfo.DamageType = 'instant_death';
			DInfo.Deliverer = self;
			DInfo.EffectStrength = 1.0;
			DInfo.DamageMultiplier = 1.0;

			if ( Other.AcceptDamage(DInfo) )
				Other.TakeDamage( self, Location, vect(0,0,0), DInfo );
		}
	}

	function TakeDamage( pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo )
	{
		DebugInfoMessage( ".AINearAttack.TakeDamage() called, MouthOpen = " $ MouthOpen $ "." );
		
		if( MouthOpen )
		{
			DInfo.JointName = 'mouth'; // Trick King_Body when we pass the damage up there.
			super.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
			KingBody.StartMultiMouthShot();
		}
		else
			super.TakeDamage( Instigator, HitLocation, Momentum, DInfo );
	}

	// *** new (state only) functions ***
	function PostAttack()
	{
		GotoState( 'AIAttackPlayer' );
	}

// Entry point when returning from AITakeDamage
DAMAGED:

// Entry point when resuming this state
RESUME:
	GotoState( 'AIAttackPlayer' );

// Default entry point
BEGIN:

	bDidMeleeDamage = false;
	PlayNearAttack();

INATTACK:
	Sleep( 0.1 );
	if( EnemyInRange() )
		goto 'INATTACK';

ATTACKED:
	PlayAnim( 'SuctionEnds' );
	FinishAnim();

	StopTimer();
	PostAttack();
} // state AINearAttack

defaultproperties
{
     MinSinePitch=-0.95
     RootJointName=MouthRoot
     MeleeRange=1500
     SoundSet=Class'Aeons.KingSoundSet'
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.King_Mouth_m'
     CollisionRadius=200
     CollisionHeight=150
     bCollideSkeleton=False
}
