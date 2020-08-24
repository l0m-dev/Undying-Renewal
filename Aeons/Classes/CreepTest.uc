//=============================================================================
// CreepTest.
//=============================================================================
class CreepTest expands Trigger;

//#exec OBJ LOAD FILE=\Aeons\Textures\fxB2.utx PACKAGE=fxB2
//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

/////////////////////////////////////////////////////////////
var() class<Decal> Decal;
var() float NormalRadius;
var() float BigRadius;
var() float HugeRadius;
var() int DamagePerLevel[6];

/////////////////////////////////////////////////////////////
var int Damage;
var float MomentumTransfer;
var float timerLen;
var Pawn dummyPawn;
var int castingLevel;
var bool bBig, bHuge;
var Decal MyDecal;
var RotTractorBeam tb;
var name Size;
var float TargetRadius;
var Actor LastGrow;
var sound HurtSound;
var float HurtSoundDelay, HurtSoundTimer;

/////////////////////////////////////////////////////////////
function PreBeginPlay()
{
	super.PreBeginPlay();
	TargetRadius = NormalRadius;
	SetCollisionSize(1.0, CollisionHeight);

	WardModifier(AeonsPlayer(Owner).WardMod).AddWard(2);
	if (Decal != none)
	{
		MyDecal = spawn(Decal,Self,,Location, Rotator(vect(0,0,1)));
		MyDecal.SetDrawScale(0.01);
	}
	Size = 'Normal';
}

function SendWarning( actor projActor, float Radius, float Duration, float Distance )
{
	local ScriptedPawn		sPawn;

	foreach RadiusActors( class 'ScriptedPawn', sPawn, Radius )
	{
		sPawn.WarnAvoidActor( projActor, Duration, Distance, 0.50 );
	}
}

function Init()
{
	timerLen = 1.0 / DamagePerLevel[CastingLevel];
	SetTimer(timerLen, true);

	switch(CastingLevel)
	{
		case 0:
			break;

		case 1:
		case 2:
			tb = spawn(class 'RotTractorBeam',,,Location);
			tb.InnerRadius = CollisionRadius;
			tb.OuterRadius = CollisionRadius * 4;
			tb.bIsActive = true;

			break;

		case 3:
			tb = spawn(class 'StrongRotTractorBeam',,,Location);
			tb.InnerRadius = CollisionRadius;
			tb.OuterRadius = CollisionRadius * 4;
			tb.bIsActive = true;
			break;

		case 4:
		case 5:
			tb = spawn(class 'StrongRotTractorBeam',,,Location);
			tb.InnerRadius = CollisionRadius;
			tb.OuterRadius = CollisionRadius * 4;
			tb.bIsActive = true;
			MyDecal.Opacity = 0.5;
			break;
	}
	// Send a warning to SP's to avoid this
	SendWarning( self, 1024, 20, CollisionRadius * 2 );
}

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	DInfo.damage = 1;
	// DInfo.damage = damagePerLevel[castingLevel] * timerLen;
	DInfo.DamageType = 'CreepingRot';
	DInfo.Deliverer = self;
	DInfo.DamageMultiplier = 1.0;
	return DInfo;	
}

function Destroyed()
{
	if (tb != none)
		tb.Destroy();
	WardModifier(AeonsPlayer(Owner).WardMod).RemoveWard(2);
	MyDecal.Destroy();
	Spawn(class 'Aeons.SigilExplosion',,,Location);
	// log("CreepingRot Trigger Destroyed");

}

function int Dispel(optional bool bCheck);

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	switch (DInfo.DamageType)
	{
		case 'concussive':
		case 'dyn_concussive':
		case 'skull_concussive':
		case 'sigil_concussive':
		case 'lbg_concussive':
		case 'phx_concussive':
		case 'gen_concussive':
			if ( DInfo.Damage > 5 )
				Destroy();
			break;
		
		default:
			break;
	}
}

function Timer()
{
	local int i;
	
	if ( (Pawn(Owner).Health <= 0) || (Pawn(Owner).mana <= 2) )
		Destroy();
	
	for (i=0;i<8;i++)
		if ( Touching[i] != None )
			Touch(Touching[i]);
}

function Grow(Actor Other)
{
	if (Other != LastGrow)
	{
		switch ( Size )
		{
			// I am normal size - grow to Big
			case 'Normal':
				TargetRadius = BigRadius;
				Size = 'Big';
				break;
	
			// I am Big or Huge size - grow to Huge
			case 'Big':
			case 'Huge':
				TargetRadius = HugeRadius;
				Size = 'Huge';
				break;
		};
	
		if (tb != none)
		{
			tb.InnerRadius = CollisionRadius;
			tb.OuterRadius = CollisionRadius * 1.5;
		}
		LastGrow = Other;
	}

}

function Touch( actor Other )
{
	local actor A;
	local DamageInfo DInfo;

	// if( IsRelevant( Other ) )
	log("CreepingRot thingy Touch()   "$Other,'Misc');

	if ( Other.IsA('CreepingRot_proj') )
	{
		// add to the creeping rot
		log("Destroying CreepingRot Projectile",'Misc');
		Other.Destroy();
		Grow(Other);
	} 
	else if ( Other.IsA('Pawn') ) 
	{
		DInfo = GetDamageInfo();
		if ( Pawn(Other).AcceptDamage(DInfo) )
		{
			Pawn(Other).TakeDamage(dummyPawn, Location, vect(0,0,-1), DInfo);
			
			if ( HurtSoundTimer <= 0.0 ) 
			{
				HurtSoundTimer = HurtSoundDelay;
				PlaySound(HurtSound);
			}
		}
	}
}

function Tick(float DeltaTime)
{
	if (CollisionRadius < TargetRadius)
	{
		SetCollisionSize((CollisionRadius + 1), CollisionHeight);

		if ( MyDecal != none )
			MyDecal.SetDrawScale(CollisionRadius / 88);
		
		if (tb != none)
		{
			tb.InnerRadius = CollisionRadius;
			tb.OuterRadius = CollisionRadius * 4;
			tb.bIsActive = true;
		}
	}

	if ( HurtSoundTimer > 0.0 )
	{
		HurtSoundTimer -= DeltaTime;
	}
}

defaultproperties
{
     Decal=Class'Aeons.CreepingRotDecal'
     NormalRadius=96
     BigRadius=138
     HugeRadius=192
     damagePerLevel(0)=30
     damagePerLevel(1)=30
     damagePerLevel(2)=50
     damagePerLevel(3)=50
     damagePerLevel(4)=50
     damagePerLevel(5)=70
     HurtSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardBurn01'
     HurtSoundDelay=1
     Physics=PHYS_Falling
     InitialState=None
     AmbientSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_WardLoop01'
     SoundRadius=24
     SoundVolume=12
     CollisionRadius=64
     CollisionHeight=16
     bCollideWorld=True
     bProjTarget=True
}
