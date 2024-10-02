//=============================================================================
// LtngBlast_proj.
//=============================================================================
class LtngBlast_proj expands SpellProjectile;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv

var int Charge;
var int NumChains;
var vector StartLoc;
var() float Range, ChainRange;

var Actor Target;
var Actor LastActor;
var Pawn SeekPawn;

var() float DamageMult;
var() sound ChainSound;

simulated function PreBeginPlay()
{
	if (RGC())
	{
		Range = 4096;
		Speed = 6000;
	}
	super.PreBeginPlay();
}

auto state flying
{
	function BeginState()
	{
		local SimpleLightning bolt;

		Bolt = spawn (class 'SimpleLightning',self,,Location);

		if (Range > 0)
			LifeSpan = Range / Speed;

		Bolt.bScaleShaft = true;
		Bolt.DamageMult = DamageMult;
		bolt.StartActor = Owner;
		Bolt.EndActor = self;
		Bolt.StartJoint = GetRandomJoint(Owner);
		Bolt.EndJoint = GetRandomJoint(self);
		Bolt.Lifespan = Lifespan;
		bolt.go();

		SetTimer(0.5, true);
		LastActor = Owner;
		Velocity = Vector(Rotation) * Speed;
	}

	function Timer()
	{
		if ( SeekPawn == none )
			GetLitPawn(SeekPawn, 4096, Location);
		
		if ( SeekPawn != none )
			Velocity = VSize(Velocity) * (Normal( (SeekPawn.Location - Location) + (Normal(Velocity) * seekWeight[castingLevel]) ) );
	}
	
	function name GetRandomJoint( Actor Other )
	{
		local int numJoints;
		
		numJoints = Other.numJoints();
		if ( NumJoints > 0 )
		{
			return Other.JointName( Rand(numJoints) );
		} else {
			return 'root';
		}
	}

	function ProcessTouch(Actor Other, vector HitLocation)
	{
		local DamageInfo DInfo;
		local SimpleLightning bolt;
		local int i, NumJoints;

		// log ("Lightning Blast - ProcessTounh() Actor = "$Other, 'Misc');
		if ( Other.IsA('Pawn') && (Other != Owner) )
		{
			if ( Pawn(Other).Health > 0 )
			{
				if ( !Owner.IsA('AeonsPlayer'))
				{
					PlaySound(ChainSound,,1,,4096,1);
					for ( i=0; i<4; i++ )
					{
						Bolt = spawn (class 'SimpleLightning',Other,,Location);
						Bolt.DamageMult = DamageMult;
						Bolt.StartActor = Owner;
						Bolt.EndActor = Other;
						Bolt.StartJoint = GetRandomJoint(Owner);
						Bolt.EndJoint = GetRandomJoint(Other);
						Bolt.Lifespan = 1;
						Bolt.go();
					}
				}

				if( !Other.IsA('King_Part') )
				{				
					switch ( Charge )
					{
						case 0:
							spawn(class 'LightningGlowFX',Other,, Location);
							Destroy();
							break;
		
						case 1:
							spawn(class 'LightningGlowFX',Other,, Location);
							SpawnChain(Other);
							break;
	
						case 2:
							spawn(class 'LightningGlowFX',Other,, Location);
							SpawnChain(Other);
							break;
					}
				}

				DInfo = GetDamageInfo();
				DInfo.Damage *= DamageMult;
				DInfo.DamageType = 'Electrical';
				Other.ProjectileHit(Instigator, HitLocation, Velocity, self, DInfo);
			}
		} else {
			if (Other != Owner)
			{
				DInfo = GetDamageInfo();
				DInfo.Damage *= DamageMult;
				DInfo.DamageType = 'Electrical';
				Other.ProjectileHit(Instigator, HitLocation, Velocity, self, DInfo);
			}
		}
	}

	function Destroyed()
	{
		// Spawn(class 'LightningBlastExplosion',,,Location);
	}

	function SpawnChain(Actor Other)
	{
		local ScriptedPawn P;
		local Pawn Pawns[8];
		local int i, pCount;
		local LtngBlast_proj SP;
		local rotator r;
		
		//log ("Lightning Blast - SpawnChain() ", 'Misc');
		ForEach RadiusActors(class 'ScriptedPawn', P, ChainRange, Other.Location)
		{
			//log("considering Pawn "$P, 'Misc');
			if (P != Other)
			{
				if (P.Health > 0)
				{
					//log("Adding Pawn "$P$" to the list", 'Misc');
					Pawns[pCount] = P;
					pCount ++;
				}
			}

			if ( pCount == 8 )
				break;
		}
		
		if ( pCount > 0 )
		{
			// found a pawn
			SetOwner(Other);
			P = ScriptedPawn(Pawns[Rand(pCount)]);
			r = Rotator(Normal(P.Location - Other.Location));
			SP = Spawn(Class 'LtngBlast_proj', Owner,, Owner.Location, r);
			SP.Target = P;
			SP.StartLoc = Location;
			SP.DamageMult = DamageMult * 0.5;
			SP.CastingLevel = CastingLevel;
			SP.Charge = Charge - 1;
			Destroy();
		} else {
			Destroy();
		}
		Charge --;
	}

}

defaultproperties
{
     Range=1280
     ChainRange=384
     DamageMult=1
     ChainSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_LightningChain01'
     damagePerLevel(0)=40
     damagePerLevel(1)=40
     damagePerLevel(2)=60
     damagePerLevel(3)=80
     damagePerLevel(4)=80
     damagePerLevel(5)=100
     Speed=3000
     MaxSpeed=10000
     Damage=20
     bMagical=True
     LifeSpan=1
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Aeons.Particles.BallLightning'
     CollisionRadius=8
     CollisionHeight=8
}
