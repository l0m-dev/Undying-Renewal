//=============================================================================
// SavedMove is used during network play to buffer recent client moves,
// for use when the server modifies the clients actual position, etc.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class SavedMove extends Info;

// also stores info in Acceleration attribute
var SavedMove NextMove;		// Next move in linked list.
var float TimeStamp;		// Time of this move.
var float Delta;			// Distance moved.
var byte MergeCount;		// Additional moves merged into this.
var bool	bRun;
var bool	bDuck;
var bool	bPressedJump;
var bool	bFire;
var bool	bForceFire;
var bool	bFireAttSpell;
var bool	bForceFireAttSpell;
var bool	bFireDefSpell;
var bool	bForceFireDefSpell;
var vector  Acceleration;

// Player attributes after applying this move
var vector SavedLocation;   
var vector SavedVelocity;
var rotator SavedViewRotation;

final function Clear()
{
	TimeStamp = 0;
	Delta = 0;
	Acceleration = vect(0,0,0);
	MergeCount = 0;
	bFire = false;
	bFireAttSpell = false;
	bFireDefSpell = false;
	bRun = false;
	bDuck = false;
	bPressedJump = false;
	bForceFire = false;
	bForceFireAttSpell = false;
	bForceFireDefSpell = false;
}

final function bool CanMergeAccel( vector OtherAccel )
{
	local vector RealAccel;

	// Physics processing limits magnitude of acceleration to AccelRate.
	RealAccel = Acceleration;
	if ( VSize(RealAccel) > PlayerPawn(Owner).AccelRate )
		RealAccel = Normal(RealAccel) * PlayerPawn(Owner).AccelRate;
	if ( VSize(OtherAccel) > PlayerPawn(Owner).AccelRate )
		OtherAccel = Normal(OtherAccel) * PlayerPawn(Owner).AccelRate;

	if ( VSize(RealAccel-OtherAccel) > 1
		&& Normal(RealAccel) dot Normal(OtherAccel) < 0.95 )
	{
		return false;
	}
	return true;
}


final function bool CanBuffer( vector OldAcceleration )
{
	if ( bForceFire || bForceFireAttSpell || bForceFireDefSpell || bPressedJump
		|| (MergeCount >= 31)
		|| !CanMergeAccel(OldAcceleration) )
		return false;

	return true;
}

final function bool CanSendRedundantly( vector NewAcceleration )
{
	if ( bPressedJump
	|| !CanMergeAccel(NewAcceleration) )
		return true;
	
	return false;
}

final function byte CompressFlags()
{
	local int Compressed;
	
	Compressed += int(bRun) * 1;
	Compressed += int(bDuck) * 2;
	Compressed += int(bFire) * 4;
	Compressed += int(bFireAttSpell) * 8;
	Compressed += int(bFireDefSpell) * 16;
	Compressed += int(bForceFire) * 32;
	Compressed += int(bForceFireAttSpell) * 64;
	Compressed += int(bForceFireDefSpell) * 128;
	return byte(Compressed);
}

final function int Compress()
{
	local int Compressed;
	local vector BuildAccel;

	BuildAccel = 0.05 * Acceleration + vect(0.5, 0.5, 0.5);
	Compressed = (CompressAccel(BuildAccel.X) << 23)
				+ (CompressAccel(BuildAccel.Y) << 15)
				+ (CompressAccel(BuildAccel.Z) << 7);
	Compressed += 64 * int(bRun);
	Compressed += 32 * int(bDuck);
	Compressed += 16 * int(bPressedJump);
	
	return Compressed;
}

final function int CompressAccel(int C)
{
	if ( C >= 0 )
		C = Min(C, 127);
	else
		C = Min(abs(C), 127) + 128;
	return C;
}

function string ToString()
{
	return "[STAMP]"@TimeStamp@"[DELTA]"@Delta@"[LOC]"@SavedLocation@"[VEL]"@SavedVelocity@"("@VSize(SavedVelocity)@")"@"[ACCEL]"@Acceleration@"("@VSize(Acceleration)@")";
}

defaultproperties
{
}
