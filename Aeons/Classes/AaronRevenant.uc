//=============================================================================
// DavidRevenant.
//=============================================================================
class AaronRevenant expands ScriptedFlyer;

var(AICombat)	float	AttackSpeed;
var(AICombat)	float	PassThroughDistance;
var				vector	AttackVelocity;
var				vector	AttackAccel;
var				float 	AttackTime;
var(Display)	float	MinOpacity;
var(Display)	float	MaxOpacity;
var		AaronSpawnPoint	TeleportPoint;
var() 			float	ReachableRange;		// Distance that enemy is considered reachable without teleport.
var()			float	ReappearTimer;
var				name	TransformStartState;

//#exec MESH IMPORT MESH=AaronRevenant_m SKELFILE=DavidRevenant.ngf INHERIT=AaronGhost_m
//#exec MESH JOINTNAME Head=Hair Neck=Head
//#exec MESH MODIFIERS LeftHook1:Chain

//#exec MESH NOTIFY SEQ=flyattackstart TIME=0.3333 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=flyattackstart TIME=0.6666 FUNCTION=DoNearDamage			//
//#exec MESH NOTIFY SEQ=flyattackstart TIME=1.0000 FUNCTION=StartPassThroughAttack			//
//#exec MESH NOTIFY SEQ=flyattackcycle TIME=0.1333 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=flyattackcycle TIME=0.4666 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=flyattackcycle TIME=0.8000 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=specialkill TIME=0.107 FUNCTION=OJDidIt
//#exec MESH NOTIFY SEQ=specialkill TIME=0.182 FUNCTION=OJDidIt
//#exec MESH NOTIFY SEQ=specialkill TIME=0.950 FUNCTION=OJDidItAgain


