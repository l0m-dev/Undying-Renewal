//=============================================================================
// attack spell.
//=============================================================================
class AttSpell extends AeonsSpell
    abstract;

// NEEDAEON -need a spell sprite instead of using weapon sprite
////#exec Texture Import File=Weapon.pcx Name=S_Weapon Mips=Off Flags=2

// general spell pickup sound
//#exec AUDIO IMPORT FILE="E_Spl_GenPck01.wav" NAME="E_Spl_GenPck01" GROUP="Spells"

// Weightings for spell projectiles seeking Pawns.
var int localCastingLevel;
var(SpellAI) 	float 	seekWeight[6];
var(SpellAI) 	float 	SightRadius;
var Pawn PawnOwner;

replication
{
	reliable if( Role==ROLE_Authority )
		ClientIdleAttSpell;
}

function bool processCastingLevel()
{
	local GhelziabahrStone Ghelz;

	if ( Super.ProcessCastingLevel() )
	{
		// Bump the casting Level up by 1 if the player has the Ghelzibahar Stone Active.
		if ( PlayerPawn(Owner).Weapon != None && PlayerPawn(Owner).Weapon.IsA('GhelziabahrStone') )
		{
			amplitudeBonus = 1;
			//GhelziabahrStone(PlayerPawn(Owner).Weapon).addUse(Clamp((castingLevel + amplitudeBonus), 0, 5));
		} else
			amplitudeBonus = 0;
	
		localCastingLevel = Clamp((castingLevel + amplitudeBonus), 0, 5 );
		return true;
	} else {
		return false;
	}
}

function Destroyed()
{
    Super.Destroyed();
    if( Pawn(Owner) != None && Pawn(Owner).AttSpell == self )
    {
        Pawn(Owner).AttSpell = None;
    }
}

function Spell RecommendAttSpell( out float rating, out int bUseAltMode )
{
    local Spell Recommended;
    local float oldRating, oldFiring;
    local int oldMode;

    if ( !Owner.IsA('PlayerPawn') )
    {
        rating = RateSelf(bUseAltMode);
        if ( (self == Pawn(Owner).AttSpell) && (Pawn(Owner).Enemy != None) )
            rating += 0.21; // tend to stick with same spell
    }

    if ( Inventory != None )
    {
        Recommended = Inventory.RecommendAttSpell(oldRating, oldMode);
        if ( (Recommended != None) && (oldRating > rating) )
        {
            rating = oldRating;
            bUseAltMode = oldMode;
            return Recommended;
        }
    }
    return self;
}

function PassControl()
{
    if ( bPassControl && Pawn(Owner).DefSpell != None )
        Pawn(Owner).DefSpell.FireDefSpell(0.0);
    bPassControl = false;
}

// we override to disable parent's version
// this global function can currently only be accessed while spell is in Idle state
function FireDefSpell( float Value )
{
    // we could place code here to facilitate a faster switch from
    // firing an Attack spell to a Defense spell.

    // only relenquish control if attack button up
    // when spell drops from fire state to idle we could:
    //    verify that DefSpell is not None -this was checked to get here
    //    stop our anim
    //    sync. the current hand anims between the two spells
    //    hide this spell (bHideSpell) and unhide the other spell
    //    set other spell to fire
    //    set this spell state to inactive 

    // if we're still firing this spell then ignore
    // go with the simple route for now
    if ( Pawn(Owner).bFireAttSpell == 0 )
    {
        PutDown(); 

        //so we'll call the defensive fire when we are done
        bPassControl = true;
    }
}


