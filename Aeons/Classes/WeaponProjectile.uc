//=============================================================================
// WeaponProjectile.
//=============================================================================
class WeaponProjectile expands Projectile;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts

var(Projectile) sound FuseSound;
var(Projectile) sound ExplodeSound;
var() float HeadShotMult;		// damage multiplier if I score a head shot.
var bool bInWater;

simulated function PreBeginPlay()
{
	spawnLoc = Location;
	super.PreBeginPlay();
}

simulated function DamageInfo getDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;

	if (DamageType == 'none')
		DamageType = MyDamageType;

	DInfo.Damage = Damage;
	DInfo.DamageType = DamageType;
	DInfo.DamageString = MyDamageString;
	DInfo.bMagical = bMagical;
	DInfo.Deliverer = self;
	DInfo.ImpactForce = Normal(Velocity) * FClamp(VSize(Velocity), 0, 2048);
	DInfo.JointName = CheckJoint();
	DInfo.DamageMultiplier = 1;

	return DInfo;
}

simulated function name CheckJoint()
{
	local vector HitLocation, HitNormal;
	local int HitJoint, FirstHitJoint;
	local Actor A, FirstHitActor;
	local name FirstHitJointName;

	FirstHitActor = Trace(HitLocation, HitNormal, FirstHitJoint, Location, OldLocation, true, true);

	if (FirstHitActor != none)
	{
		FirstHitJointName = FirstHitActor.JointName(FirstHitJoint);

		// disable the first joint we hit and see if behind it is a headshot joint
		if (!CheckHeadShotJoint(FirstHitJointName))
		{
			// Disable collision on a limb or limb tree.
			// native(417) exec final function SetLimbTangible( name Joint, bool tangible, optional bool all );

			// do the trace again after disabling collision for the first hit joint
			FirstHitActor.SetLimbTangible(FirstHitJointName, false, false);
			A = Trace(HitLocation, HitNormal, HitJoint, Location + Normal(Location - OldLocation) * 16, OldLocation, true, true);
			FirstHitActor.SetLimbTangible(FirstHitJointName, true, false);

			if (A != none && HitJoint != -1 && CheckHeadShotJoint(A.JointName(HitJoint)))
			{
				return A.JointName(HitJoint);
			}
		}

		return FirstHitJointName;
	}
	return 'None';
}

simulated function bool CheckHeadShotJoint(name JointName)
{
	switch (JointName)
	{
		case 'Neck':
		case 'Head':
		case 'Hair1':
		case 'Hair2':
		case 'Hair3':
		case 'Hair4':
		case 'Hair5':
		case 'L_Ear':
		case 'R_Ear':
		case 'Jaw':
		case 'Mouth':
			return true;
	}
	return false;
}

/*
simulated function bool CheckHeadShot()
{
	local vector Start, End, HitLocation, HitNormal, Dir;
	local int HitJoint;
	local Actor A;
	local name JointName;
	
	Dir = Normal(Velocity);
	
	Start = Location - (Dir * 64);
	End = Location + Dir * 64;
	
	A = Trace(HitLocation, HitNormal, HitJoint, End, Start, true, true);

	if (A != none)
	{
		JointName = A.JointName(HitJoint);
		//log("................................Bullet Hit Joint Name: "$JointName);
		switch ( JointName )
		{
			case 'Hair1':
			case 'Hair2':
			case 'Hair3':
			case 'Spine3':
			case 'head':
			case 'neck':
			case 'R_Ear1':
			case 'R_Ear2':
			case 'R_Ear3':
			case 'L_Ear1':
			case 'L_Ear2':
			case 'L_Ear3':
			case 'Jaw':
			case 'Mouth':
				return true;
			default:
				return false;
		}; 
	} else {
		//log("................................No Actor Traced");
		return false;
	}
}
*/

simulated function genBubbles(vector start, vector dir)
{
	local vector p;
	local int i, myZoneID;
	local BubbleScriptedFX bubbles;
	local float inv;

	myZoneID = level.getZone(start);
	Bubbles = spawn(class 'BubbleScriptedFX',,,Start);
	
	inv = 1.0 / 64;
	for (i=0; i<64; i++)
	{
		p = start + dir * (16 * i);
		if (Level.getZone(p) != myZoneID)
			break;	// Location is not in water... don't create a bubble

		p += VRand() * 16 * (i * inv);
		Bubbles.addParticle( i, p );

		Bubbles.getParticleParams(i,bubbles.p);
		Bubbles.p.width = FRand() * 3.0 * (i/64.0);
		Bubbles.p.length = FRand() * 3.0 * (i/64.0);
		Bubbles.setParticleParams(i,bubbles.p);
	}
	Bubbles.Shutdown();
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

function ZoneChange( ZoneInfo NewZone )
{
	if ( NewZone.bWaterZone )
	{
		// if we're already underwater, don't create another splash
		if ( !bInWater )
			spawn(class 'WaterBigHitFX',,,Location, rotator(vect(0,0,1)));

		bInWater = true;
	} 
	else 
	{
		bInWater = false;
	}
}

defaultproperties
{
     HeadShotMult=3
     GlassStrikeDecal=Class'Aeons.GlassHitDecal'
}
