//=============================================================================
// Boil.
//=============================================================================
class Boil expands Effects;
#exec MESH IMPORT MESH=Boil_m SKELFILE=Boil.ngf 

// User defined vars
var() float ScaleVar;
var() float ScalePeriod;
var() float ScalePeriodVar;

// internal vars.
var float Dir, Rate, Offset, Change;
var float Diff, RealScale, NewTarget;

function PostBeginPlay()
{
	loopAnim('Idle', RandRange(0.75, 1.5));

	Rate = RandRange((ScalePeriod - ScalePeriodVar), (ScalePeriod + ScalePeriodVar));
	RealScale = RandRange( (DrawScale-ScaleVar), (DrawScale+ScaleVar) );
	NewTarget = RandRange( (DrawScale-ScaleVar), (DrawScale+ScaleVar) );
	DrawScale =RealScale;

	Diff = abs(NewTarget - RealScale);

	if (RealScale < NewTarget)
		Dir = 1.0;
	else
		Dir = -1.0;

	SetTimer(Rate, true);
}

function Tick(float DeltaTime)
{
	if (RealScale < NewTarget)
		Dir = 1.0;
	else
		Dir = -1.0;

	RealScale += Diff * ((DeltaTime / Rate) * Dir);

	DrawScale = RealScale;
}

function Timer()
{
	local float p ;

	p = default.DrawScale;
	NewTarget = RandRange((p - ScaleVar), (p+ScaleVar));

	Diff = abs(NewTarget - DrawScale);

	Rate = RandRange((ScalePeriod - ScalePeriodVar), (ScalePeriod + ScalePeriodVar));
	SetTimer(Rate, true);
}

defaultproperties
{
     ScaleVar=0.355588
     ScalePeriod=1
     ScalePeriodVar=0.5
     LODBias=10
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Boil_m'
}
