//=============================================================================
// SkullStorm.
//=============================================================================
class SkullStorm expands AttSpell;
//
//
// To Do: 
//	- Tick() in state NormalFire needs to check for skulls owners as being the player who fires them
//	- Trace hit to the floor for skull spawn positions and material types
//
// Bugs:
//
//

// --------------------------------------------------------------------------------------------------------------------------
//                                                      Sounds
// --------------------------------------------------------------------------------------------------------------------------
// Spawning
//#exec AUDIO IMPORT FILE="E_Spl_SkullLaunch01.wav" NAME="E_Spl_Skulllaunch01" GROUP="Spells"

//#exec AUDIO IMPORT FILE="E_Spl_SkullScream01.wav" NAME="E_Spl_SkullScream01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullScream02.wav" NAME="E_Spl_SkullScream02" GROUP="Spells"

// --------------------------------------------------------------------------------------------------------------------------
// Threats
//#exec AUDIO IMPORT FILE="E_Spl_SkullThreatL01.wav" NAME="E_Spl_SkullThreatL01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullThreatL02.wav" NAME="E_Spl_SkullThreatL02" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullThreatL03.wav" NAME="E_Spl_SkullThreatL03" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullThreatL04.wav" NAME="E_Spl_SkullThreatL04" GROUP="Spells"

//#exec AUDIO IMPORT FILE="E_Spl_SkullThreatS01.wav" NAME="E_Spl_SkullThreatS01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullThreatS02.wav" NAME="E_Spl_SkullThreatS02" GROUP="Spells"

// --------------------------------------------------------------------------------------------------------------------------
// Talking
//#exec AUDIO IMPORT FILE="E_Spl_SkullTalkL01.wav" NAME="E_Spl_SkullTalkL01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullTalkL02.wav" NAME="E_Spl_SkullTalkL02" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullTalkL03.wav" NAME="E_Spl_SkullTalkL03" GROUP="Spells"

//#exec AUDIO IMPORT FILE="E_Spl_SkullTalkS01.wav" NAME="E_Spl_SkullTalkS01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullTalkS02.wav" NAME="E_Spl_SkullTalkS02" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullTalkS03.wav" NAME="E_Spl_SkullTalkS03" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullTalkS04.wav" NAME="E_Spl_SkullTalkS04" GROUP="Spells"


/*
// these are all Beavis samples
// --------------------------------------------------------------------------------------------------------------------------
// Screaming
//#exec AUDIO IMPORT FILE="E_Spl_SkullScream01.wav" NAME="E_Spl_SkullScream01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullScream02.wav" NAME="E_Spl_SkullScream02" GROUP="Spells"

// --------------------------------------------------------------------------------------------------------------------------
// Commentary
//#exec AUDIO IMPORT FILE="E_Spl_SkullComment01.wav" NAME="E_Spl_SkullComment01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullComment02.wav" NAME="E_Spl_SkullComment02" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullComment03.wav" NAME="E_Spl_SkullComment03" GROUP="Spells"

// --------------------------------------------------------------------------------------------------------------------------
// Greetings
//#exec AUDIO IMPORT FILE="E_Spl_SkullGreet01.wav" NAME="E_Spl_SkullGreet01" GROUP="Spells"		// hey how's it goin'?
//#exec AUDIO IMPORT FILE="E_Spl_SkullGreet02.wav" NAME="E_Spl_SkullGreet02" GROUP="Spells"		// let's go breaksomething
//#exec AUDIO IMPORT FILE="E_Spl_SkullGreet03.wav" NAME="E_Spl_SkullGreet03" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullGreet04.wav" NAME="E_Spl_SkullGreet04" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_SkullGreet05.wav" NAME="E_Spl_SkullGreet05" GROUP="Spells"
// --------------------------------------------------------------------------------------------------------------------------
*/


// User vars
var 	float 		skullSpawnRate;			// time between each skull spawning

// Internal vars
var 	int 		numSkulls, skullFireCount, numSummonedSkulls, SndId;
var 	Skull_proj 	skull, summonedSkulls[3];

var 	Skull2_proj Skull2;
var() sound GenSound;

function PreBeginPlay ()
{
	Super.PreBeginPlay();
	skullSpawnRate = 1.0;
	// castingLevel = 4;
}

