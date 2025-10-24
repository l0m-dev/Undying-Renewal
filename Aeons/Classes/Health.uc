//=============================================================================
// Health.
//=============================================================================
class Health expands Items;

//#exec MESH IMPORT MESH=health_m SKELFILE=health.ngf

// pickup sound
//#exec AUDIO IMPORT  FILE="I_HealthPU01.wav" NAME="I_HealthPU01" GROUP="Inventory"
//#exec AUDIO IMPORT  FILE="P_Heal_Breath01.WAV" NAME="P_Heal_Breath01" GROUP="Inventory"

var() int HealingAmount;
var AeonsPlayer AP;
var bool bHealthVial;
var bool bHealingRoot;
var float inc;
var vector InitialLocation;
var ParticleFX pfx;
var localized string MaxHealthMessage;

simulated function PreBeginPlay()
{
	Disable('Tick');
}

simulated function BecomeHealthVial()
{
	bHealthVial = true;

	InitialLocation = Location;
	
	if ( Owner == none && Level.NetMode != NM_Client )
	{
		pfx = spawn(class 'HealthVialParticleFX',self,,Location);
		pfx.SetBase(self);
	}

	//PickupMessage = "You gained a Health Vial";
	PickupViewMesh = SkelMesh'Aeons.Meshes.StalkerLure_m';
	PickupViewScale = 2.2;
	PickupSound = Sound'Wpn_Spl_Inv.Inventory.I_GlassPU01';
	SetPhysics(PHYS_None);
	Mesh = SkelMesh'Aeons.Meshes.StalkerLure_m';
	ShadowImportance = 0;
	DrawScale = 2.2;
	bMRM = False;
	bUnlit=true;
	LightType = LT_Steady;
	LightBrightness = 127;
	LightHue = 139;
	LightSaturation = 129;
	LightRadius = 16;
	if (Level.NetMode != NM_DedicatedServer)
		Enable('Tick');
}

simulated function BecomeHealingRoot()
{
     //PickupMessage = "You gained some Healing Roots";
     PickupViewMesh = SkelMesh'Aeons.Meshes.HealingRoot_m';
     PickupViewScale = 2;
     PickupSound = Sound'Wpn_Spl_Inv.Inventory.I_HealthRootPU01';
     Mesh = SkelMesh'Aeons.Meshes.HealingRoot_m';
     DrawScale = 2;
     //CollisionRadius=16;
     //CollisionHeight=44;
}

simulated function Tick(float DeltaTime)
{
	local vector Loc;
	local rotator r;
	
	if ( bHealthVial )
	{
		// left for compatibility with broken PHYS_Rotating
		if ( GetStateName() == 'Pickup' && Physics == PHYS_None )
		{
			r = rotation;
			r.yaw += (4096 * deltaTime);

			SetRotation(r);

			inc += DeltaTime;
			
			PrePivot.z = cos(inc) * 4;
		}
	}
}

simulated function Destroyed()
{
	Super.Destroyed();
	
	if ( pfx != none )
	{
		pfx.Shutdown();
		pfx = none;
	}
}

function PickupFunction(Pawn Other)
{
	Super.PickupFunction(Other);
	if ( pfx != none )
	{
		pfx.Shutdown();
		pfx = none;
	}
	if ( Other.IsA('AeonsPlayer') )
	{
		HealthModifier(AeonsPlayer(Other).HealthMod).NumHealths ++;
	}
}

function bool HandlePickupQuery( inventory Item )
{
	if ( item.IsA('Health') && Health(item).bHealthVial && GetRenewalConfig().bAutoUseHealthVials )
	{
		// don't do anything extra
		// return false to say picking up wasn't handled by this function
		return false;
	}

	return Super.HandlePickupQuery(Item);
}

