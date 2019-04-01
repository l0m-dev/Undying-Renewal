//=============================================================================
// EtherTrapFX.
//=============================================================================
class EtherTrapFX expands ScriptedFX;

var name JointNames[64];
var int NumJoints;

function PreBeginPlay()
{
	local int i;
	local name JointName;
	
	Disable('Tick');
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
	} else {
		AddParticle(1, Owner.Location);
	}
	
	Enable('Tick');
	bUpdate = true;
}

defaultproperties
{
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=238,G=255,B=21))
     ColorEnd=(Base=(R=0,G=255,B=255))
     AlphaEnd=(Base=0)
     SizeWidth=(Base=24)
     SizeLength=(Base=24)
     SizeEndScale=(Base=2,Rand=2)
     Gravity=(Z=20)
     Textures(0)=Texture'Aeons.Particles.Flare'
     RenderPrimitive=PPRIM_Billboard
     LifeSpan=3
}
