//=============================================================================
// CantripTrigger.
//=============================================================================
class CantripTrigger expands Trigger;

#exec TEXTURE IMPORT NAME=TrigCantrip FILE=TrigCantrip.pcx GROUP=System Mips=Off Flags=2

var Actor A;

var AeonsPlayer P;
var() float TriggerAngle;

function bool AngleCheck(vector Loc, vector A, float angleThreshold)
{
	local vector vA, vB;
	local float angle;
	local float pi;

	pi = 3.1415926535897932384626433832795;

	angleThreshold *= (pi / 180.0);
	vA = Normal(A - Loc);
	vB = Vector(P.ViewRotation);
	angle = vA dot vB;

	return ( cos(angleThreshold) < angle );
}

function bool LoS()
{
	local vector v1, v2, locB, eyeHeight;
	local float angle;
	local bool pass;
	
	eyeHeight.z = P.EyeHeight;
	return AngleCheck((P.Location + EyeHeight), Location, (TriggerAngle * 0.5));
}

function Touch( actor Other )
{
	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if( IsRelevant( Other ) )
	{
		P = AeonsPlayer(Other);
		if ( LoS() )
		{
			GotoState('Firing');
		}
	}
}

function PassThru( actor Other )
{
	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;

	if (Other.IsA('AeonsPlayer'))
	{
		P = AeonsPlayer(Other);
		if ( LoS() )
		{
			GotoState('Firing');
		}
	}
}

/*
function bool CheckLantern(AeonsPlayer P)
{
	local Inventory Inv;
	
	// Inventory we are checking for is contained within the players inventory.
	Inv = P.FindInventoryType(class 'Lantern');
	if ( (Inv != None) && Inv.bActive )
		return true;
	
	return false;
}*/

state Firing
{


	Begin:
		if (P != none)
		{
			P.AttSpell.BringUp();
			P.AttSpell.PlayAnim('FireCantrip',1,,,0);
			P.AttSpell.Finish();
			sleep(0.5);
			// Trigger the effect
			if( Event != '' )
				foreach AllActors( class 'Actor', A, Event )
					A.Trigger( self, none );

			if (bTriggerOnceOnly)
				SetCollision(false);

		}
}

defaultproperties
{
     TriggerAngle=90
     bTriggerOnceOnly=True
     Texture=Texture'Aeons.System.TrigCantrip'
     DrawScale=0.5
}
