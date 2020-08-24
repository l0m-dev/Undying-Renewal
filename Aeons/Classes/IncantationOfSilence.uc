//=============================================================================
// IncantationOfSilence.
//=============================================================================
class IncantationOfSilence expands DefSpell;

state NormalFire
{
	Ignores FireDefSpell;

	Begin:
		if ( AeonsPlayer(owner).SilenceMod != none )
		{
			AeonsPlayer(owner).SilenceMod.castingLevel = localCastingLevel;
			AeonsPlayer(owner).SilenceMod.gotoState('Activated');
		}
		FinishAnim();
		sleep(RefireRate);
		Finish();
}

defaultproperties
{
     HandAnim=Silence
     manaCostPerLevel(0)=2
     manaCostPerLevel(1)=4
     manaCostPerLevel(2)=3
     manaCostPerLevel(3)=3
     manaCostPerLevel(4)=3
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_SilenceLaunch01'
     ItemType=SPELL_Defensive
     InventoryGroup=23
     PickupMessage="Silence"
     ItemName="Silence"
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
