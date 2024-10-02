//=============================================================================
// LightningBolt.
//=============================================================================
class LightningBolt expands Effects;

struct Pulse
{
	var float 	Index;			// Current index of the pulse
	var vector	Dir;			// Directional force of the pulse
	var float	Speed;			// Speed of the pulse - how long does it take to traverse the entire shaft length?
	var float 	Scale;			// Scale at the location of the pulse.
	var float	Width;
	var int		KnotsPerSec;	// number of knots this pulse moves down the shaft per second
	var bool	bInUse;
};

var() struct SurfType {
	var() class<ParticleFX> FX_Default;
	var() class<ParticleFX> FX_Glass;
	var() class<ParticleFX> FX_Water;
	var() class<ParticleFX> FX_Leaves;
	var() class<ParticleFX> FX_Snow;
	var() class<ParticleFX> FX_Grass;
	var() class<ParticleFX> FX_Organic;
	var() class<ParticleFX> FX_Carpet;
	var() class<ParticleFX> FX_Earth;
	var() class<ParticleFX> FX_Sand;
	var() class<ParticleFX> FX_Wood;
	var() class<ParticleFX> FX_Stone;
	var() class<ParticleFX> FX_Metal;

	var() class<Decal> D_Default;
	var() class<Decal> D_Glass;
	var() class<Decal> D_Water;
	var() class<Decal> D_Leaves;
	var() class<Decal> D_Snow;
	var() class<Decal> D_Grass;
	var() class<Decal> D_Organic;
	var() class<Decal> D_Carpet;
var() class<Decal> D_Earth;
	var() class<Decal> D_Sand;
	var() class<Decal> D_Wood;
	var() class<Decal> D_Stone;
	var() class<Decal> D_Metal;

} FXSurfType;

var int i, numKnots, sndID;
var int		pointCount;			// counter for what point I'm on
var float 	segmentLen, Len, chaos, str;	// Length of a single segment, length of the Lightning Bolt
var float MajChangeX, MajChangeY, MajChangeZ, MinChangeX, MinChangeY, MinChangeZ, timeDampening;
var vector 	points[16];			// Array of points for the lightning
var vector	lastPos, lastDir, spawnPos, lastRand, iRand, lastView, lag, lastStrike;
var place	HandPlace;
var vector End, Start;

var LightningPoint lp, lPoints[32];
var Pawn 		PawnOwner;
var(Display) class<LightningScriptedFX> ShaftClass;
var LightningScriptedFX Shaft;
var ParticleFX pFX, sFX;		// Particle FX and smoke FX
var Decal MetalDecal;
var Decal D;
var bool bWaterStrike;
var() int DamagePerSec;

var vector deltas[32];

var() sound HoldSounds[3];
var() float Range[5];			// Distance you can fire the lightning - per amplitude
var() float MinPtDist;			// Minimmum distance from one point to the next.
var() float ArcPct;				// Percentage of the length of the lightning that will arc
var() bool bCausesDamage;
var() bool bTraceActors;
var LightningLight lts[4];		// Dynamic lights for the lightning shaft
var float DmgTime, DmgRem;		// 

replication
{
	reliable if (Role == ROLE_Authority && bNetInitial)
		Start, End;
}

// ===========================================================================
// function Init();
function Init( float Seconds, vector StartPoint, vector EndPoint );

simulated function PreBeginPlay()
{
	DmgTime = 1.0 / float(DamagePerSec);
	numKnots = 32;
	if (Pawn(Owner) != none)
	{
		PawnOwner = Pawn(Owner);
	} else {
		PawnOwner = none;
	}
	chaos = 0.6;
	Super.PreBeginPlay();
}

simulated function UpdateMetalDecal(vector Loc, vector n)
{
	if (MetalDecal != none)
	{
		MetalDecal.SetNewLocation(Loc, N);
	} else {
		MetalDecal = Spawn(class 'LightningMetalDecal',,,Loc,Rotator(n));
	}
}

simulated function ChangePFX(class<ParticleFX> pClass, vector Loc, vector N, optional Texture HitTexture)
{
	local vector spawnLocation;

	if ( pClass != none )
	{
		if (pFX.class.name != pClass.name)
		{
			spawnLocation = pFX.Location;
			pFX.Shutdown();
			pFX = spawn(pClass,,,SpawnLocation, Rotator(N));
			if (HitTexture != none)
				pFX.ColorStart.Base = HitTexture.MipZero;
		} else {
			if (HitTexture != none)
				pFX.ColorStart.Base = HitTexture.MipZero;
		}
	}
}

