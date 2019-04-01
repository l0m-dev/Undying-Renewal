class SPRechargeBolt expands SPLightningBolt;

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	DInfo.Damage = 1;
	DInfo.DamageMultiplier = 1.0;
	DInfo.DamageType = 'recharge';
	return DInfo;	
}

function Init( float Seconds, vector StartPoint, vector EndPoint )
{
	Start = StartPoint;
	End = EndPoint;
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
	Begin:
		Strike(Start, End);
		// sndID = PlaySound(HoldSounds[Rand(3)]);
		timeDampening = 3.0;
		
	End:
}

defaultproperties
{
     bCausesDamage=False
     bTraceActors=False
}
