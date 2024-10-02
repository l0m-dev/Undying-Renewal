//=============================================================================
// FlickeringStalkerDeathFX.
//=============================================================================
class FlickeringStalkerDeathFX expands ScriptedFX;

var int NumJoints;
var name JointName;
var int JointID;

function PreBeginPlay()
{
	SetupEffects();
}

simulated function PostNetBeginPlay()
{
	SetupEffects();
}

simulated function SetupEffects()
{
	if (Owner == none)
	{
		Destroy();
		return;
	}
	setBase(Owner);
	NumJoints = Owner.NumJoints();
	bUpdate = true;
	setTimer(2,false);
}

simulated function Timer()
{
	Disable('Tick');
	Shutdown();
}

simulated function Tick(float deltaTime)
{
	local int i;
	local name JointName;
	
	if (Owner == none)
	{
		Destroy();
		return;
	}

	setLocation(Owner.Location);
	
	for (i=0; i<NumJoints;i++)
	{
		if (FRand() < 0.1)
		{
			JointName = Owner.JointName(i);
			AddParticle(i, Owner.JointPlace(JointName).pos);
		}
	}

/*
	if ( JointID <= NumJoints )
	{
		JointName = Owner.JointName(JointID);
		AddParticle(JointID, Owner.JointPlace(JointName).pos);

		JointID ++;
		
		if ( JointID > NumJoints )
			JointID = 0;
	}
*/
}

defaultproperties
{
     Speed=(Rand=20)
     Lifetime=(Base=0.25,Rand=1)
     AlphaEnd=(Base=0)
     SizeWidth=(Base=32)
     SizeLength=(Base=32)
     SizeEndScale=(Rand=4)
     Chaos=8
     Gravity=(Z=30)
     Textures(0)=Texture'Aeons.Particles.Flare'
     RenderPrimitive=PPRIM_Billboard
}
