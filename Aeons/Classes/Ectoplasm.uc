//=============================================================================
// Ectoplasm. 
//=============================================================================
class Ectoplasm expands AttSpell;

// Sounds
//#exec AUDIO IMPORT FILE="E_Spl_EctoSpawn01.wav" NAME="E_Spl_EctoSpawn01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_EctoSpawn02.wav" NAME="E_Spl_EctoSpawn02" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_EctoSpawn03.wav" NAME="E_Spl_EctoSpawn03" GROUP="Spells"

//#exec AUDIO IMPORT FILE="E_Spl_EctoThruWall01.wav" NAME="E_Spl_EctoThruWall01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_EctoHitFlesh01.wav" NAME="E_Spl_EctoHitFlesh01" GROUP="Spells"
//#exec AUDIO IMPORT FILE="E_Spl_EctoHitGen01.wav" NAME="E_Spl_EctoHitGen01" GROUP="Spells"

/////////////////////////////////////////////////////////////////////////////////////
var()	float		ParticleAlpha[3];
var()	Color		Colors[3];
var()	Sound		SpawnSounds[3];

var		bool		bStillFiring;
var 	float 		Proj_EvalInterval;
var 	float 		CurrentAlpha;
var 	Color		CurrentColor;
var		place		HandPlace, FingerPlace;
var		Pawn		PawnOwner;
var 	PlayerPawn	PlayerPawnOwner;
var		ParticleFX	DripParticles;
var		Light		EffectLight;

var bool bPlayStartAnimation;

//////////////////////////////////////////////////////////////////////////////
//	Replication
//////////////////////////////////////////////////////////////////////////////
replication
{
    // Things the server should send to the client.
    reliable if( Role==ROLE_Authority && bNetOwner )
        HandPlace;

//	unreliable if( Role<ROLE_AutonomousProxy )
//		FireLocation;
}

//----------------------------------------------------------------------------

simulated function PreBeginPlay ()
{
	if (RGC())
	{
		seekWeight[1] = 0.7;
		seekWeight[2] = 0.8;
		seekWeight[3] = 0.9;
		seekWeight[4] = 1.0;
		seekWeight[5] = 1.0;
	}
	Super.PreBeginPlay();
	
	// Projectile setup
	ProjectileClass = class'Ectoplasm_proj';
	ProjectileSpeed = class'Ectoplasm_proj'.default.speed;

	PawnOwner = Pawn(Owner);
	PlayerPawnOwner = PlayerPawn(Owner);
}

//----------------------------------------------------------------------------

function bool processCastingLevel()
{
	if (super.ProcessCastingLevel())
	{
		localCastingLevel = Clamp((castingLevel + amplitudeBonus), 0, 5 );
	
		switch ( localCastingLevel )
		{
			case 0:
				currentColor = Colors[0];
				currentAlpha = particleAlpha[0];
				break;
			case 1:
				currentColor = (Colors[0] + Colors[1]) * 0.5;
				currentAlpha = particleAlpha[0];
				break;
			case 2:
				currentColor = Colors[1];
				currentAlpha = particleAlpha[1];
				break;
			case 3:
				currentColor = (Colors[2] + Colors[1]) * 0.5;
				currentAlpha = particleAlpha[1];
				break;
			case 4:
				currentColor = Colors[2];
				currentAlpha = particleAlpha[2];
				break;
			case 5:
				currentColor = Colors[2];
				currentAlpha = particleAlpha[2];
				break;
			
		}
		return true;
	} else {
		return false;
	}
}

simulated function PlayFiring()
{
	//logTime("Ectoplasm: PlayFiring");
// / * we need to put this back in the appropriate places. 
	// Some of it only happens clientside
	if ( effectLight == none && Level.NetMode != NM_Client )
	{
		//log("Creating Ecto Effect Light", 'Spell');
		effectLight = spawn(class 'EctoEffectLight',self,, Owner.Location);
		effectLight.setBase(self);
	}

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( DripParticles == none )
		{
			//log("Creating Ecto Drip Particles", 'Spell');
			fingerPlace = jointPlace('Hand');
			dripParticles = spawn(class 'EctoplasmDrip_particles',self,,fingerPlace.pos); // + vect(0,0,32));
			dripParticles.setBase(self, 'Wrist', 'none'); //, 'Root');
		}

		// ensure particles don't live forever
		dripParticles.LifeSpan = 1.0;
	}

	if ( AeonsPlayer(Owner).bMagicSound )
	{
		Owner.PlaySound(SpawnSounds[Rand(3)]);
		Owner.MakeNOise(3.0, 1280);
	}
