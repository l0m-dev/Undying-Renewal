//=============================================================================
// AeonsAmbushPoint.
//=============================================================================
class AeonsAmbushPoint extends AeonsNavNode;

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************
var AeonsAmbushPoint		MatingPoint;		//
var vector lookdir; //direction to look while ambushing

//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	MatingPoint = FindMatingPoint( Event );
	lookdir = 2000 * vector(Rotation);
}


//****************************************************************************
// New member funcs.
//****************************************************************************
function AeonsAmbushPoint FindMatingPoint( name LinkTag )
{
	local AeonsAmbushPoint	PPoint;

	if ( LinkTag != '' )
	{
		foreach AllActors( class 'AeonsAmbushPoint', PPoint, LinkTag )
			if ( PPoint != self )
				return PPoint;
	}
	else
	{
		return none;
	}
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
}
