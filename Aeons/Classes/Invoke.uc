//=============================================================================
// Invoke.
//=============================================================================
class Invoke expands AttSpell;

#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var int finalManaCost;				// final Mana Cost of the spell after modifiers
var ScriptedPawn TargetPawn;
var int NumSPJoints;
var vector DesiredLocation, IncrementalLocation;
var InvokingFX ivFX;
var() sound FiringSounds[3];
var() sound SaintInvoke;
var() sound MineSound;

//----------------------------------------------------------------------------

function ScriptedPawn CheckInvoke()
{
	local vector HitLocation; 
	local Actor A;
	local ScriptedPawn SP;

	A = PlayerPawn(Owner).EyeTraceActor; //PlayerPawn(Owner).EyeTrace(HitLocation,, 256, true);
	
	if (A != none)
	{
		if ( A.IsA('ScriptedPawn') && (VSize(Owner.Location - A.Location) <= (256.0 + Owner.CollisionRadius + A.CollisionRadius)) )
		{
			SP = ScriptedPawn(A);
			if ( SP.CanBeInvoked() )
			{
				return SP;
			}
		}
	}
	return none;
}

//----------------------------------------------------------------------------

state NormalFire
{
	ignores FireAttSpell;

	Begin:
		FinishAnim();
		PlayAnim('Down');
		sleep(RefireRate);
		Finish();
}

//----------------------------------------------------------------------------

state SpecialFire
{
	ignores FireAttSpell;

	Begin:
		FinishAnim();
		PlayAnim('Down');
		sleep(RefireRate);
		Finish();
}

//----------------------------------------------------------------------------

state Idle
{

	Begin:
		PlayAnim('Down');

}

//----------------------------------------------------------------------------

function FireSpell()
{

}
 
function FireAttSpell( float Value )
{
   	local bool bPCL;

	bPCL = ProcessCastingLevel();

	if ( bPCL )
	{
		if ( PawnOwner.HeadRegion.Zone.bWaterZone && !bWaterFire)
			PlayFireEmpty(); //perhaps a fizzle sound
		else if ( !bSpellUp )
				BringUp();
		else 
		{
			PlayAnim(HandAnim,,,,0);
			TargetPawn = CheckInvoke();
			NumSPJoints = TargetPawn.NumJoints();

			if ( TargetPawn != none )
			{
				if ( TargetPawn.IsA('Trsanti') )
				{
					FinalManaCost = 75;
				} else {

					switch(localCastingLevel)
					{
						case 0:
							FinalManaCost = TargetPawn.default.Health;
							break;

						case 1:
							FinalManaCost = TargetPawn.default.Health;
							break;

						case 2:
							FinalManaCost = TargetPawn.default.Health * 0.5;
							break;

						case 3:
							FinalManaCost = TargetPawn.default.Health * 0.5;
							break;

						case 4:
							FinalManaCost = TargetPawn.default.Health * 0.25;
							break;

						case 5:
							FinalManaCost = TargetPawn.default.Health * 0.25;
							break;
					}
				}

				if ( (ProcessCastingLevel()) &&  Pawn(Owner).useMana(FinalManaCost) && !AeonsPlayer(Owner).bDispelActive )
				{
					DesiredLocation  = vect(0,0,0);
					DesiredLocation.z = TargetPawn.default.CollisionHeight;
					DesiredLocation += TargetPawn.Location;
					
					IncrementalLocation = (DesiredLocation - TargetPawn.Location) ;
					
					GameStateModifier(AeonsPlayer(Owner).GameStateMod).fInvoke = 1.0;
					if ( TargetPawn.bSpecialInvoke )
					{
						if ( TargetPawn.IsA('DecayedSaint') )
						{
							PlaySound(SaintInvoke);
							PlaySound(MineSound);
						} else if ( TargetPawn.IsA('Trsanti') ) {
							PlaySound(MineSound);
						}
						
						GhelzUse(FinalManaCost);
						TargetPawn.Invoke(PlayerPawn(Owner));
						GotoState('SpecialFire');
					} else {
						PlaySound(FiringSounds[Rand(3)]);
						TargetPawn.SetPhysics(PHYS_None);
						ivFX = Spawn(class 'Aeons.InvokingFX',TargetPawn,,TargetPawn.Location);
						ivFX.ColorStart.Base = PlayerPawn(Owner).InvokeColor;
						GotoState('Holding');
					}
				} else {
					FailedSpellCast();
					GotoState('Idle');
				}
			} else
				GotoState('Idle');
		}
	}
}

//----------------------------------------------------------------------------
 
state Holding
{
	ignores FireAttSpell;

	function Tick(float DeltaTime)
	{
		local int i;
		
		TargetPawn.SetLocation(TargetPawn.Location + (IncrementalLocation * (DeltaTime *0.5)));
		
		i = Rand(NumSPJoints);
		TargetPawn.AddDynamic( TargetPawn.JointName(i), TargetPawn.JointPlace(TargetPawn.JointName(i)).pos ,VRand() * RandRange(0,50), RandRange(0.01, 0.5) );

		i = Rand(NumSPJoints);
		TargetPawn.AddDynamic( TargetPawn.JointName(i), TargetPawn.JointPlace(TargetPawn.JointName(i)).pos ,VRand() * RandRange(0,50), RandRange(0.01, 0.5) );

		i = Rand(NumSPJoints);
		TargetPawn.AddDynamic( TargetPawn.JointName(i), TargetPawn.JointPlace(TargetPawn.JointName(i)).pos ,VRand() * RandRange(0,50), RandRange(0.01, 0.5) );

	}

	function Timer()
	{
		GhelzUse(FinalManaCost);
		TargetPawn.Invoke(PlayerPawn(Owner));
		InvokeModifier(AeonsPlayer(Owner).InvokeMod).AddSP(TargetPawn, LocalCastingLevel);
		if ( Owner.bHidden )
			CheckVisibility();
		gotoState('NormalFire');
	}

	function BeginState()
	{
		if (TargetPawn == none)
			GotoState('');
		else
		{
			SetTimer(2, true);

			//audiohack
			Owner.PlaySound(FireSound);
		}
	}

	function EndState()
	{
		TargetPawn.SetPhysics(PHYS_Falling);
		TargetPawn.SetCollision(true, true, true);
	}


}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     FiringSounds(0)=Sound'Wpn_Spl_Inv.Spells.E_Spl_InvokeLive01'
     FiringSounds(1)=Sound'Wpn_Spl_Inv.Spells.E_Spl_InvokeMine01'
     FiringSounds(2)=Sound'Wpn_Spl_Inv.Spells.E_Spl_InvokeRise01'
     SaintInvoke=Sound'Wpn_Spl_Inv.Spells.E_Spl_InvokeDSaint01'
     MineSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_InvokeMine01'
     HandAnim=Invoke
     manaCostPerLevel(0)=10
     manaCostPerLevel(1)=10
     manaCostPerLevel(2)=10
     manaCostPerLevel(3)=10
     manaCostPerLevel(4)=10
     manaCostPerLevel(5)=10
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_SumGenUse01'
     ItemType=SPELL_Offensive
     InventoryGroup=18
     PickupMessage="Invoke"
     ItemName="Invoke"
     PlayerViewOffset=(X=-6,Y=6,Z=-2.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     MinTickTime=0.05
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