//#exec MESH NOTIFY SEQ=idle2 TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle2 TIME=0.555556 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack1 TIME=0.0 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.7 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=attack1 TIME=0.0 FUNCTION=PlaySound_N ARG="HookWhshA PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=attack1 TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack1 TIME=0.541667 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack1 TIME=0.583333 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=awaken TIME=0.0 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=awaken TIME=0.0 FUNCTION=PlaySound_N ARG="HookWhshA PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=awaken TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=awaken TIME=0.0574713 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=awaken TIME=0.195402 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=awaken TIME=0.229885 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=awaken TIME=0.229885 FUNCTION=PlaySound_N ARG="ChainWhipA"
//#exec MESH NOTIFY SEQ=awaken TIME=0.436782 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=awaken TIME=0.436782 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=awaken TIME=0.448276 FUNCTION=PlaySound_N ARG="StumpFS"
//#exec MESH NOTIFY SEQ=awaken TIME=0.62069 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=awaken TIME=0.804598 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=block TIME=0.2 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.5 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=block TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=block TIME=0.116279 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=block TIME=0.162791 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=block TIME=0.395349 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=block TIME=0.418605 FUNCTION=PlaySound_N ARG="HookWhshA PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=chainreturn TIME=0.0 FUNCTION=PlaySound_N ARG="VEffort CHANCE=0.5 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=chainreturn TIME=0.0 FUNCTION=PlaySound_N ARG="ChainWhipB"
//#exec MESH NOTIFY SEQ=chainreturn TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainreturn TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainreturn TIME=0.14 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainreturn TIME=0.44 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainreturn TIME=0.88 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainstuck TIME=0.0 FUNCTION=PlaySound_N ARG="VEffort CHANCE=0.5 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=chainstuck TIME=0.0 FUNCTION=PlaySound_N ARG="ChainPullA"
//#exec MESH NOTIFY SEQ=chainstuck TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainstuck TIME=0.804348 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainthrow TIME=0.3 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.5 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=chainthrow TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=chainthrow TIME=0.409091 FUNCTION=PlaySound_N ARG="HookWhshA PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=chainthrow TIME=0.409091 FUNCTION=PlaySound_N ARG="ChainThrowA"
//#exec MESH NOTIFY SEQ=chainthrow TIME=0.636364 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death1 TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.00746269 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.0746269 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.0970149 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death1 TIME=0.208955 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.238806 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=death1 TIME=0.246269 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death1 TIME=0.283582 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.298507 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.447761 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.522388 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.641791 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death1 TIME=0.820895 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=death1 TIME=0.843284 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=death1 TIME=0.858209 FUNCTION=PlaySound_N ARG="BFallBig"
//#exec MESH NOTIFY SEQ=death1 TIME=0.858209 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.0210526 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.0315789 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death2 TIME=0.115789 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.442105 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.526316 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.673684 FUNCTION=PlaySound_N ARG="StumpFS"
//#exec MESH NOTIFY SEQ=death2 TIME=0.684211 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.768421 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=death2 TIME=0.810526 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death2 TIME=0.810526 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=death2 TIME=0.831579 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.7 VVar=0.1"
//#exec MESH NOTIFY SEQ=death2 TIME=0.863158 FUNCTION=PlaySound_N ARG="BFallBig"
//#exec MESH NOTIFY SEQ=death2 TIME=0.863158 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=flyattackcycle TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=flyattackend TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=flyattackend TIME=0.0555556 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=flyattackend TIME=0.185185 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=flyattackend TIME=0.703704 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=flyattackstart TIME=0.692 FUNCTION=PlaySound_N ARG="VAttack CHANCE=0.9 PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=flyattackstart TIME=0.230769 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=flyattackstart TIME=0.538462 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=hunt TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=hunt TIME=0.225806 FUNCTION=PlaySound_N ARG="StumpFS"
//#exec MESH NOTIFY SEQ=hunt TIME=0.225806 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=hunt TIME=0.709677 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=hunt TIME=0.709677 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.0594059 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.0792079 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.168317 FUNCTION=PlaySound_N ARG="StumpFS"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.168317 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.217822 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.247525 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.39604 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.70297 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt1 TIME=0.722772 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=transform2 TIME=0.0 FUNCTION=PlaySound_N ARG="HookWhshA PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=transform2 TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=transform2 TIME=0.09375 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=transform2 TIME=0.59375 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=transform2 TIME=0.625 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.153846 FUNCTION=PlaySound_N ARG="StumpFS"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.153846 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.205128 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.435897 FUNCTION=PlaySound_N ARG="HookWhshA PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.435897 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.435897 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=turn_left TIME=0.0 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_left TIME=0.516129 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_left TIME=0.516129 FUNCTION=PlaySound_N ARG="StumpFS"
//#exec MESH NOTIFY SEQ=turn_left TIME=0.548387 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.15625 FUNCTION=PlaySound_N ARG="StumpFS"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.15625 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.15625 FUNCTION=PlaySound_N ARG="ChainMvmtA PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.25 FUNCTION=PlaySound_N ARG="HookWhshB PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.46875 FUNCTION=PlaySound_N ARG="ChainMvmtB PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.46875 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=turn_right TIME=0.53125 FUNCTION=PlaySound_N ARG="HookWhshA PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.000 FUNCTION=PlaySound_N ARG="SpKill"
//#exec MESH NOTIFY SEQ=specialkill TIME=0.358 FUNCTION=PlaySound_N ARG="VTaunt"

function PreBeginPlay()
{
	super.PreBeginPlay();

	SetCollision( true, false, false );
}

function SnapToIdle()
{
	LoopAnim( 'idle2', [TweenTime] 0.0 );
}

function PlayLocomotion( vector dVector )
{
	local vector x, y, z;
	if( VSize( dVector ) < 0.01 )
		PlayWait();
	else 
	{
		GetAxes( Rotation, x, y, z );

		if( ( x dot dVector ) < 0.0 )	// backwards
			PlayAnim( 'flight_start' );
		else if( ( x dot dVector ) < 0.5 ) // mostly sideways
		{
			if( ( y dot dVector ) < 0.0 ) // right
				LoopAnim( 'flystraferight' );
			else
				LoopAnim( 'flystrafeleft' );
		}
		else
			LoopAnim( 'flyforward' );
	}
}

function PlayTaunt()
{
	PlayAnim( 'taunt1' );
}

function vector GetTotalPhysicalEffect( float DeltaTime )
{
	return vect(0,0,0);
}

