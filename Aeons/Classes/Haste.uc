//=============================================================================
// Haste.
//=============================================================================
class Haste expands AttSpell;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//----------------------------------------------------------------------------

function FireAttSpell( float Value )
{
	local bool bPCL;
	local int cost;

	// LogTime("AttSpell: FireAttSpell");

	if ( !bFiring && !AeonsPlayer(Owner).bHasteActive )
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

				if ( Self.IsA('Scrye') && AeonsPlayer(Owner).Weapon.IsA('GhelziabahrStone'))
					cost = 0;

				if ( cost <= PawnOwner.Mana )
				{
					SayMagicWords();
					if ( PawnOwner.useMana(cost) && !AeonsPlayer(Owner).bDispelActive )
					{
						bFiring = true;
						GhelzUse(manaCostPerLevel[castingLevel]);
						PlayFiring();
						//Disable('FireAttSpell');:TODO
						
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
state NormalFire
{
	ignores FireAttSpell;
	
	Begin:
		AeonsPlayer(owner).HasteMod.castingLevel = localCastingLevel;
		AeonsPlayer(owner).HasteMod.gotoState('Activated');
		FinishAnim();
		// sleep(RefireRate);
		Finish();
		bFiring = false;
		GotoState('Idle');
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     HandAnim=Haste
     manaCostPerLevel(0)=50
     manaCostPerLevel(1)=50
     manaCostPerLevel(2)=50
     manaCostPerLevel(3)=50
     manaCostPerLevel(4)=50
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_HasteStart01'
     ItemType=SPELL_Offensive
     InventoryGroup=15
     PickupMessage="Haste"
     ItemName="Haste"
     PlayerViewOffset=(X=-4,Y=10,Z=-2.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
