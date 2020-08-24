//=============================================================================
// Mindshatter.
//=============================================================================
class Mindshatter expands AttSpell;

//---------------------------------------------------------------------------
//	Import
//----------------------------------------------------------------------------
//
//  Mindshatter Launch
//#exec AUDIO IMPORT FILE="E_Spl_MindLaunch01.wav" NAME="E_Spl_MindLaunch01" GROUP="Spells"

//  Mindshatter Loop
//  - for use as a temp sound when you're hit with mindshatter, but don't know if it's 
//     needed as we just might tweak out sounds via pitch and reverb for the player
//     that gets hit
//
// #exec AUDIO IMPORT FILE="E_Spl_MindLoop01.wav" NAME="E_Spl_MindLoop01" GROUP="Spells"

//----------------------------------------------------------------------------
//	Variables
//----------------------------------------------------------------------------
var float EffectDuration[5];
var Pawn PawnOwner;
var PlayerPawn PlayerPawnOwner;
var bool bFiring;

//----------------------------------------------------------------------------
//	Functions
//----------------------------------------------------------------------------
function PreBeginPlay()
{
	Super.PreBeginPlay();

	ProjectileClass = class'Mindshatter_proj';
	ProjectileSpeed = class'Mindshatter_proj'.default.speed;

	// CastingLevel = 4;
	
	PawnOwner = Pawn(Owner);
	PlayerPawnOwner = PlayerPawn(Owner);
	
	EffectDuration[0] = 30;
	EffectDuration[1] = 30;
	EffectDuration[2] = 30;
	EffectDuration[3] = 45;
	EffectDuration[4] = 90;
}

//----------------------------------------------------------------------------

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local Vector Start, End, X,Y,Z, HitLocation, HitNormal, FireLoc, eyeOffset;
	local Mindshatter_proj m;
	local int HitJoint;

	// Pawn(Owner).EyeTrace(HitLocation,,4096, true);

	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	// finger location
	FireLoc = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	// FireLoc = (JointPlace('Index_Knuck2')).pos + Vector(Pawn(Owner).ViewRotation) * 168 + Y*128;

	// spawn the projectile
	m = Spawn(class 'Mindshatter_proj',Pawn(Owner),, FireLoc, Rotator( PlayerPawn(Owner).EyeTraceLoc - FireLoc ));
	m.castingLevel = castingLevel;
	m.manaCost = manaCostPerLevel[castingLevel];

	// Test PlayActuator here!!
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_FadeOut, 0.8f);
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_Quick, 0.4f);
	return m;
}

//----------------------------------------------------------------------------

state NormalFire
{
	function FireAttSpell(float F){}

	Begin:
		Enable('FireAttSpell');
		ProjectileFire(ProjectileClass, ProjectileSpeed, false, true);
		FinishAnim();
		Sleep(RefireRate);
		bFiring = false;
		Finish();
}

//----------------------------------------------------------------------------

simulated function playFiring()
{
	if ( !bFiring )
	{
		bFiring = true;
		PlayAnim('Mindshatter',,,,0);
	}
}

//----------------------------------------------------------------------------

state ClientFiring
{
	// overloaded. may just be better to put the attspell behavior up in the subclasses that need it
	simulated function Tick(float DeltaTime)
	{
	//	Super.Tick(DeltaTime);
	}

	simulated function AnimEnd()
	{
		if ( AnimSequence == HandAnim )
		{
			log("Mind: state ClientFiring: AnimEnd:   HandAnim");
			GotoState('');
			PlayDownPosition();
		}
	}

	simulated function PlayFiring()
	{
	
		LogTime("Mind: PlayFiring: empty");
		// PlayerPawn(Owner).ClientMessage("AttSpell: PlayFiring()");
		//PlayAnim(HandAnim,,,,0);
		// disable('FireAttSpell');
	}

	simulated function BeginState()
	{
		Log("Mind: state ClientFiring: BeginState");
		PlayAnim(HandAnim,,,,0);
	}
}


//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     HandAnim=Mindshatter
     manaCostPerLevel(0)=50
     manaCostPerLevel(1)=50
     manaCostPerLevel(2)=50
     manaCostPerLevel(3)=50
     manaCostPerLevel(4)=50
     manaCostPerLevel(5)=50
     FireOffset=(X=32,Y=20)
     RefireRate=1
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_MindLaunch01'
     ItemType=SPELL_Offensive
     InventoryGroup=25
     PickupMessage="MindShatter"
     ItemName="MindShatter"
     PlayerViewOffset=(X=-3,Y=18,Z=-1)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     Buoyancy=20
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Mass=25
}
