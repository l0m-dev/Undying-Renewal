//=============================================================================
// Pyro.
//=============================================================================
class Pyro expands AttSpell;

var bool bFiring;

state NormalFire
{
	function FireAttSpell( float Value ){}

	function CastPyro()
	{
		if (PlayerPawn(Owner).EyeTraceActor != None )
		{
			Pawn(PlayerPawn(Owner).EyeTraceActor).OnFire(true);
		}
		
		Spawn(class 'MolotovExplosion',,,PlayerPawn(Owner).EyeTraceLoc, Rotation);
		MakeNoise( 5.0, 2560.0 );
		
		if ( AeonsPlayer(Owner).bMagicSound )
		{
			Owner.PlaySound(FireSound,, 1);
			AeonsPlayer(Owner).MakePlayerNoise(3.0, 1280*3);
		}
		
		PawnOwner.useMana(manaCostPerLevel[localCastingLevel]);
	}

	Begin:
		CastPyro();
		FinishAnim();
		sleep(RefireRate);
		//PawnOwner.bFireAttSpell = 0;
		Finish();
}

defaultproperties
{
     HandAnim=FireCantrip
	 RefireRate=1.0
     manaCostPerLevel(0)=60
     manaCostPerLevel(1)=50
     manaCostPerLevel(2)=40
     manaCostPerLevel(3)=30
     manaCostPerLevel(4)=20
     ItemType=SPELL_Offensive
     InventoryGroup=20
     PickupMessage="Pyro"
     ItemName="Pyro"
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     bContinuousFire=False
}