auto state Pickup
{
	function bool ValidTouch( actor Other )
	{
		local AeonsPlayer AP;
		local Inventory Inv;
		local int HealthPacks;

		AP = AeonsPlayer(Other);
		if ( AP != None )
		{
			// health vial check
			if (bHealthVial && GetRenewalConfig().bAutoUseHealthVials)
			{
				if (HealthModifier(AP.HealthMod).ProjectedHealthTarget >= 100)
					return false;

				return Super.ValidTouch(Other);
			}

			// health limit check
			Inv = AP.Inventory.FindItemInGroup(default.InventoryGroup);
			if (Inv != None)
				HealthPacks = Pickup(Inv).numCopies + 1;
			
			if (GetRenewalConfig().bLimitHealth && (
				(Level.Game.Difficulty == 0 && HealthPacks >= 15) ||
				(Level.Game.Difficulty == 1 && HealthPacks >= 10) ||
				(Level.Game.Difficulty == 2 && HealthPacks >= 5) ||
				(Level.Game.Difficulty >= 3 && HealthPacks >= 2)))
			{
				AP.ClientMessage(MaxHealthMessage, 'Pickup');
				return false;
			}
		}

		return Super.ValidTouch(Other);
	}

	function Touch( actor Other )
	{
		local Inventory Copy;
		local AeonsPlayer AP;

		if ( ValidTouch(Other) ) 
		{
			Copy = SpawnCopy(Pawn(Other));
			AP = AeonsPlayer(Other);
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
			if (bActivatable && Pawn(Other).SelectedItem==None) 
				Pawn(Other).SelectedItem=Copy;
			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate) Copy.Activate();
			if (AP == None || !GetRenewalConfig().bShowQuickSelectHint || !AP.ShowSelectItemHint(PickupMessage))
			{
				// hint was not shown
				if ( PickupMessageClass == None )
					Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
				else
					Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			}
			PlaySound (PickupSound,,2.0);	
			Pickup(Copy).PickupFunction(Pawn(Other));

			if (AP != None)
			{
				if ((Level.Game.Difficulty == 0 && HealthModifier(AP.HealthMod).ProjectedHealthTarget <= 65) || (bHealthVial && GetRenewalConfig().bAutoUseHealthVials))
				{
					// Picking up health when I really need it.
					Copy.Activate();
				}
			}
		}
	}
}


state Activated
{
	function Activate()
	{
		local int Diff, HealAmt, ProjectedHealth;

		if ( (Pawn(Owner) != None) )
		{
			AP = AeonsPlayer(Owner);
			ProjectedHealth = HealthModifier(AP.HealthMod).ProjectedHealthTarget;
			if ( ProjectedHealth < 100 )
			{
				Diff = (200 - ProjectedHealth + 1);
				
				if ( Diff > HealingAmount )
					HealAmt = HealingAmount;
				else
					HealAmt = Diff;
				
				Owner.PlaySound(ActivateSound);
				HealthModifier(AP.HealthMod).HealthSurplus += HealAmt;
				HealthModifier(AP.HealthMod).UpdateProjectedHealthTarget();
				numCopies --;
				//HealthModifier(AP.HealthMod).NumHealths --;
			}
		}
	
		Super.Activate();
		if ( numCopies < 0 )
		{
			SelectNext();
			Pawn(Owner).DeleteInventory(self);
		}
	}

	function BeginState()
	{
		Super.BeginState();
		Activate();
	}
}

state Deactivated
{

	Begin:
		bActive = false;
		
}

defaultproperties
{
     HealingAmount=35
     bCanHaveMultipleCopies=True
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=101
     bActivatable=True
     bDisplayableInv=True
     bAmbientGlow=False
     PickupMessage="You gained a Health Pack"
     ItemName="Health"
     MaxHealthMessage="You cannot carry any more Health"
     PickupViewMesh=SkelMesh'Aeons.Meshes.health_m'
     PickupSound=Sound'Aeons.Inventory.I_HealthPU01'
     ActivateSound=Sound'Wpn_Spl_Inv.Inventory.I_HealthUse01'
     Icon=Texture'Aeons.Icons.Health_Icon'
     Texture=Texture'Engine.S_Ammo'
     Mesh=SkelMesh'Aeons.Meshes.health_m'
     AmbientGlow=0
     CollisionRadius=20
     CollisionHeight=21
}
