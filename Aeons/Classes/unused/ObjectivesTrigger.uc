//=============================================================================
// ObjectivesTrigger.
//=============================================================================
class ObjectivesTrigger expands Info;

var() localized string Objectives;

function Trigger( actor Other, pawn EventInstigator )
{
	local AeonsPlayer AP;

	log("ObjectivesTrigger: Trigger");

	forEach AllActors( class 'AeonsPlayer', AP )
	{
		break;
	}

	if (( AP != None )&&( Objectives != "" ))
	{
		AP.ProcessObjectives( Objectives );		
	}
	else
	{
		Log("ObjectivesTrigger: couldn't process objectives.  AP=" $ AP $ " Objectives='" $ Objectives $ "'"); 
	}

}

defaultproperties
{
}
