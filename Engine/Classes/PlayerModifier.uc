//=============================================================================
// PlayerModifier.
//=============================================================================
class PlayerModifier expands Invisible;

// this is not working during UCC MAKE
////#exec OBJ LOAD FILE=..\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

// A player modifier inventory item is invisible to the player, but can be
// turned on and off by weapons, spells, environmental changes, etc.
//
// Implemented this way, each inventory item can more easily manage its effect
// on the AeonsPlayer or ScriptedPawn without overcrowding the main class.
//
//

var() sound ActivateSound;
var() sound DeactivateSound;
var() sound EffectSound;
var travel int ManaCost;			// Amount of mana used to activate this modifier
var travel int CastingLevel;		// Amplitude this modifier was activated at
var float refreshRate;		// 

var travel bool bActive;

/*----------------------------------------------------------------------------
	Replication
----------------------------------------------------------------------------*/
replication
{
	// Variables the server should send to the client.
	reliable if( Role==ROLE_Authority && bNetOwner )
		CastingLevel, bActive;
}

//----------------------------------------------------------------------------

simulated function PreBeginPlay()
{
	if ( Owner == none )
	{
		Destroy();
		return;
	}

	SetLocation( Owner.Location );
	SetBase( Owner );
}

function int Dispel(optional bool bCheck)
{
	if ( !bCheck )
		GotoState('Deactivated');
}

/*----------------------------------------------------------------------------
	Default Properties
----------------------------------------------------------------------------*/

defaultproperties
{
     bHidden=True
     DrawType=DT_None
     bTravel=True
     RemoteRole=ROLE_None
     NetUpdateFrequency=10
}
