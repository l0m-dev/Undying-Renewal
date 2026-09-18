//=============================================================================
// PlayerDamageModifier.
//=============================================================================
class PlayerDamageModifier expands PlayerModifier;

// old damage feedback
var float Str;
var float Damping;
var float RotStrength;
var Vector TotalVec;
var float y, p, r;
var float AccY, AccP, AccR;

// new damage feedback
var float RollKick, PitchKick, YawKick;		// peak kick for a full strength hit
var float MaxRoll, MaxPitch, MaxYaw;		// limits for stacked hits
var float MinDirScale;						// roll and pitch always get at least this much
var float MinHitStr;						// kick of the weakest hit
var float DamageToStrength;					// for hits without EffectStrength
var float MinShakeDamage;					// weaker hits without EffectStrength are ignored
var float SpringFreq, SpringDamping;
var float NoisePerHit, NoiseFade;
var float NoiseRoll, NoisePitch, NoiseYaw;
var float NoiseFreq;

var float SpringW, SpringWD, SpringDecay, KickScale;
var float LastSpringFreq, LastSpringDamping;
var vector KickPos, KickVel, NoisePhase;	// X = roll, Y = pitch, Z = yaw
var float NoiseStr, NoiseTime;
var bool bKickActive;
var rotator ViewOffset;						// currently added to ViewRotation

simulated function PreBeginPlay()
{
	super.PreBeginPlay();
	Damping = 0.800;
	RotStrength = 4096;
}

simulated function Destroyed()
{
	RemoveViewOffset();
	super.Destroyed();
}

//----------------------------------------------------------------------------

// called at the start of AeonsPlayer ViewShake
simulated function RemoveViewOffset()
{
	local PlayerPawn P;

	P = PlayerPawn(Owner);
	if ( P == None )
		return;

	P.ViewRotation.Pitch = (P.ViewRotation.Pitch - ViewOffset.Pitch) & 65535;
	P.ViewRotation.Yaw = P.ViewRotation.Yaw - ViewOffset.Yaw;
	P.ViewRotation.Roll = (P.ViewRotation.Roll - ViewOffset.Roll) & 65535;
	ViewOffset = rot(0,0,0);
}

// called at the end of AeonsPlayer ViewShake
simulated function ApplyViewOffset(float DeltaTime)
{
	local PlayerPawn P;
	local float Roll, Pitch, Yaw, N, BasePitch;

	P = PlayerPawn(Owner);

	UpdateKick(DeltaTime);
	if ( !bKickActive )
		return;

	N = NoiseStr * NoiseStr;
	Roll = FClamp(KickPos.X + N * NoiseRoll * Noise(NoiseTime, NoisePhase.X), -MaxRoll, MaxRoll);
	Pitch = FClamp(KickPos.Y + N * NoisePitch * Noise(NoiseTime, NoisePhase.Y), -MaxPitch, MaxPitch);
	Yaw = FClamp(KickPos.Z + N * NoiseYaw * Noise(NoiseTime, NoisePhase.Z), -MaxYaw, MaxYaw);

	// stay inside the look limits so UpdateRotation doesn't clip the offset
	BasePitch = P.ViewRotation.Pitch;
	if ( BasePitch > 32767 )
		BasePitch -= 65536;
	Pitch = FClamp(Pitch, -16384.0 - BasePitch, 18000.0 - BasePitch);

	ViewOffset.Roll = int(Roll);
	ViewOffset.Pitch = int(Pitch);
	ViewOffset.Yaw = int(Yaw);

	P.ViewRotation.Roll = (P.ViewRotation.Roll + ViewOffset.Roll) & 65535;
	P.ViewRotation.Pitch = (P.ViewRotation.Pitch + ViewOffset.Pitch) & 65535;
	P.ViewRotation.Yaw = P.ViewRotation.Yaw + ViewOffset.Yaw;
}

//----------------------------------------------------------------------------

