//=============================================================================
// DrinenTeleportFX.
//=============================================================================
class DrinenTeleportFX expands ScriptedFX;

function PreBeginPlay()
{
	local int numJoints, i;
	local vector lastJoint, iJoint;
	
	if (Owner == none)
		Destroy();
	
	LastJoint = Location;

	SetRotation(Owner.Rotation);
	
	NumJoints = Owner.NumJoints();

	for (i=0; i<NumJoints; i++)
	{
		iJoint = Owner.JointPlace(Owner.JointName(i)).pos;
		AddParticle(i, iJoint);
		// AddParticle(i, (iJoint + LastJoint) * 0.5);
		LastJoint = iJoint;
	}
	
	Shutdown();
	// Super.PreBeginPlay();
}

defaultproperties
{
     Speed=(Base=400,Rand=410)
     Lifetime=(Base=0.1,Rand=0.25)
     ColorStart=(Base=(R=0,G=255,B=198))
     ColorEnd=(Base=(R=179,G=0,B=255))
     AlphaEnd=(Base=0)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2,Rand=4)
     SpinRate=(Base=-8,Rand=16)
     Textures(0)=Texture'Aeons.Particles.Soft_pfx'
     RenderPrimitive=PPRIM_Billboard
}
