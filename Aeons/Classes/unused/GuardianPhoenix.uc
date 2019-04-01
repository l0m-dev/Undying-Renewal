//=============================================================================
// GuardianPhoenix.
//=============================================================================
class GuardianPhoenix expands Darkbat;

#exec MESH IMPORT MESH=GuardianPhoenix_m SKELFILE=Phoenix.ngf INHERIT=DarkBat_m


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
#exec MESH NOTIFY SEQ=Attack_Bite TIME=0.0434783 FUNCTION=PlaySound_N ARG="Atk PVar=0.2 VVar=0.1"
#exec MESH NOTIFY SEQ=Attack_Bite TIME=0.434783 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=Attack_Dive TIME=0.0666667 FUNCTION=PlaySound_N ARG="Atk PVar=0.2 VVar=0.1"
#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.133333 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.4 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=Death_End TIME=0.222222 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=1.25 VVar=0.1"
#exec MESH NOTIFY SEQ=Death_Start TIME=0.0769231 FUNCTION=PlaySound_N ARG="VDeath PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=Death_Start TIME=0.307692 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=Hunt TIME=0.266667 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"
#exec MESH NOTIFY SEQ=Idle_Wake TIME=0.166667 FUNCTION=PlaySound_N ARG="WingFlap PVar=0.2 V=0.5 VVar=0.1"


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayWalk()
{
	if ( DefCon == 0 )
		LoopAnim( 'hunt', FVariant( 0.25, 0.05 ) );
	else
		LoopAnim( 'hunt', FVariant( 1.2, 0.4 ) );
}

function PlayRun()
{
	PlayWalk();
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	FireMod.Activate();
}

function GiveModifiers()
{
	super.GiveModifiers();
	if ( FireMod != none )
		FireMod.Destroy();

	FireMod = Spawn( class'PhoenixFireModifier', self,, Location );
}

function Generated()
{
}

function bool FlankEnemy()
{
	return false;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************


//****************************************************************************
// AINearAttackRun
// Post near attack action.
//****************************************************************************
state AINearAttackRun
{
	// *** ignored functions ***
	function AnimEnd(){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		bCanStrafe = true;
	}

	function EndState()
	{
		super.EndState();
		bCanStrafe = false;
	}

	// *** new (state only) functions ***

BEGIN:
	StopMovement();
	PlayWalk();
	SetTimer( FVariant( 1.25, 0.25 ), false );
	StrafeFacing( Location + vect(0,0,28) * CollisionHeight, Enemy, 0.45 );
	StopMovement();

} // state AINearAttackRun


//****************************************************************************
// AICharge
// Charge Enemy.
//****************************************************************************
state AICharge
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Timer()
	{
		super.Timer();

		if ( FRand() < 0.10 )
			PlaySound_P( "Atk PVar=0.2 VVar=0.1" );
	}

	// *** new (state only) functions ***

} // state AICharge


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     HoverAltitude=350
     HoverVariance=350
     HoverRadius=400
     MeleeInfo(0)=(Damage=15,EffectStrength=0.15,Method=RipSlice)
     WalkSpeedScale=0.45
     FireScalar=0
     AirSpeed=800
     Health=60
     SoundSet=Class'Aeons.GuardianPhoenixSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.GuardianPhoenix_m'
     DrawScale=0.225
     TransientSoundRadius=1500
     CollisionRadius=24
     CollisionHeight=18
}
