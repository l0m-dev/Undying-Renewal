//=============================================================================
// SiblingDeathFX.
//=============================================================================
class SiblingDeathFX expands ScriptedFX;

var int NumJoints;


function PreBeginPlay()
{
//	if (Owner == none)
//	{
//		Destroy();
//	} else {
//		NumJoints = Owner.NumJoints();
		GotoState('GenEffect');
//	}
}

state GenEffect
{
	function BeginState()
	{
		local int i;
		local vector Offset;
		
		setRotation(Rotator(vect(1,0,0)));
		
//		Offset.z = -(Owner.CollisionHeight * 0.5);
		
//		SetLocation(Owner.Location + Offset);
		
		
	}	

	function Tick(float DeltaTime)
	{
		local rotator r;
		
		r = rotation;
		r.yaw += 16;
		setRotation(r);
	}

	Begin:
	
}

defaultproperties
{
     ParticlesPerSec=(Base=128)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=20,Rand=50)
     Lifetime=(Base=5,Rand=2)
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=0,G=0,B=255))
     AlphaEnd=(Base=0)
     SizeEndScale=(Base=2,Rand=4)
     Gravity=(Z=20)
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     RenderPrimitive=PPRIM_Billboard
     Physics=PHYS_Rotating
     RotationRate=(Pitch=256,Yaw=512,Roll=654)
}
