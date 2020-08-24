//=============================================================================
// Shield.
//=============================================================================
class Shield expands AttSpell;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//----------------------------------------------------------------------------

state NormalFire
{
	ignores FireAttSpell;

	Begin: 
		AeonsPlayer(owner).ShieldMod.gotoState('Activated');
		AeonsPlayer(owner).ShieldMod.castingLevel = localCastingLevel;
		FinishAnim();
		sleep(RefireRate);
		bFiring = false;
		AeonsPlayer(Owner).bFireAttSpell = 0;
		Finish();
}

state Idle
{
	function BeginState()
	{
		bFiring = false;
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     HandAnim=Shield
     manaCostPerLevel(0)=60
     manaCostPerLevel(1)=60
     manaCostPerLevel(2)=60
     manaCostPerLevel(3)=60
     manaCostPerLevel(4)=60
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_ShldLaunch01'
     ItemType=SPELL_Offensive
     InventoryGroup=17
     PickupMessage="Shield"
     ItemName="Shield"
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
