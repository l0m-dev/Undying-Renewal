//=============================================================================
// ScriptedNarrator.
//=============================================================================
class ScriptedNarrator expands ScriptedBiped
	abstract;


//****************************************************************************
// Member vars.
//****************************************************************************
var pawn					MyKiller;			//
var float					KillTimer;			//
var() float					DeathAutoRestart;	//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	local float		InitGroundSpeed;
	local float		InitAirSpeed;
	local float		InitDrawScale;

	InitGroundSpeed = GroundSpeed;
	InitAirSpeed = AirSpeed;
	InitDrawScale = DrawScale;

	super.PreBeginPlay();

	GroundSpeed = InitGroundSpeed;
	AirSpeed = InitAirSpeed;
	DrawScale = InitDrawScale;

	PlayerLeash = Spawn( class'NarratorTractorBeam', self,, Location );
}

function Destroyed()
{
	if ( PlayerLeash != none )
	{
		PlayerLeash.Destroy();
		PlayerLeash = none;
	}
	if ( ( KillTimer > 0.0 ) && ( PlayerPawn(MyKiller) != none ) )
	{
		PlayerPawn(MyKiller).PlayerDied( 'FadingDeath' );
	}

	super.Destroyed();
}

function Trigger( actor Other, pawn EventInstigator )
{
	DebugInfoMessage( ".Trigger, Other is " $ Other.name $ ", EventInstigator is " $ EventInstigator );
	ScriptTriggerer = Other;
	if ( TriggerScriptTag != '' )
		Script = FindScript( TriggerScriptTag );
	ScriptAction = TriggerScriptAction;
	GotoState( 'AIRunScript', 'TRIGGER' );
}

function CheckHatedEnemy( pawn Other )
{
}

function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
{
	DebugInfoMessage( ".Died(), Killer is " $ Killer.name $ ", damageType is " $ damageType );
	if ( damageType == 'fire' )
		Killer = FindPlayer();
	MyKiller = Killer;
	KillTimer = DeathAutoRestart;
	if ( ( KillTimer > 0.0 ) && ( PlayerPawn(MyKiller) != none ) )
		DisableTeleporters();
	super.Died( Killer, damageType, HitLocation, DInfo );
}

function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );
	if ( KillTimer > 0.0 )
	{
		KillTimer = FMax( KillTimer - DeltaTime, 0.0 );
		if ( ( KillTimer == 0.0 ) && ( PlayerPawn(MyKiller) != none ) )
		{
			PlayerPawn(MyKiller).PlayerDied( 'FadingDeath' );
		}
	}
}

function Bump( actor Other )
{
	if ( !bIgnoreBump && !bIsLeashed )
		super.Bump( Other );
}

function TakeMindshatter( pawn Instigator, int castingLevel )
{
	super.TakeMindshatter( Instigator, castingLevel );
	MyKiller = Instigator;
	KillTimer = DeathAutoRestart;
	if ( ( KillTimer > 0.0 ) && ( PlayerPawn(MyKiller) != none ) )
		DisableTeleporters();
}


//****************************************************************************
// New class functions.
//****************************************************************************
function DisableTeleporters()
{
	local Teleporter	T;

	if (Level.NetMode == NM_Standalone)
	{
		foreach AllActors( class'Teleporter', T )
		{
			T.bEnabled = false;
			T.bForcePlayerTouch = true;
		}
	}
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     DeathAutoRestart=5
     OrderState=AIRunScript
     AttitudeToPlayer=ATTITUDE_Ignore
     TransientSoundRadius=2560
     Mass=2000
}
