//=============================================================================
// CreepingRot.
//=============================================================================
class CreepingRot expands Trigger;

//#exec MESH IMPORT MESH=CreepingRot_m SKELFILE=CreepingRot.ngf

var() class<Decal> Decal;

var int Damage;
var float MomentumTransfer;
var float timerLen;
var Pawn dummyPawn;
var int castingLevel;
var bool bBig, bHuge;
var Decal MyDecal;
var int DamagePerLevel[6];

function PreBeginPlay()
{
	super.PreBeginPlay();
	timerLen = 0.1;
	setTimer(timerLen, true);
	WardModifier(AeonsPlayer(Owner).WardMod).AddWard();
	MyDecal = spawn(Decal,Self,,Location, Rotator(vect(0,0,1)));
}

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	
	DInfo.damage = 1;
	// DInfo.damage = damagePerLevel[castingLevel] * timerLen;
	DInfo.DamageType = 'CreepingRot';
	DInfo.Deliverer = self;
	return DInfo;	
}

function Touch( actor Other )
{
	local actor A;
	local DamageInfo DInfo;
	
	// if( IsRelevant( Other ) )
	log("Creeping Rot Touch()   "$Other,'Misc');
	if ( Other.IsA('CreepingRot_proj') )
	{
		if (!bBig && !bHuge)
		{
			// I am a normal creeping rot, create a big one and kill me
			spawn(class 'CreepingRotBig',owner,,Location,Rotation);
			Other.Destroy();
			Destroy();
		} else if (bBig) {
			// I am a big creeping rot, create a huge one and kill me
			spawn(class 'CreepingRotHuge',owner,,Location,Rotation);
			Other.Destroy();
			Destroy();
		} else if (bHuge) {
			// I am a huge creeping rot, can't get any bigger!
			Other.Destroy();
		}
	} else if ( Other.IsA('Pawn') )
		DInfo = GetDamageInfo();
		if ( Pawn(Other).AcceptDamage(DInfo) )
			Pawn(Other).TakeDamage(dummyPawn, Location, vect(0,0,-1), getDamageInfo());
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

function int Dispel(optional bool bCheck);

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	// log("Rot Taking Damage");
	if ( DInfo.Damage > 5 )
		Destroy();
}

function Destroyed()
{
	WardModifier(AeonsPlayer(Owner).WardMod).RemoveWard();
	MyDecal.Destroy();
	// log("CreepingRot Trigger Destroyed");
}

defaultproperties
{
     Decal=Class'Aeons.CreepingRotDecal'
     TriggerType=TT_AnyProximity
     bHidden=False
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_None
     Style=STY_Translucent
     Texture=Texture'Engine.S_Actor'
     Mesh=SkelMesh'Aeons.Meshes.CreepingRot_m'
     SoundRadius=24
     CollisionRadius=64
     CollisionHeight=2
     bCollideWorld=True
     LightType=LT_Steady
     LightBrightness=128
     LightSaturation=126
     LightRadius=16
}
