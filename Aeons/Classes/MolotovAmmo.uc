//=============================================================================
// MolotovAmmo.
//=============================================================================
class MolotovAmmo expands Ammo;

var bool bDelayExplosion;
var float damageThreshold;

var() sound BounceSound[3];
var() sound UnderWaterExplosionSound;
var() sound WaterExplosionSound;
var() sound ExplosionSounds[3];


function PreBeginPlay()
{
	DamageThreshold = 2;
	Super.preBeginPlay();
}

function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	DInfo.Damage = 100;
	DInfo.DamageType = DamageType;
	DInfo.bMagical = false;
	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = 1;
	return DInfo;
}

function Spin()
{
	LoopAnim('Spin1', 0.5 + FRand() * 0.5);
}

state Activated
{
	function Activate()
	{
		local AeonsWeapon wep;
		
		if (Pawn(Owner) != none)
		{
			wep = AeonsWeapon(Pawn(Owner).Weapon);
			if ( Wep.isA('Molotov') )
			{
				if ( !wep.bAltAmmo )
				{
					// wep.AmmoType.AmmoAmount += wep.ClipCount;
					// switch to a new mesh
					// if (wep.AltAmmoMesh != none)
					// 	wep.Mesh = wep.AltAmmoMesh;

					wep.ClipCount = 0;			// Empty the clip
					wep.bAltAmmo = true;		// Normal Ammo Type
					wep.AmmoType = Ammo(Pawn(Owner).FindInventoryType(wep.AltAmmoName));
					wep.gotoState('SwitchWeaponMesh');	// Load the New Clip
				}
			} else {
				Pawn(Owner).ClientMessage("Invalid ammo type for your currently selected weapon");
				// Play buzzer sound?
			}
		}
	}
}


/*
function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	if ( ((DInfo.damage > damageThreshold) || (dInfo.DamageType == 'Electrical')) && (!DInfo.bMagical))
	{
		// delay if concussive of fire damage types/
		if ( (DInfo.DamageType == 'Dyn_Concussive') || (DInfo.DamageType == 'Fire') )
			bDelayExplosion = true;

		GotoState('Blow');
	}
}
*/

/*
function Tick(float deltaTime)
{
	if ( mesh != none )
		if ( VSize(Velocity) < 8 )
			playAnim('none');
}
*/
function bool ValidTouch( actor Other )
{
	local Actor A;

	if( Other.bIsPawn && Pawn(Other).bIsPlayer && (Pawn(Other).Health > 0) && Level.Game.PickupQuery(Pawn(Other), self) )
	{
		if( Event != '' )
			foreach AllActors( class 'Actor', A, Event )
				A.Trigger( Other, Other.Instigator );
		return true;
	}
	return false;
}


state Deactivated
{
	Begin:
		
}

function PickupFunction(Pawn Other){}

auto state Pickup
{	
	function Tick(float deltaTime)
	{
		if ( mesh != none )
			if ( VSize(Velocity) < 8 )
			{
				playAnim('none');
				Disable('Tick');
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

	function Touch( actor Other )
	{
		local Inventory Copy;
		local Weapon NewWeapon;

		if ( ValidTouch(Other) ) 
		{
			Copy = SpawnCopy(Pawn(Other));
			if (Level.Game.LocalLog != None)
				Level.Game.LocalLog.LogPickup(Self, Pawn(Other));
			if (Level.Game.WorldLog != None)
				Level.Game.WorldLog.LogPickup(Self, Pawn(Other));
			if (bActivatable && Pawn(Other).SelectedItem==None) 
				Pawn(Other).SelectedItem=Copy;
			if (bActivatable && bAutoActivate && Pawn(Other).bAutoActivate) Copy.Activate();
			if ( PickupMessageClass == None )
				Pawn(Other).ClientMessage(PickupMessage, 'Pickup');
			else
				Pawn(Other).ReceiveLocalizedMessage( PickupMessageClass, 0, None, None, Self.Class );
			PlaySound (PickupSound,,2.0);	
			Pickup(Copy).PickupFunction(Pawn(Other));
		}
	}

	function BeginState()
	{
		Super.BeginState();
		NumCopies = 0;
	}
}

defaultproperties
{
     AmmoAmount=1
     MaxAmmo=4
     ExplosionDecal=Class'Aeons.ExplosionDecal'
     bCanActivate=True
     InventoryGroup=115
     bAmbientGlow=False
     PickupMessage="You picked up a molotov cocktail"
     ItemName="Molotov Cocktails"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Molotov_m'
     PickupSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_MoltPU01'
     Icon=Texture'Aeons.Icons.Molotov_Icon'
     Physics=PHYS_Falling
     bDirectional=True
     Mesh=SkelMesh'Aeons.Meshes.Molotov_m'
     AmbientGlow=0
     bGameRelevant=True
     CollisionRadius=6
     CollisionHeight=16
     bCollideActors=True
     bCollideWorld=True
     bProjTarget=True
     bFixedRotationDir=False
}
