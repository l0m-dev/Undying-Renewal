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
var string MaxHealthMessage;

function PreBeginPlay()
{
	MaxHealthMessage = Localize("Aeons.Health", "MaxHealthMessage", "Renewal");
}

function BecomeHealthVial()
{
	bHealthVial = true;

	InitialLocation = Location;
	
	if ( Owner == none )
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
}

function BecomeHealingRoot()
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

function Tick(float DeltaTime)
{
	local vector Loc;
	local rotator r;
	
	if ( bHealthVial )
	{
		if ( GetStateName() == 'Pickup' )
		{
			r = rotation;
			r.yaw += (4096 * deltaTime);

			SetRotation(r);

			inc += DeltaTime;
			
			PrePivot.z = cos(inc) * 4;
		}
	}
}

auto state Pickup
{	
	function Touch( actor Other )
	{
		local Inventory Copy;
		local AeonsPlayer AP;
		local bool bContinue;
		local Inventory Inv;
		local int HealthPacks;

		if ( Other.IsA('AeonsPlayer') )
		{
			AP = AeonsPlayer(Other);
			Inv = PlayerPawn(Other).Inventory.FindItemInGroup(default.InventoryGroup);
			if (Inv != None)
				HealthPacks = Pickup(Inv).numCopies + 1;

			if (((Level.Game.Difficulty == 0) && ( HealthModifier(AP.HealthMod).ProjectedHealthTarget <= 65 )) || (bHealthVial && GetRenewalConfig().bAutoUseHealthVials))
			{
				// Picking up health when I really need it.
				if (HealthModifier(AP.HealthMod).ProjectedHealthTarget < 100)
				{
					HealthModifier(AP.HealthMod).HealthSurplus += healingAmount;
					if ( PickupMessageClass == None )
					{
						Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
					} else
						Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
					PlaySound (PickupSound,,2.0);
					Destroy();
				}
			} else {
				if ((Level.Game.Difficulty == 0 && HealthPacks < 15) ||
				    (Level.Game.Difficulty == 1 && HealthPacks < 10) ||
				    (Level.Game.Difficulty == 2 && HealthPacks < 5) || !RGC()) {
					bContinue = true;
				} else {
					Pawn(Other).ClientMessage(MaxHealthMessage, 'Pickup');
				}
			}
		}
		if ( bContinue && ValidTouch(Other) )
		{
			// anything but the player
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
			if (bActivatable && Pawn(Other).SelectedItem==None) 
				Pawn(Other).SelectedItem=Copy;
			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate) Copy.Activate();

			if (GetRenewalConfig().bShowQuickSelectHint && AP != None && Ap.ShowSelectItemHint(PickupMessage))
			{
				// hint was shown successfully
			}
			else
			{
				if ( PickupMessageClass == None )
					Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
				else
					Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			}

			Copy = SpawnCopy(Pawn(Other));
			Pickup(Copy).PickupFunction(Pawn(Other));
			AmbientSound = none;
			if ( Other.IsA('AeonsPlayer') )
			{
				HealthModifier(AeonsPlayer(Other).HealthMod).NumHealths ++;
			}
			PlaySound (PickupSound,,2.0);	
		}
		
	}

	function Trigger( Actor Other, Pawn EventInstigator )
	{
		local PlayerPawn P;
		
		ForEach AllActors(class 'PlayerPawn', P)
		{
			break;
		}

		if ( p!= none )
			Touch(P);
	}

	function BeginState()
	{
		Super.BeginState();
		NumCopies = 0;
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

	Begin:
		Activate();
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
