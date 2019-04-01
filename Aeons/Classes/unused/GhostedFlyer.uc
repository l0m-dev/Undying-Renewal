//=============================================================================
// GhostedFlyer.
//=============================================================================
class GhostedFlyer expands ScriptedFlyer;


//****************************************************************************
// Member vars.
//****************************************************************************
var ParticleFX				MyPFX;				//
var() class<ParticleFX>		AttachFX;			//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Sound trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();

	DrawType = DT_None;
	MyPFX = Spawn( AttachFX, self,, Location );
	if ( MyPFX != none )
		MyPFX.SetBase( self );
}

function Destroyed()
{
	if ( MyPFX != none )
		MyPFX.Destroy();

	super.Destroyed();
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     HoverAltitude=800
     HoverVariance=150
     HoverRadius=600
     WaitGlideScalar=0.1
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     AirSpeed=600
     MaxStepHeight=16
     SightRadius=1500
     BaseEyeHeight=1
     Health=10
     RotationRate=(Pitch=15000,Yaw=60000,Roll=9000)
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Particle'
     CollisionRadius=10
     CollisionHeight=8
     Mass=10000
}
