//=============================================================================
// ShalasVortex.
//=============================================================================
class ShalasVortex expands DefSpell;

state NormalFire
{

	function Tick(float deltaTime)
	{
		if ( Pawn(Owner).bFireDefSpell == 0 )
		{
			AeonsPlayer(owner).ShalasMod.gotoState('Deactivated');
			Finish();
		}
	}

	Begin: 
		AeonsPlayer(owner).ShalasMod.gotoState('Activated');
		AeonsPlayer(owner).ShalasMod.castingLevel = localCastingLevel;
		FinishAnim();

		// AeonsPlayer(owner).useMana(manaCostPerLevel[castingLevel]);

		//sleep(RefireRate);
		//Finish();
}

defaultproperties
{
     HandAnim=ShalaVortex
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShalaLaunch01'
     ItemType=SPELL_Defensive
     InventoryGroup=26
     PickupMessage="ShalasVortex"
     ItemName="Shala"
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
