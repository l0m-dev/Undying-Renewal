//=============================================================================
// Bot.
//=============================================================================
class Bot expands Bots;
	
// Advanced AI attributes.
var(Orders) name	Orders;			//orders a bot is carrying out 
var(Orders) name	OrderTag;		// tag of object referred to by orders
var		actor		OrderObject;		// object referred to by orders (if applicable)
var(Combat) float	TimeBetweenAttacks;  // seconds - modified by difficulty
var 	name		NextAnim;		// used in states with multiple, sequenced animations	
var(Combat) float	Aggressiveness; //0.0 to 1.0 (typically)
var		float       BaseAggressiveness; 
var   	Pawn		OldEnemy;
var		int			numHuntPaths;
var		vector		HidingSpot;
var		float		WalkingSpeed;
var(Combat) float	RefireRate;
var		float		StrafingAbility;

//AI flags
var	 	bool   		bReadyToAttack;		// can attack again 
var		bool		bCanFire;			//used by TacticalMove and Charging states
var		bool		bCanDuck;
var		bool		bStrafeDir;
var(Combat) bool	bLeadTarget;		// lead target with projectile attack
var		bool		bSpecialGoal;
var		bool		bChangeDir;			// tactical move boolean
var		bool		bFiringPaused;
var		bool		bComboPaused;
var		bool		bSpecialPausing;
var		bool		bGreenBlood;
var		bool		bFrustrated;
var		bool		bNoShootDecor;
var		bool		bGathering;
var		bool		bCamping;
var config	bool	bVerbose; //for debugging
var		bool		bViewTarget; //is being used as a viewtarget
var		bool		bWantsToCamp;
var		bool		bWallAdjust;
var		bool		bInitLifeMessage;
var		bool		bNoClearSpecial;
var		bool		bStayFreelance;
var		bool		bNovice;
var		bool		bThreePlus;		// high skill novice
var		bool		bKamikaze;
var		bool		bClearShot;
var		bool		bQuickFire;		// fire quickly as moving in and out of cover
var		bool		bDevious;
var		bool		bDumbDown;		// dumb down team AI 
var		bool		bJumpy;
var		bool		bHasImpactHammer;
var		bool		bImpactJumping;
var		bool		bSniping;
var		bool		bFireFalling;
var		bool		bLeading;
var		bool		bSpecialAmbush;
var		bool		bCampOnlyOnce;
var		bool		bPowerPlay;
var		bool		bBigJump;
var     bool		bTacticalDir;		// used during movement between pathnodes
var		bool		bNoTact;
var		bool		bMustHunt;
var		bool		bIsCrouching;

var Weapon EnemyDropped;
var float LastInvFind;
var float Accuracy;
var vector WanderDir;

var     name		LastPainAnim;
var		float		LastPainTime;
var		float		LastAcquireTime;

var(Sounds) sound 	drown;
var(Sounds) sound	breathagain;
var(Sounds) sound	Footstep1;
var(Sounds) sound	Footstep2;
var(Sounds) sound	Footstep3;
var(Sounds) sound	HitSound3;
var(Sounds) sound	HitSound4;
var(Sounds)	Sound	Deaths[6];
var(Sounds) sound	GaspSound;
var(Sounds) sound	UWHit1;
var(Sounds) sound	UWHit2;
var(Sounds) sound   LandGrunt;
var(Sounds) sound	JumpSound;

var name OldMessageType;
var int OldMessageID;

var float PointDied;
var float CampTime;
var float CampingRate;
var float LastCampCheck;
var float LastAttractCheck;
var AeonsAmbushpoint AmbushSpot;
var AlternatePath AlternatePath; //used by game AI for team games with bases
var Actor RoamTarget, ImpactTarget;
var float Rating;
var int	FixedSkin;
var int	TeamSkin1;
var int	TeamSkin2;
var string DefaultSkinName;
var string DefaultPackage;
var float BaseAlertness;
	
function InitializeSkill(float InSkill)
{
	Skill = InSkill;
	bNovice = ( Skill < 4 );
	if ( !bNovice )
		Skill -= 4;
	Skill = FClamp(Skill, 0, 3);
	ReSetSkill();
}

function ReSetSkill()
{
	//log(self$" at skill "$Skill$" novice "$bNovice);
	bThreePlus = ( (Skill >= 3) );
	bLeadTarget = ( !bNovice || bThreePlus );
	if ( bNovice )
		ReFireRate = Default.ReFireRate;
	else
		ReFireRate = Default.ReFireRate * (1 - 0.25 * skill);

	PreSetMovement();
}
	
defaultproperties
{
     CarcassType=Class'Engine.Carcass'
     TimeBetweenAttacks=0.600000
     Aggressiveness=0.350000
     BaseAggressiveness=0.350000
     WalkingSpeed=0.350000
     RefireRate=0.900000
     bLeadTarget=False
     PointDied=-1000.000000
     bIsPlayer=True
     bAutoActivate=False
     bIsMultiSkinned=False
     AirControl=0.350000
     SightRadius=5000.000000
     HearingThreshold=0.350000
	 
     EyeHeight=23.000000
     PlayerReplicationInfoClass=Class'PlayerReplicationInfo'
   
	 BackRightDecalClass=Class'Aeons.BldRightPrint'
     BackLeftDecalClass=Class'Aeons.BldLeftPrint'
     BackRightSnowDecalClass=Class'Aeons.RightSnowFootprint'
     BackLeftSnowDecalClass=Class'Aeons.LeftSnowFootprint'
     ManaRefreshAmt=1
     ManaRefreshTime=0.2
     bRunMode=True
     BaseEyeHeight=55
     FootSoundClass=Class'Aeons.DefaultFootSoundSet'
     Physics=PHYS_Walking
     LODBias=5
	 DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Patrick_m'
	 Style=STY_Normal
     CollisionRadius=22
     CollisionHeight=57
	 OnFireParticles=Class'Aeons.OnFireParticleFX'
     UnderWaterTime=20
     Intelligence=BRAINS_Human
     PI_StabSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BiteSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BluntSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_BulletSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_RipSliceSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenLargeSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenMediumSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     PI_GenSmallSound=(Radius=1024,MaxPitch=1.2,MinPitch=0.8)
     HitSound1=Sound'Voiceover.Patrick.Pa_124'
     HitSound2=Sound'Voiceover.Patrick.Pa_125'
     Land=Sound'Voiceover.Patrick.Pa_137'
     Die=Sound'Voiceover.Patrick.Pa_130'
     Buoyancy=99
     AnimSequence=WalkSM
	 JumpSound(0)=Sound'Voiceover.Patrick.Pa_135'
     bSinglePlayer=True
     bCanStrafe=True
     bIsHuman=True
     MeleeRange=50
     GroundSpeed=400
     AirSpeed=256
     AccelRate=2048
     JumpZ=350
	 BreathAgain=Sound'Voiceover.Patrick.Pa_140'

     HitSound3=Sound'Voiceover.Patrick.Pa_126'
     HitSound4=Sound'Voiceover.Patrick.Pa_127'
     Die2=Sound'Voiceover.Patrick.Pa_131'
     Die3=Sound'Voiceover.Patrick.Pa_132'
     Die4=Sound'Voiceover.Patrick.Pa_132'
     GaspSound=Sound'Voiceover.Patrick.Pa_140'
     LandGrunt=Sound'Voiceover.Patrick.Pa_138'
     VoiceType=Class'Engine.VoicePack'
     NetPriority=3.000000
     RotationRate=(Pitch=3072,Yaw=65000,Roll=2048)
}