function AdjustDamage( out DamageInfo DInfo )
{
	DInfo.Damage = 0;
}

function bool FlankEnemy()
{
	return false;
}

function PlayNearAttack()
{
	local vector AttackTarget;

	if( Enemy != none )
	{
		AttackSpeed = Default.AttackSpeed;
		AttackTarget = Enemy.Location; // + 0.5*Enemy.CollisionHeight*vect(0,0,1);
		AttackVelocity = AttackSpeed * Normal( AttackTarget - Location );
	}

	PlayAnim( 'flyattackstart' );
}

function StartPassThroughAttack()
{
	// After attacking, go to aispecialteleport, then resume attacks.
	PushState( GetStateName(), 'ATTACKED' );
	PushState( 'AISpecialTeleport', 'Begin' );
	GotoState( 'PassThroughAttack' );
}

state PassThroughAttack
{
	// *** ignored functions ***
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}
	function Bump( actor Other ){}

	function HitWall( vector hitNormal, actor hitWall, byte textureID )
	{
		local float mag;

		mag = 1.25 * hitNormal dot AttackVelocity;
		AttackVelocity -= (mag * hitNormal);
	}

	function BeginState()
	{
		local float desiredDelta;

		DebugBeginState();
		
		if( Enemy != none )
		{
			LoopAnim( 'flyattackcycle' );
		
			AttackTime = (VSize( Enemy.Location - Location ) + PassThroughDistance) / AttackSpeed;
			DesiredSpeed = AttackSpeed;
			Velocity = AttackVelocity;
			AttackAccel = vect(0,0,0);
			
			desiredDelta = -AttackVelocity.Z * AttackTime;		
			AttackAccel.Z = 2.0 * desiredDelta / (AttackTime * AttackTime);
		}
		else
		{
			DebugInfoMessage(".PassThroughAttack -- no enemy.");
			GotoState( , 'End' );
		}
	}

	function EndState()
	{
		DebugEndState();
	}
	
	function Tick( float deltaTime )
	{
		AttackVelocity +=  (deltaTime * AttackAccel);
		DesiredSpeed = AttackSpeed;
		Velocity = AttackVelocity;

		global.Tick( deltaTime );
	}

	function Timer()
	{
		DebugInfoMessage( ".PassThroughAttack.Timer() -- end attack animation." );
		GotoState( , 'End' );
	}

Damaged:
Resume:
End:	
	AttackSpeed = 0;
	AttackVelocity = vect(0, 0, 0);
	DesiredSpeed = AttackSpeed;
	Velocity = AttackVelocity;

	if ( Enemy != none )
		DesiredRotation = rotator(Enemy.Location - Location);
	PlayAnim( 'flyattackend',, MOVE_None );
	FinishAnim();

Exit:
	PopState();

Begin:
	SetTimer( AttackTime, false );
}

//****************************************************************************
// AIAttack
// primary attack dispatch state
//****************************************************************************
state AIAttack
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Dispatch()
	{
		local float		Dist;

		Dist = PathDistanceTo( Enemy );
		if ( (Dist > ReachableRange) || (Dist < 0) || !actorReachable(Enemy) )
		{
			DebugInfoMessage( ".AIAttack, Dispatch() teleporting" );
			PushState( GetStateName(), 'RESUME' );
			GotoState( 'AISpecialTeleport' );
		}
		else
		{
			DebugInfoMessage( ".AIAttack, Dispatch(), calling super.Dispatch(), dist is " $ Dist );
			super.Dispatch();
		}
	}

	// *** new (state only) functions ***

} // state AIAttack


state AICantReachEnemy
{
	function BeginState()
	{
		super.BeginState();
		
		if( Enemy != none )
		{
			PushState( 'AIAttack', 'RESUME' );
			GotoState( 'AISpecialTeleport' );
		}
	}
}
	
state AIHuntPlayer
{
	function bool KeepHunting( actor target )
	{
		local float		Dist;

		if( super.KeepHunting( target ) )
		{
			Dist = PathDistanceTo( target );

			return ((Dist <= ReachableRange) && (Dist >= 0));
		}
		else
			return false;
	}
}

