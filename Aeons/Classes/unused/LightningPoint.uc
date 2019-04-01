//=============================================================================
// LightningPoint.
//=============================================================================
class LightningPoint expands AnimSpriteEffect;

var float xMajor, yMajor, zMajor, xMinor, yMinor, zMinor, c;


/*
function PreBeginPlay()
{
	x = RandRange(-1.0, 1.0);
	y = RandRange(-1.0, 1.0);
	z = RandRange(-1.0, 1.0);
}
*/

function Tick(float deltaTime)
{
	xMajor += 0.1;
	yMajor += 0.1;
	zMajor += 0.1;

	xMinor += 0.3;
	yMinor += 0.3;
	zMinor += 0.3;

}

state kill
{
	simulated function Tick(float deltaTime)
	{
		DrawScale *= 1.01;
	}
	simulated function Timer()
	{
		Destroy();
	}

	simulated function BeginState()
	{
		SetTimer(1.0,false);
	}
}

state MSkill
{
	simulated function Tick(float deltaTime)
	{
		DrawScale *= 1.01;
	}

	simulated function Timer()
	{
		Destroy();
	}

	simulated function BeginState()
	{
		SetTimer(1.0,false);
	}
}

defaultproperties
{
     DrawType=DT_Sprite
     LightType=LT_None
}
