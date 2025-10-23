//=============================================================================
// Scrye.
//=============================================================================
class Scrye expands AttSpell;

//-----------------------------------------------------------------------------
//									Sounds
//-----------------------------------------------------------------------------
//
//#exec AUDIO IMPORT FILE="E_Spl_ScryeLaunch01.wav" NAME="E_Spl_ScryeLaunch01" GROUP="Spells"

function FireAttSpell( float Value )
{
	local bool bPCL;
	local int cost;

	// LogTime("AttSpell: FireAttSpell");

	if ( AeonsPlayer(Owner).ScryeTimer != 0 )
	{
		return;
	}

	Super.FireAttSpell(Value);
}

state NormalFire
{
	ignores FireAttSpell;
	
	Begin:
		if ( RGC() )
		{
			AeonsPlayer(owner).ScryeFullTime = 10 + castingLevel * 2;
			AeonsPlayer(owner).ScryeTimer = AeonsPlayer(owner).ScryeFullTime;
		}
		else
		{
			AeonsPlayer(owner).ScryeFullTime = 10;
			AeonsPlayer(owner).ScryeTimer = 10;
		}
		AeonsPlayer(owner).ScryeMod.gotoState('Activated');
		AeonsPlayer(owner).ScryeMod.castingLevel = localCastingLevel;
		AeonsPlayer(owner).ClientSetScryeModActive(true, localCastingLevel);
		GhelzUse(ManaCostPerLevel[castingLevel]);
		FinishAnim();
		// Sleep(RefireRate);
		Finish();
		bFiring = false;
		GotoState('Idle');
}

defaultproperties
{
     HandAnim=Scrye
     manaCostPerLevel(0)=60
     manaCostPerLevel(1)=50
     manaCostPerLevel(2)=40
     manaCostPerLevel(3)=30
     manaCostPerLevel(4)=20
     RefireRate=1
     FireSound=Sound'Aeons.Spells.E_Spl_ScryeLaunch01'
     ItemType=SPELL_Offensive
     InventoryGroup=16
     PickupMessage="Scrye"
     ItemName="Scrye"
     PlayerViewOffset=(X=-4,Y=10,Z=-2.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
