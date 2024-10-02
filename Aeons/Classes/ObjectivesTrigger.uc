//=============================================================================
// ObjectivesTrigger.
//=============================================================================
class ObjectivesTrigger expands Info;

var() localized string Objectives;

function Trigger( actor Other, pawn EventInstigator )
{
	local AeonsPlayer AP;

	log("ObjectivesTrigger: Trigger");

	if (( Objectives != "" ))
	{
		forEach AllActors( class 'AeonsPlayer', AP )
		{
			AP.ProcessObjectives( Objectives );		
		}
	}
	else
	{
		Log("ObjectivesTrigger: couldn't process objectives.  AP=" $ AP $ " Objectives='" $ Objectives $ "'"); 
	}
}

defaultproperties
{
}
