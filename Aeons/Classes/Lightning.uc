//=============================================================================
// Lightning.
//=============================================================================
class Lightning expands AttSpell;

// ============================================================================
// Sounds
#exec AUDIO IMPORT FILE="E_Spl_LightningStart01.wav" NAME="E_Spl_LightningStart01" GROUP="Spells"
#exec AUDIO IMPORT FILE="E_Spl_LightningSustain01.wav" NAME="E_Spl_LightningSustain01" GROUP="Spells"
#exec AUDIO IMPORT FILE="E_Spl_LightningSustain02.wav" NAME="E_Spl_LightningSustain02" GROUP="Spells"
#exec AUDIO IMPORT FILE="E_Spl_LightningSustain03.wav" NAME="E_Spl_LightningSustain03" GROUP="Spells"
// ============================================================================

simulated function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
	local Vector X,Y,Z, HitLocation, Start;
	local rotator Dir;
	local Ectoplasm_proj ecto;
	local LtngBlast_proj SP;

	AeonsPlayer(Owner).MakePlayerNoise(1.0);
	// Pawn(Owner).eyeTrace(HitLocation,, 4096,true);
	if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
	Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;
	Dir = Rotator(Normal(PlayerPawn(Owner).EyeTraceLoc - Start));

	SP = Spawn(Class 'LtngBlast_proj', PlayerPawn(Owner),, Start, Dir);
	// SP.Range = InitialStrikeRange;
	SP.CastingLevel = LocalCastingLevel;
	SP.StartLoc = Start;
	Switch( LocalCastingLevel)
	{
		case 0:
			SP.Charge = 0;
			break;

		case 1:
			SP.Charge = 1;
			break;

		case 2:
			SP.Charge = 1;
			break;

		case 3:
			SP.Charge = 1;
			break;

		case 4:
			SP.Charge = 2;
			break;

		case 5:
			SP.Charge = 2;
			break;
	
	}
	GameStateModifier(AeonsPlayer(Owner).GameStateMod).fLightning = 1.0;
	// SP.Velocity = SP.Speed * vector(Dir);
}

function ChargeSpear()
{
	Speargun(PlayerPawn(Owner).Weapon).Charge();
}

function FireAttSpell( float Value )
{
	local bool bPCL;
	
	bPCL = ProcessCastingLevel();
	
	PawnOwner = Pawn(Owner);

    if ( PawnOwner.HeadRegion.Zone.bWaterZone && !bWaterFire)
	{
		PlayFireEmpty(); //perhaps a fizzle sound
    } else if ( !bSpellUp && bPCL) {
		BringUp();
	} else {
		SayMagicWords();

		if ( bPCL && !AeonsPlayer(Owner).bDispelActive )
		{
			if ( PlayerPawn(Owner).Weapon.IsA('Speargun') )
			{
				if ( !Speargun(PlayerPawn(Owner).Weapon).bCharged ){}
					if ( PawnOwner.useMana(50) )
						ChargeSpear();
			} else if ( PawnOwner.useMana(manaCostPerLevel[localCastingLevel]) ) {
				PlayFiring();
				// gotoState('NormalFire');
				if ( Owner.bHidden )
					CheckVisibility();
			} else {
				FailedSpellCast();
				GotoState('Idle');
			}
		}
	}
}

state NormalFire
{
	ignores FireAttSpell;
	
	Begin:
		ProjectileFire(ProjectileClass, 8000, false, true);
		FinishAnim();
		PlayAnim('Down');
		sleep(RefireRate);
		Finish();
}

