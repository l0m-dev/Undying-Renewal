//=============================================================================
// EtherTrapTrigger.
//=============================================================================
class EtherTrapTrigger expands Trigger;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//#exec MESH IMPORT MESH=EtherTrap_m SKELFILE=EtherTrap.ngf

var VoidInfo Vi;
var PlayerPawn P;
var ParticleFX fx;

var() sound CloseSound;
var() sound CatchSound;
var() sound AmbientLoop;
var() float InitialStateTime;
var() float HoldStateTime;

simulated function BeginPlay()
{
	super.BeginPlay();
	AmbientSound = AmbientLoop;
	if (Level.NetMode != NM_DedicatedServer)
		fx = spawn(class 'EtherTrapParticleFX',self,,Location + (vect(0,0,-1) * (CollisionHeight - 8)), Rotator(vect(1,0,0)));
}

state() EtherTrapState
{
	function int Dispel(bool bCheck)
	{
		if ( bCheck )
			return 2;
		
		Destroy();
	}

	function Tick(float DeltaTime)
	{
		/// fx.SetLocation (Location + vect(0,0,32));
	}

	function Timer()
	{
		GotoState('Holding');
	}

	function BeginState()
	{
		SetTimer(InitialStateTime, false);
	}

	function Touch(Actor Other){}

}

state Holding
{
	function Touch(Actor Other)
	{
		local EtherTrapEvent A;
		local DamageInfo DInfo;
	
		log( "" $ name $ ".Touch( " $ Other.name $ " ) called." );
//		Disable effect on player pawn -- new intention is that it only effects ethereal creatures.
//		if ( Other.IsA('PlayerPawn') )
//		{
//			ForEach AllActors(class 'VoidInfo', Vi)
//			{
//				break;
//			}
//			
//			PlaySound(CatchSound);
//
//			if (Vi != none)
//			{
//				PlayerPawn(Other).SetLocation(Vi.Location);
//				PlayerPawn(Other).Velocity = vect(0,0,0);
//				PlayerPawn(Other).SetPhysics(PHYS_Falling);
//			} else {
//				PlayerPawn(Other).ClientMessage("No Void Info Found!");
//				PlayerPawn(Other).Died( None, '', Location, DInfo );
//			}
//			
//			ForEach AllActors(class 'EtherTrapEvent', A)
//			{
//				A.Trigger(Other, Other.Instigator);
//			}
//			
//		} else 
		if ( Other.IsA('ScriptedPawn') && ScriptedPawn(Other).bIsEthereal ) {
			ForEach AllActors(class 'EtherTrapEvent', A)
			{
				// log("EtherTrapTrigger: Triggering EtherTrap Event", 'Misc');
				A.Trigger(self, self.Instigator);
			}
	
			Spawn(class 'EtherTrapFX',ScriptedPawn(Other),,ScriptedPawn(Other).Location);
			PlaySound(CatchSound);
			ScriptedPawn(Other).Destroy();
			Destroy();
		}
	}


	function int Dispel(bool bCheck)
	{
		if ( bCheck )
			return -1;
	}

	function Timer()
	{
		Spawn(class 'EtherTrap',,, Location);
		Destroy();
	}

	function bool WithinRange( actor Other )
	{
		local vector DVect;

		if ( Abs(Location.Z - Other.Location.Z) < ( CollisionHeight + Other.CollisionHeight ) )
		{
			// Z overlap.
			DVect = Location - Other.Location;
			DVect.Z = 0;
			if( VSize(DVect) < (CollisionRadius + Other.CollisionRadius) )
				return true;
		}

		return false;
	}

	function BeginState()
	{
		local ScriptedPawn Other;
		local EtherTrapEvent A;
		local bool triggered;

		triggered = false;
		foreach AllActors( class 'ScriptedPawn', Other )
		{
			if ( (Other != none ) && Other.bIsEthereal && WithinRange( Other ) ) 
			{
				ForEach AllActors(class 'EtherTrapEvent', A)
				{
					// log("EtherTrapTrigger: Triggering EtherTrap Event", 'Misc');
					A.Trigger(self, self.Instigator);
				}
	
				Spawn(class 'EtherTrapFX',Other,,Other.Location);
				PlaySound(CatchSound);
				Other.Destroy();
				triggered = true;
			}
		}
		if( triggered )
			Destroy();	
		else
			SetTimer(HoldStateTime, false);
	}
}

simulated function Destroyed()
{
	PlaySound(CloseSound);
	if (fx != none)
		fx.Shutdown();
}

defaultproperties
{
     CloseSound=Sound'Wpn_Spl_Inv.Inventory.I_EtherTrapClose01'
     CatchSound=Sound'Wpn_Spl_Inv.Inventory.I_EtherTrapCatch01'
     AmbientLoop=Sound'Wpn_Spl_Inv.Inventory.I_EtherTrapLp01'
     InitialStateTime=0.5
     HoldStateTime=10
     TriggerType=TT_PawnProximity
     RepeatTriggerTime=0.05
     bHidden=False
     Physics=PHYS_Falling
     InitialState=EtherTrapState
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.EtherTrap_m'
     DrawScale=3
     CollisionRadius=100
     CollisionHeight=128
     bCollideWorld=True
}