simulated function UpdateStrikeFX(Texture HitTexture, vector Loc, vector N)
{
	local int i;

	if ( pFX != none )
	{
		switch( HitTexture.ImpactID )
		{
			case TID_Glass:
				ChangePFX(FXSurfType.FX_Glass, Loc, N, HitTexture);
				if (sFX != none)
				{
					sFX.Shutdown();
					sFX = none;
				}
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Water:
				ChangePFX(FXSurfType.FX_Water, Loc, N, HitTexture);
				if (sFX != none)
				{
					sFX.Shutdown();
					sFX = none;
				}
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Leaves:
				ChangePFX(FXSurfType.FX_Leaves, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Leaves,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX == none) sFX = spawn(class 'LightningSmokeFX',,,Loc, Rotator(N));
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Snow:
				ChangePFX(FXSurfType.FX_Snow, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Snow,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX == none) sFX = spawn(class 'LightningSmokeFX',,,Loc, Rotator(N));
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Grass:
				ChangePFX(FXSurfType.FX_Grass, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Grass,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX == none) sFX = spawn(class 'LightningSmokeFX',,,Loc, Rotator(N));
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Organic:
				ChangePFX(FXSurfType.FX_Organic, Loc, N, HitTexture);
				if (sFX == none) sFX = spawn(class 'LightningSmokeFX',,,Loc, Rotator(N));
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Carpet:
				ChangePFX(FXSurfType.FX_Carpet, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Carpet,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX == none) sFX = spawn(class 'LightningSmokeFX',,,Loc, Rotator(N));
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Earth:
				ChangePFX(FXSurfType.FX_Earth, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Earth,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX == none) sFX = spawn(class 'LightningSmokeFX',,,Loc, Rotator(N));
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Sand:
				ChangePFX(FXSurfType.FX_Sand, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Sand,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				sFX.Shutdown();
				sFX = none;
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Metal:
				ChangePFX(FXSurfType.FX_Metal, Loc, N, HitTexture);
				UpdateMetalDecal(Loc, N);
				D = Spawn(FXSurfType.D_Metal,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX != none)
				{
					sFX.Shutdown();
					sFX = none;
				}
				break;

			case TID_WoodHollow:
			case TID_WoodSolid:
				ChangePFX(FXSurfType.FX_Wood, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Wood,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX == none) sFX = spawn(class 'LightningSmokeFX',,,Loc, Rotator(N));
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Stone:
				ChangePFX(FXSurfType.FX_Stone, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Stone,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX != none)
				{
					sFX.Shutdown();
					sFX = none;
				}
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			default:
				ChangePFX(FXSurfType.FX_Default, Loc, N, HitTexture);
				D = Spawn(FXSurfType.D_Default,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX != none)
				{
					sFX.Shutdown();
					sFX = none;
				}
				if (MetalDecal != none) MetalDecal.Destroy();
				break;
		};

		if (sFX != none)
		{
			sFX.SetLocation(Loc);
			sFX.SetRotation(Rotator(N));
		}

		pFX.SetLocation(Loc);
		pFX.SetRotation(Rotator(N));
	} else {
		switch( HitTexture.ImpactID )
		{
			case TID_WoodHollow:
			case TID_WoodSolid:
				pFX = spawn(FXSurfType.FX_Wood,,,Loc, Rotator(N));
				break;

			case TID_Stone:
				pFX = spawn(FXSurfType.FX_Stone,,,Loc, Rotator(N));
				break;

			default:
				pFX = spawn(FXSurfType.FX_Default,,,Loc, Rotator(N));
				break;
		};
	}
}

simulated function Strike(vector Start, vector End)
{
	local int i, numPoints;
	local vector loc;
	local float scalar;
	
	// zero the deltas
	for (i=0; i<32; i++)
		deltas[i] = vect(0,0,0);

	setLocation(start);
	setRotation( Rotator(End - Start) );
	shaft = spawn( ShaftClass, Owner,, Start );

	len = VSize(end-start) / float(numKnots);

	if ( len < MinPtDist )
	{
		len = MinPtDist;
		numPoints = VSize(end-start) / minPtDist;
	} else {
		numPoints = 32;
	}

	for (i=0; i<32; i++)
	{
		deltas[i] = VRand() * i;
		if (i < numPoints)
		{
			scalar = VSize(end-start); // / Range[LocalCastingLevel];
			loc = start + Normal(end-start) * (len * i);
			loc += deltas[i] * scalar;
			Shaft.AddParticle(i,loc);
		} else {
			Shaft.AddParticle(i,loc);
		}
	}
	shaft.bUpdate = true;

	for (i=0; i<4; i++)
	{
		lts[i] = spawn( class 'LightningLight',,,(start + (end-start) * 0.25 * i) );
	}
}

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	DInfo.Damage = 1;
	DInfo.DamageMultiplier = 1.0;
	DInfo.DamageType = DamageType;
	return DInfo;	
}

