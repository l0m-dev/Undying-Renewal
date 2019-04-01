//=============================================================================
// Sigil.
//=============================================================================
class Sigil expands Trigger;

#exec MESH IMPORT MESH=Sigil_m SKELFILE=Sigil.ngf
#exec MESH ORIGIN MESH=Sigil_m YAW=128
#exec AUDIO IMPORT FILE="..\Dynamite_proj\E_Wpn_DynaExpl01.wav" NAME="E_Wpn_DynaExpl01" GROUP="Weapons"

var int Damage;
var float MomentumTransfer;
var int castingLevel;
var() sound Explodesound;

function PreBeginPlay()
{
	super.PreBeginPlay();
	log("Sigil:PreBeginPlay() ",'Misc');
	Damage = 50;
	MomentumTransfer = 5000;
	// Add maintenance to players mana modifier
	WardModifier(AeonsPlayer(Owner).WardMod).AddWard();
	// Opacity = 0;
	if ( CastingLevel == 4 )
		bScryeOnly = true;
	GotoState('FadeIn');
}

function Destroyed()
{
	// remove mana maintenence
	if ( Owner != none )
	{
		WardModifier(AeonsPlayer(Owner).WardMod).RemoveWard();
	}
}

function bool IsRelevant( actor Other )
{

	if ( Other.IsA('Skull_proj') || Other.IsA('Pawn') )
		return true;

	if ( Other.IsA('SpellProjectile') )
		return false;
}

state FadeIn
{
	function Timer()
	{
		Opacity += 0.05;
		if ( Opacity >= 0.95 )
		{
			Opacity = 1.0;
			gotoState('Armed');
		}
	}
	
	Begin:
		setTimer(0.1,true);
		log("Sigil:FadeIn State... begin", 'Misc');
}

state Armed
{
	function BeginState()
	{
		if ( CastingLevel == 4 )
			bScryeOnly = true;
		else
			LoopAnim('Idle');
	}


/*
	function Timer()
	{
		local int i;

		for (i=0;i<8;i++)
			if ( Touching[i] != None )
				Touch(Touching[i]);

		if ( (Pawn(Owner).health <= 0) || (Pawn(Owner).mana <= 2) )
			gotoState('BlowUp');
	}
*/
	
	function Touch( actor Other )
	{
		log("Sigil:Touch "$Other.name,'Misc');
		
		if( IsRelevant( Other ) )
		{
			if ( Other.IsA('Actor'))
			{
				gotoState('BlowUp');
			}
		}
	}

	function UnTouch( actor Other )
	{
		local actor A;
		
		log("Sigil:Touch "$Other.name,'Misc');
		if( IsRelevant( Other ) )
		{
			if ( Other.IsA('Actor'))
			{
				gotoState('BlowUp');
			}
		}
	}

	Begin:
		setTimer(0.25,true);
		log("Sigil:Armed State... begin", 'Misc');
}


state BlowUp
{

	function DamageInfo getDamageInfo(optional name DamageType)
	{
		local DamageInfo DInfo;
		
		// DInfo.Damage = DamagePerLevel[CastingLevel];
		DInfo.Damage = 50;
		DInfo.DamageType = 'Sigil_Concussive';

		return DInfo;
	}

	//
	// Hurt actors within the radius via Concussive damage method
	//
	function HurtRadius (float DamageRadius, name DamageName, float Momentum, vector HitLocation, DamageInfo DInfo)
	{
		local actor Victims;
		local float damageScale, dist;
		local vector dir;
		
		if( bHurtEntry )
			return;
	
		bHurtEntry = true;
		foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
		{
			if( Victims != self )
			{
				dir = Victims.Location - HitLocation;
				dist = FMax(1,VSize(dir));
				dir = dir/dist; 
				damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
				if ( Victims.AcceptDamage(DInfo) )
					Victims.TakeDamage
					(
						Instigator, 
						Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir,
						(damageScale * Momentum * dir),
						DInfo
					);
			} 
		}
	bHurtEntry = false;
	}

	Begin:
		log("Sigil:Blow up State... begin", 'Misc');
		spawn(class 'ExplosionWind',,,Location);
		PlaySound(ExplodeSound,,2);
		spawn (class 'DefaultParticleExplosionFX',,,Location);
		HurtRadius(64 + CollisionRadius, 'exploded', MomentumTransfer, Location, getDamageInfo() );
		MakeNoise(1.0);
		Destroy();

}

defaultproperties
{
     ExplodeSound=Sound'Aeons.Weapons.E_Wpn_DynaExpl01'
     InitialState=None
     DrawType=DT_Mesh
     Texture=Texture'Engine.S_Corpse'
     bMRM=False
     SoundRadius=16
     CollisionRadius=64
     CollisionHeight=128
     bCollideJoints=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
