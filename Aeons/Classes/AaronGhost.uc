//=============================================================================
// AaronGhost.
//=============================================================================
class AaronGhost expands ScriptedFlyer;

//#exec MESH IMPORT MESH=AaronGhost_m SKELFILE=DavidGhost.ngf INHERIT=ScriptedBiped_m


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=pageturn TIME=0.44 FUNCTION=PlaySound_N ARG="PageTurn V=0.6"
//#exec MESH NOTIFY SEQ=paint1 TIME=0.305556 FUNCTION=PlaySound_N ARG="PaintA PVar=0.1 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=paint2 TIME=0.129032 FUNCTION=PlaySound_N ARG="PaintB PVar=0.1 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=paint3 TIME=0.5 FUNCTION=PlaySound_N ARG="PaintC PVar=0.1 V=0.5 VVar=0.1"
//#exec MESH NOTIFY SEQ=putdownbook TIME=0.576923 FUNCTION=PlaySound_N ARG="DropBook V=0.8"


//****************************************************************************
// Member vars.
//****************************************************************************
var() name					TransformStartState;
var HeldProp				BookProp;


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	Spawn( class'AaronGhostHalo', self,, Location );
}

function vector GetTotalPhysicalEffect( float DeltaTime )
{
	return vect(0,0,0);
}

function PlayLocomotion( vector dVector )
{
	local vector x, y, z;
	if( VSize( dVector ) < 0.01 )
		PlayWait();
	else 
	{
		GetAxes( Rotation, x, y, z );

		if( ( x dot dVector ) < 0.0 )	// backwards
			LoopAnim( 'flight_cycle' );
		else if( ( x dot dVector ) < 0.5 ) // mostly sideways
		{
			if( ( y dot dVector ) < 0.0 ) // right
				LoopAnim( 'flystraferight' );
			else
				LoopAnim( 'flystrafeleft' );
		}
		else
			LoopAnim( 'flyforward' );
	}
}

function CustomScriptAction( name AName, sound ASound, float AFloat, bool ABool )
{
	local place		MyJointPlace;

	switch ( AName )
	{
		case 'showbook':
			if ( BookProp == none )
			{
				MyJointPlace = JointPlace('book_att');
				BookProp = Spawn( class'AaronBook', self,, MyJointPlace.pos, ConvertQuat(MyJointPlace.rot) );
				BookProp.Setup( 'book_att', 'book_att' );
			}
			break;
		case 'dropbook':
			if ( BookProp != none )
			{
				BookProp.Thrown( vector(Rotation), 50.0 );
				BookProp = none;
			}
			break;
		case 'hidebook':
			if ( BookProp != none )
			{
				BookProp.Destroy();
				BookProp = none;
			}
			break;
		case 'turret':
			bSpecialTurret = ABool;
			break;
	}
}

function SnapToIdle()
{
	LoopAnim( 'idle1', [TweenTime] 0.0 );
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************
state AaronTransform expands AIDoNothing
{
	function SpawnRevenantAndDestroySelf()
	{
		local AaronRevenant revenant;

		SetCollision( false, false, false );

		revenant = spawn( class'AaronRevenant',,, Location, Rotation );
		if( revenant != none )
		{
			revenant.TransformStartState = TransformStartState;
			revenant.GotoState( 'AaronTransform' );
		}
		Destroy();
	}

Begin:
	PlayAnim( 'transform1' );
	FinishAnim();
	SpawnRevenantAndDestroySelf();
}



//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     TransformStartState=AIHuntPlayer
     HoverAltitude=100
     HoverVariance=20
     HoverRadius=10
     JumpDownDistance=140
     Aggressiveness=1
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     bSpecialTurret=True
     ScriptSoundAmp=5
     AirSpeed=300
     MaxStepHeight=35
     SightRadius=1500
     BaseEyeHeight=54
     Health=1000
     SoundSet=Class'Aeons.AaronGhostSoundSet'
     RotationRate=(Pitch=15000,Yaw=60000)
     Mesh=SkelMesh'Aeons.Meshes.AaronGhost_m'
     ShadowImportance=0
     ShadowRange=0
     CollisionRadius=20
     CollisionHeight=60
     bCollideActors=False
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     Mass=2000
}