simulated function TakeHitNew(float Damage, vector HitLocation, float Strength, vector Momentum)
{
	local PlayerPawn P;
	local vector PushDir, X, Y, Z;
	local rotator ViewYaw;
	local float Fwd, Right, HitStr;

	P = PlayerPawn(Owner);

	HitStr = GetHitStr(Strength, Damage);
	if ( HitStr <= 0.0 )
		return;

	if ( VSize(Momentum) > 1.0 )
		PushDir = Momentum;
	else if ( HitLocation != vect(0,0,0) )
		PushDir = P.Location - HitLocation;

	PushDir.Z = 0;
	if ( VSize(PushDir) < 0.001 )
	{
		PushDir = VRand();
		PushDir.Z = 0;
	}
	PushDir = Normal(PushDir);

	ViewYaw.Yaw = P.ViewRotation.Yaw;
	GetAxes(ViewYaw, X, Y, Z);
	Fwd = PushDir dot X;		// > 0 when hit from behind
	Right = PushDir dot Y;		// > 0 when hit from the left

	UpdateSpring();

	if ( !bKickActive )
	{
		bKickActive = true;
		NoiseTime = 0;
		NoisePhase.X = FRand() * 2.0 * Pi;
		NoisePhase.Y = FRand() * 2.0 * Pi;
		NoisePhase.Z = FRand() * 2.0 * Pi;
	}

	KickVel.X += KickImpulse(KickPos.X, HitStr * RollKick * DirScale(Right), MaxRoll);
	KickVel.Y += KickImpulse(KickPos.Y, -HitStr * PitchKick * DirScale(Fwd), MaxPitch);
	KickVel.Z += KickImpulse(KickPos.Z, HitStr * YawKick * Right, MaxYaw);

	NoiseStr = FMin(1.0, NoiseStr + HitStr * NoisePerHit);
}

simulated function float GetHitStr(float Strength, float Damage)
{
	local float Scale;

	Scale = class'RenewalConfig'.default.DamageScreenShakeScale;
	if ( Scale <= 0.0 )
		return 0.0;

	// non-melee hits have no EffectStrength, use the damage instead
	if ( Strength <= 0.0 )
	{
		if ( Damage >= MinShakeDamage )
			Strength = Damage * DamageToStrength;
		else
			return 0.0;
	}

	Strength = FClamp(Strength, 0.0, 2.0);
	return Scale * (MinHitStr + (1.0 - MinHitStr) * Sqrt(Strength));
}

simulated function float DirScale(float V)
{
	local float S;

	if ( Abs(V) < 0.05 )
	{
		if ( FRand() < 0.5 )
			S = -1.0;
		else
			S = 1.0;
	}
	else if ( V < 0.0 )
		S = -1.0;
	else
		S = 1.0;

	return S * (MinDirScale + (1.0 - MinDirScale) * Abs(V));
}

// less room left in that direction means a smaller kick
simulated function float KickImpulse(float Pos, float Peak, float Limit)
{
	local float Room;

	if ( Limit <= 0.0 )
		return 0.0;

	if ( Peak > 0.0 )
		Room = FClamp(1.0 - Pos / Limit, 0.0, 1.0);
	else
		Room = FClamp(1.0 + Pos / Limit, 0.0, 1.0);

	return Peak * Room * KickScale;
}

//----------------------------------------------------------------------------

simulated function UpdateSpring()
{
	local float Zeta, T;

	if ( SpringFreq == LastSpringFreq && SpringDamping == LastSpringDamping )
		return;
	LastSpringFreq = SpringFreq;
	LastSpringDamping = SpringDamping;

	Zeta = FClamp(SpringDamping, 0.05, 0.95);
	SpringW = 2.0 * Pi * FMax(SpringFreq, 0.1);
	SpringDecay = Zeta * SpringW;
	SpringWD = SpringW * Sqrt(1.0 - Zeta * Zeta);

	// scale so a kick of 1 peaks at exactly 1
	T = Atan(SpringWD / SpringDecay) / SpringWD;
	KickScale = SpringWD / (Exp(-SpringDecay * T) * Sin(SpringWD * T));
}

