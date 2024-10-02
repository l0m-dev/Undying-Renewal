//=============================================================================
// ColdScriptedFX.
//=============================================================================
class ColdScriptedFX expands ScriptedFX;

var int NumJoints;

simulated function PreBeginPlay()
{
	if (Owner == none)
	{
		if (Level.NetMode != NM_Client)
			Destroy();
	}
	else
	{
		NumJoints = Owner.NumJoints();
	}
}

simulated function PostNetBeginPlay()
{
	if (Owner == none)
	{
		Destroy();
	}
	else
	{
		NumJoints = Owner.NumJoints();
	}
}

simulated function Tick(float deltaTime)
{
	local int i;

	if (Owner == None)
	{
		ShutDownFX();
		return;
	}
	
	for (i=0; i<NumJoints; i++)
	{
		if( (FRand() < 0.15) && (!Owner.IsA('ScriptedPawn') || ScriptedPawn(Owner).AddParticleToJoint(i)) )
		{
			AddParticle(i, Owner.JointPlace(Owner.JointName(i)).pos);
		}
	}
}

simulated function ShutDownFX()
{
	Disable('Tick');
	Shutdown();
}

defaultproperties
{
     AngularSpreadWidth=(Base=180)
     AngularSpreadHeight=(Base=180)
     Speed=(Rand=30)
     Lifetime=(Base=0.5,Rand=1)
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=121,G=121,B=255))
     AlphaEnd=(Base=0)
     SizeWidth=(Base=24)
     SizeLength=(Base=32)
     SizeEndScale=(Base=2,Rand=4)
     Gravity=(Z=-100)
     Textures(0)=Texture'Aeons.Particles.noisy1_pfx'
     RenderPrimitive=PPRIM_Billboard
}
