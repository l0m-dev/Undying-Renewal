//=============================================================================
// DynamiteAmmo.
//=============================================================================
class DynamiteAmmo expands Ammo;

#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

#exec MESH IMPORT MESH=Dynamite_m SKELFILE=Dynamite_m.ngf

// pickup sound
#exec AUDIO IMPORT  FILE="I_DynAmmoPU01.WAV" NAME="I_DynAmmoPU01" GROUP="Inventory"

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

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	if ( ((DInfo.damage > damageThreshold) || (dInfo.DamageType == 'Electrical')) && (!DInfo.bMagical))
	{
		// delay if concussive of fire damage types/
		if ( (DInfo.DamageType == 'Dyn_Concussive') || (DInfo.DamageType == 'Fire') )
			bDelayExplosion = true;

		gotoState('Blow');
	}
}

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


// ==============================================================================
// Blow
// ==============================================================================
state Blow
{
	// no ticky!
	function Tick(float DeltaTime);
	
	// We're already blowing up - don't take any damage - causes inifinite recursion is this is take out.
	function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo);

	function BlowUp(vector HitLocation)
	{
		//stopSound(sndID);
		if ( Region.Zone.bWaterZone )
		{
			HurtRadius(384.0, 'exploded', 1000 , HitLocation, getDamageInfo('Dyn_Concussive'));
			MakeNoise(3.0);
			PlaySound(UnderWaterExplosionSound,SLOT_Misc,3);
		} else {
			HurtRadius(256.0, 'exploded', 1000, HitLocation, getDamageInfo('Dyn_Concussive'));
			MakeNoise(1.0);
			PlaySound(ExplosionSounds[Rand(3)],SLOT_Misc,3);

			WallDecal(Location,vect(0,0,1));
			WallDecal(Location,vect(0,0,-1));
			WallDecal(Location,vect(0,1,0));
			WallDecal(Location,vect(0,-1,0));
			WallDecal(Location,vect(1,0,0));
			WallDecal(Location,vect(-1,0,0));
		}
		spawn(class 'ExplosionWind',,,Location);
	}

	Begin:
		if (bDelayExplosion)
			sleep((FRand() * 0.5) + 0.15);
		if ( Region.Zone.bWaterZone )
			spawn (class 'UnderwaterExplosionFX',,,Location);
		else {
			// spawn (class 'DefaultParticleExplosionFX',,,Location);
			spawn (class 'DynamiteExplosion',owner,,Location);
			//spawn (class 'SmokyExplosionFX'  ,,,Location);
			//spawn (class 'ParticleExplosion' ,,,Location);
		}
			
		BlowUp(Location);
		destroy();
}

// ==============================================================================
// Activated
// ==============================================================================
state Activated
{
	function Activate()
	{
		local AeonsWeapon wep;
		
		if (Pawn(Owner) != none)
		{
			wep = AeonsWeapon(Pawn(Owner).Weapon);
			if ( Wep.isA('Dynamite') )
			{
				if ( wep.bAltAmmo )
				{
					wep.ClipCount = 0;			// Empty the clip
					wep.bAltAmmo = false;		// Normal Ammo Type
					wep.AmmoType = Ammo(Pawn(Owner).FindInventoryType(wep.AmmoName));
					wep.gotoState('SwitchWeaponMesh');	// Load the New Clip
				}
			} else {
				Pawn(Owner).ClientMessage("Invalid ammo type for your currently selected weapon");
			}
		}
	}
}

state Deactivated
{
	Begin:
		
}

function PickupFunction(Pawn Other)
{
}

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
		local Actor A;
		
		A = spawn(class 'Dynamite');
		A.Touch(Other);

		Destroy();
		
		/*
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
		}*/
	}

	function BeginState()
	{
		Super.BeginState();
		NumCopies = 0;
	}
}

defaultproperties
{
     ExplosionSounds(0)=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     AmmoAmount=1
     MaxAmmo=10
     UsedInWeaponSlot(8)=1
     ExplosionDecal=Class'Aeons.ExplosionDecal'
     InventoryGroup=114
     bAmbientGlow=False
     PickupMessage="You picked up a dynamite stick"
     ItemName="Dynamite Sticks"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Dynamite_m'
     PickupSound=Sound'Aeons.Inventory.I_DynAmmoPU01'
     Icon=Texture'Aeons.Icons.Dynamite_Icon'
     ImpactSoundClass=Class'Aeons.DynImpact'
     Physics=PHYS_Falling
     bDirectional=True
     Mesh=SkelMesh'Aeons.Meshes.Dynamite_m'
     AmbientGlow=0
     bGameRelevant=True
     CollisionRadius=4
     CollisionHeight=12
     bCollideActors=True
     bCollideWorld=True
     bProjTarget=True
     bFixedRotationDir=False
}
