//=============================================================================
// PlayerJointEffects.
//=============================================================================
class PlayerJointEffects expands PlayerEffects
	abstract;

/*
function int NumJoints();
function name JointName( int iJoint );
function int JointIndex( name JointName );
function place JointPlace( name JointName );
function vector StaticJointDir( name BodyLoc, vector Dir );
function SetBase( actor NewBase, optional name BaseLoc, optional name SelfLoc );
*/

var() class<Actor> EffectClass;

function PreBeginPlay()
{
	local int NumJoints, i;
	local name JointName;
	local Actor A;
	local place P;
	
	if ((Owner != none) && (EffectClass != none))
	{
		NumJoints = Owner.NumJoints();
		if ( NumJoints > 0 )
		{
			for (i=0; i<NumJoints; i++)
			{
				JointName = Owner.JointName(i);
				P = Owner.JointPlace(JointName);
				A = Spawn(EffectClass, Owner,, P.pos);
				A.SetBase(Owner,JointName, 'root');
			}
		}
		setTimer(1,true);
	} else {
		// can't exist without an owner.
		Destroy();
	}
}

function Timer()
{
	if ( Owner == none )
	{
		Destroy();
	}
}

defaultproperties
{
}
