//=============================================================================
// InvokeModifier.
//=============================================================================
class InvokeModifier expands PlayerModifier;

var ScriptedPawn InvokedPawns[8];
var float Timers[8], RefTimers[8];
var float Times[6];

function PreBeginPlay()
{	
	Super.PreBeginPlay();
	SetTimer(1, true);
	
	if ( RGC() )
	{
		Times[0] = 30;
		Times[1] = 50;
		Times[2] = 60;
		Times[3] = 80;
		Times[4] = 100;
		Times[5] = 120;
	}
	else
	{
		Times[0] = 20;
		Times[1] = 40;
		Times[2] = 40;
		Times[3] = 60;
		Times[4] = 60;
		Times[5] = 80;
	}
}

function bool AddSP(ScriptedPawn SP, int j)
{
	local int i;
	
	for ( i=0; i<8; i++ )
	{
		if ( InvokedPawns[i] == none )
		{
			InvokedPawns[i] = SP;
			RefTimers[i] = Times[j];
			Timers[i] = 0;
			return true;
		}
	}
	return false;
}

function Timer()
{
	local int i;

	for (i=0; i<8; i++)
	{
		if (InvokedPawns[i] != none)
		{
			Timers[i] += 1.0;
			if ((Timers[i] >= RefTimers[i]) || (InvokedPawns[i].Health <= 0))
			{
				Spawn(class 'RevokeFX',InvokedPawns[i],,InvokedPawns[i].Location);
				InvokedPawns[i].Destroy();
				InvokedPawns[i] = none;
			}
		}	
	}
}

defaultproperties
{
     RemoteRole=ROLE_None
}
