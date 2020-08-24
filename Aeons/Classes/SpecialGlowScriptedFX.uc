//=============================================================================
// SpecialGlowScriptedFX. 
//=============================================================================
class SpecialGlowScriptedFX expands GlowScriptedFX;

function PreBeginPlay()
{
	local int i;
	local name JointName;
	
	disable('Tick');
	
	if (Owner == none)
	{
		Destroy();
		return;
	}

	setLocation(Owner.Location);
	setBase(Owner);
}

function AddJointGlow( int OwnerJoint, int MyJoint )
{
	JointNames[MyJoint] = Owner.JointName(OwnerJoint);
	AddParticle(MyJoint, Owner.JointPlace(JointNames[MyJoint]).pos);
}

defaultproperties
{
}
