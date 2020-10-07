//=============================================================================
// AeonsSpell
//=============================================================================
class AeonsSpell extends Spell
    abstract;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//=============================================================================
// Hand
//=============================================================================
//#exec MESH IMPORT MESH=SpellHand_m SKELFILE=SpellHand_m.ngf MOVERELATIVE=0
//#exec MESH ORIGIN MESH=SpellHand_m YAW=64

//#exec TEXTURE IMPORT NAME=SpellHand_1 FILE=SpellHand_1.PCX GROUP=SpellHand
//#exec TEXTURE IMPORT NAME=SpellHand_2 FILE=SpellHand_2.PCX GROUP=SpellHand
//#exec TEXTURE IMPORT NAME=SpellHand_3 FILE=SpellHand_3.PCX GROUP=SpellHand
//#exec TEXTURE IMPORT NAME=SpellHand_4 FILE=SpellHand_4.PCX GROUP=SpellHand
//#exec TEXTURE IMPORT NAME=SpellHand_5 FILE=SpellHand_5.PCX GROUP=SpellHand

//=============================================================================
// Animation Notifys
//#exec MESH NOTIFY SEQ=MindShatter TIME=0.185 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Silence TIME=0.01 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Shield TIME=0.480 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Ward TIME=0.759 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Dispel TIME=0.900 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Firefly TIME=0.441 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Haste TIME=0.007000 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Phase TIME=0.01 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=PowerWord TIME=0.0100 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=PowerWord TIME=0.071 FUNCTION=StartParticles
//#exec MESH NOTIFY SEQ=PowerWord TIME=0.943 FUNCTION=StopParticles
//#exec MESH NOTIFY SEQ=Scrye TIME=0.250 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=Invoke TIME=0.684 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=ShalaVortex TIME=0.001 FUNCTION=FireSpell
//#exec MESH NOTIFY SEQ=FireCantrip TIME=0.350 FUNCTION=FireCantrip
//#exec MESH NOTIFY SEQ=SkullStorm_Throw TIME=0.190 FUNCTION=ReleaseSkulls
//#exec MESH NOTIFY SEQ=FireCantrip TIME=0.99 FUNCTION=PlayDownPosition
//#exec MESH NOTIFY SEQ=EctoEnd Time=0.5 FUNCTION=RemoveFX
//#exec MESH NOTIFY SEQ=Lightning Time=0.394 FUNCTION=FireSpell

//#exec MESH NOTIFY SEQ=PowerWord TIME=0.99 FUNCTION=PlayDownPosition

//#exec TEXTURE IMPORT NAME=SpellIcon FILE=SpellIcon.pcx GROUP=System Mips=Off Flags=2

/*
// Load the sound package
//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv
*/

//=============================================================================

var bool bCanClientFire;
var() name HandAnim;
var() texture SpellHandTextures[5];
var() sound CantripSound, NoManaSound;

//////////////////////////////////////////////////////////////////////////////
//	Replication
//////////////////////////////////////////////////////////////////////////////
replication
{
    // Things the server should send to the client.
    Reliable if ( bNetOwner && (Role == ROLE_Authority) )
		bCanClientFire;		
}



simulated event RenderOverlays( canvas Canvas )
{
	if ( AeonsPlayer(Owner).Opacity == 1.0 )
	{
		if (AeonsPlayer(Owner).bRenderWeapon)
			Opacity = FClamp(Opacity + 0.05, 0, 1);
		else
			Opacity = FClamp(Opacity - 0.05, 0, 1);
	} else {
		Opacity = FClamp(AeonsPlayer(Owner).Opacity, 0.15, 1);
	}

	super.RenderOverlays(Canvas);
}

simulated function PlayDownPosition()
{
	// Log("AeonsSpell: PlayDownPosition", 'Misc');
	PlayAnim('DownPosition',,,,0);
}

// takes two locations A, and B, and a starting location Loc and determines if
// the vectors from [Loc to A] and [Loc to B] are withing the angleThreshold value

