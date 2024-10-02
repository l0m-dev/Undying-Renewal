//=============================================================================
// GlowScriptedFX. 
//=============================================================================
class GlowScriptedFX expands ScriptedFX;

var name JointNames[64];
var int NumJoints;
var() float	Direction;

simulated function InitJoints( Pawn PawnOwner, bool bForceAdd )
{
	local int i;

	if( (NumParticles() > 0) && !bForceAdd )
		return;

	NumJoints = 0;
	for( i = 0; i < PawnOwner.NumJoints(); ++i )
	{
		if( PawnOwner.AddParticleToJoint(i) )
		{
			JointNames[NumJoints] = PawnOwner.JointName(i);
			AddParticle( NumJoints, PawnOwner.JointPlace(JointNames[NumJoints]).pos );
			++NumJoints;
		}
	}
}

simulated function SetupJoints( int startJoint, int endJoint )
{
	local int i;

	for( i = startJoint; i < endJoint; ++i )
	{
		JointNames[i] = Owner.JointName(i);
		AddParticle(i, Owner.JointPlace(JointNames[i]).pos);
	}
}

simulated function SetupEffects()
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
	
	if ( NumJoints > 0 && Owner.IsA('Pawn') && (!Owner.IsA('Rat')) )
	{
		InitJoints( Pawn(Owner), false );
		Enable('Tick');
	} else {
		AddParticle(1, Owner.Location);
		NumJoints = 0;
	}
}

function StartLevel()
{
	if (Level.NetMode != NM_DedicatedServer)
		SetupEffects();
}

simulated function PostNetBeginPlay()
{
	SetupEffects();
}

simulated function Tick(float DeltaTime)
{
	local int i;
	
	if ( Owner == none )
		Destroy();

	setLocation(Owner.Location);

	if ( NumJoints > 0 )
	{
		for (i=0; i<NumJoints; i++)
		{
			GetParticleParams(i,Params);
			Params.Position = Owner.JointPlace(JointNames[i]).pos;
			Params.Alpha = Owner.Opacity;
			SetParticleParams(i, Params);
		}
	} else {
		GetParticleParams(1,Params);
		Params.Position = Owner.Location;
		SetParticleParams(1, Params);
	}

	if( Direction != 0.0 )
	{
		Opacity += Direction * DeltaTime;
		if( Opacity >= 1.0 )
		{
			Opacity = 1.0;
			Direction = 0.0;
		}
		else if( Opacity <= 0.0 )
		{
			Opacity = 0.0;
			Direction = 0.0;
		}
	}
}

/*
state ShutDownState
{
	Begin:
		Destroy();
}
*/

defaultproperties
{
     SizeWidth=(Base=48)
     SizeLength=(Base=48)
     Textures(0)=Texture'Aeons.Particles.Glow00'
     RenderPrimitive=PPRIM_Billboard
     bDrawBehindOwner=True
}
