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

final function Clear()
{
	TimeStamp = 0;
	Delta = 0;
	Acceleration = vect(0,0,0);
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

defaultproperties
{
}