simulated function UpdateKick(float DeltaTime)
{
	local float D, Cs, Sn;
	local vector OldPos;

	if ( !bKickActive )
		return;

	UpdateSpring();

	if ( DeltaTime > 0.0 )
	{
		D = Exp(-SpringDecay * DeltaTime);
		Cs = Cos(SpringWD * DeltaTime);
		Sn = Sin(SpringWD * DeltaTime) / SpringWD;

		OldPos = KickPos;
		KickPos = D * (OldPos * Cs + (KickVel + SpringDecay * OldPos) * Sn);
		KickVel = D * (KickVel * Cs - (SpringW * SpringW * OldPos + SpringDecay * KickVel) * Sn);

		NoiseTime += DeltaTime;
		NoiseStr = FMax(0.0, NoiseStr - NoiseFade * DeltaTime);
	}

	if ( NoiseStr <= 0.0 && Abs(KickPos.X) + Abs(KickPos.Y) + Abs(KickPos.Z) < 1.0 && Abs(KickVel.X) + Abs(KickVel.Y) + Abs(KickVel.Z) < 5.0 )
		ResetKick();
}

simulated function ResetKick()
{
	KickPos = vect(0,0,0);
	KickVel = vect(0,0,0);
	NoiseStr = 0;
	NoiseTime = 0;
	bKickActive = false;
}

simulated function float Noise(float T, float Phase)
{
	local float W;

	W = 2.0 * Pi * NoiseFreq;
	return 0.6 * Sin(W * T + Phase) + 0.4 * Sin(W * 1.83 * T + Phase * 1.7);
}

//----------------------------------------------------------------------------

simulated function TakeHit(float Strength)
{
	Strength *= class'RenewalConfig'.default.DamageScreenShakeScale;
	str = 100;
	if (FRand() > 0.5)
		y = RotStrength * Strength;
	else
		y = RotStrength * Strength * -1;

	if (FRand() > 0.5)
		p = RotStrength * Strength;
	else
		p = RotStrength * Strength * -1;

	if (FRand() > 0.5)
		r = RotStrength * Strength;
	else
		r = RotStrength * Strength * -1;
}

simulated function Tick(float DeltaTime)
{
	local rotator rot;
	local float Decay, Weight;

	if (PlayerPawn(Owner) == None)
		return;

	if (str > 1.0)
	{
		// stock damped once per tick, scale it to 60 fps
		Decay = Damping ** (DeltaTime * 60.0);
		Weight = (1.0 - Decay) * Damping / (1.0 - Damping);

		AccY += y * Weight;
		AccP += p * Weight;
		AccR += r * Weight;

		rot.yaw = int(AccY);
		rot.pitch = int(AccP);
		rot.roll = int(AccR);

		AccY -= rot.yaw;
		AccP -= rot.pitch;
		AccR -= rot.roll;

		PlayerPawn(Owner).ViewRotation += rot;

		str *= Decay;
		y *= Decay;
		p *= Decay;
		r *= Decay;
	}
}

defaultproperties
{
     RollKick=1820.000000
     PitchKick=910.000000
     YawKick=360.000000
     MaxRoll=2350.000000
     MaxPitch=1180.000000
     MaxYaw=465.000000
     MinDirScale=0.300000
     MinHitStr=0.300000
     DamageToStrength=0.010000
     MinShakeDamage=5.000000
     SpringFreq=4.500000
     SpringDamping=0.500000
     NoisePerHit=2.000000
     NoiseFade=3.000000
     NoiseRoll=330.000000
     NoisePitch=165.000000
     NoiseYaw=110.000000
     NoiseFreq=7.000000
}
