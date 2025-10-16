//=============================================================================
// Mindshatter_proj.
//=============================================================================
class Mindshatter_proj expands SpellProjectile;

//#exec Texture Import Name=Ring_pfx File=Ring_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Ring2_pfx File=Ring2_pfx.pcx Group=Particles Mips=OFF
//#exec Texture Import Name=Ring3_pfx File=Ring3_pfx.pcx Group=Particles Mips=OFF

var int numWarps;
var() int numDiscs;
var float discOffset, dist;
var vector spawnLocation;
var vector WarpIn[4], WarpOut[4];
var MindShatterScriptedFX mTrail;

var bool bIsNetReady;
var bool bExploded;

replication
{
	reliable if ( Role == ROLE_Authority )
		spawnLocation;

}

// Put in this state ONLY by the effect of DispelMagic spell effect.
function int Dispel(optional bool bCheck)
{
	if ( bCheck )
		return -1;

	// spawn (class 'DispelParticleFX',,,Location);
	// Destroy();
}


simulated function PreBeginPlay()
{
	super.PreBeginPlay();

	if ( Level.NetMode != NM_Client )
		spawnLocation = Location;
}

simulated function PostNetBeginPlay()
{
	bIsNetReady = true;
}

function Warped(vector oldLocation)
{
	if (numWarps < 3)
	{
		if ( numWarps == 0 )
			dist = VSize(spawnLocation - oldLocation);
		else
			dist += VSize(WarpOut[numWarps-1] - oldLocation);
		WarpIn[numWarps] = oldLocation;
		WarpOut[numWarps] = Location;
		numWarps ++;
	}
}

simulated function ProcessTouch (Actor Other, Vector HitLocation)
{
	local smokePuff smkPuff;
	local vector eyeHeight;

	if ( (Other != Owner) && (Role == ROLE_Authority) )
	{
//		if ( Role == ROLE_Authority )
//		{
			/*
			log("Mindshatter Height %: "$(HitLocation.Z - Other.Location.Z));
			log("Head region: "$(0.62 * Other.CollisionHeight));
			log("Within Head region: "$((HitLocation.Z - Other.Location.Z) > (0.62 * Other.CollisionHeight)));
			*/
	
			Other.ProjectileHit(Pawn(Owner), HitLocation, vect(0,0,0), self, GetDamageInfo());
			if ( Other.IsA('AeonsPlayer') ) // && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight) )
			{
				eyeHeight.z = AeonsPlayer(Other).Eyeheight;
				// log("Applying Mindshatter effect to AeonsPlayer: "$Other.name);
				AeonsPlayer(Other).MindshatterMod.castingLevel = castingLevel;
				// AeonsPlayer(Other).MindshatterMod.castingLevel = 3;
				AeonsPlayer(Other).MindshatterMod.gotoState('Activated');
				AeonsPlayer(Other).MindshatterMod.manaCost = manaCost;
				if (Other.RemoteRole == ROLE_AutonomousProxy)
					MindshatterModifier(AeonsPlayer(Other).MindshatterMod).ClientActivated(castingLevel);
				spawn(class 'MindshatterExplosionFX',,,Other.Location + Eyeheight, Rotator(Velocity));
				Other.ProjectileHit( Instigator, HitLocation, vect(0,0,0), self, GetDamageInfo() );
				//smkPuff = spawn(class 'SmokePuff',,,Location);
				//smkPuff.drawScale = 5;

				//if (RGC())
				//{
				//	if ( SlothModifier(AeonsPlayer(Other).SlothMod) != none )
				//		SlothModifier(AeonsPlayer(Other).SlothMod).Activate();
				//}
			} 
			else if ( Other.IsA('ScriptedPawn')) 
			{ // && (HitLocation.Z - Other.Location.Z > 0.62 * Other.CollisionHeight) ) {	// need joint based headshot detection here
				eyeHeight.z = ScriptedPawn(Other).Eyeheight;
				// log("Applying Mindshatter effect to ScriptedPawn: "$Other.name);
				if ( Other.AcceptDamage(getDamageInfo( 'mindshatter' )) )
				{
					ScriptedPawn(Other).TakeDamage( Instigator, HitLocation, vect(0,0,0), getDamageInfo( 'mindshatter' ) );
					Spawn(class 'MindshatterExplosionFX',,,Other.Location +Eyeheight, Rotator(Velocity));
				}
	//			ScriptedPawn(Other).TakeMindshatter( Instigator, castingLevel );
	//			ScriptedPawn(Other).MindshatterMod.castingLevel = castingLevel;
	//			ScriptedPawn(Other).MindshatterMod.gotoState('SPActivated');

				//smkPuff = spawn(class 'SmokePuff',,,Location);
				//smkPuff.drawScale = 5;
			} 
			else 
			{
				log("Applying Mindshatter effect to nothing: "$Other.name);
				//smkPuff = spawn(class 'SmokePuff',,,Location);
				//smkPuff.drawScale = 1;
			}

			PlaySound(MiscSound, SLOT_Misc, 2.0);
			Explode(HitLocation, vect(0,0,0));
			//log("Setting timer for delayed destroy");
			//SetTimer(5, false);
			//destroy();
//		}
	}
}

simulated function Timer()
{
	log("MindShatter_Proj: Timer: Destroying");
	Destroy();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local int i;
	local float tempDrawScale, pI, scalar, pDist;
	local vector loc, dir;
	local LightningPoint lt;
	
	if ( bExploded )
		return;
	
	bExploded = true;

	// log (""$self.name$" is Exploding", 'Misc');
	
	if (!bIsNetReady)
		log("Explode called before all variables transferred");

	if (numWarps == 0) dist = VSize(Hitlocation - spawnLocation);

	pi = 3.1415926535897932384626433832795;
	discOffset = (dist / float(numDiscs));
	mTrail = spawn(class 'MindShatterScriptedFX',,,HitLocation);
	dir = Normal(HitLocation - spawnLocation);

	if (numWarps == 0)
	{
		for (i=0; i<numDiscs; i++)
		{
			pDist = i/float(numdiscs);

			scalar = abs(pDist - 1);

			loc = spawnLocation + (dir * (i * discOffset));
			mTrail.addParticle(i, loc);

			mTrail.GetParticleParams(i,mTrail.Params);
			mTrail.Params.Position = loc;
			tempDrawScale = 0.8 + (cos(i) * 0.1); // + (-0.02 * i); 
			// tempDrawScale = cos(i*0.5) * scalar;
			FClamp(tempDrawScale, 0.5, 5);
			mTrail.Params.Width =  (32 * tempDrawScale) * scalar;
			mTrail.SetParticleParams(i, mTrail.Params);
			//mTrail.RecomputeDeltas(i);

/*
			tempDrawScale = 0.8 + (cos(i) * 0.1) + (-0.02 * i); 
			lt.drawScale = FClamp(tempDrawScale, 0.085, 2);
			lt.Style = STY_Translucent;
			lt.Texture = Texture'Ring3_pfx';
			lt.gotoState('Kill');
*/
		}
		// mTrail.Gravity = dir * ;
		mTrail.bUpdate = true;
		mtrail.Shutdown();
	} else {
		log("numWarps > 0");
		// dir = something else
	}
//	log("explode: calling destroy");
//	Destroy();
	SetTimer(5, false);
}

auto state Flying
{

	Begin:
		Velocity = Vector(Rotation) * speed;
}

defaultproperties
{
     numDiscs=128
     Speed=20000
     MaxSpeed=20000
     MyDamageType=Mindshatter
     MyDamageString="Mindshattered"
     bMagical=True
     DrawType=DT_None
}
