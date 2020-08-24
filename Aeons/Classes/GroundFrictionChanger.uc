//=============================================================================
// GroundFrictionChanger.
//=============================================================================
class GroundFrictionChanger expands Info;

//#exec TEXTURE IMPORT FILE=GroundFrictionChanger.pcx GROUP=System Mips=On

var() bool bAffectCreatures;
var() bool bAffectPlayers;
var() bool bActive;
var() float NewFriction;

function Trigger(Actor Other, Pawn Instigator)
{
	bActive = !bActive;
}

function Touch(Actor Other)
{
	if ( bActive )
	{
		if ( Other.IsA('Pawn') )
		{
			if ( Other.IsA('AeonsPlayer') && bAffectPlayers )
			{
				log("Touch() ... Changing the players friction to "$NewFriction, 'Misc');
				if ( AeonsPlayer(Other).FrictionMod != None ) 
					FrictionModifier(AeonsPlayer(Other).FrictionMod).OverRideFriction = NewFriction;
			}

			if ( Other.IsA('ScriptedPawn') && bAffectCreatures )
			{
				ScriptedPawn(Other).GroundFriction = NewFriction;
			}

		}
	}
}

function UnTouch(Actor Other)
{
	if (bActive)
	{
		if ( Other.IsA('Pawn') )
		{
			if ( Other.IsA('AeonsPlayer') && bAffectPlayers )
			{
				log("UnTouch() ... Changing the players friction to 8 ", 'Misc');
				if ( AeonsPlayer(Other).FrictionMod != None ) 
					FrictionModifier(AeonsPlayer(Other).FrictionMod).OverRideFriction = 8.0;
			}

			if ( Other.IsA('ScriptedPawn') && bAffectCreatures )
			{
				ScriptedPawn(Other).GroundFriction = 8.0;
			}

		}
	}
}

defaultproperties
{
     bAffectPlayers=True
     bActive=True
     Texture=Texture'Aeons.System.GroundFrictionChanger'
}