// Finish a firing sequence
function Finish()
{
    local Pawn PawnOwner;
    local PlayerPawn PlayerPawnOwner;

	//log("Finish(): Setting bFiring to False", 'Misc');
	bFiring = false;
	PawnOwner = Pawn(Owner);
    PlayerPawnOwner = PlayerPawn(Owner);

    if ( bChangeSpell ) {
		//log("Going to DownSpell", 'Misc');
		GotoState('DownSpell');
	} else if ( PlayerPawnOwner == None ) {
        if ( (PawnOwner.bFireAttSpell != 0) && (FRand() < RefireRate) )
        {
			//log("A: AttSpell:Finish() ... calling Global FireAttSpell()", 'Misc');
            Global.FireAttSpell(0);
		} else {
			//log("C: ", 'Misc');
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
		//log("D: ", 'Misc');
		GotoState('Idle2');
    } else if ( PawnOwner.bFireAttSpell != 0 && bContinuousFire ) {
		//log("B: AttSpell:Finish() ... calling Global FireAttSpell()", 'Misc');
        Global.FireAttSpell(0);
	} else {
		//log("E: ", 'Misc');
		GotoState('Idle');
	}
}

function StopFiring();

function FireAttSpell( float Value )
{
	local bool bPCL;
	local int cost;

	if ( Self.IsA('Pyro') && AeonsPlayer(Owner).Weapon.ItemName == "Molotov" )
		return;

	if ( !bFiring )
	{
		bPCL = ProcessCastingLevel();

		PawnOwner = Pawn(Owner);

		if ( PawnOwner.HeadRegion.Zone.bWaterZone && !bWaterFire) 
		{
			PlayFireEmpty();
  		} 
		else if ( !bSpellUp && bPCL ) 
		{
			BringUp();
		} else 
		{
			if (bPCL)
			{
				cost = manaCostPerLevel[castingLevel];

				if ( Self.IsA('Scrye') && AeonsPlayer(Owner).Weapon != None && AeonsPlayer(Owner).Weapon.IsA('GhelziabahrStone') )
					cost = 0;

				if ( cost <= PawnOwner.Mana )
				{
					SayMagicWords();
					if ( PawnOwner.useMana(cost) && !AeonsPlayer(Owner).bDispelActive )
					{
						bFiring = true;
						GhelzUse(manaCostPerLevel[castingLevel]);
						PlayFiring();
						//Disable('FireAttSpell');
						
						if ( Owner.bHidden )
							CheckVisibility();
			
						// gotoState('NormalFire');
					} else {
						bFiring = false;
						FailedSpellCast();
						StopFiring();
					}
				} else {
					FailedSpellCast();
				}
			} else {
				bFiring = false;
				GotoState('PostAmplify');
			}
		}
	}
}

simulated function PlayFiring()
{

	//LogTime("AttSpell: PlayFiring");
	// PlayerPawn(Owner).ClientMessage("AttSpell: PlayFiring()");
	PlayAnim(HandAnim,,,,0);
	// disable('FireAttSpell');
}

state ClientFiring
{
	simulated function AnimEnd()
	{
		if ( bCanClientFire && (PlayerPawn(Owner) != None) && bContinuousFire )
		{
			if ( Pawn(Owner).bFireAttSpell != 0 )
			{
				Global.ClientFire(0);
				return;
			}
		}
		GotoState('ClientFinishing');
	}
	simulated function Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		if ( PlayerPawn(owner).bFireAttSpell == 0 )
		{
			//LogTime("AttSpell: state ClientFiring: Tick: bFireAttSpell is 0 , exiting state");
			GotoState('ClientFinishing');
		}
	}
}

simulated state ClientFinishing
{
	simulated function bool ClientFire(float Value)
	{
		return false;
	}

	simulated function AnimEnded() // AnimEnd
	{
		//if (AnimSequence == 'Down')
		//{
			if ( bCanClientFire && (PlayerPawn(Owner) != None) && bContinuousFire )
			{
				if ( Pawn(Owner).bFireAttSpell != 0 )
				{
					Global.ClientFire(0);
					return;
				}
			}
			GotoState('ClientIdle');
		//}
	}
	
	Begin:
		FinishAnim();

		PlayDownPosition();
		FinishAnim();
		
		//PlayAnim('DownPosition',,,,0);
		PlayAnim('Down',,,,0);
		FinishAnim();
		if (!bContinuousFire)
			sleep(RefireRate);
		AnimEnded();
}

state ReadyToAmplify
{
	function FireAttSpell(float Value)
	{
		if ( castingLevel < 4 )
		{
			castingLevel ++;
			PlayerPawn(Owner).bAmplifySpell = false;
			GotoState('Idle');
		}
	}

	Begin:

}

function GhelzUse(int cost)
{
	// Ghelziabahr use
	if ( PlayerPawn(Owner).Weapon != None && PlayerPawn(Owner).Weapon.IsA('GhelziabahrStone') )
		GhelziabahrStone(PlayerPawn(Owner).Weapon).addUse(localCastingLevel);
}

function ForceFire()
{
	//Log("AttSpell: Global ForceFire");
	FireAttSpell(0);
}

simulated function ClientIdleAttSpell()
{
	if (Level.NetMode != NM_Client)
		return;

	// fix hand showing on failed cast
	if (AnimSequence == 'None')
		PlayAnim('Down');
	
	//log("AttSpell: ClientIdleAttSpell");
	if (GetStateName() != 'ClientIdle')
		GotoState('ClientIdle');
}

state Idle2
{
	function BeginState()
	{
		bFiring = false;

		// fix hand showing on failed cast, after level change
		if (AnimSequence == 'None')
			PlayAnim('Down');

		ClientIdleAttSpell();
	}
}

// OVERRIDABLES FROM Spell CLASS TO NOT MODIFY Engine PACKAGE

//**********************************************************************************
// Bring newly active spell up
state Active
{
    function FireDefSpell(float Value) 
    {
	    //if we're an aborted offensive spell being asked to switch
        if ( ItemType == SPELL_Offensive && Pawn(Owner).bFireAttSpell == 0 )
        {
            PutDown();
            bPassControl = true;
        }
    }
}

//**********************************************************************************
// Putting down spell in favor of a new one.
State DownSpell
{
    function FireDefSpell(float F) 
    {
        //if we're an aborted offensive spell being asked to switch
        if ( ItemType == SPELL_Offensive && Pawn(Owner).bFireAttSpell == 0 )
            bPassControl = true;
    }
}

defaultproperties
{
     PlayerViewMesh=None
}
