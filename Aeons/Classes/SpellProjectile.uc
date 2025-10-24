//=============================================================================
// SpellProjectile.
//=============================================================================
class SpellProjectile expands Projectile;

// Import some shared assets here.
//#exec Texture Import Name=sphereOfCold_projTex File=..\SphereOfCold_proj\SphereOfCold_proj.pcx Group=Trails Mips=On

var 	int 	castingLevel;	// Casting level used by all spell projectiles
var		int		manaCost;		// Cost incurred to cast this projectile
var		bool	bCanHitInstigator, bInWater;
var		float	seekWeight[6];	// seek weights for firefly interaction
var()	int		DamagePerLevel[6];
var()	int		AltDamagePerLevel[6];

/*
function PreBeginPlay()
{
	seekWeight[0] = 0;
	seekWeight[1] = 0.15;
	seekWeight[2] = 0.30;
	seekWeight[3] = 0.30;
	seekWeight[4] = 0.60;
	seekWeight[5] = 0.60;
}
*/

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	if ( Role == ROLE_Authority )
	{
		if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			if ( Wall.AcceptDamage(GetDamageInfo()) )
				Wall.TakeDamage( instigator, Location, MomentumTransfer * Normal(Velocity), getDamageInfo());
		MakeNoise(1.0);
	}
	PlaySound(ProjImpactSound, SLOT_None, 1);
	Explode(Location + ExploWallOut * HitNormal, HitNormal);
	// Paste a decal on the wall.
	WallDecal(Location, HitNormal);
}

////////////////////////////////////////////
// Function: GetLitPawn
// returns the closest Lit pawn
////////////////////////////////////////////

simulated function Pawn getLitPawn(out pawn p, optional float Radius, optional vector Loc)
{
	local Pawn tPawn;
	local float len, tLen;

	len = 4096; // big len
	
	forEach VisibleActors(class'Pawn',tPawn, Radius, Loc)
	{
		if ( tPawn.bIsLit && (tPawn.Health > 0) )
		{
			// Lit Pawn
			tLen = VSize(Location - tPawn.Location);
			if ( tLen < len )
			{
				len = tLen;
				p = tPawn;
			}
		}
	}
	return p;
}

////////////////////////////////////////////
// Function: GetClosePawn
// returns the closest pawn, not the player
////////////////////////////////////////////

simulated function Pawn getClosePawn(out pawn p, optional float Radius, optional vector Loc)
{
	local 	Pawn 		tPawn; // temp pawn
	local 	float 		len, tLen; // length and temp length

	len = 4096; // big len
	
	forEach VisibleActors(class'Pawn',tPawn, Radius, Loc)
	{
		if ( (tPawn != Pawn(Owner)) && (!tPawn.bIsLit) ) // not the player and not lit up
		{
			tLen = VSize(Location - tPawn.Location);
			if ( tLen < len )
			{
				len = tLen;
				p = tPawn;
			}
		} else {
			// log("Found Player");
		}
	}
	return p;
}


// Put in this state ONLY by the effect of DispelMagic spell effect.
simulated function int Dispel(optional bool bCheck)
{
	if ( bCheck )
		return CastingLevel;

	spawn (class 'DispelParticleFX',,,Location);
	Destroy();
	return 0;
}

simulated function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if ( DamageType == 'none' )
		DamageType = MyDamageType;

	DInfo.Damage = DamagePerLevel[castingLevel];
	DInfo.DamageType = DamageType;
	DInfo.DamageString = MyDamageString;
	DInfo.bMagical = bMagical;
	DInfo.Deliverer = self;
	DInfo.ManaCost = ManaCost;
	DInfo.JointName = CheckJoint();
	DInfo.DamageMultiplier = 1.0;
	return DInfo;

}

simulated function name CheckJoint()
{
	local vector HitLocation, HitNormal, Dir;
	local int HitJoint;
	local Actor A;
	local name JointName;
	
	Dir = Normal(Velocity);
	
	A = Trace(HitLocation, HitNormal, HitJoint, Location, OldLocation, true, true);

	if (A != none)
		return A.JointName(HitJoint);

	return 'None';
}

simulated function genBubbles(vector start, vector dir)
{
	local vector p;
	local int i, myZoneID;
	local BubbleScriptedFX bubbles;
	
	myZoneID = level.getZone(start);
	bubbles = spawn(class 'BubbleScriptedFX',,,Start);
	
	for (i=0; i<64; i++)
	{
		p = start + dir * (16 * i);
		if (Level.getZone(p) != myZoneID)
			break;	// Location is not in water... don't create a bubble

		p += VRand() * 4 * (i/64.0);
		bubbles.addParticle( i, p );

		bubbles.getParticleParams(i,bubbles.p);
		bubbles.p.width = 8.0 * (0.1 + (i/64.0 * 0.9));
		bubbles.setParticleParams(i,bubbles.p);
	}
	bubbles.Shutdown();
}

simulated function bool CheckGenBubbles()
{
	local int myZoneID;
	local ZoneInfo zi;
	
	myZoneID = Level.getZone(Location);

	forEach AllActors(class 'ZoneInfo', zi)
	{
		if ( (zi.bWaterZone) && (Level.getZone(zi.Location) == myZoneID) )
		{
			genBubbles(location, -Normal(Velocity));
			return true;
		}
	}
	return false;
}

simulated function ZoneChange( ZoneInfo NewZone )
{
	if ( NewZone.bWaterZone )
	{
		bInWater = true;
		spawn(class 'WaterBigHitFX',,,Location, rotator(vect(0,0,1)));
	} else {
		bInWater = false;
	}
}

defaultproperties
{
     seekWeight(1)=0.15
     seekWeight(2)=0.3
     seekWeight(3)=0.6
     seekWeight(4)=0.6
     seekWeight(5)=0.6
}
