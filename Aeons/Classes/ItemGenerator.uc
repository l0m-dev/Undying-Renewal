//=============================================================================
// ItemGenerator.
//=============================================================================
class ItemGenerator expands Generator;

//****************************************************************************
// Member vars.
//****************************************************************************

var Pickup 					GenItem;			// Item spawned by generator.
var() class<Pickup>			SpawnClass;			// Class of item spawned.
var() bool					bGroundPlacement;	// Calculate spawn point at height of spawning item.
var() float					TimerInterval;		// Timer generation interval.

//****************************************************************************
// Inherited member funcs.
//****************************************************************************

// Called after creation (or spawning).
function PreBeginPlay()
{
	super.PreBeginPlay();
	
	GenerateEvent();
}

function Timer()
{
	GenerateEvent();
}

//****************************************************************************
// New member funcs.
//****************************************************************************

// The generation event.
function GenerateEvent()
{		
	SetTimer( FMax(FVariant( TimerInterval, 5.0 ), 0.1), false);
	
	if (GenItem == None || GenItem.GetStateName() != 'Pickup' || GenItem.bHidden)
	{
		//	GenItem.Destroy();
		
		if ( SpawnClass != none )
			GenItem = Spawn( SpawnClass, self,, GetSpawnPoint( SpawnClass ), Rotation );
		else
			log("No spawn class set for "$self);
	}
}

// Calculate a spawn point.
function vector GetSpawnPoint( class<Pickup> classID )
{
	local vector sPoint;
	
	sPoint = CalcGroundPoint( Location, classID.default.CollisionHeight );
	
	if ( !bGroundPlacement )
		sPoint.Z += 30;
	
	return sPoint;
}

// Calculate a semi-valid point based on the location and height passed.
function vector CalcGroundPoint( vector thisLocation, float thisHeight )
{
	local actor		HitActor;
	local vector	HitLocation, HitNormal;
	local int		HitJoint;

	HitActor = Trace( HitLocation, HitNormal, HitJoint, thisLocation + vect(0,0,-500), thisLocation, false );
	return HitLocation + ( vect(0,0,1) * thisHeight );
}

//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     bGroundPlacement=True
     Texture=Texture'Aeons.System.InventoryGenerator'
}