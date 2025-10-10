//=============================================================================
// AaronGhost.
//=============================================================================
class AaronBoss expands ScriptedBiped;


//#exec MESH IMPORT MESH=AaronBoss_m SKELFILE=DavidRevenant.ngf INHERIT=TrsantiBase_m
//#exec MESH JOINTNAME Head=Hair Neck=Head
//#exec MESH MODIFIERS LeftHook1:Chain


//****************************************************************************
// Animation sequence notifications.

//#exec MESH NOTIFY SEQ=Attack1 TIME=0.182 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack1 TIME=0.227 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Attack1 TIME=0.273 FUNCTION=DoNearDamage

////#exec MESH NOTIFY SEQ=Block TIME=0.366 FUNCTION=BlockScythe
//#exec MESH NOTIFY SEQ=Block TIME=0.250 FUNCTION=BlockScythe

//#exec MESH NOTIFY SEQ=Block TIME=0.463 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Block TIME=0.512 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Block TIME=0.561 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Block TIME=0.610 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=Block TIME=0.659 FUNCTION=DoNearDamage

////#exec MESH NOTIFY SEQ=ChainThrow TIME=0.500 FUNCTION=PushBack
////#exec MESH NOTIFY SEQ=ChainThrow TIME=0.970 FUNCTION=CheckChainThrow
////#exec MESH NOTIFY SEQ=ChainReturn TIME=0.970 FUNCTION=EndChainThrow

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
//#exec MESH NOTIFY SEQ=chainthrow TIME=0.409091 FUNCTION=PlaySound_N ARG="ChainThrow1"
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
//#exec MESH NOTIFY SEQ=get_up TIME=0.111111 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.135802 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.135802 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.382716 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=get_up TIME=0.469136 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.469136 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.567901 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=trip TIME=0.025641 FUNCTION=PlaySound_N ARG="VDamage PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=trip TIME=0.025641 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=trip TIME=0.230769 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=trip TIME=0.358974 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=trip TIME=0.641026 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=trip TIME=0.692308 FUNCTION=C_BackLeft


//****************************************************************************
// Member vars.
//****************************************************************************
var				bool	LostArm;
var				bool	JumpLanding;
var				bool	KillingBlow;
var(AICombat)	float	ChainDamage;
var(AICombat)	float	ChainMomentum;
var(AICombat)	float	PushBackMomentum;
var(AICombat)	float	ChainStuckTimer;
var(AICombat)	float	ScytheRange;
var(AICombat)	float	AttackSpeed;
var				vector	ChainDirection;
var 			AaronTractorBeam	Beam;
var				AaronTractorBeamFX	BeamFX;
var				GlowScriptedFX		GlowFX;
var()			int		FirstChainJoint;
var()			int		LastChainJoint;
var				HomeBase Home;
var				bool	WillTrip;

//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function BlockScythe()
{
	local actor B;
	local vector HitLocation, Velocity;
	local float Dist;
	local PersistentWound Wound;

//	DestroyLimb( 'R_Elbow' );

	HitLocation = JointPlace( 'R_Elbow' ).pos;

	B = DetachLimb('R_Elbow', Class 'BodyPart');

	if( Home != none )
	{
		Velocity = B.Location - Home.Location;
		Dist = Velocity dot Velocity;
		if( Dist > (128*128) )
		{
			Velocity = Velocity * (128.0 / Dist);
		}
		else
		{
			Velocity = Normal( Velocity ) * 128.0;
		}

		Velocity.Z = 64.0;
	}
	else
	{
		Velocity = vect(0,0,64);
	}
	B.Velocity = Velocity;
	B.DesiredRotation = RotRand(true);
	B.bBounce = true;
	B.SetCollisionSize((B.CollisionRadius * 0.35), (B.CollisionHeight * 0.15));

	ReplicateDetachLimb(self, 'R_Elbow', B.Velocity, B.DesiredRotation);

	Spawn(class 'InstantScytheWound',self,,HitLocation);
	Wound = Spawn(class 'ScytheWound',self,,HitLocation);
	Wound.AttachJoint = 'R_Elbow';
	Wound.setup();

	bHacked = true;
	Hacked(FindPlayer());
}

