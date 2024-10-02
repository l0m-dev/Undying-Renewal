//=============================================================================
// SimpleLightning.
//=============================================================================
class SimpleLightning expands Effects;

var Actor StartActor;
var Actor EndActor;
var ScriptedFX shaft;
var name StartJoint, EndJoint;
var float Len;
var bool bScaleShaft;
var() float DamageMult;

function go()
{
	if ( (StartActor != none) && (EndActor != none) )
	{
		if ( (StartJoint != 'none') && (EndJoint != 'none') )
		{
			Strike(StartActor.JointPlace(StartJoint).pos, EndActor.JointPlace(EndJoint).pos);
		} else {
			log("Start Joint = "$StartJoint$" EndJoint = "$EndJoint, 'Misc');
			Strike(StartActor.Location, EndActor.Location);
		}
		GotoState('Hold');
	} else {
		log("Actors undefined - destroying self", 'Misc');
		Destroy();
	}
}

function Strike(vector Start, vector End)
{
	local int i;
	local vector loc;
		
	shaft = spawn( class 'SimpleLightningFX',StartActor,, (Start + End) * 0.5 );

	len = VSize(end-start) / 8.0;
	
	if ( bScaleShaft )
		len = FClamp(len, 0, 128);

	for (i=0; i<8; i++)
	{
		loc = End + Normal(start-end) * (len * i);
		Shaft.AddParticle(i,loc);

		Shaft.GetParticleParams(i,Shaft.Params);

		if ( !bScaleShaft )
		{
			switch ( i )
			{
				case 0:
				case 7:
					Shaft.Params.Width = 32 * DamageMult * 2;
					break;
	
				case 1:
				case 6:
					Shaft.Params.Width = 16 * DamageMult * 2;
					break;
	
				case 2:
				case 5:
					Shaft.Params.Width = 12 * DamageMult * 2;
					break;
	
				case 3:
				case 4:
					Shaft.Params.Width = 8 * DamageMult * 2;
				break;
			}
		} else {
			switch ( i )
			{
				case 0:
					Shaft.Params.Width = 32 * DamageMult * 2;
					break;
	
				case 1:
					Shaft.Params.Width = 16 * DamageMult * 2;
					break;
	
				case 2:
					Shaft.Params.Width = 12 * DamageMult * 2;
					break;
	
				case 3:
				case 4:
					Shaft.Params.Width = 8 * DamageMult * 2;
					break;

				case 6:
				case 5:
					Shaft.Params.Width = 4 * DamageMult * 2;
					break;

				case 7:
					Shaft.Params.Width = 0;
					break;

				break;
			}
		}

		Shaft.SetParticleParams(i, Shaft.Params);
	}
}

function Destroyed()
{
	if ( shaft != none )
		shaft.Destroy();
}

state Hold
{
	function BeginState()
	{
		setTimer(Lifespan, false);
	}
	
	function Tick( float DeltaTime )
	{
		local int i;
		local vector Loc, start, end;

		if ( (StartActor == none) || (EndActor == none) )
		{
			log("Hold: Actors undefined - destroying self", 'Misc');
			Destroy();
			return;
		}
		
		start = StartActor.JointPlace(StartJoint).pos;
		end = EndActor.JointPlace(EndJoint).pos;

		len = VSize(end-start) / 8.0;
		
		if ( bScaleShaft )
			len = FClamp(len, 0, 128);
	
		for (i=0; i<8; i++)
		{
			if ( bScaleShaft && (Owner != None) )
			{
				loc = end + Normal(-Owner.Velocity) * (len * i);
			} 
			else 
			{
				loc = end + Normal(Start-end) * (len * i);
			}

			Shaft.GetParticleParams(i,Shaft.Params);
			Shaft.Params.Position = Loc + (VRand() * 8);
			Shaft.SetParticleParams(i, Shaft.Params);
		}

	}
	
	function Timer()
	{
		log("Timer limit reached... destroying", 'Misc');
		Destroy();
	}

	Begin:
		
}

defaultproperties
{
     DamageMult=1
}
