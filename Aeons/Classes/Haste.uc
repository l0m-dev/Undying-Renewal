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

	if ( AeonsPlayer(owner).HasteMod.bActive )
	{
		return;
	}

	Super.FireAttSpell(Value);
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
