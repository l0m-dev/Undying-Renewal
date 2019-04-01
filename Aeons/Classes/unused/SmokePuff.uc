//=============================================================================
// SmokePuff.
//=============================================================================
class SmokePuff expands AnimSpriteEffect;

var() Texture SSprites[20];
var() int NumSets;
var() float RisingRate;
	
simulated function PostBeginPlay()
{
	Velocity = Vect(0,0,1)*RisingRate;
	Texture = SSPrites[int(FRand()*NumSets*0.97)];
	if (Texture == None) Texture = Texture'S_Actor';
}

defaultproperties
{
     NumSets=10
     RisingRate=50
     NumFrames=8
     Pause=0.05
     bNetOptional=True
     Physics=PHYS_Projectile
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=1.5
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     DrawScale=2
     LightType=LT_None
     LightBrightness=10
     LightHue=0
     LightSaturation=255
     LightRadius=14
     bCorona=False
}