function bool AngleCheck(vector Loc, vector A, vector B, float angleThreshold)
{
	local vector vA, vB;
	local float angle;
	local float pi;

	pi = 3.1415926535897932384626433832795;

	angleThreshold *= (pi / 180.0);
	vA = Normal(A - Loc);
	vB = Normal(B - Loc);
	angle = vA dot vB;
	return ( cos(angleThreshold) < angle );
}

function FailedSpellCast()
{
	// Pawn(Owner).ClientMessage("No Mana ... foooo!");
	Owner.PlaySound(NoManaSound);
	AeonsPlayer(Owner).NoManaFlashTime = Level.TimeSeconds + 1;
}

function FireSpell()
{
	// log ("AeonsSpell FireSpell()", 'Misc');
	// PlayerPawn(Owner).ClientMessage("AeonsSpell:FireSpell");
	if ( AeonsPlayer(Owner).bMagicSound )
	{
		Owner.PlaySound(FireSound,, 1);
		AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
	}
	Enable('FireAttSpell');
	Enable('FireDefSpell');
	GotoState('NormalFire');
}

function FireCantrip()
{
	local vector dir;
	
	dir = Normal(JointPlace('Index_Tip').pos - JointPlace('Index_Knuck2').pos);
	spawn(class 'CantripParticleFX',,,JointPlace('Index_Knuck2').pos, rotator(dir));
	PlaySound(CantripSound);
}

simulated function bool ClientFire( float Value )
{
	//logTime("AeonsSpell: ClientFire: ... bCanClientFire = "$bCanClientFire);

	if ( bCanClientFire && ((Role == ROLE_Authority) || (Pawn(Owner).Mana >= ManaCostPerLevel[castingLevel])) )
	{
/*		if ( (PlayerPawn(Owner) != None) 
			&& ((Level.NetMode == NM_Standalone) || PlayerPawn(Owner).Player.IsA('ViewPort')) )
		{
			if ( InstFlash != 0.0 )
				PlayerPawn(Owner).ClientInstantFlash( InstFlash, InstFog);
			PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
		}
		if ( Affector != None )
			Affector.FireEffect();
*/
		//LogTime("AeonsSpell: ClientFire: bCanClientFire && ( Server || Mana )");
		PlayFiring();

		if ( Role < ROLE_Authority )
		{
			//LogTime("AeonsSpell: ClientFire: Client: GotoState('ClientFiring')");
			GotoState('ClientFiring');
		}
		return true;
	}

	return false;
}		

//----------------------------------------------------------------------------

state NormalFire
{
	function EndState()
	{
		//Log("AeonsSpell: state NormalFire: EndState: setting bCanClientFire to TRUE");
		bCanClientFire = true;
	}
}

//============================================================================

state ClientFiring
{
/*
	simulated function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		if ( PlayerPawn(owner).bFireAttSpell == 0 )
		{
			LogTime("AeonsSpell: state ClientFiring: bFireAttSpell is 0 , exiting state");
			GotoState('');
		}
	}
*/

/*
	simulated function Timer()
	{
		LogTime("AeonsSpell: state ClientFiring: Timer");
		LoopAnim('EctoCycle');
		SetTimer(2.0, false);
	}

	simulated function BeginState()
	{
		SetTimer(2.0, false);
		LoopAnim('EctoCycle');
		LogActor("AeonsSpell: state ClientFiring: BeginState");
	}
*/	
/*
	simulated function EndState()
	{
		//LogActor("AeonsSpell: state ClientFiring: EndState");
		//PlayAnim('EctoStart');
	}
*/
}

//----------------------------------------------------------------------------

state PostAmplify
{
	ignores FireAttSpell;
	
	Begin:
		// log(".....Post Amplify");
		sleep(0.33);
		Finish();

}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     SpellHandTextures(0)=Texture'Aeons.SpellHand.SpellHand_1'
     SpellHandTextures(1)=Texture'Aeons.SpellHand.SpellHand_2'
     SpellHandTextures(2)=Texture'Aeons.SpellHand.SpellHand_3'
     SpellHandTextures(3)=Texture'Aeons.SpellHand.SpellHand_4'
     SpellHandTextures(4)=Texture'Aeons.SpellHand.SpellHand_5'
     CantripSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_DynaLight01'
     NoManaSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_NoMana01'
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     bNoSmooth=False
}
