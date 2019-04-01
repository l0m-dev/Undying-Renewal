class SPLightningBolt expands LightningBolt;

var float	Duration;

function Init( float Seconds, vector StartPoint, vector EndPoint )
{
	Duration = Seconds;
	GotoState( 'Holding' );
}

function Update( float DeltaTime, vector StartPoint, vector EndPoint )
{
	Start = StartPoint;
	End = EndPoint;

	shaft.setLocation(StartPoint);
	shaft.setRotation(Rotator(Normal(EndPoint - StartPoint)));
	UpdateShaft(DeltaTime, Start, End , 10, 4);
}

auto state StartBolt
{
Begin:
}

state Holding
{
	function Tick( float deltaTime )
	{
	}

	function Timer()
	{
		gotoState('Release');
	}

	Begin:
		setTimer(Duration, false);
		Strike(Start, End);
		// sndID = PlaySound(HoldSounds[Rand(3)]);
		timeDampening = 3.0;
		
	End:
}

defaultproperties
{
}
