//=============================================================================
// DispelMagicTrigger.
//=============================================================================
class DispelMagicTrigger expands DynamicTrigger;

var bool debug;
var int castingLevel;
var float dispelRadius;
var int manaBag;

function PreBeginPlay()
{
	super.PreBeginPlay();
	// debug = true;
	dispelRadius = 512;
	if ( debug )
		log("DispelMagicTrigger Created");
	handleDispel();
}

// takes the castingLevel of the DispelMagic Spell, and the casting level
// of the magical effect it is trying to dispel and calculates how much
// mana is required to dispel the effect.
function int DispelManaCost(int DispelLevel, int effectLevel)
{
	local int finalManaCost, baseManaCost, levelOffset, manaInc;
	
	baseManaCost = 45;
	manaInc = 10;
	
	levelOffset = effectLevel - dispelLevel;
	finalManaCost = baseManaCost + (levelOffset * manaInc);
	
	return finalManaCost;
}

function handleDispel()
{
	local actor A;
	local int dispelCost;

	forEach RadiusActors(class 'Actor',A, dispelRadius, Location)
	{
		if ( debug )
			log("Actor in Radius:"$A.name);
		if ( A != Owner )	// Not the Owner of the trigger
		{
			A.Dispel();
			// Players && || ScriptedPawns
			if ( A.isA('AeonsPlayer') || A.isA('ScriptedPawn') )
			{
				AeonsPlayer(A).DispelMod.gotoState('Dispel');
				manaBag = AeonsPlayer(A).DisableSpellModifiers(manaBag, CastingLevel, false);
			}

			// 
			if ( A.isA('MagicalTrigger') )
				MagicalTrigger(A).gotoState('Dispel');
	
			// Magical Projectiles
			if ( A.isA('SpellProjectile') )
			{
				dispelCost = DispelManaCost(castingLevel, SpellProjectile(A).castingLevel);
				if ( manaBag > dispelCost )
				{
					manaBag -= dispelCost;
					SpellProjectile(A).gotoState('Dispel');
				}
			}
		}
	}
}

auto state DispelSomeStuff
{
	function BeginState()
	{
		// AeonsPlayer(Owner).DispelMod.gotoState('Dispel');
		manaBag = AeonsPlayer(Owner).Mana;
		if ( debug )
			log("ManaBag Amount = "$ManaBag);

		handleDispel();
	}
	Begin:
		log("InState");
}

function Touch( actor Other )
{
	local actor A;
	
	if( IsRelevant( Other ) )
	{
		if ( Other != Instigator ) // should not be the player
		{
			if ( Other.IsA('AeonsPlayer'))
			{
				handleDispel();
				AeonsPlayer(Other).DispelMod.gotoState('Dispel');
				manaBag = AeonsPlayer(Other).Mana;
				if ( debug )
					log("ManaBag Amount = "$ManaBag);
			}
		}
	}
}

defaultproperties
{
}
