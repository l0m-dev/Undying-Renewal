//=============================================================================
// Blood_Statue.
//=============================================================================
class Blood_Statue expands Pawn;

//#exec MESH IMPORT MESH=Blood_Statue_m SKELFILE=Blood_Statue.ngf
//#exec MESH ORIGIN X=32

//#exec OBJ LOAD FILE=\Aeons\Sounds\LevelMechanics.uax PACKAGE=LevelMechanics
//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts


//****************************************************************************
// Member vars.
//****************************************************************************
var actor					LookTarget;			//
var vector					LookLocation;		//
var() vector				LookAheadOffset;	//
var() vector				LookDownOffset;		//
var PlayerPawn				Player;				//
var bool					bUseLooking;		//
var() float					HeartHealth;		//
var() float					HeartDropVelocity;	//
var() name					HeartEvent;			//
var() float					FountainDelay;		//
var() sound					NormalAmbientSound;	//
var() sound					RipOpenSound;		//
var() sound					HeartBeatSound;		//
var() sound					VocalSound1;		//
var() sound					MovementSound1;		//
var() sound					MovementSound2;		//
var() sound					ImpactSound;		//
var int						SoundID1;			//
var int						SoundID2;			//
var int						SoundID3;			//
var() byte					NormalVolume;		//
var() byte					HeartBeatVolume;	//
var() float					SpeakAmplitude;		//
var() class<Pickup>			HeartDropClass;		//
var() class<Actor>			BloodPuffEffect;	//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	SetLimbTangible( 'root', false );
	SetLookLocation( LookAheadOffset );
}

function BeginState()
{
//	DebugBeginState();
}

function PreSkelAnim()
{
	local vector	DVect;
	local rotator	HRot;

	HRot = rotator(LookLocation - JointPlace('head').Pos);
	if ( bUseLooking && ( LookTarget != none ) )
	{
		DVect = LookTarget.Location - JointPlace('head').Pos;
		if ( ( DVect dot vector(Rotation) ) > 0.5 )
			HRot = rotator(DVect);
	}
	AddTargetRot( 'head', ConvertRot(HRot), true, true );
}

function TakeDamage( pawn InstigatedBy, vector HitLocation, vector Momentum, DamageInfo DInfo )
{
}


//****************************************************************************
// New class functions.
//****************************************************************************
function DebugInfoMessage( string Msg )
{
	log( name $ Msg );
}

function DebugBeginState( optional string Msg )
{
	if ( Msg != "" )
		DebugInfoMessage( "." $ GetStateName() $ ".BeginState() @" $ Level.TimeSeconds $ ", Ph=" $ Physics $ ", " $ Msg );
	else
		DebugInfoMessage( "." $ GetStateName() $ ".BeginState() @" $ Level.TimeSeconds $ ", Ph=" $ Physics );
}

function TriggerHeartEvent()
{
	local actor		A;

	if ( HeartEvent != '' )
		foreach AllActors( class'Actor', A, HeartEvent )
			A.Trigger( self, self );
}

function SpawnHeart()
{
	local Pickup	P;

	P = Spawn( HeartDropClass,,, JointPlace('heart1').pos, Rotation );
	if ( P != none )
	{
		LookTarget = P;
		P.Velocity = vector(Rotation) * HeartDropVelocity;
		P.SetPhysics( PHYS_Falling );
	}
}

function SpawnFountain()
{
	local ParticleFX	PFX;

	PFX = Spawn( class'BloodStreamPFX', self,, JointPlace('mouth').pos, ConvertQuat(JointPlace('mouth').rot) );
	if ( PFX != none )
	{
		PFX.SetBase( self, 'mouth' );
	}
}

function SetLookLocation( vector Offset )
{
	local vector	X, Y, Z;

	GetAxes( Rotation, X, Y, Z );
	Offset *= DrawScale;
	LookLocation = Location + ( X * Offset.X ) + ( Y * Offset.Y ) + ( Z * Offset.Z );
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// BSDormant
// 
//****************************************************************************
auto state BSDormant
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Trigger( actor Other, pawn EventInstigator )
	{
//		DebugInfoMessage( ".BSDormant, Trigger(), Other is " $ Other.name $ ", Instigator is " $ EventInstigator );
		Player = PlayerPawn(EventInstigator);
		if ( EventInstigator.bIsPlayer && ( Player != none ) )
		{
			LookTarget = Player;
			GotoState( 'BSScryeEvent' );
		}
	}

	// *** new (state only) functions ***

BEGIN:
	AmbientSound = NormalAmbientSound;
	SoundVolume = NormalVolume;
	bUseLooking = false;
} // state BSDormant


