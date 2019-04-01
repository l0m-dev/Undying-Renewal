//=============================================================================
// Maid.
//=============================================================================
class Maid expands Servant;

#exec MESH IMPORT MESH=MaidBrokenNeck_m SKELFILE=Poses\MaidBrokenNeck.ngf
#exec MESH IMPORT MESH=MaidPinned_m SKELFILE=Poses\MaidPinned.ngf

#exec MESH IMPORT MESH=Maid_m SKELFILE=Maid.ngf INHERIT=ScriptedBiped_m

#exec MESH NOTIFY SEQ=walk TIME=0.105 FUNCTION=C_BackRight
#exec MESH NOTIFY SEQ=walk TIME=0.605 FUNCTION=C_BackLeft


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

		DebugInfoMessage( ".(Maid)PlayAnimFromGroup(), Group is " $ Group );
		if ( Group != 0 )
		{
			if ( ScriptWaitCount > 0 )
			{
				ScriptWaitCount -= 1;
				PlayAnim( 'idle', [TweenTime] 1.0 );
				DebugInfoMessage( ".(Maid)PlayAnimFromGroup(), played wait @ " $ Level.TimeSeconds );
			}
			else
			{
				ScriptWaitCount = 1;	// + Rand(4);
				R = FRand();
				switch ( Group )
				{
					// Casual
					case 1:
						if ( R < 0.10 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.55 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.85 )
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						else
							PlayAnim( 'talk3', [TweenTime] 1.0 );
						break;
					// Imploring
					case 2:
						if ( R < 0.10 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.50 )
							PlayAnim( 'talk1', [TweenTime] 1.0 );
						else if ( R < 0.80 )
							PlayAnim( 'talk2', [TweenTime] 1.0 );
						else
							PlayAnim( 'talk3', [TweenTime] 1.0 );
						break;
					// Inquisitive.
					case 3:
						if ( R < 0.10 )
							PlayAnim( 'idle', [TweenTime] 1.0 );
						else if ( R < 0.50 )
							PlayAnim( 'talk3', [TweenTime] 1.0 );
						else if ( R < 0.65 )
							PlayAnim( 'speaking_question2', [TweenTime] 1.0 );
						else
							PlayAnim( 'talk2', [TweenTime] 1.0 );
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
     ScriptSoundAmp=5
     BaseEyeHeight=54
     Health=10
     SoundSet=Class'Aeons.MaidSoundSet'
     FootSoundClass=Class'Aeons.HeelFootSoundSet'
     LODBias=1.5
     Mesh=SkelMesh'Aeons.Meshes.Maid_m'
     DrawScale=1.15
     TransientSoundRadius=1500
     CollisionRadius=23
     CollisionHeight=58
     Mass=1000
}