// * /
	if (Level.NetMode == NM_Client)
	{
		PlayAnim('EctoStart',1,,,0);
		LoopAnim('EctoCycle',2);
	}
	bStillFiring = true;
}

simulated function StartFiring()
{
	PlayAnim('EctoStart',1,,,0);
}

state NormalFire
{
	ignores FireAttSpell;

	function FireEcto()
	{
		CalculateAutoAimDir();
		// log("	Ecto: FireEcto(), 'Misc'");
		GhelzUse(manaCostPerLevel[localCastingLevel]);
		// play sound and visual effects
		PlayFiring();
		// create the projectile
		ProjectileFire(ProjectileClass, ProjectileSpeed, true, true);
		
		GameStateModifier(AeonsPlayer(Owner).GameStateMod).fEcto = 1.0;
		
		// Test PlayActuator here
		PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_Quick, 0.2f);

		if ( AeonsPlayer(Owner).bMagicSound )
		{
			Owner.PlaySound(SpawnSounds[Rand(3)]);
			AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
		}

		if ( effectLight == none && Level.NetMode == NM_Client )
		{
			// log("Creating Ecto Effect Light", 'Spell');
			effectLight = spawn(class 'EctoEffectLight',Owner,, Owner.Location);
			effectLight.setBase(Owner);
		}

		if ( Level.NetMode != NM_DedicatedServer )
		{
			if ( DripParticles == none )
			{
				// log("Creating Ecto Drip Particles", 'Spell');
				fingerPlace = jointPlace('Hand');
				dripParticles = spawn(class 'EctoplasmDrip_particles',self,,fingerPlace.pos); // + vect(0,0,32));
				dripParticles.setBase(self, 'Wrist', 'none'); //, 'Root');
			}

			// ensure particles don't live forever
			dripParticles.LifeSpan = 1.0;
		}
	}

	function Timer()
	{
		//log("Ecto: NormalFire:Timer()", 'Misc');
		bStillFiring = true;
		
		if (PlayerPawn(owner).health <= 0)
			PlayerPawn(owner).bFireAttSpell = 0;

		if ( (PlayerPawn(owner).bFireAttSpell == 0) && bStillFiring ) {
			GotoState('');
		} else if ( ProcessCastingLevel() && Pawn(Owner).useMana(manaCostPerLevel[localCastingLevel]) && !AeonsPlayer(Owner).bDispelActive ) {
			//log("Ecto: NormalFire:Timer -- used mana... calling FireEcto()", 'Misc');
			FireEcto();	
		} else {
			FailedSpellCast();
			gotoState('Idle');
			// gotoState(GetStateName(), 'End');
		}
	}

	function EndState()
	{

		//logTime("Ectoplasm: state NormalFire: EndState");

		bStillFiring = false;
		bCanClientFire = true;
	
		if ( DripParticles != none )
		{
			DripParticles.Shutdown();
			DripParticles = none;
		}
		
		if (EffectLight != none)
		{
			EffectLight.Destroy();
			EffectLight = none;
		}
		PlayAnim('EctoEnd',1,,,0);
		Finish();
	}
	
	Begin:
		//log("Ecto: NormalFire:Begin", 'Misc');
		bPlayStartAnimation = AnimSequence != 'EctoEnd';
		if ( bPlayStartAnimation )
		{
			//StartFiring();
			//FinishAnim();
			PlayAnim('EctoStart',1,,,0);
		}
		
		bStillFiring = false;
		// Fire the first shot - this avoids the delay in firing
		if ( ProcessCastingLevel() && Pawn(Owner).useMana(manaCostPerLevel[localCastingLevel]) && (!AeonsPlayer(Owner).DispelMod.isInState('Dispel')) )
		{
			//log("Ecto: NormalFire:Begin -- used mana... calling FireEcto()", 'Misc');
			FireEcto();
			SetTimer(RefireRate, true);
		} else {
			// no mana, or dispelled... see ya later.
			GotoState('');
		}
		if ( bPlayStartAnimation )
			FinishAnim();
		LoopAnim('EctoCycle',2);
}