simulated function bool IsWaterZone(vector loc)
{
	local int id;
	local ZoneInfo Z;
	
	id = Level.GetZone(Loc);
	
	ForEach AllActors(class 'ZoneInfo', Z)
	{
		if (Z.bWaterZone && (Level.GetZone(Z.Location) == id))
			return true;
	}
}

simulated function vector GetZoneChangeLoc(vector Start, vector End, float Resolution )
{
	local vector iVec, Dir, ZLoc;		// our temp test vector location
	local int NumIncrements, i, InitialID;
	local float Dist;
	
	Dir = Normal(Start-End);			// direction from start to end
	Dist = VSize(Start-End);			// distance from start to end
	InitialID = Level.GetZone(End);		// ID to test against
	NumIncrements = Dist / Resolution;	// number of increments I need

	for (i=0; i<NumIncrements; i++)
	{
		iVec = End + (Dir * (i*Resolution));
		if (Level.GetZone(iVec) != InitialID)
		{
			ZLoc = iVec;
			break;
		}
	}
	return ZLoc;
}

////////////////////////////////////////////////////////////////////////////////////////
simulated function updateShaft(float DeltaTime, vector Start, vector End, float Chaos, float Width)
{
	local int i, HitJoint, Flags, numPoints, hp, TotalAmplitude;
	local float scalar, RScale;
	local vector loc, HitLocation, HitNormal, X, Y, Z, LastPoint, ld, td, LastY, LastZ, WaterSurface;
	local Actor A;
	local Texture HitTexture;
	local DamageInfo Di;

	HitTexture = none;
	if ( shaft != none )
	{
		A = Trace(HitLocation,HitNormal,HitJoint, End, Start, bTraceActors);
		
		if ( HitLocation != vect(0,0,0) )
			End = HitLocation;

		if ( IsWaterZone(end) )
		{
			bWaterStrike = true;
			WaterSurface = GetZoneChangeLoc(Start, End, 2);
			if ( WaterSurface != vect(0,0,0) )
			{
				End = WaterSurface;
			}
		} else {
			bWaterStrike = false;
		}
		
		len = VSize(end-start) / float(numKnots);
		HitTexture = TraceTexture(end + (Normal(end-start) * 2), start, Flags);

		// update Lights
		for (i=0; i<4; i++)
			lts[i].SetLocation(start + (end-start) * 0.25 * i);

		if ( len < MinPtDist )
		{
			len = MinPtDist;
			numPoints = VSize(end-start) / minPtDist;
		} else {
			numPoints = 32;
		}

		LastPoint = Start;

		Shaft.GetParticleParams(0,Shaft.Params);
		Shaft.Params.Position = LastPoint;
		Shaft.Params.Width = 2;
		Shaft.SetParticleParams(0, Shaft.Params);

		for (i=1; i<32; i++)
		{
			if ( i < numPoints )
			{
				RScale = float(i)/float(numpoints);

				Len = VSize(End - LastPoint) / (NumPoints-i);

				LastY = Normal( Y * 0.5 + LastY ) * RandRange(-2-(Chaos * 1.25), 2 + (Chaos * 1.25));
				LastZ = Normal( Z * 0.5 + LastZ ) * RandRange(-2-(Chaos * 1.25), 2 + (Chaos * 1.25));

				Deltas[i] = (Deltas[i] * 0.25) +  (LastY + LastZ);

				Loc = LastPoint + (Normal(end-LastPoint) * len);
				Loc += VRand() * RandRange(2.0,4.0);
				
				// log("Delats[i] = "$Deltas[i], 'Spell');

				// Loc = LastPoint + (Normal(end-LastPoint) * len);
				// Loc += deltas[i];

				Shaft.GetParticleParams(i,Shaft.Params);
				Shaft.Params.Position = Loc;
				Shaft.Params.Width = (width + 2) * (1+ (i/float(numPoints)));
				Shaft.SetParticleParams(i, Shaft.Params);
				LastPoint = Loc;
			} else {
				Shaft.GetParticleParams(i,Shaft.Params);
				Shaft.Params.Position = LastPoint;
				Shaft.Params.Width = 0;
				Shaft.SetParticleParams(i, Shaft.Params);
			}
		}

		if( (A != none) && (A != Owner) )
		{
			if (DmgRem > DmgTime)
			{
				if (bCausesDamage)
				{
					hp = DmgRem / DmgTime;
					DmgRem -= hp * DmgTime;
					Di = GetDamageInfo('Electrical');
					Di.Damage = hp;
					if ( A.AcceptDamage(Di) )
						A.TakeDamage(PawnOwner, HitLocation, vect(0,0,0), Di);
					if ( Pawn(A) != none )
					{
						Pawn(A).PlayDamageMethodImpact('Bullet', HitLocation, -Vector(Pawn(Owner).ViewRotation));
						spawn(class 'BloodPuffFX',,,end);
					}
				}
			} else {
				DmgRem += deltaTime;
			}
		} else {
			DmgRem = 0;
		}

		if ( HitTexture != none )
		{
			UpdateStrikeFX(HitTexture, end, HitNormal);
		} else {
			if (bWaterStrike)
			{
				ChangePFX(FXSurfType.FX_Water, End, vect(0,0,1));
				if (sFX != none)
				{
					sFX.Shutdown();
					sFX = none;
				}
				pFX.SetLocation(End);
				pFX.SetRotation(Rotator(vect(0,0,1)));
				if ( bCausesDamage )
				{
					ForEach RadiusActors(class 'Actor',A, 256, End)
					{
						Di = GetDamageInfo();
						if ((A.Region.Zone.bWaterZone) && A.AcceptDamage(Di))
							A.TakeDamage(Pawn(Owner), End, vect(0,0,0), Di);
					}
				}
			} else if (pFX != none) {
				pFX.Shutdown();
				pFX = none;
			}
		}

		LastStrike = end;
	} else {
		log("..................Lightning:UpdateShaft:No Shaft!");
	}
}

