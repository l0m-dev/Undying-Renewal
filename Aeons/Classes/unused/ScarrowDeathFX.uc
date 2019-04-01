//=============================================================================
// ScarrowDeathFX.
//=============================================================================
class ScarrowDeathFX expands ScriptedFX;

var int NumJoints;
var name JointNames[64];

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
	NumJoints = Owner.NumJoints();
	
	if (NumJoints > 0)
	{
		// Iterate the joints
		for (i=0; i<NumJoints; i++)
		{
			JointNames[i] = Owner.JointName(i);
			AddParticle(i, Owner.JointPlace(JointNames[i]).pos);
		}
		Enable('Tick');
	} else {
		AddParticle(1, Owner.Location);
	}
	bUpdate = true;
}

defaultproperties
{
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Base=2,Rand=20)
     Lifetime=(Base=2,Rand=2)
     AlphaEnd=(Base=0)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Base=3,Rand=3)
     Gravity=(Z=20)
     Textures(0)=Texture'Aeons.Particles.Smoke32_01'
     RenderPrimitive=PPRIM_Billboard
     Style=STY_AlphaBlend
}
