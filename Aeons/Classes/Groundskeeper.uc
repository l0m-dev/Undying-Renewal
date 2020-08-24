//=============================================================================
// Groundskeeper.
//=============================================================================
class Groundskeeper expands Servant;

//#exec MESH IMPORT MESH=GroundsKeeperPropped_m SKELFILE=Poses\GroundsKeeperPropped.ngf
//#exec MESH IMPORT MESH=GroundsKeeperImpaled_m SKELFILE=Poses\GroundsKeeperImpaled.ngf

//#exec MESH IMPORT MESH=Groundskeeper_m SKELFILE=Groundskeeper.ngf INHERIT=ScriptedBiped_m

//#exec MESH NOTIFY SEQ=walk TIME=0.105 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=walk TIME=0.605 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=idlehat TIME=0.170 FUNCTION=HatToHand
//#exec MESH NOTIFY SEQ=idlehat TIME=0.810 FUNCTION=HatToHead

//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function Died( pawn Killer, name damageType, vector HitLocation, DamageInfo DInfo )
{
	local vector	TDir;
	local rotator	DRot;

	super.Died( Killer, damageType, HitLocation, DInfo );
	if ( MyProp[0] != none )
	{
		MyProp[0].SetBase( none );
		MyProp[0].bCollideWorld = true;		// TODO: move to Thrown() in HeldProp?

		DRot = MyProp[0].Rotation;
		DRot.Pitch = 0;
		MyProp[0].SetRotation( DRot );

		TDir = VRand();
		TDir.Z = Abs(TDir.Z);
		MyProp[0].Thrown( TDir, 200.0 );
	}
}


//****************************************************************************
// New class functions.
//****************************************************************************
function HatToHand()
{
	if ( MyProp[0] != none )
		MyProp[0].SetBase( self, 'r_hand1', 'handle' );
}

function HatToHead()
{
	if ( MyProp[0] != none )
		MyProp[0].SetBase( self, 'head1', 'hat_att' );
}


//****************************************************************************
// Animation/audio notification handlers [SFX].
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************


//****************************************************************************
// AIRunScript
// Follow the actions of the script.
//****************************************************************************
state AIRunScript
{
	// *** ignored functions ***

	// *** overridden functions ***
	function PlayAnimFromGroup( int Group )
	{
		local float		R;

		DebugInfoMessage( ".(Groundskeeper)PlayAnimFromGroup(), Group is " $ Group );
		if ( Group != 0 )
		{
			if ( ScriptWaitCount > 0 )
			{
				ScriptWaitCount -= 1;
				PlayAnim( 'idle', [TweenTime] 1.0 );
				DebugInfoMessage( ".(Groundskeeper)PlayAnimFromGroup(), played wait @ " $ Level.TimeSeconds );
			}
			else
			{
				ScriptWaitCount = 1;	// + Rand(4);
				R = FRand();
				switch ( Group )
				{
					// Casual
					case 1:
						if ( R < 0.05 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.50 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.75 )
							PlayAnim( 'idlehat', [TweenTime] 1.0 );
						else
							PlayAnim( 'speaking_emphasis', [TweenTime] 1.0 );
						break;
					// Imploring
					case 2:
						if ( R < 0.05 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.45 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.70 )
							PlayAnim( 'idlehat', [TweenTime] 1.0 );
						else
							PlayAnim( 'speaking_emphasis', [TweenTime] 1.0 );
						break;
					// Inquisitive.
					case 3:
						if ( R < 0.10 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.30 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.50 )
							PlayAnim( 'idlehat', [TweenTime] 1.0 );
						else if ( R < 0.75 )
							PlayAnim( 'speaking_question2', [TweenTime] 1.0 );
						else
							PlayAnim( 'speaking_emphasis', [TweenTime] 1.0 );
						break;
				}
			}
		}
	}

	// *** new (state only) functions ***

} // state AIRunScript


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     MyPropInfo(0)=(Prop=Class'Aeons.Groundskeeper_Hat',PawnAttachJointName=Head1,AttachJointName=Hat_Att)
     ScriptSoundAmp=5
     BaseEyeHeight=65
     Health=10
     SoundSet=Class'Aeons.GroundskeeperSoundSet'
     FootSoundClass=Class'Aeons.DefaultFootSoundSet'
     LODBias=1.5
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Groundskeeper_m'
     DrawScale=1.05
     CollisionRadius=26
     CollisionHeight=70
     Mass=1000
}