function spawnEffect(texture tex, vector Loc)
{
	switch(tex.ImpactID)
	{
		default:
			spawn(class 'SkullDecal',,,Loc, rotator(vect(0,0,1)));
			spawn( class 'SkullSpawnDefaultFX',,,Loc);
			break;
	};
}

function bool CheckGenSkull()
{
	local Pawn PawnOwner;
	local vector Start;

	// we always want them to spawn now
	return true;
		
	PawnOwner = Pawn(Owner);

	Start = PawnOwner.Location + (vect(0,0,1) * PawnOwner.EyeHeight) + (Vector(PawnOwner.ViewRotation) * (PawnOwner.CollisionRadius + 16));
	
	// start trace location is not in the level (player is likely standing right up against the wall)
	if (Level.GetZone(Start) == 0)
		return false;
	
	return true;
}

function Skull_proj genSkull(int nS)
{
	local vector Start, End, SpawnLoc, HitNormal;
	local int HitJoint, Flags;

	local Pawn PawnOwner;
	local texture HitTexture;
	
	AeonsPlayer(Owner).UseMana(manaCostPerLevel[localCastingLevel]);

	PawnOwner = Pawn(Owner);

	Start = PawnOwner.Location + (vect(0,0,1) * PawnOwner.EyeHeight) + (Vector(PawnOwner.ViewRotation) * (PawnOwner.CollisionRadius + 16));
	End = Start + vect(0,0,-512);
	
	Trace(SpawnLoc, HitNormal, HitJoint, End, Start, false, true);

	// PlayerPawn(Owner).ClientMessage("SpawnLocation = "$SpawnLoc$", "$VSize(Start-SpawnLoc));
	
	if ( SpawnLoc == vect(0,0,0) || (VSize(Start-SpawnLoc) > 256) )
	{
		SpawnLoc = Start;
		spawn( class 'SkullSpawnAirFX',,,SpawnLoc);
	} else {
		HitTexture = TraceTexture(End, Start, Flags);
		SpawnEffect(HitTexture, SpawnLoc);
	}

	if ( PlayerPawn(Owner) != None )
		PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
	
	bPointing=True;
	
	if ( ns == 0 )
		PlayFiring();
	
	Skull2 = Spawn(class 'Skull2_proj',PawnOwner,, SpawnLoc, AdjustedAim);		// SkullA
	
	if ( Skull2 == none )
		Skull2 = Spawn(class 'Skull2_proj',PawnOwner,, Start + vect(0,0,-1) * 32, AdjustedAim);		// SkullA

	// PlayerPawn(Owner).ClientMessage("Skull is = "$Skull2.name);
	Skull2.Tag = Owner.Name;
	Skull2.SetOffset(ns);

	if ( Owner.bHidden )
		CheckVisibility();
	
	return skull;
}

simulated function PlayFiring()
{
/*
	if ( AeonsPlayer(Owner).bMagicSound )
	{
		// Owner.PlaySound(FireSound, SLOT_None, 0.3); 
		AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
	}
	// PlayAnim('SkullStorm_Start',,,,0);
	// LoopAnim('SkullStorm_Cycle');
	// bStillFiring = true;
*/
}

function StartFiring()
{
	// PlayAnim('SkullStorm_Start',,,,0);
}

function StopFiring()
{
	if ( numSkulls > 0 )
	{
		PlayAnim('SkullStorm_Throw',,,,0.15);
		PlaySound(FireSound);
	} else {
		Owner.StopSound(SndId);
		PlayAnim('Down');
	}
	// AeonsPlayer(Owner).bAllowSpellSelectionHUD = true;
}

state Idle
{
	/*
	function FireAttSpell(float F)
	{
		log ("SkullStorm FireAttSpell within Idle State", 'Misc');
		Global.Fire(F);
	}*/
	
	Begin:
		sleep(refireRate);
		Finish();
}

function releaseSkulls()
{
	local Skull2_proj Skull;

	ForEach AllActors(class 'skull2_proj', Skull, Owner.Name)
	{
		Skull.Fire();
	}
}