function BlockedScythe()
{
	GotoState( 'AaronStartChainAttack' );
}

function TurnOnGlow()
{
	if( GlowFX != none )
	{
		GlowFX.Direction = 1.0;
		GlowFX.Enable( 'Tick' );
	}
	else
		DebugInfoMessage(".TurnOnGlow() has no GlowFX.");

	AmbientSound = Sound'CreatureSFX.Lizbeth.C_Lizbeth_HasteLp1';
}

function TurnOffGlow()
{
	if( GlowFX != none )
	{
		GlowFX.Direction = -1.0;
		GlowFX.Enable( 'Tick' );
	}
	else
		DebugInfoMessage(".TurnOffGlow() has no GlowFX.");

	AmbientSound = default.AmbientSound;
}

function TurnOnRepulsor()
{
	if( Beam != none )
		Beam.bIsActive = true;
	if( BeamFX != none )
	{
		BeamFX.TurnOnEffect();
		BeamFX.Direction = 1.0;
		BeamFX.Enable( 'Tick' );
	}
	else
		DebugInfoMessage(".TurnOnRepulsor() has no BeamFX.");
}

function TurnOffRepulsor()
{
	if( Beam != none )
		Beam.bIsActive = false;
	if( BeamFX != none )
	{
		BeamFX.Direction = -1.0;
		BeamFX.TurnOffEffect();
		BeamFX.Enable( 'Tick' );
	}
	else
		DebugInfoMessage(".TurnOffRepulsor() has no BeamFX.");
}

function CheckChainThrow()
{
	local Actor Other;
	local Texture HitTexture;
	local vector HitLocation, HitNormal, StartPoint, EndPoint;
	local int HitJoint, Flags;

//	StartPoint = JointPlace( 'AttackChain1' ).pos;
	StartPoint = Location;
//	EndPoint = StartPoint + 2000.0 * Vector( ConvertQuat( JointPlace( 'AttackChain1' ).rot ) );
	EndPoint = StartPoint + 2000.0 * ChainDirection;

	Other = Trace( HitLocation, HitNormal, HitJoint, EndPoint, StartPoint, true );
	if( (Pawn( Other ) != none) && (Other != self) )
	{
		DebugInfoMessage( ".CheckChainThrow() hit pawn " $ Other.name );

		PlaySound_P( "ChainHitStone" );
		PlayAnim( 'ChainReturn' );
		ApplyDamageAndPushBack( Other, HitJoint );
	}
	else
	{
		HitTexture = TraceTexture( EndPoint, StartPoint, Flags );
	
		if( HitTexture == none )
		{
			DebugInfoMessage( ".CheckChainThrow() HitTexture is none." );
			PlaySound_P( "ChainHitStone" );
			PlayAnim( 'ChainReturn' );
		}
		else
		{
			switch( HitTexture.ImpactID )
			{
			case TID_WoodHollow:
			case TID_WoodSolid:
				DebugInfoMessage( ".CheckChainThrow() HitTexture = " $ HitTexture.name $ " is wood." );
				PlaySound_P( "ChainHitWood" );
				if( !KillingBlow )
					GotoState( 'AIChainAttack', 'ChainStuck' );
				break;
			default:
				DebugInfoMessage( ".CheckChainThrow() HitTexture = " $ HitTexture.name $ " is not wood." );
				PlaySound_P( "ChainHitStone" );
				PlayAnim( 'ChainReturn' );				
			}
		}
	}
}

function EndChainThrow()
{
	if( !KillingBlow )
		GotoState( 'AIResumeChainAttack' );
}

