//=============================================================================
// DispelMagic.
//=============================================================================
class DispelMagic expands AttSpell;

//-----------------------------------------------------------------------------
//								Sounds
//-----------------------------------------------------------------------------

// Dispel Launch

//#exec AUDIO IMPORT FILE="E_Spl_DspMagic01.wav" NAME="E_Spl_DspMagic01" GROUP="Spells"
//-----------------------------------------------------------------------------

var DispelMagicTrigger dmt;
var int manaBag, InitialManaBag;
var bool bFiring;

function FireSpell()
{
	GotoState('NormalFire');
}

function FireAttSpell( float Value )
{
	local bool bPCL;
	local int cost;

	//LogTime("AttSpell: FireAttSpell");

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

			if ( Self.IsA('Scrye') && AeonsPlayer(Owner).Weapon.IsA('GhelziabahrStone'))
				cost = 0;

			SayMagicWords();
			if ( !AeonsPlayer(Owner).bDispelActive )
			{
				GhelzUse(manaCostPerLevel[castingLevel]);
				PlayFiring();
				
				if ( Owner.bHidden )
					CheckVisibility();
	
				// gotoState('NormalFire');
			} else {
				// FailedSpellCast();
				StopFiring();
			}
		} 
		else 
		{
			GotoState('PostAmplify');
		}
	}
}


state NormalFire
{
	function FireAttSpell( float Value ){}

	function CastDispel()
	{
		local actor A;
		local int DispelCost;
		local int OtherLevel;

		GameStateModifier(AeonsPlayer(Owner).GameStateMod).fDispel = 1.0;
		
		// Generate the effect
		spawn (class 'DispelCastFX',,,Pawn(Owner).Location + vect(0,0,1) * Pawn(Owner).EyeHeight + vect(0,0,-12) );
		if ( AeonsPlayer(Owner).bMagicSound )
		{
			Owner.PlaySound(FireSound,, 1);
			AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
		}

		ForEach RadiusActors(class 'Actor',A, 1280, Pawn(Owner).Location)
		{
			if ( (A != Pawn(Owner)) && (A.Owner != Pawn(Owner)) && (FastTrace(Pawn(Owner).Location, A.Location)) )
			{
				OtherLevel = A.Dispel(true);
				log("DispelMagic.OtherLevel = "$OtherLevel, 'Misc');
				if ( OtherLevel >= 0 )
				{
					DispelCost = DispelManaCost(CastingLevel, OtherLevel);
					log("DispelMagic.A = "$A.name, 'Misc');
					log("DispelMagic.DispelCost = "$DispelCost$" ManaBag = "$MAnaBag, 'Misc');
					if ( DispelCost <= ManaBag )
					{
						ManaBag -= DispelCost;
						PawnOwner.useMana(DispelCost);
						A.Dispel(false);
					} else {
						FailedSpellCast();
					}
				}
			}
		}
	}

	function int DispelManaCost(int DispelLevel, int effectLevel)
	{
		local int finalManaCost, baseManaCost, levelOffset, manaInc;
		
		baseManaCost = 45;
		manaInc = 10;
		
		levelOffset = effectLevel - dispelLevel;
		finalManaCost = baseManaCost + (levelOffset * manaInc);
		
		return finalManaCost;
	}

	Begin:
		if (AeonsPlayer(Owner).Mana > 80)
			manaBag = 80;
		else
			manaBag = AeonsPlayer(Owner).Mana;

		InitialManaBag = ManaBag;
		manabag = AeonsPlayer(Owner).DisableSpellModifiers(manaBag, LocalCastingLevel, true);
		if (ManaBag < InitialManaBag)
			PawnOwner.UseMana(InitialManaBag-manaBag);
		
		CastDispel();
		FinishAnim();
		sleep(RefireRate);
		PawnOwner.bFireAttSpell = 0;
		Finish();
}

defaultproperties
{
     HandAnim=Dispel
     manaCostPerLevel(0)=80
     manaCostPerLevel(1)=80
     manaCostPerLevel(2)=80
     manaCostPerLevel(3)=80
     manaCostPerLevel(4)=80
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_DspMagicLaunch01'
     ItemType=SPELL_Offensive
     InventoryGroup=13
     PickupMessage="DispelMagic"
     ItemName="Dispel"
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
