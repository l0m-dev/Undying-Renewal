//=============================================================================
// ChunkyMaid.
//=============================================================================
class ChunkyMaid expands Maid;

#exec MESH IMPORT MESH=ChunkyMaid_m SKELFILE=ChunkyMaid.ngf INHERIT=ScriptedBiped_m
#exec MESH JOINTNAME Head=Hair Neck=Head


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************


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

		DebugInfoMessage( ".(ChunkyMaid)PlayAnimFromGroup(), Group is " $ Group );
		if ( Group != 0 )
		{
			if ( ScriptWaitCount > 0 )
			{
				ScriptWaitCount -= 1;
				PlayAnim( 'idle', [TweenTime] 1.0 );
				DebugInfoMessage( ".(ChunkyMaid)PlayAnimFromGroup(), played wait @ " $ Level.TimeSeconds );
			}
			else
			{
				ScriptWaitCount = 1;	// + Rand(4);
				R = FRand();
				switch ( Group )
				{
					// Casual
					case 1:
						if ( R < 0.40 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.80 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						break;
					// Imploring
					case 2:
						if ( R < 0.30 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.70 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						break;
					// Inquisitive.
					case 3:
						if ( R < 0.10 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.40 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.75 )
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						else
							PlayAnim( 'speaking_question2', [TweenTime] 1.0 );
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
     BaseEyeHeight=50
     SoundSet=Class'Aeons.ChunkyMaidSoundSet'
     Mesh=SkelMesh'Aeons.Meshes.ChunkyMaid_m'
     CollisionRadius=32
     CollisionHeight=64
}