//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	local int i, j;

	super.PreBeginPlay();

	Beam = Spawn( class'AaronTractorBeam', self,, Location );
	if( Beam != none )
	{
		Beam.SetBase( self );
	}

	BeamFX = Spawn( class'AaronTractorBeamFX', self,, Location );
	if( BeamFX != none )
	{
		BeamFX.SetBase( self );
	}

	GlowFX = Spawn( class'GlowScriptedFX', self,, Location );
	if( GlowFX != none )
	{
		GlowFX.SetBase( self );
		TurnOffGlow();
	}

	TurnOffRepulsor();
	LostArm = false;
	KillingBlow = false;

	foreach AllActors( class'HomeBase', Home )
		break;

	if( Home == none )
	{
		DebugInfoMessage( ".PreBeginPlay() couldn't find home base." );
	}
}

//function int SetupGlowJoints( GlowScriptedFX GlowFX )
//{
//	GlowFX.SetupJoints( 0, FirstChainJoint );
//	GlowFX.SetupJoints( LastChainJoint+1, NumJoints() );
//	return NumJoints() - (LastChainJoint - FirstChainJoint + 1);
//}

function bool AddParticleToJoint( int i )
{
	return ((i >= 0) && (i < FirstChainJoint)) || ((i > LastChainJoint) && (i < NumJoints()));
}

/*
event PreSkelAnim()
{
	local vector	rVect;

	if ( LookAtActor == none )
		NoLook();
	if ( bUseLookAt )
	{
		if ( LookAtActor != none )
		{
			// LookActor will override any previously set ViewRotation.
			// Set direction based on head positions. More reliable than EyeHeight.
			if ( LookAtActor == Enemy )
			{
				rVect = EnemyAimSpot() - JointPlace('head').Pos;
			}
			else
			{
				rVect = LookAtActor.JointPlace('head').Pos - JointPlace('head').Pos;
			}
			ViewRotation = rotator(rVect);
			if ( ( rVect dot vector(Rotation) ) < 0.50 )
				return;
		}

		AddTargetRot( 'Spine3', ConvertRot(ViewRotation), true );
	}
}
*/

// Play death animation, based on damage type.
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	DebugInfoMessage(".PlayDying() called.");
	PlayAnim( 'Death1', [OverrideTarget] true );
}

function vector GetTotalPhysicalEffect( float DeltaTime )
{
	local PhysicsEffector	PEffect;
	local vector			PVect;

	PVect = vect(0,0,0);
	foreach AllActors( class'PhysicsEffector', PEffect )
		if ( PEffect.bAffectAI && !PEffect.IsA('TractorBeam'))
			PVect += PEffect.EffectOn( Location );
	return PVect;
}

function bool DoFarAttack()
{
	return LostArm || super.DoFarAttack();
}

function PlayNearAttack()
{
	PlayAnim( 'Attack1', AttackSpeed );
}

function PlayWait()
{
	LoopAnim( 'Idle2' );
}

function bool MoveAnim( name Anim )
{
	if( Anim == 'run' )
	{
		Anim = 'hunt';
	}

	return super.MoveAnim( Anim );
}

function PlayChainAttack()
{
//	ChainDirection = Vector( Rotation );
	ChainDirection = Vector( WeaponAimAt( Enemy, Location, WeaponAccuracy ) );
	PlayAnim( 'ChainThrow', 1.0, [OverrideTarget] true );
}

// Called to warn this pawn that it should avoid something.
function WarnAvoidActor( actor Other, float Duration, float Distance, float Threat )
{
	if ( Intelligence < BRAINS_Human )
		return;
	ProcessWarnAvoidActor( Other, Duration, Distance, Threat );
}

function AdjustDamage( out DamageInfo DInfo )
{
	DebugInfoMessage(".AdjustDamage() called.");
//	super.AdjustDamage( DInfo );

	if( LostArm && !Beam.bIsActive && ((DInfo.DamageType == 'scythe') || (DInfo.DamageType == 'scythedouble')))
	{
		DebugInfoMessage(".AdjustDamage() killing blow.");
		KillingBlow = true;
		DInfo.Damage = 2.0 * InitHealth;
		DInfo.JointName = 'Head';
	}
	else
		DInfo.Damage = 0;
}