state NormalFire
{
	function BeginState()
	{
		Super.BeginState();
		numSkulls = 0;
	}

	function EndState()
	{
		log ("Skullstorm EndState", 'Misc');
		if (AeonsPlayer(Owner).PendingAttSpell != none)
			AeonsPlayer(Owner).ChangedAttSpell();
	}
	
	function FireAttSpell(float Value){}

	function AnimEnd()
	{
		LoopAnim('SkullStorm_Cycle');
	}
	
	function bool PutDown()
	{
		log ("Skullstorm PutDown()", 'Misc');
		PlayerPawn(owner).bFireAttSpell = 0;
		GotoState('NormalFire', 'Eh');
		// Global.PutDown();
	}

	function Tick(float DeltaTime)
	{
		if ( PlayerPawn(owner).bFireAttSpell == 0 )
		{
			StopFiring();
			Finish();
		}
	}

	Begin:

		// AeonsPlayer(Owner).bAllowSpellSelectionHUD = false;
		NumSkulls = 0;
		while (NumSkulls < SkullFireCount)
		{
			if ( CheckGenSkull() )
			{
				if ( AeonsPlayer(owner).Mana >manaCostPerLevel[localCastingLevel] && !AeonsPlayer(Owner).bDispelActive )
				{
					if ( NumSkulls == 0 )
						PlayAnim('SkullStorm_Start',2,,,0);
					
					SndId = Owner.PlaySound(GenSound);
					
					sleep(0.5);
					SummonedSkulls[NumSkulls] = GenSkull(NumSkulls);
					GhelzUse(manaCostPerLevel[CastingLevel]);
					AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
					
					if ( NumSkulls > 0 )
					{
						SummonedSkulls[numskulls-1].LookAtActor = SummonedSkulls[numSkulls];
						SummonedSkulls[numskulls].LookAtActor = Pawn(Owner);
					}
					else
						SummonedSkulls[numskulls].LookAtActor = none;

					NumSkulls++;
					NumSummonedSkulls++;

					Sleep(SkullSpawnRate);
				} else {
					FailedSpellCast();
					break;
				}
			} else {
				break;
			}
		}
		stop;
		
	Eh:
		sleep(0.5);
		Global.PutDown();
}
 

function bool ProcessCastingLevel()
{
	if ( super.ProcessCastingLevel() )
	{
		// determine how many skulls are generated from the casting level.
		if ( localCastingLevel > 4 )
			SkullFireCount = 4;
		else if ( localCastingLevel > 3 )
			SkullFireCount = 3;
		else if ( localCastingLevel > 1 )
			SkullFireCount = 2;
		else 
			SkullFireCount = 1;

		if (RGC())
			skullSpawnRate = 1.0 / (localCastingLevel / 4.0 + 1);

		return true;
	} else {
		return false;
	}
}

function FireAttSpell( float Value )
{
	//log ("SkullStorm FireAttSpell, Player State = "$AeonsPlayer(Owner).GetStateName(), 'Misc');
	if (!(AeonsPlayer(Owner).GetStateName() == 'DialogScene') && !(AeonsPlayer(Owner).GetStateName() == 'PlayerCutscene'))
	{
		//log("SkullStorm FireAttSpell called ... ", 'Misc');
		//logStack('Misc');
		numSummonedSkulls = 0;
		if ( processCastingLevel() )
		{
			if ( !bSpellUp )
				BringUp();
			SayMagicWords();
			bPointing = true;
			CheckVisibility();
			GotoState('NormalFire');
		} else {
			gotoState('PostAmplify');
		}
	}
}

defaultproperties
{
     skullSpawnRate=0.5
     GenSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_Skulllaunch01'
     manaCostPerLevel(0)=25
     manaCostPerLevel(1)=20
     manaCostPerLevel(2)=20
     manaCostPerLevel(3)=15
     manaCostPerLevel(4)=15
     manaCostPerLevel(5)=10
     damagePerLevel(0)=40
     damagePerLevel(1)=40
     damagePerLevel(2)=40
     damagePerLevel(3)=40
     damagePerLevel(4)=40
     damagePerLevel(5)=40
     ProjectileClass=Class'Aeons.Skull_proj'
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_SkullFireLaunch01'
     ItemType=SPELL_Offensive
     InventoryGroup=12
     PickupMessage=""
     ItemName="Skull Storm"
     PlayerViewOffset=(X=-6,Y=6,Z=-2.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     DrawScale=0.5
}