function Finish()
{
    local Pawn PawnOwner;
    local PlayerPawn PlayerPawnOwner;

	//log("Ecto: Finish()", 'Misc');


    PawnOwner = Pawn(Owner);
    PlayerPawnOwner = PlayerPawn(Owner);

    if ( bChangeSpell )
        GotoState('DownSpell');
    else if ( PlayerPawnOwner == None )
    {
        if ( (PawnOwner.bFireAttSpell != 0) && (FRand() < RefireRate) )
        {
	        if ( !bStillfiring )
	        {
				// log("AttSpell:Finish() ... calling Global FireAttSpell()");
				Global.FireAttSpell(0);
			}
		} else {
            PawnOwner.StopFiringAttSpell();
            GotoState('Idle');
        }
    } else if ( (Pawn(Owner).AttSpell != self) ) {
        //This shouldn't happen -immediate shutdown and reset
        PawnOwner.ClientMessage("Error: Immediate shutdown of "$ItemName);
        //bHideSpell = true;
        bInControl = false;
        bSpellUp = false;
        bMuzzleFlash = 0;
        PawnOwner.ChangedSpell();
        GotoState('Idle2');
    } else if ( PawnOwner.bFireAttSpell != 0 ) {
        if ( !bStillfiring )
        {
			// log("AttSpell:Global Fire", 'spell');
			Global.FireAttSpell(0);
		}
	} else {
        GotoState('Idle');
	}
}

simulated function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
/*
	local 	Vector 				Start, X, Y, Z, FireLocation, rVector, HitLocation, StartLoc, tempSeekLoc;
	local 	Ectoplasm_proj 		ecto;

	// if ( PlayerPawnOwner != None )
	// 	PlayerPawnOwner.ClientInstantFlash( -0.4, vect(500, 0, 650));

	AeonsPlayer(Owner).MakePlayerNoise(1.0);

	Pawn(Owner).eyeTrace(HitLocation);

	handPlace = jointPlace('Wrist');
	AdjustedAim = Rotator(HitLocation - handPlace.pos);

	ecto = Spawn(class 'Ectoplasm_proj',PlayerPawn(Owner),, handPlace.pos + vector(Pawn(Owner).ViewRotation) * 32, AdjustedAim);
	ecto.castingLevel = localCastingLevel;
	ecto.speed = (ecto.speedPerLevel[localCastingLevel] * RandRange(0.9, 1.3));
	ecto.manaCost = manaCostPerLevel[castingLevel];
	// TraceFire(0.0, HitLocation);
	
	ecto.seekLocation = HitLocation;
	ecto.initialSeekDir = Vector(AdjustedAim);

//	tempSeekLoc = FireLocation + Vector(Pawn(Owner).ViewRotation) * 2048;
//	if ( AngleCheck(FireLocation, HitLocation, tempSeekLoc , 10) )
//	{
//		ecto.seekLocation = HitLocation;
//		ecto.initialSeekDir = Normal(HitLocation - ecto.Location);
//	} else {
//		ecto.seekLocation = tempSeekLoc;
//		ecto.initialSeekDir = Normal(tempSeekLoc - ecto.Location);
//	}

	ecto.ectoTrail.ColorEnd.Base.r = currentColor.r;
	ecto.ectoTrail.ColorEnd.Base.g = currentColor.g;
	ecto.ectoTrail.ColorEnd.Base.b = currentColor.b;

	ecto.ectoTrail.AlphaStart.Base = currentAlpha;
*/
	local Vector X,Y,Z, Start; //, HitLocation;
	local rotator Dir;
	local Ectoplasm_proj ecto;
	local PlayerPawn Player;

	Player = PlayerPawn(Owner);
	AeonsPlayer(Owner).MakePlayerNoise(1.0);

	// PlayerPawn(Owner).eyeTrace(HitLocation,, 4096);

	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);

	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

	Dir = Rotator(Normal(Player.EyeTraceLoc - Start));

	ecto = Spawn(class 'Ectoplasm_proj', PlayerPawn(Owner),, Start, Dir);
	
	ecto.castingLevel = localCastingLevel;
	ecto.speed = (ecto.speedPerLevel[localCastingLevel] * RandRange(0.9, 1.3));
	ecto.manaCost = manaCostPerLevel[castingLevel];

	// ecto.seekLocation = Player.EyeTraceLoc;
	ecto.InitialDir = Vector(Dir);

	ecto.ectoTrail.ColorEnd.Base.r = currentColor.r;
	ecto.ectoTrail.ColorEnd.Base.g = currentColor.g;
	ecto.ectoTrail.ColorEnd.Base.b = currentColor.b;

	ecto.ectoTrail.AlphaStart.Base = currentAlpha;

}

