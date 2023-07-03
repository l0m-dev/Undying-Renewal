//=============================================================================
// Dispatcher: receives one trigger (corresponding to its name) as input, 
// then triggers a set of specifid events with optional delays.
//=============================================================================
class Dispatcher extends Triggers;

//#exec Texture Import File=Textures\Dispatch.pcx Name=S_Dispatcher Mips=On Flags=2

//-----------------------------------------------------------------------------
// Dispatcher variables.

var() bool	bFireOnceOnly;
var() name  OutEvents[8]; // Events to generate.
var() float OutDelays[8]; // Relative delays before generating events.
var int i;                // Internal counter.
var Actor Other;
var() bool bInterruptable;
var bool bDisabled;

//=============================================================================
// Dispatcher logic.

function PreBeginPlay()
{
	super.PreBeginPlay();
	bSavable = true;
}

//
// When dispatcher is triggered...
//
function Trigger( actor Other, pawn EventInstigator )
{
	if ( !bDisabled )
	{
		Instigator = EventInstigator;
		gotostate('Dispatch');
	}
}

//
// Dispatch events.
//
state Dispatch
{
	function Trigger(Actor Other, Pawn Instigator)
	{
		if ( bInterruptable )
		{
			GotoState('');
		}
	}

Begin:
	for( i=0; i<ArrayCount(OutEvents); i++ )
	{
		if( OutEvents[i] != '' )
		{
			Sleep( OutDelays[i] );
			foreach AllActors( class 'Actor', Target, OutEvents[i] )
			{
				if ( Target.IsA('Trigger') )
				{
					// handle Pass Thru message
					if ( Trigger(Target).bPassThru )
					{
						Trigger(Target).PassThru(Other);
					}
				}
				Target.Trigger( Self, Instigator );
			}
		}
	}
	
	if ( bFireOnceOnly )
		bDisabled = true;
	
	GotoState('');		
}

defaultproperties
{
     Texture=Texture'Engine.S_Dispatcher'
}
