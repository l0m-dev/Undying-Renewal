class SPLightningFingers expands SPLightningBolt;

var name startJoint, endJoint;

function DamageInfo GetDamageInfo(optional name DamageType)
{
	local DamageInfo DInfo;
	DInfo.Damage = 0;
	DInfo.DamageMultiplier = 0.0;
	DInfo.DamageType = 'none';
	return DInfo;	
}

function InitFingers( name joint1, name joint2 )
{
	startJoint = joint1;
	endJoint = joint2;
	GotoState( 'Holding' );
}

auto state StartBolt
{
Begin:
}

state Holding
{
	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
		if( Owner != none )
		{
			LogActor("Tick() updating lightning fingers.");
			Update( DeltaTime, Owner.JointPlace( startJoint ).pos, Owner.JointPlace( endJoint ).pos );
		}
	}

	Begin:
		Start = Owner.JointPlace( startJoint ).pos;
		End = Owner.JointPlace( endJoint ).pos;

		Strike(Start, End);
		// sndID = PlaySound(HoldSounds[Rand(3)]);
		timeDampening = 3.0;
		
	End:
}

defaultproperties
{
     MinPtDist=2
     bCausesDamage=False
     bTraceActors=False
}