function bool Decapitate( optional vector Dir )
{
	return LostArm && super.Decapitate( Dir );
}

// Play ranged jumping attack animation.
function PlayJumpAttack()
{
	TurnOffGlow();
	PlayJump();
}

//****************************************************************************
// New class functions.
//****************************************************************************
function PushBack()
{
	local Pawn aPawn;
	local vector Momentum;

	foreach RadiusActors( class'Pawn', aPawn, 768 )
	{
		if( aPawn != self )
		{
			Momentum = aPawn.Location - Location;
			Momentum.Z = 0.0;
			Momentum = Normal( Momentum );

			aPawn.SetPhysics( PHYS_Falling );

			if( VSize( Momentum ) > 0.01 )		
			{
				Momentum.Z = 0.15;
			}
			else
			{
				Momentum = Vector( Rotation );
				Momentum.Z = 0.15;
			}

			Momentum *= PushBackMomentum;
			aPawn.Velocity += Momentum;
		}
	}
}

function ApplyDamageAndPushBack( actor Other, int HitJoint )
{
	local DamageInfo DInfo;
	local vector Momentum;

	DInfo.Damage = ChainDamage;
	DInfo.DamageType = 'AaronChain';
	DInfo.DamageString = "chain";
	DInfo.bMagical = false;
	DInfo.Deliverer = self;
	DInfo.JointName = Other.JointName( HitJoint );
	DInfo.DamageMultiplier = 1.0;

	Momentum = ChainDirection;
	Momentum.Z = 0.0;
	Momentum = Normal( Momentum );
	Momentum.Z = 0.15;
	Momentum *= ChainMomentum;

	Other.SetPhysics( PHYS_Falling );
	Other.Velocity += Momentum;
	if ( Other.AcceptDamage(DInfo) )
		Other.TakeDamage( self, Other.Location, Momentum, DInfo );

	PlaySound_P("ForceBlast PVar=0.2 V=0.5 VVar=0.2");
}

//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

state AaronTempWeak expands AIScriptedState
{
	function WeaponFireNotify( name WeaponName, Pawn Attacker )
	{
		if( !LostArm && (WeaponName == 'Scythe') && (DistanceTo(Attacker) < ScytheRange) )
		{
			GotoState( 'AaronBlockScythe' );
		}
	}
	
Begin:
Resume:
Dodged:
	PlayAnim( 'get_up' );
	FinishAnim();
	GotoState( 'AIFarAttackAnim', 'FinishedAttack' );
}

//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***


JUMPED:
	if( WillTrip )
		GotoState( 'AaronTempWeak' );

FinishedAttack:
	TurnOnGlow();
	GotoState( 'AIAttack' );

// Entry point when returning from AITakeDamage.
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state.
RESUME:

// Default entry point.
BEGIN:
	WillTrip = (FRand() < 0.25);
	SlowMovement();
	PushState( GetStateName(), 'JUMPED' );
	GotoState( 'AIJumpAtEnemy' );
} // state AIFarAttackAnim

state AIJumpAtEnemy
{
	function BeginState()
	{
		super.BeginState();
		JumpLanding = false;
	}

	function bool PlayJumpAttackLanding()
	{
		JumpLanding = true;
		if( WillTrip )
			return PlayAnim('trip');
		else
			return PlayAnim( 'Attack1', AttackSpeed );
	}

	function WeaponFireNotify( name WeaponName, Pawn Attacker )
	{
		if( !LostArm && JumpLanding && (WeaponName == 'Scythe') && (DistanceTo(Attacker) < ScytheRange) )
		{
			GotoState( 'AaronBlockScythe' );
		}
	}
}

//****************************************************************************
// AIChainAttack
// Attack far enemy with chain throw.
//****************************************************************************
state AIChainAttack expands AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		LostArm = true;
	}

	function Timer()
	{
		GotoState( 'AIChainAttack', 'RecoverChain' );
	}

	// *** new (state only) functions ***

