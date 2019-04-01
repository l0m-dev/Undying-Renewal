//=============================================================================
// Gerald.
//=============================================================================
class Gerald expands ScriptedNarrator;

#exec MESH IMPORT MESH=Gerald_m SKELFILE=Gerald.ngf INHERIT=ScriptedBiped_m


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************
function bool IsAlert()
{
	return false;
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

		DebugInfoMessage( ".(Gerald)PlayAnimFromGroup(), Group is " $ Group );
		if ( Group != 0 )
		{
			if ( ScriptWaitCount > 0 )
			{
				ScriptWaitCount -= 1;
				PlayAnim( 'idle', [TweenTime] 1.0 );
				DebugInfoMessage( ".(Gerald)PlayAnimFromGroup(), played wait @ " $ Level.TimeSeconds );
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
						else if ( R < 0.90 )
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						else
							PlayAnim( 'speaking_emphasis', [TweenTime] 1.0 );
						break;
					// Imploring
					case 2:
						if ( R < 0.05 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.45 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.90 )
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						else
							PlayAnim( 'speaking_emphasis', [TweenTime] 1.0 );
						break;
					// Inquisitive.
					case 3:
						if ( R < 0.05 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.25 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.55 )
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						else if ( R < 0.80 )
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
     DeathAutoRestart=0
     JumpScalar=0.75
     ScriptSoundAmp=5
     GroundSpeed=350
     AccelRate=1500
     BaseEyeHeight=60
     FootSoundClass=Class'Aeons.DefaultFootSoundSet'
     LODBias=1.5
     Mesh=SkelMesh'Aeons.Meshes.Gerald_m'
     CollisionRadius=22
}
