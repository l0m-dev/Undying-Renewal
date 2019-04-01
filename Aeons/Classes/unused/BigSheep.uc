//=============================================================================
// BigSheep.
//=============================================================================
class BigSheep expands Sheep;


function GrazeLoop()
{
	LoopAnim( 'graze_cycle', 0.5, MOVE_None );
}

//****************************************************************************
// AIWait
// wait for encounter at current location
//****************************************************************************
state AIWait
{
	// *** ignored functions ***
	function DefConChanged( int OldValue, int NewValue ){}

	// *** overridden functions ***
	function CueNextEvent()
	{
		if ( FRand() < 0.05 )
		{
			GotoState( , 'WALKAHEAD' );
			return;
		}
		switch ( Rand(3) )
		{
			case 0:
				GotoState( , 'IDLE' );
				break;
			case 1:
				GotoState( , 'GRAZE' );
				break;
			case 2:
				GotoState( , 'LOOKAROUND' );
				break;
		}
	}

	// *** new (state only) functions ***

IDLE:
	PlayWait();
	Sleep( FVariant( 3.0, 1.0 ) );
	CueNextEvent();

GRAZE:
	PlayAnim( 'graze', 0.5, MOVE_None );
	Sleep( FVariant( 6.0, 1.0 ) );
	CueNextEvent();

LOOKAROUND:
	PlayAnim( 'lookaround', 0.5, MOVE_None );
	FinishAnim();
	PlayWait();
	Sleep( FVariant( 3.0, 2.0 ) );
	CueNextEvent();

WALKAHEAD:
	TargetPoint = GetGotoPoint( Location + vector(Rotation) * CollisionRadius * FVariant( 2.5, 1.0 ) );
	if ( pointReachable( TargetPoint ) )
	{
		PlayWalk();
		MoveTo( TargetPoint, WalkSpeedScale );
		StopMovement();
	}
	PlayWait();
	Sleep( FVariant( 3.0, 1.0 ) );
	CueNextEvent();

} // state AIWait

defaultproperties
{
     GroundSpeed=350
     Health=300
     SoundSet=Class'Aeons.BigSheepSoundSet'
     Event=EQ
     DrawScale=10
     bMRM=False
     TransientSoundRadius=6000
     CollisionRadius=140
     CollisionHeight=130
}
