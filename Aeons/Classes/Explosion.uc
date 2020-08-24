//=============================================================================
// Explosion.
//=============================================================================
class Explosion expands Effects;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

//#exec TEXTURE IMPORT NAME=Explosion FILE=Explosion.pcx GROUP=System Mips=Off Flags=2

// This class works via two different methods

var() bool bTriggered;
var() float DamageRadius;
var() int Damage;
var() name DamageType;
var() localized string DamageString;		// Damage String - used to construc messages
var() bool bMagical;			// Damage is magical
var() float	DamageMultiplier;	// damage multiplier - for head shots.
var() float MomentumTransfer;
var() Sound Sounds[3];
var() bool bTriggerMultiple;
var() bool bCausesDamage;
var() class<Decal> DecalClass;
var() float SoundRadius;
var() float RumbleRadius;
var() float RumbleStrength;
var() EActEffects RumbleType;

function GibRadius( float DamageRadius, vector HitLocation, DamageInfo DInfo, pawn Instigator )
{
	local actor Victims;

	if( DInfo.DamageRadius == 0.0 )
		DInfo.DamageRadius = DamageRadius;

	if( DInfo.DamageLocation == vect(0,0,0) )
		DInfo.DamageLocation = HitLocation;
	
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		if( Victims != self && Victims.IsA('ScriptedPawn') && Pawn(Victims).Health <= 0 )
		{
			if (DInfo.ImpactForce != vect(0,0,0))
				ScriptedPawn(Victims).SpawnGibbedCarcass(HitLocation-Victims.Location);
			else
				ScriptedPawn(Victims).SpawnGibbedCarcass(DInfo.ImpactForce);
			
			Pawn(Victims).gibbedBy( PlayerPawn(Instigator) );
			Pawn(Victims).Destroy();
		}  
	}
}

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	DInfo.DamageMultiplier = 1.0;
	DInfo.Damage = Damage;
	Dinfo.DamageType = DamageType;
	Dinfo.DamageString = DamageString;
	DInfo.bMagical = bMagical;
	DInfo.DamageMultiplier = DamageMultiplier;
	DInfo.DamageRadius = DamageRadius;
	if (Owner != none)
		DInfo.Deliverer = Owner;
	return DInfo;	
}

simulated function WallDecal(Vector HitLocation, Vector HitNormal)
{
	if ( (DecalClass != None) && (Level.NetMode != NM_DedicatedServer) )
	{
		Spawn(DecalClass,self,,Location, rotator(HitNormal));
	}
}

function GenerateDecal()
{
	WallDecal(Location,vect(0,0,1));
	WallDecal(Location,vect(0,0,-1));
	WallDecal(Location,vect(0,1,0));
	WallDecal(Location,vect(0,-1,0));
	WallDecal(Location,vect(1,0,0));
	WallDecal(Location,vect(-1,0,0));
}

function PlayEffectSound(optional float Volume)
{
	local float Decision, Vol;
	
	if ( Volume > 0 )
		Vol = Volume;
	else
		Vol = 3.0;
	
	Decision = FRand();
	
	if ( (decision > 0.66667) && (Sounds[2] != none) )
		PlaySound(Sounds[2],SLOT_Interact, Vol ,,SoundRadius, 1.0);
	else if ( (decision > 0.33333334) && (Sounds[1] != none) )
		PlaySound(Sounds[1],SLOT_Interact, Vol ,,SoundRadius, 1.0);
	else if (Sounds[0] != none)
		PlaySound(Sounds[0],SLOT_Interact, Vol ,,SoundRadius, 1.0);
}

function CreateExplosion(Pawn Instigator);

function BeginPlay()
{
	Super.BeginPlay();
	if ( !bTriggered )
	{
		if ( Pawn(Owner) != none )
			CreateExplosion(Pawn(Owner));
		else
			CreateExplosion(Instigator);
		Destroy();
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	CreateExplosion(Instigator);

	if (!bTriggerMultiple)
		Destroy();
}

defaultproperties
{
     DamageRadius=256
     Damage=30
     DamageType=concussive
     DamageString="Exploded"
     DamageMultiplier=1
     MomentumTransfer=300
     bCausesDamage=True
     SoundRadius=4096
     bHidden=True
     DrawType=DT_Sprite
     Style=STY_Masked
     Texture=Texture'Aeons.System.Explosion'
}
