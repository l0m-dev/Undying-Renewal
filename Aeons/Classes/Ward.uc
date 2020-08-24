//=============================================================================
// Ward.
//=============================================================================
class Ward expands AttSpell;

//-----------------------------------------------------------------------------
//                                SOUNDS
//-----------------------------------------------------------------------------
// Rot
//#exec AUDIO IMPORT FILE="E_Spl_WardRot01.wav" NAME="E_Spl_WardRot01" GROUP="Spells"

// Sigil
//#exec AUDIO IMPORT FILE="E_Spl_WardSigil01.wav" NAME="E_Spl_WardSigil01" GROUP="Spells"
//------------------------------------------------------------------------------

function summonEffect()
{
	local vector HitLocation, HitNormal, dir, startLoc, eyeadjust;
	local Sigil_proj s;
	local CreepingRot_proj c;
	local vector EyeHeight;
	local Vector x, y, z;
		
	// Pawn(Owner).eyeTrace(HitLocation, HitNormal, 4096);

	if ( false )
	{	
		startLoc = (JointPlace('Mid_Base')).pos;
	}
	else
	{
		EyeHeight.z = Pawn(Owner).EyeHeight;
			
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
					
		startLoc = Owner.Location + EyeHeight + (X*Owner.CollisionRadius); // fire from your eye
	}

	dir = PlayerPawn(Owner).EyeTraceLoc - startLoc;

	if ( PlayerPawn(Owner).EyeTraceNormal.z > 0.50 )
	{
		c = spawn(class 'CreepingRot_proj',Pawn(Owner),,startLoc, rotator(dir));
		c.castingLevel = localCastingLevel;
	} else {
		s = spawn(class 'Sigil_proj',Pawn(Owner),,startLoc, rotator(dir));
		s.castingLevel = LocalCastingLevel;
	}
}

state NormalFire
{
	ignores FireAttSpell;
	
	Begin:
		summonEffect();
		// Test PlayActuator here!!
		PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_Quick, 0.5f);
		FinishAnim();
		PlayAnim('Down');
		sleep(RefireRate);
		Finish();
		bCanClientFire = true;


}



state ClientFiring
{
	// overloaded. may just be better to put the attspell behavior up in the subclasses that need it
	simulated function Tick(float DeltaTime)
	{
	//	Super.Tick(DeltaTime);
	}

	simulated function AnimEnd()
	{
		if ( AnimSequence == HandAnim )
		{
			//log("Ward: state ClientFiring: AnimEnd:   HandAnim");
			GotoState('');
			PlayDownPosition();
		}
	}

	simulated function PlayFiring()
	{
	
		//LogTime("Ward: PlayFiring: empty");
		// PlayerPawn(Owner).ClientMessage("AttSpell: PlayFiring()");
		//PlayAnim(HandAnim,,,,0);
		// disable('FireAttSpell');
	}

	simulated function BeginState()
	{
		//Log("Ward: state ClientFiring: BeginState");
		PlayAnim(HandAnim,,,,0);
	}


}


//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     HandAnim=Ward
     manaCostPerLevel(0)=40
     manaCostPerLevel(1)=40
     manaCostPerLevel(2)=40
     manaCostPerLevel(3)=40
     manaCostPerLevel(4)=40
     manaCostPerLevel(5)=40
     RefireRate=2
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardLaunch01'
     ItemType=SPELL_Offensive
     InventoryGroup=24
     PickupMessage="Ward"
     ItemName="Ward"
     PlayerViewOffset=(X=-3,Y=7.5,Z=-1)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
