//=============================================================================
// EctoplasmTrail.
//=============================================================================
class EctoplasmTrail expands AnimSpriteEffect;

//#exec Texture Import Name=FX_ectoTrail01 File=FX_ectoTrail01.pcx Group=Trails Mips=On
////#exec OBJ LOAD FILE=FX.utx PACKAGE=Aeons.EctoplasmTrail
////#exec OBJ LOAD FILE=SmokeEffect1.utx PACKAGE=UNREALSHARE.SEffect1

var() float destroyAtDrawScale;
// var() float iterativeScaleFactor;
var() float updateTimeStep;
var() float scaleOffset;
var float trailMultiplier;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}

auto state Flying
{
	function BeginState()
	{	
		SetTimer(updateTimeStep,True);
		Super.BeginState();
	}
}	

function Timer ()
{
	
	DrawScale = (DrawScale * (trailMultiplier));
	if (DrawScale < destroyAtDrawScale)
		destroy();
}

defaultproperties
{
     destroyAtDrawScale=0.05
     updateTimeStep=0.001
     scaleOffset=0.1
     DrawType=DT_Sprite
     Style=STY_Modulated
     Texture=Texture'Aeons.Trails.FX_ectoTrail01'
     DrawScale=0.25
     LightType=LT_None
     LightBrightness=0
     LightHue=0
     LightSaturation=0
     LightRadius=0
     Mass=1
}
