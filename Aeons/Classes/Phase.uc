//=============================================================================
// Phase.
//=============================================================================
class Phase expands DefSpell;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//----------------------------------------------------------------------------

state NormalFire
{
	ignores FireDefSpell;

	Begin:
		AeonsPlayer(owner).PhaseMod.castingLevel = localCastingLevel;
		AeonsPlayer(owner).PhaseMod.gotoState('Activated');
		spawn(class 'PhaseEffect',AeonsPlayer(owner),,AeonsPlayer(owner).Location);

		FinishAnim();
		sleep(RefireRate);
		Finish();
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     HandAnim=Phase
     manaCostPerLevel(0)=3
     manaCostPerLevel(1)=5
     manaCostPerLevel(2)=5
     manaCostPerLevel(3)=4
     manaCostPerLevel(4)=4
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PhaseLaunch01'
     ItemType=SPELL_Defensive
     InventoryGroup=22
     PickupMessage="Phase"
     ItemName="Phase"
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