ChainStuck:
	TurnOffRepulsor();
	LoopAnim( 'ChainStuck', [OverrideTarget] true );
	SetTimer( ChainStuckTimer, false );

WaitForChain:
	Sleep( 0.1 );
	goto 'WaitForChain';

RecoverChain:
	PlayAnim( 'ChainReturn', [OverrideTarget] true );
	FinishAnim();
	EndChainThrow();
	
// Entry point when returning from AITakeDamage.
DAMAGED:
// Entry point when resuming this state.
RESUME:

// Default entry point.
BEGIN:
	StopTimer();
	StopMovement();
	TurnOnRepulsor();
	TurnToward( Enemy, 0 );
	PlayChainAttack();
	StopMovement();
	FinishAnim();
	CheckChainThrow();
	FinishAnim();
	EndChainThrow();
} // state AIChainAttack

state AIResumeChainAttack
{
	function BeginState()
	{
		DebugBeginState();

		if( Enemy == none )
			SetEnemy( FindPlayer() );

		GotoState('AIChainAttack');
	}
}

state AaronBlockScythe expands AIScriptedState
{
Begin:
	PlayAnim( 'Block' );
	FinishAnim();
	BlockedScythe();
}

state AaronStartChainAttack expands AIScriptedState
{
	function BeginState()
	{
		DebugBeginState();

		bHasSpecialKill = false;

		TargetPoint = Home.Location;
	}

	function EndState()
	{
		DebugEndState();
	}

CheckJump:
	if( VSize( TargetPoint - Location ) < 128 )
		GotoState( 'AIChainAttack' );
	else if( actorReachable( Home ) )
	{
		PlayWalk();
		MoveToward( Home );
	}
	else
	{
		SetLocation( TargetPoint );
	}
	GotoState( 'AIChainAttack' );

Begin:
Jump:
	PushState( GetStateName(), 'CheckJump' );
	GotoState( 'AIJumpToPoint' );

}

state BossFightAwaken expands AIScriptedState
{
	function bool AcceptDamage( DamageInfo DInfo )
	{
		return false;
	}
	function WeaponFireNotify( name WeaponName, Pawn Attacker )
	{
	}

Begin:
	TurnOnGlow();
	PlayAnim( 'Awaken' );
	FinishAnim();

	GotoState( 'AIAttackPlayer' );
}

state BossFightInitialState expands AIDoNothing
{
	function bool AcceptDamage( DamageInfo DInfo )
	{
		return false;
	}
	function WeaponFireNotify( name WeaponName, Pawn Attacker )
	{
	}

Begin:
	LoopAnim( 'Idle1' );
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

//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     ChainDamage=50
     ChainMomentum=2000
     ChainStuckTimer=8
     ScytheRange=128
     AttackSpeed=2
     FirstChainJoint=16
     LastChainJoint=26
     bIsBoss=True
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=40,Method=RipSlice)
     WeaponAccuracy=1
     DamageRadius=110
     SK_PlayerOffset=(X=80,Z=20)
     bHasSpecialKill=True
     OrderState=BossFightInitialState
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     JumpScalar=1.15
     MeleeRange=80
     GroundSpeed=128
     AirSpeed=1000
     AccelRate=2000
     SightRadius=1500
     BaseEyeHeight=54
     Health=1000
     Intelligence=BRAINS_Human
     SoundSet=Class'Aeons.AaronBossSoundSet'
     FootSoundClass=Class'Aeons.BareFootSoundSet'
     RotationRate=(Pitch=15000,Yaw=60000,Roll=3000)
     Style=STY_AlphaBlend
     Mesh=SkelMesh'Aeons.Meshes.AaronBoss_m'
     CollisionRadius=20
     CollisionHeight=60
     Mass=2000
     MenuName="Aaron"
     CreatureDeathVerb="possesed"
}