//****************************************************************************
// BSScryeEvent
// 
//****************************************************************************
state BSScryeEvent
{
	// *** ignored functions ***

	// *** overridden functions ***
	function EndState()
	{
		StopSound( SoundID1 );
		StopSound( SoundID2 );
		StopSound( SoundID3 );
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if ( Player.ScryeTimer < DeltaTime )
		{
			ClearAnims();
			GotoState( 'BSDormant' );
		}
	}

	function TakeDamage( pawn InstigatedBy, vector HitLocation, vector Momentum, DamageInfo DInfo )
	{
		local bool		bAlive;

//		DebugInfoMessage( ".TakeDamage(), joint is " $ DInfo.JointName );

		bAlive = ( HeartHealth > 0.0 );
		HeartHealth = HeartHealth - DInfo.Damage;
		if ( bAlive )
		{
			PlaySound( ImpactSound );
			Spawn( BloodPuffEffect, self,, HitLocation + vector(Rotation) * 10.0, Rotation );
		}

		if ( bAlive && ( HeartHealth <= 0.0 ) )
		{
			TriggerHeartEvent();
			PlayAnim( 'heart_gone_morph',, MOVE_None, COMBINE_Modulate );
			SpawnHeart();
			GotoState( 'BSDead' );
		}
	}

	// *** new (state only) functions ***

BEGIN:
	AmbientSound = none;
	SoundVolume = HeartBeatVolume;
	bUseLooking = true;
	LoopAnim( 'heart_beat_morph',, MOVE_None, COMBINE_Modulate, 0.0 );
	PlayAnim( 'arm_rip_morph',, MOVE_None, COMBINE_Modulate, 0.0 );
	SoundID1 = PlaySound( RipOpenSound, [Volume] 2.0, [Flags] SOUND_NOSCRYEPITCH );
//	DebugInfoMessage( " SoundID1 is " $ SoundID1 );
//	SoundID2 = PlaySound( VocalSound1, [Flags] SOUND_NOSCRYEPITCH );
	SoundID2 = PlayAnimSound( 'speakingmorph', VocalSound1, SpeakAmplitude, SLOT_Talk, [Flags] SOUND_NOSCRYEPITCH );
//	DebugInfoMessage( " SoundID2 is " $ SoundID2 );
	if ( SoundID2 == 0 )
		PlaySound( VocalSound1, [Flags] SOUND_NOSCRYEPITCH );
	Sleep( 1.0 );
	SoundID3 = PlaySound( HeartBeatSound, [Volume] 2.0, [Flags] SOUND_NOSCRYEPITCH );

} // state BSScryeEvent


//****************************************************************************
// BSDead
// 
//****************************************************************************
state BSDead
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***

BEGIN:
	AmbientSound = none;
	SetLookLocation( LookDownOffset );
//	Sleep( FountainDelay );
//	SpawnFountain();
} // state BSDead


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     LookAheadOffset=(X=100,Z=90)
     LookDownOffset=(X=100,Z=-100)
     HeartHealth=100
     HeartDropVelocity=75
     FountainDelay=3
     NormalAmbientSound=Sound'LevelMechanics.Onieros.A09_StatueVoiceAmb01'
     RipOpenSound=Sound'LevelMechanics.Onieros.A09_StatueRip01'
     HeartBeatSound=Sound'LevelMechanics.Onieros.A09_StatueHeartbeat03'
     VocalSound1=Sound'LevelMechanics.Onieros.A09_StatueVoice02'
     MovementSound1=Sound'LevelMechanics.Onieros.A09_StatueHead01'
     MovementSound2=Sound'LevelMechanics.Onieros.A09_StatueHead02'
     ImpactSound=Sound'Impacts.GoreSpecific.E_Imp_FleshBullet01'
     NormalVolume=128
     HeartBeatVolume=250
     SpeakAmplitude=5
     HeartDropClass=Class'Aeons.HumanHeart'
     BloodPuffEffect=Class'Aeons.CombinedBlood'
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Blood_Statue_m'
     SoundRadius=40
     TransientSoundRadius=1000
     CollisionRadius=90
     CollisionHeight=125
}