state AIChasePlayer
{
	function bool KeepChasing( actor target )
	{
		local float		Dist;

		if( super.KeepChasing( target ) )
		{
			Dist = PathDistanceTo( target );

			return ((Dist <= ReachableRange) && (Dist >= 0));
		}
		else
			return false;
	}
}

//****************************************************************************
// AISpecialTeleport
// Teleport to another part of the house.
//****************************************************************************
state AISpecialTeleport
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function EffectorHearNoise( actor sensed ){}
	function EffectorSeePlayer( actor sensed ){}
	function Trigger( actor Other, pawn EventInstigator ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function ReactToDamage( pawn Instigator, DamageInfo DInfo ){}

	// Find nearest reachable teleport point.
	function AaronSpawnPoint FindNearTeleportPoint()
	{
		local AaronSpawnPoint	sPoint, aPoint;
		local float				aDist, BestDist;

		sPoint = none;
		foreach AllActors( class'AaronSpawnPoint', aPoint )
		{
			aDist = PathDistanceTo( aPoint );
			if ( ( Enemy != none ) &&
				 IsForwardProgress( Enemy.Location, aPoint.Location ) &&
				 ( DistanceTo( Enemy ) < aDist ) )
				aDist *= 1.50;
			if ( ( sPoint == none ) || ( ( aDist >= 0.0 ) && ( aDist < BestDist ) ) )
			{
				sPoint = aPoint;
				BestDist = aDist;
			}
		}

		return sPoint;
	}

	// Compute a valid teleportation location based on the location passed.
	function vector ComputeTeleportLocation( vector here )
	{
		local vector	HitLocation, HitNormal;
		local int		HitJoint;

		Trace( HitLocation, HitNormal, HitJoint, here - vect(0,0,500), here, false );
		return HitLocation + ( vect(0,0,1) * CollisionHeight );
	}

	// Find a good point to shadow-morph to.
	function AaronSpawnPoint FindAmbushPoint()
	{
		local AaronSpawnPoint	sPoint, aPoint, sPoint2;
		local vector			oLocation;
		local float				aDist, pDist, BestDist, BestDist2;

		oLocation = Location;
		sPoint = none;
		foreach AllActors( class'AaronSpawnPoint', aPoint )
		{
			aDist = VSize(Enemy.Location - aPoint.Location);
			if ( ( sPoint == none ) ||
				 ( aDist < BestDist ) ||
				 ( aDist < BestDist2 ) )
			{
				SetLocation( ComputeTeleportLocation( aPoint.Location ) );
				pDist = PathDistanceTo( Enemy );
				if ( pDist < 0.0 )
					pDist = aDist * 10.0;	// if can't path to Enemy from this point, assign arbitrary large distance
				if ( ( pDist > 0.0 ) &&
					 ( ( sPoint == none ) || ( pDist < BestDist ) ) )
				{
					if ( sPoint != none )
					{
						sPoint2 = sPoint;
						BestDist2 = BestDist;
					}
					sPoint = aPoint;
					BestDist = pDist;
				}
				else if ( ( pDist > 0.0 ) && ( sPoint2 != none ) && ( pDist < BestDist2) )
				{
					sPoint2 = aPoint;
					BestDist2 = pDist;
				}
			}
		}
		SetLocation( oLocation );
		if ( ( sPoint2 != none ) && ( FRand() < 0.60 ) )
			return sPoint2;
		else
			return sPoint;
	}

	// Perform the shadow-moprh.
	function TeleportTo( vector Here )
	{
		local vector	DVect;

		VisionEffector.Reset();
		SetLocation( ComputeTeleportLocation( Here ) );
		DVect = Enemy.Location - Location;
		DVect.Z = 0.0;
		SetRotation( rotator(DVect) );
		DesiredRotation = Rotation;
	}

	function Timer()
	{
		GotoState( , 'Reappear');
	}

Reappear:
	OpacityEffector.SetFade( 0.0, -1.0 );
	OpacityEffector.SetFade( default.Opacity, 1.0 );
	PlayAnim( 'transform2',,,, 0.0 );
	FinishAnim();

END:
	PopState();

BEGIN:

	/*
	TeleportPoint = FindNearTeleportPoint();
	if ( TeleportPoint != none )
		TeleportPoint.Using( self );

GOTOACT:
	if ( CloseToPoint( TeleportPoint.Location, 2.0 ) )
	{
		goto 'ATPOINT';
	}
	else if ( actorReachable( TeleportPoint ) )
	{
		PlayRun();
		MoveTo( GetGotoPoint( GetEnRoutePoint( TeleportPoint.Location, -50.0 ) ), FullSpeedScale );
		goto 'ATPOINT';
	}
	else
	{
		OrderObject = TeleportPoint;
		PathObject = PathTowardOrder();
		if ( PathObject != none )
		{
			// can path to OrderObject
			PlayRun();
			MoveToward( PathObject, FullSpeedScale );
			goto 'GOTOACT';
		}
	}
	*/

ATPOINT:
//	Spawn( class'ScarrowDarkLight', self,, Location );
	OpacityEffector.SetFade( Opacity, -1.0 );
	OpacityEffector.SetFade( 0.0, 1.0 );
	PlayAnim( 'transform1' );
	PlaySound_P( "VTeleport" );
//	MoveToward( TeleportPoint, FullSpeedScale * 0.60 );

INSHADOW:
	FinishAnim();

DAMAGED:
RESUME:

	TeleportPoint = FindAmbushPoint();
	if ( TeleportPoint != none )
	{
		TeleportTo( TeleportPoint.Location );
	}
	else
		DebugInfoMessage( " FindAmbushPoint() found NONE" );

	SetTimer( ReappearTimer, false );
} // state AISpecialTeleport

