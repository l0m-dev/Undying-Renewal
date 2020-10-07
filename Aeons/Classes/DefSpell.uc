//=============================================================================
// defense spell.
//=============================================================================
class DefSpell extends AeonsSpell
    abstract;

// Basic textures and sounds are loaded in AttSpell

var int localCastingLevel;
var Pawn PawnOwner;

//=============================================================================
// Inventory travelling across servers.

function Destroyed()
{
    Super.Destroyed();
    if( Pawn(Owner) != None && Pawn(Owner).DefSpell == self )
    {
        Pawn(Owner).DefSpell = None;
    }
}

function bool processCastingLevel()
{
	local GhelziabahrStone Ghelz;
	
	// ProcessCasting Level exists in Spell.uc - it is the only place that
	// should deal with amplification of the spell from an inventory amplifier
	// (sets the bAmplify flag in PlayerPawn).  This overridden instance
	// of ProcessCastingLevel() exists here because it needs to do a 
	// check for the player's Ghelziabahr stone, which does not exist at the
	// engine level.

	if ( Super.ProcessCastingLevel() )
	{
		// Bump the casting Level up by 1 if the player has the Ghelzibahar Stone Active.
		if ( PlayerPawn(Owner).Weapon.IsA('GhelziabahrStone') )
		{
			amplitudeBonus = 1;
			GhelziabahrStone(PlayerPawn(Owner).Weapon).addUse(Clamp((castingLevel + amplitudeBonus), 0, 5));
		} else
			amplitudeBonus = 0;
	
		localCastingLevel = Clamp((castingLevel + amplitudeBonus), 0, 5 );
		return true;
	} else {
		return false;
	}
}

function Spell RecommendDefSpell( out float rating, out int bUseAltMode )
{
    local Spell Recommended;
    local float oldRating, oldFiring;
    local int oldMode;

    if ( !Owner.IsA('PlayerPawn') )
    {
        rating = RateSelf(bUseAltMode);
        if ( (self == Pawn(Owner).DefSpell) && (Pawn(Owner).Enemy != None) )
            rating += 0.21; // tend to stick with same spell
    }

    if ( Inventory != None )
    {
        Recommended = Inventory.RecommendDefSpell(oldRating, oldMode);
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
    if ( bPassControl && Pawn(Owner).AttSpell != None )
        Pawn(Owner).AttSpell.FireAttSpell(0.0);
    bPassControl = false;
}

// we override to disable parent's version
// this global function can currently only be accessed while spell is in Idle state
function FireAttSpell( float Value )
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
    if ( Pawn(Owner).bFireDefSpell == 0 )
    {
        PutDown(); 

        //so we'll call the defensive fire when we are done
        bPassControl = true;
    }
}

//=============================================================================
// Finish a firing sequence
function Finish()
{
    local Pawn PawnOwner;
    local PlayerPawn PlayerPawnOwner;

    PawnOwner = Pawn(Owner);
    PlayerPawnOwner = PlayerPawn(Owner);

	//enable('FireDefSpell');

    if ( bChangeSpell )
        GotoState('DownSpell');
    else if ( PlayerPawnOwner == None )
    {
        if ( (PawnOwner.bFireDefSpell != 0) && (FRand() < RefireRate) )
            Global.FireDefSpell(0);
        else 
        {
            PawnOwner.StopFiringDefSpell();
            GotoState('Idle');
        }
    }
    else if ( (Pawn(Owner).DefSpell != self) )
    {
        //This shouldn't happen -immediate shutdown and reset
        PawnOwner.ClientMessage("Error: Immediate shutdown of "$ItemName);
        bHideSpell = true;
        bInControl = false;
        bSpellUp = false;
        bMuzzleFlash = 0;
        PawnOwner.ChangedSpell();
        GotoState('Idle2');
    }
    else if ( PawnOwner.bFireDefSpell != 0 )
        Global.FireDefSpell(0);
    else 
        GotoState('Idle');
}

simulated function playFiring()
{
	//Log("DefSpell: PlayFiring");
	// PlayerPawn(Owner).ClientMessage("DefSpell: PlayFiring()");
	PlayAnim(HandAnim,,,,0);
	//disable('FireDefSpell');
}


/*
function FireDefSpell( float Value )
{
	local bool bPCL;
	
	bPCL = ProcessCastingLevel();

	PawnOwner = Pawn(Owner);

    if ( PawnOwner.HeadRegion.Zone.bWaterZone && !bWaterFire )
		PlayFireEmpty(); //perhaps a fizzle sound
    else
		if ( !bSpellUp && bPCL)
		    BringUp();
	else {
		if ( bPCL ) 
		{
			SayMagicWords();
			if (PawnOwner.useMana(manaCostPerLevel[castingLevel]) && !AeonsPlayer(Owner).bDispelActive)
			{
				GhelzUse(ManaCostPerLevel[castingLevel]);

				PlayFiring();
				if ( Owner.bHidden )
					CheckVisibility();
			} else {
				GotoState('Idle');
			}
		} else {
			GotoState('PostAmplify');
		}
	}
}
*/

function GhelzUse(int cost)
{
	// Ghelziabahr use
	if ( PlayerPawn(Owner).Weapon.IsA('GhelziabahrStone') )
		GhelziabahrStone(PlayerPawn(Owner).Weapon).addUse(localCastingLevel * cost);
}

function ForceFire()
{
	//Log("DefSpell: Global ForceFire");
	FireDefSpell(0);
}

defaultproperties
{
     PlayerViewMesh=None
}
