//=============================================================================
// MagicalTrigger.
//=============================================================================
class MagicalTrigger expands DynamicTrigger;

var int CastingLevel;
var() int damagePerLevel[5];

// Network replication
//
replication
{
    // Things the server should send to the client.
    reliable if( Role==ROLE_Authority && bNetOwner )
        CastingLevel;
}

function int Dispel(optional bool bCheck)
{
	if ( bCheck )
		return 0;
	
	Destroy();
	return 0;
}

defaultproperties
{
     damagePerLevel(0)=30
     damagePerLevel(1)=50
     damagePerLevel(2)=60
     damagePerLevel(3)=100
     damagePerLevel(4)=100
}