state AITakeDamage
{
	function BeginState()
	{
		DebugBeginState();
		PopState();
	}
	
	function EndState()
	{
		DebugEndState();
	}
}

state AaronTransform expands AIDoNothing
{
Begin:
	PlayAnim( 'transform2' );
	FinishAnim();
	GotoState( TransformStartState );
}


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function PostSpecialKill()
	{
		TargetActor = SK_TargetPawn;
		GotoState( 'AIDance', 'DANCE' );
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
	}

	function StartSequence()
	{
		GotoState( , 'AARONSTART' );
	}

	// *** new (state only) functions ***
	function OJDidIt()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('spine3').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'spine3', 'root');
	}

	function OJDidItAgain()
	{
		PlayerBleedOutFromJoint('spine3');
	}


AARONSTART:
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'aaron_death', [TweenTime] 0.0  );
	PlayAnim( 'specialkill', [TweenTime] 0.0  );
	FinishAnim();
	PostSpecialKill();

} // state AISpecialKill

defaultproperties
{
     AttackSpeed=500
     PassThroughDistance=400
     MinOpacity=0.2
     MaxOpacity=0.45
     ReachableRange=8500
     ReappearTimer=3
     HoverAltitude=80
     HoverVariance=20
     HoverRadius=10
     bCanHover=True
     SafeDistance=20
     Aggressiveness=1
     MeleeInfo(0)=(Damage=25,Method=RipSlice)
     DamageRadius=75
     SK_PlayerOffset=(X=80,Z=20)
     bHasSpecialKill=True
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.6
     WalkSpeedScale=0.55
     PhysicalScalar=0.5
     FireScalar=0.5
     bIsEthereal=True
     LostCounter=0
     bCanStrafe=True
     bCanFly=True
     MeleeRange=400
     GroundSpeed=300
     AirSpeed=300
     Alertness=1
     SightRadius=9000
     BaseEyeHeight=52
     Health=600
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.AaronRevenantSoundSet'
     Style=STY_AlphaBlendZ
     Mesh=SkelMesh'Aeons.Meshes.AaronRevenant_m'
     Opacity=0.3
     bUnlit=True
     CollisionHeight=52
     bGroundMesh=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     LightEffect=LE_WateryShimmer
     LightBrightness=255
     LightHue=128
     LightSaturation=64
     LightRadius=24
     LightRadiusInner=16
     MenuName="Aaron"
     CreatureDeathVerb="possesed"
}