/*

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

var LightningPoint lp, lPoints[32];
var Pawn 		PawnOwner;
var PlayerPawn 	PlayerPawnOwner;
var LightningScriptedFX Shaft;
var ParticleFX pFX, sFX;		// Particle FX and smoke FX
var Decal MetalDecal;
var Decal D;
var bool bWaterStrike;

var vector deltas[32];

var() sound HoldSounds[3];
var() float Range[6];			// Distance you can fire the lightning - per amplitude
var() float MinPtDist;			// Minimmum distance from one point to the next.
var() float ArcPct;				// Percentage of the length of the lightning that will arc
var LightningLight lts[4];		// Dynamic lights for the lightning shaft
var float DmgTime, DmgRem;		// 
var Pawn LitPawn;				// Pawn that is lit by the firefly spell

// ===========================================================================
function PreBeginPlay()
{
	numKnots = 32;
	PawnOwner = Pawn(Owner);
	PlayerPawnOwner = PlayerPawn(Owner);
	chaos = 0.6;
	Super.PreBeginPlay();
}

// look for lit pawns within my strike radius
// and find the closest one to me that is lit
function GetLitPawn()
{
	local Pawn P;
	local float MinDist, TempDist;

	MinDist = Range[LocalCastingLevel] * 2;

	LitPawn = none;

	ForEach RadiusActors(class 'Pawn', P, Range[LocalCastingLevel])
	{
		if ( P.bIsLit && (P.Health > 0) )
		{
			TempDist = VSize(Owner.Location - P.Location);
			if (TempDist < MinDist)
				LitPawn = P;
		}
	}
}


function StartStrike()
{
	local vector end;
	local place fingerPlace;

	DmgTime = 1.0 / DamagePerLevel[localCastingLevel];
	if (pfx != none)
	{
		pFX.Destroy();
		pFX = none;
	}
	fingerPlace = JointPlace('Mid_base');
	// PawnOwner.EyeTrace(End,,,true);
	PawnOwner.EyeTrace(End,,Range[LocalCastingLevel],false);
	Strike(FingerPlace.pos + Vector(PlayerPawn(Owner).ViewRotation) * PlayerPawn(Owner).CollisionRadius, End);
}

function FireSpell()
{
	// are we holding a speargun?
	if (PlayerPawn(Owner).Weapon.IsA('Speargun'))
	{
		// is the speargun charged?
		if ( !Speargun(PlayerPawn(Owner).Weapon).bCharged ){}
			if ( PawnOwner.useMana(50) )
				Speargun(PlayerPawn(Owner).Weapon).Charge();
		else
			// normal lightning behavior
			StartStrike();
	} else
		// normal lightning behavior
		StartStrike();

	// Activate Actuator
	PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_HardShake, 100000.0f);
}

function UpdateMetalDecal(vector Loc, vector n)
{
	if (MetalDecal != none)
	{
		MetalDecal.SetNewLocation(Loc, N);
	} else {
		MetalDecal = Spawn(class 'LightningMetalDecal',,,Loc,Rotator(n));
	}
}

function ChangePFX(class<ParticleFX> pClass, vector Loc, vector N, optional Texture HitTexture)
{
	local vector spawnLocation;

	if ( (pClass != none) && (pfx != none))
	{
		if (pFX.class.name != pClass.name)
		{
			spawnLocation = pFX.Location;
			pFX.bShuttingDown = true;
			pFX = spawn(pClass,,,SpawnLocation, Rotator(N));
			if (HitTexture != none)
				pFX.ColorStart.Base = HitTexture.MipZero;
		} else {
			if (HitTexture != none)
				pFX.ColorStart.Base = HitTexture.MipZero;
		}
	}
}

function UpdateStrikeFX(Texture HitTexture, vector Loc, vector N)
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
					sFX.bShuttingDown = true;
					sFX = none;
				}
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Water:
				ChangePFX(FXSurfType.FX_Water, Loc, N, HitTexture);
				if (sFX != none)
				{
					sFX.bShuttingDown = true;
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
				if (sfx != none)
				{
					sFX.bShuttingDown = true;
					sFX = none;
				}
				if (MetalDecal != none) MetalDecal.Destroy();
				break;

			case TID_Metal:
				ChangePFX(FXSurfType.FX_Metal, Loc, N, HitTexture);
				UpdateMetalDecal(Loc, N);
				D = Spawn(FXSurfType.D_Metal,,,loc,rotator(N));
				D.AttachToSurface(Normal(loc - LastStrike));
				if (sFX != none)
				{
					sFX.bShuttingDown = true;
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
					sFX.bShuttingDown = true;
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
					sFX.bShuttingDown = true;
					sFX = none;
				}
				if (MetalDecal != none) MetalDecal.Destroy();
				break;
		};

		if ( sFX != none )
		{
			sFX.SetLocation(Loc);
			sFX.SetRotation(Rotator(N));
		}

		if (pfx != none)
		{
			pFX.SetLocation(Loc);
			pFX.SetRotation(Rotator(N));
		}
	} else {
		switch ( HitTexture.ImpactID )
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

function Strike(vector Start, vector End)
{
	local int i, numPoints;
	local vector loc;
	local float scalar;
	
	// zero the deltas
	for (i=0; i<32; i++)
		deltas[i] = vect(0,0,0);

	setLocation(start);
	setRotation( Rotator(End - Start) );
	if (shaft != none)
		shaft.Destroy();
	shaft = spawn(class 'LightningScriptedFX',PlayerPawn(Owner),,Start);

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
			scalar = VSize(end-start) / Range[LocalCastingLevel];
			loc = start + Normal(end-start) * (len * i);
			loc += deltas[i] * scalar;
			Shaft.AddParticle(i,loc);
		} else {
			Shaft.AddParticle(i,loc);
		}
	}
	shaft.bUpdate = true;

	for (i=0; i<8; i++)
	{
		if ( lts[i] != none )
			lts[i].Destroy();
		lts[i] = spawn( class 'LightningLight',,,(start + (end-start) * 0.25 * i) );
	}
}

function vector getStartLoc()
{
	local Vector Start, X, Y, Z, FireLocation, HitLocation, StartLoc;

	GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
	StartLoc = Owner.Location + CalcDrawOffset(); 
	FireLocation = StartLoc + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
	return FireLocation;
}

////////////////////////////////////////////////////////////////////////////////////////
state NormalFire
{
	ignores FireAttSpell;

	Begin:
		if ( pFX != none )
			pFX.Destroy();
		PlayAnim('Lightning_start');
		PlaySound(FireSound);
		FinishAnim();
		FireSpell();
		GotoState('Holding');
}

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	DInfo.Damage = 1;
	DInfo.DamageMultiplier = 1.0;
	DInfo.DamageType = DamageType;
	return DInfo;	
}

function bool IsWaterZone(vector loc)
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

function vector GetZoneChangeLoc(vector Start, vector End, float Resolution )
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
state Holding
{
	ignores FireAttSpell;

	function updateShaft(float DeltaTime)
	{
		local int i, HitJoint, Flags, numPoints, hp, TotalAmplitude;
		local float scalar, RScale;
		local vector loc, Start, End, HitLocation, HitNormal, X, Y, Z, LastPoint, ld, td, LastY, LastZ, WaterSurface;
		local Actor A;
		local Texture HitTexture;
		local DamageInfo Di;

		GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);

		HitTexture = none;
		if ( shaft != none )
		{
			// check for Firefly lit guys
			GetLitPawn();
			
			Start = JointPlace('Mid_base').pos;

			if (LitPawn == none)
			{
				// nothing lit by firefly - proceed as normal
				A = PawnOwner.EyeTrace(end,HitNormal,Range[LocalCastingLevel], true);
				PawnOwner.EyeTrace(end,HitNormal,Range[LocalCastingLevel], false);

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
				for (i=0; i<8; i++)
					lts[i].SetLocation(start + (end-start) * 0.25 * i);
	
				if ( len < MinPtDist )
				{
					len = MinPtDist;
					numPoints = VSize(end-start) / minPtDist;
				}
				else
					numPoints = 32;
	
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

						LastY = Normal( Y * 0.5 + LastY ) * RandRange(-2-(LocalCastingLevel * 1.25), 2 + (LocalCastingLevel * 1.25));
						LastZ = Normal( Z * 0.5 + LastZ ) * RandRange(-2-(LocalCastingLevel * 1.25), 2 + (LocalCastingLevel * 1.25));

						Deltas[i] = (Deltas[i] * 0.25) +  (LastY + LastZ);// * RScale;

						Loc = LastPoint + (Normal(end-LastPoint) * len);
						Loc += deltas[i];

						Shaft.GetParticleParams(i,Shaft.Params);
						Shaft.Params.Position = Loc;
						Shaft.Params.Width = (localCastingLevel + 2) * (1+ (i/float(numPoints)));
						Shaft.SetParticleParams(i, Shaft.Params);
						LastPoint = Loc;
					} else {
						Shaft.GetParticleParams(i,Shaft.Params);
						Shaft.Params.Position = LastPoint;
						Shaft.Params.Width = 0;
						Shaft.SetParticleParams(i, Shaft.Params);
					}
				}
	
				if (A != none)
				{
					if (DmgRem > DmgTime)
					{
						hp = DmgRem / DmgTime;
						DmgRem -= hp * DmgTime;
						Di = GetDamageInfo('Electrical');
						Di.Damage = hp;
						A.TakeDamage( PlayerPawn(Owner), HitLocation, vect(0,0,0), Di);
						if ( Pawn(A) != none )
						{
							Pawn(A).PlayDamageMethodImpact('Bullet', HitLocation, -Vector(Pawn(Owner).ViewRotation));
							spawn(class 'BloodPuffFX',,,end);
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
							sFX.bShuttingDown = true;
							sFX = none;
						}
						if (pFX != none)
						{
							pFX.SetLocation(End);
							pFX.SetRotation(Rotator(vect(0,0,1)));
						}
						ForEach RadiusActors(class 'Actor',A, 256, End)
						{
							if (A.Region.Zone.bWaterZone)
								A.TakeDamage(Pawn(Owner), End, vect(0,0,0), GetDamageInfo());
						}
						// spawn(class 'DebugLocationMarker',,,End);
					} else if (pFX != none) {
						pFX.bShuttingDown = true;
						pFX = none;
					}
				}

				LastStrike = end;
			} else {

// =======
// FireFly
// =======

				// we have a lit pawn by the firefly spell - go an git it.
				end = LitPawn.Location;

				len = VSize(end-start) / float(numKnots);
	
				// update Lights
				for (i=0; i<4; i++)
					lts[i].SetLocation(start + (end-start) * 0.25 * i);
	
				LastPoint = start;
				Shaft.GetParticleParams(0,Shaft.Params);
				Shaft.Params.Position = LastPoint;
				Shaft.Params.Width = 2;
				Shaft.SetParticleParams(0, Shaft.Params);

				for (i=1; i<32; i++)
				{
					RScale = 1;
					// RScale = float(i)/float(numpoints);
					Scalar = VSize(end-start) / Range[LocalCastingLevel];

					
					if (i == 31)
						len = VSize( End-LastPoint);
					else
						len = VSize( End-LastPoint) / (32-i);

					Deltas[i] = ((Z * RandRange(-16,16) + Y * RandRange(-8,8)) * scalar * square(RScale) );

					// Combined amplitude of the firefly that is attached to the Pawn
					// and the local casting level of this lightning spell.
					TotalAmplitude = LitPawn.LitAmplitude + LocalCastingLevel + 2;

					ld = Vector(Pawn(Owner).ViewRotation) * 0.35; //2 * (1-(i/32.0));
					td = Normal(end-LastPoint) * ( TotalAmplitude * 0.05 );
					Loc = LastPoint +  Normal(td+ld) * len;
					Loc += deltas[i] * scalar;

					Shaft.GetParticleParams(i,Shaft.Params);
					Shaft.Params.Position = loc;
					Shaft.Params.Width = (localCastingLevel+1);// * (1+ (i/float(numPoints)));
					Shaft.SetParticleParams(i, Shaft.Params);
					LastPoint = Loc;
				}

				if ( VSize(LastPoint - LitPawn.Location) < (LitPawn.CollisionRadius + LitPawn.CollisionHeight * 0.5) )
					if ( DmgRem > DmgTime)
					{
						Hp = DmgRem / DmgTime;
						DmgRem -= hp * DmgTime;
						Di = GetDamageInfo('Electrical');
						Di.Damage = hp;
						LitPawn.TakeDamage( PlayerPawn(Owner), HitLocation, vect(0,0,0), Di);
						LitPawn.PlayDamageMethodImpact('Bullet', HitLocation, -Vector(Pawn(Owner).ViewRotation));
						if ( LitPawn.IsA('Pawn') )
							spawn(class 'BloodPuffFX',,,end);
					} else {
						DmgRem += deltaTime;
					}
			}
		} else {
			log("..................Lightning:UpdateShaft:No Shaft!");
		}
	}

	function Timer()
	{
		if ( !Pawn(Owner).UseMana(1) )
		{
			GhelzUse(1);
			PlayerPawn(Owner).bFireAttSpell = 0;
			GotoState('Release');
		}
	}

	function Tick(float DeltaTime)
	{
		lastRand = vRand();
		shaft.setLocation(JointPlace('Mid_base').pos);
		shaft.setRotation(PlayerPawn(Owner).ViewRotation);
		UpdateShaft(DeltaTime);

		if ( (PlayerPawn(Owner).bFireAttSpell == 0)) // || (Shaft == none) )
			GotoState('Release');
	}

	Begin:
		setTimer(0.04,true);
		sndID = PlaySound(HoldSounds[Rand(3)]);
		loopAnim('Lightning_cycle');
		timeDampening = 3.0;
		
	End:
}

////////////////////////////////////////////////////////////////////////////////////////
state Release
{
	function BeginState()
	{
		local int i;
		
		for (i=0; i<4; i++)
			lts[i].Destroy();
	}

	Begin:
		StopSound(sndID);
		Shaft.Destroy();

		if (MetalDecal != none)
		{
			MetalDecal.Destroy();
		}
		if (sFX != none)
		{
			sFX.bShuttingDown = true;
			sFX = none;
		}

		if (pFX != none)
		{
			pFX.bShuttingDown = true;
			pFX = none;
		}

		// Test PlayActuator here!!
		PlayActuator (PlayerPawn (Owner), EActEffects.ACTFX_FadeOut, 0.1f);
		playAnim('Lightning_end');
		FinishAnim();
		sleep(RefireRate);
		Finish();
}


function FireAttSpell( float Value )
{
	local bool bPCL;
	
	bPCL = ProcessCastingLevel();
	
	PawnOwner = Pawn(Owner);

    if ( PawnOwner.HeadRegion.Zone.bWaterZone && !bWaterFire)
	{
		PlayFireEmpty(); //perhaps a fizzle sound
    } else if ( !bSpellUp && bPCL) {
		BringUp();
	} else {
		SayMagicWords();

		if ( bPCL && !AeonsPlayer(Owner).bDispelActive )
		{
			if ( PlayerPawn(Owner).Weapon.IsA('Speargun') )
			{
				if ( !Speargun(PlayerPawn(Owner).Weapon).bCharged ){}
					if ( PawnOwner.useMana(50) )
						ChargeSpear();
			} else if ( PawnOwner.useMana(manaCostPerLevel[localCastingLevel]) ) {
				gotoState('NormalFire');
				if ( Owner.bHidden )
					CheckVisibility();
			} else {
				GotoState('Idle');
			}
		}
	}
}
*/

defaultproperties
{
     HandAnim=Lightning
     manaCostPerLevel(0)=40
     manaCostPerLevel(1)=40
     manaCostPerLevel(2)=40
     manaCostPerLevel(3)=40
     manaCostPerLevel(4)=40
     manaCostPerLevel(5)=40
     damagePerLevel(0)=15
     damagePerLevel(1)=20
     damagePerLevel(2)=25
     damagePerLevel(3)=30
     damagePerLevel(4)=40
     damagePerLevel(5)=50
     MaxTargetRange=4096
     FireOffset=(Y=16,Z=-10)
     ProjectileClass=Class'Aeons.LtngBlast_proj'
     RefireRate=0.5
     FireSound=Sound'Aeons.Spells.E_Spl_LightningStart01'
     ItemType=SPELL_Offensive
     InventoryGroup=14
     PickupMessage="Lightning"
     ItemName="Lightning"
     PlayerViewOffset=(X=-4,Y=10,Z=-2.5)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     Rotation=(Yaw=16384)
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