auto simulated state Holding
{
	simulated function Tick(float DeltaTime)
	{
		local vector x, y, z;
		
		GetAxes(Owner.Rotation, x, y, z);
		
		LastRand = vRand();
		Shaft.setLocation(Owner.Location);
		Shaft.setRotation(Owner.Rotation);
		UpdateShaft(DeltaTime, Owner.Location, Owner.Location + (x*512) , 10, 4);
	}
	
	simulated function Timer()
	{
		gotoState('Release');
	}

	Begin:
		setTimer(5, false);
		start = Owner.Location;
		end = Owner.Location;
		Strike(start, End);
		// sndID = PlaySound(HoldSounds[Rand(3)]);
		timeDampening = 3.0;
		
	End:
}

////////////////////////////////////////////////////////////////////////////////////////
simulated function CleanUp()
{
	local int i;

	for( i=0; i<4; ++i )
		lts[i].Destroy();

	StopSound(sndID);
	Shaft.Destroy();
	Shaft = none;

	if (MetalDecal != none)
	{
		MetalDecal.Destroy();
	}
	if (sFX != none)
	{
		sFX.Shutdown();
		sFX = none;
	}

	if (pFX != none)
	{
		pFX.Shutdown();
		pFX = none;
	}
}

simulated function Destroyed()
{
	CleanUp();
}

simulated state Release
{
Begin:
	CleanUp();
}

defaultproperties
{
     FXSurfType=(FX_Default=Class'Aeons.LightningHitFX',FX_Glass=Class'Aeons.LightningHitFX',FX_Water=Class'Aeons.WaterLightningHitFX',FX_Leaves=Class'Aeons.LightningHitFX',FX_Snow=Class'Aeons.SnowLightningHitFX',FX_Grass=Class'Aeons.DirtLightningHitFX',FX_Organic=Class'Aeons.BloodLightningHitFX',FX_Carpet=Class'Aeons.LightningHitFX',FX_Earth=Class'Aeons.DirtLightningHitFX',FX_Sand=Class'Aeons.SandLightningHitFX',FX_Wood=Class'Aeons.LightningHitWoodFX',FX_Stone=Class'Aeons.StoneLightningHitFX',FX_Metal=Class'Aeons.MetalLightningHitFX',D_Default=Class'Aeons.LightningDecal',D_Glass=Class'Aeons.LightningDecal',D_Leaves=Class'Aeons.LightningDecal',D_Snow=Class'Aeons.LightningDecal',D_Grass=Class'Aeons.LightningDecal',D_Carpet=Class'Aeons.LightningDecal',D_Earth=Class'Aeons.LightningDecal',D_Sand=Class'Aeons.LightningDecal',D_Wood=Class'Aeons.LightningDecal',D_Stone=Class'Aeons.LightningDecal',D_Metal=Class'Aeons.LightningDecalMetal')
     ShaftClass=Class'Aeons.LightningScriptedFX'
     DamagePerSec=30
     MinPtDist=16
     ArcPct=0.25
     bCausesDamage=True
     bTraceActors=True
     bCollideActors=True
     bCollideWorld=True
     RemoteRole=ROLE_SimulatedProxy
}