function FireAttSpell( float Value )
{
	local bool bPCL;
	local float n;
	
	n = Rand(100);
	
	bPCL = ProcessCastingLevel();
	PawnOwner = Pawn(Owner);

	// log("Ectoplasm:FireAttSpell()......"$n, 'Spell');

    if ( PawnOwner.HeadRegion.Zone.bWaterZone && !bWaterFire ) {
		// log("Ectoplasm:FireEmpty .........."$n, 'Spell');
		PlayFireEmpty();
  	} else if ( !bSpellUp && bPCL ) {
		// log("Ectoplasm:Bringing up .........."$n, 'Spell');
	    BringUp();
	} else {
		if (bPCL)
		{
			if (PlayerPawn(Owner).Mana > manaCostPerLevel[localCastingLevel])
			{
				SayMagicWords();
				// if ( PawnOwner.useMana(manaCostPerLevel[LocalCastingLevel]) && (!AeonsPlayer(Owner).DispelMod.isInState('Dispel')) )
				if ( !AeonsPlayer(Owner).DispelMod.isInState('Dispel') )
				{
					// log("Ectoplasm:Use Mana passed .........."$n, 'Spell');
					PlayFiring();
					if ( Owner.bHidden )
						CheckVisibility();
					//log("Ectoplasm:going to state NormalFire .........."$n, 'Spell');
					gotoState('NormalFire');
				} else {
					// log("Ectoplasm:StopFiring() .........."$n, 'Spell');
					StopFiring();
				}
			} else {
				StopFiring();
			}
		} else {
			// log("Ectoplasm:going to PostAmplify State .........."$n, 'Spell');
			GotoState('PostAmplify');
		}
	}
}

simulated state ClientFinishing
{
	simulated function BeginState()
	{
		if ( DripParticles != none )
		{
			DripParticles.Shutdown();
			DripParticles = none;
		}
		
		if (EffectLight != none)
		{
			EffectLight.Destroy();
			EffectLight = none;
		}
		PlayAnim('EctoEnd',1,,,0);
	}
}

defaultproperties
{
     ParticleAlpha(0)=0.35
     ParticleAlpha(1)=0.5
     ParticleAlpha(2)=0.8
     Colors(0)=(R=49,G=148,B=27)
     Colors(1)=(R=14,G=30,B=227)
     Colors(2)=(R=227,G=24,B=50)
     SpawnSounds(0)=Sound'Aeons.Spells.E_Spl_EctoSpawn01'
     SpawnSounds(1)=Sound'Aeons.Spells.E_Spl_EctoSpawn02'
     SpawnSounds(2)=Sound'Aeons.Spells.E_Spl_EctoSpawn03'
     seekWeight(1)=0.3
     seekWeight(2)=0.3
     seekWeight(3)=0.7
     seekWeight(4)=0.7
     seekWeight(5)=0.7
     SightRadius=2048
     manaCostPerLevel(0)=8
     manaCostPerLevel(1)=6
     manaCostPerLevel(2)=6
     manaCostPerLevel(3)=5
     manaCostPerLevel(4)=5
     manaCostPerLevel(5)=5
     damagePerLevel(0)=10
     damagePerLevel(1)=10
     damagePerLevel(2)=10
     damagePerLevel(3)=10
     damagePerLevel(4)=10
     damagePerLevel(5)=10
     FireOffset=(X=20,Y=25,Z=-15)
     RefireRate=0.333333
     FireSound=Sound'Aeons.Spells.E_Spl_EctoSpawn01'
     ItemType=SPELL_Offensive
     InventoryGroup=11
     PickupMessage="Ectoplasm"
     ItemName="Ectoplasm"
     PlayerViewOffset=(X=-4,Y=10,Z=-2.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     RotationRate=(Yaw=0)
     DesiredRotation=(Yaw=0)
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     DeathMessage="%k geisted %o with ectoplasm."
     AltDeathMessage="%k phantasmed %o with ectoplasm."
}
